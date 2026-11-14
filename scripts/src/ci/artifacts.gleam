//// Prepare a composed component once and reuse its exact bytes for CI calls.

import ci/commands
import ci/common as c
import ci/data as d
import ci/files as f
import ci/native
import gleam/result
import gleam/string

pub fn path(output: String, name: String) -> Result(String, String) {
  find(string.split(output, "\n"), name)
}

fn find(lines: List(String), name: String) -> Result(String, String) {
  case lines {
    [] ->
      Error("Module inspection did not return a prebuilt artifact for " <> name)
    [_, ..rest] -> {
      let candidate = {
        use record <- result.try(d.parse_prefix(string.join(lines, "\n")))
        use module <- result.try(case d.array(d.get(record, "modules")) {
          [module] -> Ok(module)
          _ -> Error("Expected exactly one inspected module")
        })
        let artifact = d.s(module, "wasm")
        use _ <- result.try(c.require(
          d.s(module, "name") == name
            && string.starts_with(artifact, "/")
            && string.ends_with(artifact, ".wasm")
            && !string.contains(artifact, "\u{0}"),
          "Invalid inspected artifact identity or path",
        ))
        Ok(artifact)
      }
      case candidate {
        Ok(artifact) -> Ok(artifact)
        Error(_) -> find(rest, name)
      }
    }
  }
}

pub fn prepare(
  root: String,
  name: String,
  directory: String,
  log: String,
) -> Result(String, String) {
  use output <- result.try(commands.logged(
    ["fluentci", "modules", name, "--json"],
    root,
    log,
    1_200_000,
    False,
  ))
  use artifact <- result.try(path(output, name))
  use bytes <- result.try(native.read(artifact))
  use _ <- result.try(c.require(
    case bytes {
      <<0, 97, 115, 109, 13, 0, 1, 0, _:bits>> -> True
      _ -> False
    },
    "Prepared artifact is not a Wasm component",
  ))
  let target = directory <> "/dist/ci.wasm"
  use _ <- result.try(native.mkdir(f.parent(target)))
  use _ <- result.try(native.write(target, bytes))
  Ok(target)
}
