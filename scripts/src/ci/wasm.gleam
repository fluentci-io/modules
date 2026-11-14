import ci/common as c
import ci/data as d
import ci/files as f
import ci/native
import gleam/bit_array
import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn byte(bytes: BitArray, offset: Int) -> Result(Int, String) {
  case bit_array.slice(bytes, offset, 1) {
    Ok(<<value:8>>) -> Ok(value)
    _ -> Error("Truncated component")
  }
}

fn uint(
  bytes: BitArray,
  offset: Int,
  shift: Int,
  value: Int,
) -> Result(#(Int, Int), String) {
  use _ <- result.try(c.require(shift < 35, "Invalid component section length"))
  use b <- result.try(byte(bytes, offset))
  let value = value + int.bitwise_shift_left(int.bitwise_and(b, 127), shift)
  case b < 128 {
    True -> Ok(#(value, offset + 1))
    False -> uint(bytes, offset + 1, shift + 7, value)
  }
}

fn metadata_at(
  bytes: BitArray,
  offset: Int,
  metadata: d.Value,
) -> Result(d.Value, String) {
  case offset == bit_array.byte_size(bytes) {
    True -> {
      use _ <- result.try(c.require(
        d.array(d.get(metadata, "functions")) != [],
        "Missing typed component metadata",
      ))
      Ok(metadata)
    }
    False -> {
      use id <- result.try(byte(bytes, offset))
      use length <- result.try(uint(bytes, offset + 1, 0, 0))
      let end = length.1 + length.0
      use _ <- result.try(c.require(
        end <= bit_array.byte_size(bytes),
        "Truncated component section",
      ))
      use metadata <- result.try(case id {
        0 -> {
          use name <- result.try(uint(bytes, length.1, 0, 0))
          use _ <- result.try(c.require(
            name.1 + name.0 <= end,
            "Truncated component custom-section name",
          ))
          use label <- result.try(
            bit_array.slice(bytes, name.1, name.0)
            |> result.map_error(fn(_) { "Invalid section name" }),
          )
          case bit_array.to_string(label) {
            Ok("fluentci:metadata") -> {
              use _ <- result.try(c.require(
                metadata == d.Null,
                "Duplicate module metadata",
              ))
              use payload <- result.try(
                bit_array.slice(bytes, name.1 + name.0, end - name.1 - name.0)
                |> result.map_error(fn(_) { "Invalid metadata payload" }),
              )
              use text <- result.try(
                bit_array.to_string(payload)
                |> result.map_error(fn(_) { "Invalid UTF-8 metadata" }),
              )
              d.parse(text)
            }
            _ -> Ok(metadata)
          }
        }
        _ -> Ok(metadata)
      })
      metadata_at(bytes, end, metadata)
    }
  }
}

pub fn metadata(bytes: BitArray) -> Result(d.Value, String) {
  use _ <- result.try(c.require(
    bit_array.slice(bytes, 0, 8) == Ok(<<0, 97, 115, 109, 13, 0, 1, 0>>),
    "Expected a native WebAssembly component, not an Extism core module",
  ))
  metadata_at(bytes, 8, d.Null)
}

fn normalize(name: String) -> String {
  f.kebab(case string.starts_with(name, "_") {
    True -> string.drop_start(name, 1)
    False -> name
  })
}

fn names(value: d.Value) -> List(String) {
  list.map(d.fields(value), fn(p) { normalize(p.0) })
  |> list.sort(string.compare)
}

fn field(value: d.Value, key: String) -> d.Value {
  d.fields(value)
  |> list.find(fn(p) { normalize(p.0) == normalize(key) })
  |> result.map(fn(p) { p.1 })
  |> result.unwrap(d.Null)
}

fn check_type(native: d.Value, schema: d.Value) -> Result(Nil, String) {
  let kind = d.s(schema, "type")
  let expected = case kind {
    "integer" -> "number"
    other -> other
  }
  use _ <- result.try(c.require(
    d.s(native, "type") == expected,
    "Native component type differs from schema",
  ))
  case kind {
    "array" -> check_type(d.get(native, "items"), d.get(schema, "items"))
    "object" -> {
      let source = d.get(native, "properties")
      let target = d.get(schema, "properties")
      use _ <- result.try(c.require(
        names(source) == names(target),
        "Native record fields differ from schema",
      ))
      c.all(d.fields(target), fn(pair) {
        check_type(field(source, pair.0), pair.1)
      })
    }
    _ -> Ok(Nil)
  }
}

fn wit_type(schema: d.Value, native: d.Value) -> String {
  case d.s(schema, "type") {
    "object" -> normalize(d.s(native, "returnName"))
    "array" -> "list<" <> wit_type(d.get(schema, "items"), d.Null) <> ">"
    "string" -> "string"
    "boolean" -> "bool"
    "integer" -> "s32"
    "number" -> "f64"
    _ -> ""
  }
}

pub fn validate(
  root: String,
  directory: String,
) -> Result(List(String), String) {
  use entry <- result.try(c.text(directory <> "/entry.mjs"))
  use exported <- result.try(case string.split(entry, "{") {
    [_, rest] ->
      case string.split(rest, "}") {
        [names, _] ->
          Ok(
            list.map(string.split(names, ","), fn(n) {
              normalize(string.trim(n))
            }),
          )
        _ -> Error("Missing entry exports")
      }
    _ -> Error("Missing entry exports")
  })
  let exported = list.sort(exported, string.compare)
  use bytes <- result.try(native.read(directory <> "/dist/plugin.wasm"))
  use meta <- result.try(metadata(bytes))
  use sidecar <- result.try(f.json(directory <> "/dist/fluentci.metadata.json"))
  use _ <- result.try(c.require(
    d.s(sidecar, "sha256") == native.sha256(bytes)
      && d.equivalent(d.get(sidecar, "functions"), d.get(meta, "functions")),
    "Component checksum or metadata sidecar differs",
  ))
  use raw <- result.try(c.run(
    "node",
    [root <> "/lib/component/inspect-abi.mjs", directory],
    root,
  ))
  use native <- result.try(d.parse(raw))
  let functions = d.array(native)
  use _ <- result.try(c.require(
    list.sort(
      list.map(functions, fn(n) { normalize(d.s(n, "name")) }),
      string.compare,
    )
      == exported,
    "Component public exports differ from entry.mjs",
  ))
  let metadata = d.array(d.get(meta, "functions"))
  use _ <- result.try(c.require(
    list.sort(list.map(metadata, fn(m) { d.s(m, "name") }), string.compare)
      == exported,
    "Typed metadata exports differ",
  ))
  use schema <- result.try(f.json(directory <> "/schema.json"))
  use _ <- result.try(
    c.all(d.fields(d.get(schema, "exports")), fn(pair) {
      let name = normalize(pair.0)
      use function <- result.try(
        list.find(functions, fn(n) { normalize(d.s(n, "name")) == name })
        |> result.map_error(fn(_) { "Missing native function " <> name }),
      )
      use meta <- result.try(
        list.find(metadata, fn(m) { d.s(m, "name") == name })
        |> result.map_error(fn(_) { "Missing function metadata " <> name }),
      )
      use _ <- result.try(c.require(
        d.s(meta, "inputFormat") == "wit"
          && string.trim(d.s(meta, "description")) != "",
        name <> ": missing function description",
      ))
      let props = d.get(d.get(pair.1, "input"), "properties")
      let required = d.strings(d.get(d.get(pair.1, "input"), "required"))
      let args = d.array(d.get(meta, "args"))
      use _ <- result.try(c.require(
        list.sort(list.map(args, fn(arg) { d.s(arg, "name") }), string.compare)
          == names(props),
        name <> ": argument metadata differs",
      ))
      use _ <- result.try(case d.fields(props) {
        [] ->
          c.require(
            d.array(d.get(function, "parameters")) == [],
            "Unexpected native parameters",
          )
        _ -> {
          use input <- result.try(case d.array(d.get(function, "parameters")) {
            [input] -> Ok(input)
            _ -> Error("Use one named argument record")
          })
          let fields = d.get(input, "properties")
          use _ <- result.try(c.require(
            names(fields) == names(props),
            "Native argument fields differ",
          ))
          c.all(d.fields(props), fn(p) {
            let arg =
              list.find(args, fn(a) { d.s(a, "name") == normalize(p.0) })
              |> result.unwrap(d.Null)
            let native = field(fields, p.0)
            use _ <- result.try(c.require(
              string.trim(d.s(arg, "description")) != "",
              name <> "/" <> p.0 <> ": missing argument description",
            ))
            use _ <- result.try(c.require(
              { d.get(arg, "required") != d.Bool(False) }
                == list.contains(required, p.0)
                && d.bool(d.get(native, "optional"))
                != list.contains(required, p.0),
              "Native argument optionality differs",
            ))
            check_type(native, p.1)
          })
        }
      })
      use _ <- result.try(check_type(
        d.get(function, "output"),
        d.get(pair.1, "output"),
      ))
      c.require(
        d.s(meta, "returnType") == wit_type(d.get(pair.1, "output"), function),
        name <> ": return metadata differs from native ABI",
      )
    }),
  )
  Ok(exported)
}

pub fn run(root: String, directory: String) -> Result(Nil, String) {
  use functions <- result.try(validate(root, directory))
  let _ =
    native.stdout(
      "Validated "
      <> directory
      <> ": "
      <> int.to_string(list.length(functions))
      <> " typed native functions.\n",
    )
  Ok(Nil)
}
