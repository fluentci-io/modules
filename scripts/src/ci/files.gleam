import ci/common as c
import ci/data as d
import ci/native
import gleam/list
import gleam/result
import gleam/string

pub fn root() -> Result(String, String) {
  find_root(native.cwd(), 0)
}

fn find_root(path: String, depth: Int) -> Result(String, String) {
  case depth > 20 {
    True -> Error("Run inside the fluentci-modules repository")
    False ->
      case
        native.regular(path <> "/fluentci.toml")
        && native.regular(path <> "/lib/cli/catalog.json")
      {
        True -> Ok(path)
        False -> find_root(parent(path), depth + 1)
      }
  }
}

pub fn parent(path: String) -> String {
  let parts = string.split(path, "/")
  string.join(list.take(parts, list.length(parts) - 1), "/")
}

pub fn json(path: String) -> Result(d.Value, String) {
  use text <- result.try(c.text(path))
  d.parse(text) |> result.map_error(fn(error) { path <> ": " <> error })
}

pub fn toml(path: String) -> Result(d.Value, String) {
  use text <- result.try(c.text(path))
  d.parse_toml(text) |> result.map_error(fn(error) { path <> ": " <> error })
}

pub fn registry(root: String) -> Result(List(d.Value), String) {
  use config <- result.try(toml(root <> "/fluentci.toml"))
  Ok(d.array(d.get(config, "modules")))
}

pub fn write(path: String, content: String) -> Result(Nil, String) {
  use _ <- result.try(native.mkdir(parent(path)))
  c.write(path, content)
}

pub fn generated(
  path: String,
  content: String,
  check: Bool,
) -> Result(Nil, String) {
  case check {
    True ->
      c.require(c.text(path) == Ok(content), "Stale generated file: " <> path)
    False -> write(path, content)
  }
}

pub fn walk(path: String) -> Result(List(String), String) {
  use names <- result.try(native.list_dir(path))
  list.try_fold(names, [], fn(acc, name) {
    let child = path <> "/" <> name
    case
      string.starts_with(name, ".")
      || list.contains(["node_modules", "output", "dist", "build"], name)
    {
      True -> Ok(acc)
      False ->
        case native.is_directory(child) {
          True -> {
            use children <- result.try(walk(child))
            Ok(list.append(acc, children))
          }
          False -> Ok(list.append(acc, [child]))
        }
    }
  })
}

pub fn title(name: String) -> String {
  name
  |> string.split("-")
  |> list.map(fn(part) {
    string.uppercase(string.slice(part, 0, 1))
    <> string.slice(part, 1, string.length(part))
  })
  |> string.concat
}

pub fn kebab(name: String) -> String {
  name
  |> string.to_graphemes
  |> list.index_map(fn(c, index) {
    case c == string.uppercase(c) && c != string.lowercase(c) && index > 0 {
      True -> "-" <> string.lowercase(c)
      False -> c
    }
  })
  |> string.concat
  |> string.replace("_", "-")
  |> string.lowercase
}

pub fn lines(values: List(String)) -> String {
  string.join(values, "\n")
}

pub fn safe_name(name: String) -> Bool {
  name != ""
  && c.ascii(string.slice(name, 0, 1), "abcdefghijklmnopqrstuvwxyz")
  && c.ascii(name, "abcdefghijklmnopqrstuvwxyz0123456789-")
  && !string.starts_with(name, "-")
}

pub fn module_path(path: String) -> Bool {
  case string.split(path, "/") {
    [category, name] -> safe_name(category) && safe_name(name)
    _ -> False
  }
}

pub fn label(value: String) -> String {
  let #(parts, _) =
    list.fold(string.to_graphemes(value), #([], False), fn(acc, char) {
      let upper =
        char == string.uppercase(char) && char != string.lowercase(char)
      let text = case upper && acc.1 {
        True -> " " <> char
        False -> char
      }
      #(
        [text, ..acc.0],
        char == string.lowercase(char) && char != string.uppercase(char),
      )
    })
  let value = string.replace(string.concat(list.reverse(parts)), "_", " ")
  string.uppercase(string.slice(value, 0, 1)) <> string.drop_start(value, 1)
}
