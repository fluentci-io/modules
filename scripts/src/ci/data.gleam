import gleam/dict
import gleam/dynamic/decode
import gleam/int
import gleam/json
import gleam/list
import gleam/result
import gleam/string
import tom

// Ordered JSON values keep catalog field and public argument order stable.
pub type Value {
  Object(List(#(String, Value)))
  Array(List(Value))
  Text(String)
  Number(String)
  Bool(Bool)
  Null
}

pub fn get(value: Value, key: String) -> Value {
  case value {
    Object(fields) -> list.key_find(fields, key) |> result.unwrap(Null)
    _ -> Null
  }
}

pub fn text(value: Value) -> String {
  case value {
    Text(s) -> s
    _ -> ""
  }
}

pub fn bool(value: Value) -> Bool {
  value == Bool(True)
}

pub fn array(value: Value) -> List(Value) {
  case value {
    Array(items) -> items
    _ -> []
  }
}

pub fn fields(value: Value) -> List(#(String, Value)) {
  case value {
    Object(items) -> items
    _ -> []
  }
}

pub fn s(value: Value, key: String) -> String {
  text(get(value, key))
}

pub fn strings(value: Value) -> List(String) {
  list.map(array(value), text)
}

pub fn put(value: Value, key: String, item: Value) -> Value {
  let pairs = fields(value)
  case list.key_find(pairs, key) {
    Ok(_) ->
      Object(
        list.map(pairs, fn(pair) {
          case pair.0 == key {
            True -> #(key, item)
            False -> pair
          }
        }),
      )
    Error(_) -> Object(list.append(pairs, [#(key, item)]))
  }
}

pub fn delete(value: Value, key: String) -> Value {
  Object(list.filter(fields(value), fn(pair) { pair.0 != key }))
}

pub fn merge(first: Value, second: Value) -> Value {
  list.fold(fields(second), first, fn(value, pair) {
    put(value, pair.0, pair.1)
  })
}

pub fn quote(value: String) -> String {
  json.to_string(json.string(value))
}

fn spaces(chars: List(String)) -> List(String) {
  list.drop_while(chars, fn(c) { list.contains([" ", "\n", "\r", "\t"], c) })
}

fn quoted(
  chars: List(String),
  acc: List(String),
  escaped: Bool,
) -> Result(#(String, List(String)), String) {
  case chars {
    [] -> Error("Unterminated JSON string")
    ["\"", ..rest] if !escaped -> {
      let literal = "\"" <> string.concat(list.reverse(["\"", ..acc]))
      use value <- result.try(
        json.parse(literal, decode.string)
        |> result.map_error(fn(_) { "Invalid JSON string" }),
      )
      Ok(#(value, rest))
    }
    [head, ..tail] -> quoted(tail, [head, ..acc], head == "\\" && !escaped)
  }
}

fn parse_value(chars: List(String)) -> Result(#(Value, List(String)), String) {
  case spaces(chars) {
    ["\"", ..rest] -> {
      use pair <- result.try(quoted(rest, [], False))
      Ok(#(Text(pair.0), pair.1))
    }
    ["{", ..rest] -> object_value(spaces(rest), [])
    ["[", ..rest] -> array_value(spaces(rest), [])
    ["t", "r", "u", "e", ..rest] -> Ok(#(Bool(True), rest))
    ["f", "a", "l", "s", "e", ..rest] -> Ok(#(Bool(False), rest))
    ["n", "u", "l", "l", ..rest] -> Ok(#(Null, rest))
    input -> {
      let #(number, rest) =
        list.split_while(input, fn(c) {
          list.contains(string.to_graphemes("-+0123456789.eE"), c)
        })
      let token = string.concat(number)
      use _ <- result.try(
        json.parse(
          token,
          decode.one_of(decode.map(decode.int, fn(_) { Nil }), [
            decode.map(decode.float, fn(_) { Nil }),
          ]),
        )
        |> result.map_error(fn(_) { "Invalid JSON value: " <> token }),
      )
      Ok(#(Number(token), rest))
    }
  }
}

fn object_value(
  chars: List(String),
  pairs: List(#(String, Value)),
) -> Result(#(Value, List(String)), String) {
  case chars {
    ["}", ..rest] -> Ok(#(Object(list.reverse(pairs)), rest))
    ["\"", ..rest] -> {
      use key <- result.try(quoted(rest, [], False))
      use _ <- result.try(case list.key_find(pairs, key.0) {
        Ok(_) -> Error("Duplicate JSON key: " <> key.0)
        Error(_) -> Ok(Nil)
      })
      case spaces(key.1) {
        [":", ..rest] -> {
          use value <- result.try(parse_value(rest))
          let next = [#(key.0, value.0), ..pairs]
          case spaces(value.1) {
            [",", ..tail] ->
              case spaces(tail) {
                ["}", ..] -> Error("Trailing JSON comma")
                other -> object_value(other, next)
              }
            ["}", ..tail] -> Ok(#(Object(list.reverse(next)), tail))
            _ -> Error("Expected JSON object delimiter")
          }
        }
        _ -> Error("Expected JSON colon")
      }
    }
    _ -> Error("Expected JSON object key")
  }
}

fn array_value(
  chars: List(String),
  values: List(Value),
) -> Result(#(Value, List(String)), String) {
  case chars {
    ["]", ..rest] -> Ok(#(Array(list.reverse(values)), rest))
    input -> {
      use value <- result.try(parse_value(input))
      let next = [value.0, ..values]
      case spaces(value.1) {
        [",", ..tail] ->
          case spaces(tail) {
            ["]", ..] -> Error("Trailing JSON comma")
            other -> array_value(other, next)
          }
        ["]", ..tail] -> Ok(#(Array(list.reverse(next)), tail))
        _ -> Error("Expected JSON array delimiter")
      }
    }
  }
}

pub fn parse(source: String) -> Result(Value, String) {
  use parsed <- result.try(parse_value(string.to_graphemes(source)))
  case spaces(parsed.1) {
    [] -> Ok(parsed.0)
    _ -> Error("Trailing JSON data")
  }
}

pub fn encode(value: Value) -> String {
  case value {
    Text(s) -> quote(s)
    Number(s) -> s
    Bool(True) -> "true"
    Bool(False) -> "false"
    Null -> "null"
    Array(items) -> "[" <> string.join(list.map(items, encode), ",") <> "]"
    Object(items) ->
      "{"
      <> string.join(
        list.map(items, fn(p) { quote(p.0) <> ":" <> encode(p.1) }),
        ",",
      )
      <> "}"
  }
}

fn indent(depth: Int) -> String {
  string.repeat("  ", depth)
}

fn pretty_at(value: Value, depth: Int) -> String {
  let children = case value {
    Object(items) ->
      list.map(items, fn(p) { quote(p.0) <> ": " <> pretty_at(p.1, depth + 1) })
    Array(items) -> list.map(items, fn(item) { pretty_at(item, depth + 1) })
    _ -> []
  }
  case children {
    [] -> encode(value)
    _ -> {
      let #(start, end) = case value {
        Object(_) -> #("{", "}")
        _ -> #("[", "]")
      }
      start
      <> "\n"
      <> indent(depth + 1)
      <> string.join(children, ",\n" <> indent(depth + 1))
      <> "\n"
      <> indent(depth)
      <> end
    }
  }
}

pub fn pretty(value: Value) -> String {
  pretty_at(value, 0) <> "\n"
}

fn from_tom(value: tom.Toml) -> Value {
  case value {
    tom.String(v) -> Text(v)
    tom.Bool(v) -> Bool(v)
    tom.Int(v) -> Number(json.to_string(json.int(v)))
    tom.Float(v) -> Number(json.to_string(json.float(v)))
    tom.Array(values) -> Array(list.map(values, from_tom))
    tom.ArrayOfTables(values) ->
      Array(list.map(values, fn(v) { from_tom(tom.Table(v)) }))
    tom.Table(values) | tom.InlineTable(values) ->
      Object(list.map(dict.to_list(values), fn(p) { #(p.0, from_tom(p.1)) }))
    _ -> Null
  }
}

pub fn parse_toml(source: String) -> Result(Value, String) {
  use parsed <- result.try(
    tom.parse(source) |> result.map_error(fn(_) { "Invalid TOML document" }),
  )
  Ok(from_tom(tom.Table(parsed)))
}

pub fn integer(value: Value) -> Int {
  case value {
    Number(s) -> int.parse(s) |> result.unwrap(0)
    _ -> 0
  }
}

pub fn equivalent(left: Value, right: Value) -> Bool {
  case left, right {
    Object(a), Object(b) ->
      list.length(a) == list.length(b)
      && list.all(a, fn(p) {
        case list.key_find(b, p.0) {
          Ok(v) -> equivalent(p.1, v)
          Error(_) -> False
        }
      })
    Array(a), Array(b) ->
      list.length(a) == list.length(b)
      && list.all(list.zip(a, b), fn(p) { equivalent(p.0, p.1) })
    _, _ -> left == right
  }
}

pub fn parse_prefix(source: String) -> Result(Value, String) {
  parse_value(string.to_graphemes(source))
  |> result.map(fn(parsed) { parsed.0 })
}
