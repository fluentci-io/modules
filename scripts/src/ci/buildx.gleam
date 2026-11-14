import ci/common as c
import ci/data as d
import ci/files as f
import ci/native
import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn camel(name: String) -> String {
  let parts = string.split(name, "-")
  let name = case parts {
    [] -> name
    [head, ..tail] -> head <> string.concat(list.map(tail, f.title))
  }
  name
  <> case
    list.contains(
      [
        "type",
        "data",
        "class",
        "instance",
        "module",
        "import",
        "foreign",
        "in",
        "where",
        "case",
        "of",
        "do",
        "let",
      ],
      name,
    )
  {
    True -> "_"
    False -> ""
  }
}

fn command(path: List(String)) -> String {
  case path {
    [] -> "buildx"
    _ -> string.join(list.map(path, fn(p) { string.replace(p, "-", "_") }), "_")
  }
}

fn kind(option: d.Value) -> #(String, d.Value, String) {
  case d.s(option, "type") {
    "stringArray" | "strings" | "filter" | "ulimit" -> #(
      "Array String",
      d.Object([
        #("type", d.Text("array")),
        #("items", d.Object([#("type", d.Text("string"))])),
      ]),
      "arrayOption",
    )
    "boolean" -> #(
      "Boolean",
      d.Object([#("type", d.Text("boolean"))]),
      "booleanOption",
    )
    "int" | "int64" -> #(
      "Int",
      d.Object([#("type", d.Text("integer"))]),
      "intOption",
    )
    _ -> #("String", d.Object([#("type", d.Text("string"))]), "stringOption")
  }
}

fn argument(key: String) -> String {
  "argument"
  <> string.uppercase(string.slice(key, 0, 1))
  <> string.drop_start(key, 1)
}

fn rows(fields: List(#(String, String, String))) -> String {
  string.join(list.map(fields, fn(p) { p.0 <> " :: " <> p.1 }), "\n  , ")
}

fn optional(option: d.Value) -> #(String, String, String) {
  #(d.s(option, "key"), "Maybe (" <> d.s(option, "ps") <> ")", "Nothing")
}

fn decode_line(field: #(String, String, String)) -> String {
  "  "
  <> argument(field.0)
  <> " <- B."
  <> case string.starts_with(field.1, "Maybe") {
    True -> "optional object " <> d.quote(field.0)
    False -> "field object " <> d.quote(field.0) <> " " <> field.2
  }
}

fn decoder(title: String, fields: List(#(String, String, String))) -> String {
  let chunks =
    list.map(c.indices({ list.length(fields) + 11 } / 12), fn(index) {
      list.take(list.drop(fields, index * 12), 12)
    })
  let helpers =
    list.index_map(chunks, fn(selected, index) {
      let name = "decode" <> title <> "Chunk" <> int.to_string(index)
      f.lines([
        name
          <> " :: Object.Object Json -> Either String { "
          <> string.join(
          list.map(selected, fn(p) { p.0 <> " :: " <> p.1 }),
          ", ",
        )
          <> " }",
        name <> " object = do",
        f.lines(list.map(selected, decode_line)),
        "  pure { "
          <> string.join(
          list.map(selected, fn(p) { p.0 <> ": " <> argument(p.0) }),
          ", ",
        )
          <> " }",
        "",
      ])
    })
  let calls =
    list.index_map(chunks, fn(_, index) {
      "  chunk"
      <> int.to_string(index)
      <> " <- decode"
      <> title
      <> "Chunk"
      <> int.to_string(index)
      <> " object"
    })
  let names =
    "[ " <> string.join(list.map(fields, fn(p) { d.quote(p.0) }), ", ") <> " ]"
  let returned =
    string.join(
      list.index_map(fields, fn(p, index) {
        p.0 <> ": chunk" <> int.to_string(index / 12) <> "." <> p.0
      }),
      ", ",
    )
  f.lines(
    list.append(helpers, [
      "decode" <> title <> "Args :: Json -> Either String " <> title <> "Args",
      "decode" <> title <> "Args json = do",
      "  object <- B.decodeObject " <> names <> " json",
      f.lines(calls),
      "  pure { " <> returned <> " }",
      "",
    ]),
  )
}

pub fn run(root: String, check: Bool) -> Result(Nil, String) {
  let directory = root <> "/containers/buildx"
  use snapshot <- result.try(f.json(directory <> "/buildx-options.json"))
  use positions <- result.try(f.json(
    root <> "/scripts/templates/buildx-positionals.json",
  ))
  use main_header <- result.try(c.text(
    root <> "/scripts/templates/buildx-main.purs",
  ))
  use docs_header <- result.try(c.text(
    root <> "/scripts/templates/buildx-options-header.md",
  ))
  let nodes = d.array(d.get(snapshot, "commands"))
  use generated <- result.try(
    list.try_map(nodes, fn(node) {
      let path = d.strings(d.get(node, "path"))
      let public = command(path)
      let pure = case path {
        [] -> "buildx"
        _ -> camel(string.join(path, "-"))
      }
      let title =
        string.uppercase(string.slice(pure, 0, 1)) <> string.drop_start(pure, 1)
      let options =
        list.fold(c.indices(list.length(path) + 1), [], fn(acc, depth) {
          let parent =
            list.find(nodes, fn(n) {
              d.strings(d.get(n, "path")) == list.take(path, depth)
            })
            |> result.unwrap(d.Null)
          list.fold(
            d.array(d.get(parent, "options")),
            acc,
            fn(selected, option) {
              let key = camel(d.s(option, "flag"))
              case list.any(selected, fn(o) { d.s(o, "key") == key }) {
                True -> selected
                False -> {
                  let #(ps, schema, emit) = kind(option)
                  list.append(selected, [
                    d.merge(
                      option,
                      d.Object([
                        #("key", d.Text(key)),
                        #("ps", d.Text(ps)),
                        #("schema", schema),
                        #("emit", d.Text(emit)),
                        #("depth", d.Number(int.to_string(depth))),
                      ]),
                    ),
                  ])
                }
              }
            },
          )
        })
      let help =
        d.Object([
          #("key", d.Text("help")),
          #("flag", d.Text("help")),
          #("ps", d.Text("Boolean")),
          #("schema", d.Object([#("type", d.Text("boolean"))])),
          #("emit", d.Text("booleanOption")),
          #("depth", d.Number(int.to_string(list.length(path)))),
          #("description", d.Text("Show this command's help.")),
        ])
      let options =
        list.append(list.filter(options, fn(o) { d.s(o, "key") != "help" }), [
          help,
        ])
      let position = case d.array(d.get(node, "children")) {
        [] -> d.get(positions, public)
        _ ->
          d.Object([
            #("key", d.Text("arguments")),
            #("ps", d.Text("Array String")),
            #("default", d.Array([])),
            #("mode", d.Text("positional")),
            #(
              "description",
              d.Text(
                "Subcommand positional arguments; prefer the corresponding named export.",
              ),
            ),
          ])
      }
      let runtime = [
        #("project", "String", "\".\""),
        #("runDir", "String", "\"\""),
        #("docker", "String", "\"docker\""),
        #("timeoutMs", "Int", "900000"),
        #("experimental", "Boolean", "false"),
      ]
      let positional = case position {
        d.Null -> []
        _ -> [
          #(
            d.s(position, "key"),
            d.s(position, "ps"),
            case d.s(position, "ps") {
              "Maybe String" -> "Nothing"
              _ -> d.encode(d.get(position, "default"))
            },
          ),
        ]
      }
      let fields =
        list.append(
          runtime,
          list.append(positional, list.map(options, optional)),
        )
      let defaults = list.append(positional, list.map(options, optional))
      let defaults = list.map(defaults, fn(p) { "  , " <> p.0 <> ": " <> p.2 })
      let calls =
        list.flat_map(c.indices(list.length(path) + 1), fn(depth) {
          let command = case list.first(list.drop(path, depth - 1)) {
            Ok(part) if depth > 0 -> ["  <> [ " <> d.quote(part) <> " ]"]
            _ -> []
          }
          let flags =
            list.filter(options, fn(o) {
              d.get(o, "depth") == d.Number(int.to_string(depth))
            })
            |> list.map(fn(o) {
              "  <> B."
              <> d.s(o, "emit")
              <> " "
              <> d.quote(d.s(o, "flag"))
              <> " arguments."
              <> d.s(o, "key")
            })
          list.append(command, flags)
        })
      let call = case position {
        d.Null -> ""
        _ -> {
          let key = d.s(position, "key")
          let expression = case d.s(position, "mode") {
            "maybe" -> "B.maybePositional arguments." <> key
            "single" -> "[ arguments." <> key <> " ]"
            _ -> "arguments." <> key
          }
          "\n  <> B.positional (" <> expression <> ")"
        }
      }
      let source =
        f.lines([
          "type " <> title <> "Args =",
          "  { " <> rows(fields) <> "\n  }",
          "",
          pure <> "Args :: String -> String -> " <> title <> "Args",
          pure <> "Args project runDir =",
          "  { project, runDir, docker: \"docker\", timeoutMs: 900000, experimental: false",
          f.lines(defaults),
          "  }",
          "",
          decoder(title, fields),
          "runtime" <> title <> " :: " <> title <> "Args -> B.Runtime",
          "runtime" <> title <> " arguments =",
          "  { "
            <> string.join(
            list.map(runtime, fn(p) { p.0 <> ": arguments." <> p.0 }),
            ", ",
          )
            <> " }",
          "",
          pure <> "Arguments :: " <> title <> "Args -> Array String",
          pure <> "Arguments arguments =",
          "  [ \"buildx\" ]",
          f.lines(calls) <> call,
          "",
          pure <> " :: " <> title <> "Args -> Either String Plan.Plan",
          pure
            <> " arguments = B.commandPlan (runtime"
            <> title
            <> " arguments) ("
            <> pure
            <> "Arguments arguments)",
          "",
        ])
      let props =
        d.Object([
          #(
            "project",
            d.Object([#("type", d.Text("string")), #("default", d.Text("."))]),
          ),
          #(
            "runDir",
            d.Object([
              #("type", d.Text("string")),
              #("minLength", d.Number("1")),
            ]),
          ),
          #(
            "docker",
            d.Object([
              #("type", d.Text("string")),
              #("default", d.Text("docker")),
            ]),
          ),
          #(
            "timeoutMs",
            d.Object([
              #("type", d.Text("integer")),
              #("format", d.Text("int32")),
              #("minimum", d.Number("1")),
              #("maximum", d.Number("2147483647")),
              #("default", d.Number("900000")),
            ]),
          ),
          #(
            "experimental",
            d.Object([#("type", d.Text("boolean")), #("default", d.Bool(False))]),
          ),
        ])
      let props = case position {
        d.Null -> props
        _ -> {
          let prop = case d.s(position, "ps") {
            "Array String" ->
              d.Object([
                #("type", d.Text("array")),
                #("items", d.Object([#("type", d.Text("string"))])),
              ])
            _ -> d.Object([#("type", d.Text("string"))])
          }
          let prop = d.put(prop, "description", d.get(position, "description"))
          let prop = case d.get(position, "default") {
            d.Null -> prop
            value -> d.put(prop, "default", value)
          }
          d.put(props, d.s(position, "key"), prop)
        }
      }
      let props =
        list.fold(options, props, fn(acc, o) {
          d.put(
            acc,
            d.s(o, "key"),
            d.put(
              d.get(o, "schema"),
              "description",
              d.Text("--" <> d.s(o, "flag") <> ": " <> d.s(o, "description")),
            ),
          )
        })
      let schema =
        d.Object([
          #(
            "input",
            d.Object([
              #("type", d.Text("object")),
              #("properties", props),
              #("required", d.Array([d.Text("runDir")])),
              #("additionalProperties", d.Bool(False)),
              #("contentType", d.Text("application/json")),
            ]),
          ),
          #(
            "output",
            d.Object([
              #("type", d.Text("string")),
              #("contentType", d.Text("text/plain; charset=utf-8")),
            ]),
          ),
        ])
      let main =
        public
        <> " :: Effect Unit\n"
        <> public
        <> " = invoke C.decode"
        <> title
        <> "Args C."
        <> pure
        <> " C.runtime"
        <> title
        <> "\n"
      let doc = [
        "## `" <> public <> "`",
        "",
        "`" <> d.s(node, "usage") <> "`",
        "",
        "PureScript: `Buildx.Commands."
          <> pure
          <> " :: "
          <> title
          <> "Args -> Either String Plan.Plan`.",
        "",
        "Common module parameters: `project` (default `.`), `runDir` (required, fresh),",
        "`docker` (executable, default `docker`), `timeoutMs` (default 900000),",
        "`experimental` (default false, enables `BUILDX_EXPERIMENTAL=1`).",
        "",
      ]
      let doc =
        list.append(doc, case position {
          d.Null -> []
          _ -> [
            "Positional parameter: `"
              <> d.s(position, "key")
              <> " :: "
              <> string.replace(
              d.s(position, "ps"),
              "Array String",
              "String (CSV)",
            )
              <> "` — "
              <> d.s(position, "description"),
            "",
          ]
        })
      let doc =
        list.append(doc, [
          "| Module argument | Docker option | Type |",
          "| --- | --- | --- |",
          ..list.map(options, fn(o) {
            "| `"
            <> d.s(o, "key")
            <> "` | `--"
            <> d.s(o, "flag")
            <> "` | `"
            <> string.replace(d.s(o, "ps"), "Array String", "String (CSV)")
            <> "` |"
          })
        ])
      Ok(#(source, main, #(public, schema), f.lines(list.append(doc, [""]))))
    }),
  )
  let header =
    "-- Generated by Gleam CI helpers.\nmodule Buildx.Commands where\n\nimport Prelude\nimport Buildx as B\nimport Data.Argonaut.Core (Json)\nimport Data.Either (Either)\nimport Data.Maybe (Maybe(..))\nimport Foreign.Object as Object\nimport FluentCI.Host.Plan as Plan\n\n"
  use _ <- result.try(f.generated(
    directory <> "/src/Buildx/Commands.purs",
    header <> string.join(list.map(generated, fn(p) { p.0 }), "\n"),
    check,
  ))
  use _ <- result.try(f.generated(
    directory <> "/src/Main.purs",
    main_header <> string.join(list.map(generated, fn(p) { p.1 }), "\n"),
    check,
  ))
  use _ <- result.try(f.generated(
    directory <> "/legacy-entry.mjs",
    "export { "
      <> string.join(list.map(generated, fn(p) { p.2.0 }), ", ")
      <> " } from \"./output/Main/index.js\";\n",
    check,
  ))
  use _ <- result.try(f.generated(
    directory <> "/legacy-schema.json",
    d.pretty(
      d.Object([
        #("name", d.Text("buildx")),
        #("exports", d.Object(list.map(generated, fn(p) { p.2 }))),
      ]),
    ),
    check,
  ))
  f.generated(
    directory <> "/OPTIONS.md",
    string.replace(docs_header, "{{version}}", d.s(snapshot, "version"))
      <> string.join(list.map(generated, fn(p) { p.3 }), "\n"),
    check,
  )
}

fn capture_nodes(
  root: String,
  pending: List(List(String)),
  nodes: List(d.Value),
) -> Result(List(d.Value), String) {
  case pending {
    [] -> Ok(nodes)
    [path, ..queue] -> {
      use output <- result.try(c.run(
        "docker",
        list.append(["buildx"], list.append(path, ["--help"])),
        root,
      ))
      let lines = string.split(output, "\n")
      let #(options, children, _) =
        list.fold(lines, #([], [], ""), fn(acc, line) {
          let section = case native.regex("^([A-Za-z][^:]+:)$", line) {
            [_] -> line
            _ -> acc.2
          }
          let children = case string.contains(section, "Commands:") {
            True ->
              case native.regex("^  ([a-z][a-z0-9-]+)\\s{2,}(.+)", line) {
                [[name, _]] -> list.append(acc.1, [name])
                _ -> acc.1
              }
            False -> acc.1
          }
          let options = case
            native.regex(
              "^\\s+(?:-\\S,\\s+)?--([a-z0-9-]+)(?: ([A-Za-z][A-Za-z0-9]*))?\\s{2,}(.*)$",
              line,
            )
          {
            [[flag, kind, description]] ->
              list.append(acc.0, [
                d.Object([
                  #("flag", d.Text(flag)),
                  #(
                    "type",
                    d.Text(case kind {
                      "" -> "boolean"
                      other -> other
                    }),
                  ),
                  #("description", d.Text(description)),
                ]),
              ])
            _ -> acc.0
          }
          #(options, children, section)
        })
      use _ <- result.try(
        c.all(options, fn(option) {
          c.require(
            list.contains(
              [
                "boolean",
                "string",
                "stringArray",
                "strings",
                "filter",
                "bytes",
                "duration",
                "ulimit",
                "int",
                "int64",
              ],
              d.s(option, "type"),
            ),
            "Unknown Buildx option type",
          )
        }),
      )
      let node =
        d.Object([
          #("path", d.Array(list.map(path, d.Text))),
          #("usage", d.Text(list.first(lines) |> result.unwrap(""))),
          #("options", d.Array(options)),
          #("children", d.Array(list.map(children, d.Text))),
        ])
      let queue =
        list.append(
          queue,
          list.map(children, fn(child) { list.append(path, [child]) }),
        )
      capture_nodes(root, queue, list.append(nodes, [node]))
    }
  }
}

pub fn capture(root: String) -> Result(Nil, String) {
  let before = native.env("BUILDX_EXPERIMENTAL")
  let _ = native.set_env("BUILDX_EXPERIMENTAL", "1")
  let captured = capture_nodes(root, [[]], [])
  let _ = native.set_env("BUILDX_EXPERIMENTAL", before)
  use nodes <- result.try(captured)
  use version <- result.try(c.run("docker", ["buildx", "version"], root))
  f.write(
    root <> "/containers/buildx/buildx-options.json",
    d.pretty(
      d.Object([
        #("version", d.Text(string.trim(version))),
        #("experimentalIncluded", d.Bool(True)),
        #("commands", d.Array(nodes)),
      ]),
    ),
  )
}
