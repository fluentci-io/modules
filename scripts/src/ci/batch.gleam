import ci/commands
import ci/common as c
import ci/data as d
import ci/files as f
import ci/native
import ci/wasm
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn run(
  root: String,
  modules: List(d.Value),
  logs: String,
) -> Result(Nil, String) {
  use _ <- result.try(native.mkdir(logs))
  let failures =
    list.filter_map(modules, fn(module) {
      let name = d.s(module, "name")
      let path = d.s(module, "path")
      let checked = {
        use _ <- result.try(c.require(
          f.safe_name(name) && f.module_path(path),
          "Invalid module batch identity",
        ))
        let directory = root <> "/" <> path
        let log = logs <> "/" <> name <> ".log"
        let _ = native.stdout("Testing " <> name <> "\n")
        let install = case string.starts_with(path, "testing/") {
          True -> ["bun", "install", "--frozen-lockfile"]
          False -> ["npm", "ci"]
        }
        use _ <- result.try(
          c.all([install, ["npm", "run", "build"], ["npm", "test"]], fn(argv) {
            commands.logged(argv, directory, log, 1_200_000, False)
            |> result.map(fn(_) { Nil })
          }),
        )
        use _ <- result.try(wasm.run(root, directory))
        use manifest <- result.try(f.toml(directory <> "/fluentci-module.toml"))
        use _ <- result.try(case d.fields(d.get(manifest, "dependencies")) {
          [] -> Ok("")
          _ ->
            commands.logged(
              ["fluentci", "run", ".", "--help"],
              directory,
              log,
              1_200_000,
              False,
            )
        })
        let _ = native.stdout(name <> " passed\n")
        Ok(Nil)
      }
      case checked {
        Ok(_) -> Error(Nil)
        Error(error) -> {
          let _ = native.stderr(name <> " FAILED: " <> error <> "\n")
          Ok(name)
        }
      }
    })
  let _ =
    native.stdout(
      int.to_string(list.length(modules) - list.length(failures))
      <> "/"
      <> int.to_string(list.length(modules))
      <> " modules passed\n",
    )
  c.require(failures == [], "Failed modules: " <> string.join(failures, ", "))
}
