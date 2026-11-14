import ci/artifacts
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
  use workers <- result.try(concurrency(native.env("MODULE_BUILD_CONCURRENCY")))
  use _ <- result.try(c.require(
    list.length(list.unique(list.map(modules, fn(m) { d.s(m, "path") })))
      == list.length(modules),
    "Module batch must not build a source directory twice concurrently",
  ))
  let _ =
    native.stdout(
      "Building module batch with concurrency "
      <> int.to_string(workers)
      <> "\n",
    )
  let failures = build_all(root, modules, logs, workers)
  let _ =
    native.stdout(
      int.to_string(list.length(modules) - list.length(failures))
      <> "/"
      <> int.to_string(list.length(modules))
      <> " modules passed\n",
    )
  c.require(failures == [], "Failed modules: " <> string.join(failures, ", "))
}

pub fn concurrency(value: String) -> Result(Int, String) {
  let parsed = case value {
    "" -> Ok(32)
    _ -> int.parse(value)
  }
  use workers <- result.try(
    result.map_error(parsed, fn(_) {
      "MODULE_BUILD_CONCURRENCY must be an integer from 1 to 32"
    }),
  )
  use _ <- result.try(c.require(
    workers >= 1 && workers <= 32,
    "MODULE_BUILD_CONCURRENCY must be an integer from 1 to 32",
  ))
  Ok(workers)
}

fn build_all(
  root: String,
  modules: List(d.Value),
  logs: String,
  workers: Int,
) -> List(String) {
  case modules {
    [] -> []
    _ -> {
      let group = list.take(modules, workers)
      // Finish shared source writes before any module compiler starts.
      let prepared = list.map(group, fn(module) { prepare(root, module, logs) })
      let built =
        native.parallel(list.zip(group, prepared), fn(pair) {
          use _ <- result.try(pair.1)
          check(root, pair.0, logs)
        })
      // Composition may prepare setup sources again, so wait for all compilers.
      let results =
        list.map(list.zip(group, built), fn(pair) {
          use _ <- result.try(pair.1)
          finish(root, pair.0, logs)
        })
      let failures =
        list.filter_map(results, fn(value) {
          case value {
            Ok(_) -> Error(Nil)
            Error(error) -> Ok(error)
          }
        })
      list.append(
        failures,
        build_all(root, list.drop(modules, workers), logs, workers),
      )
    }
  }
}

fn check(root: String, module: d.Value, logs: String) -> Result(Nil, String) {
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
    use _ <- result.try(commands.logged(
      install,
      directory,
      log,
      1_200_000,
      False,
    ))
    use _ <- result.try(commands.logged(
      ["node", root <> "/lib/component/build-cli.mjs"],
      directory,
      log,
      1_200_000,
      False,
    ))
    use _ <- result.try(commands.logged(
      ["npm", "test"],
      directory,
      log,
      1_200_000,
      False,
    ))
    use _ <- result.try(wasm.run(root, directory))
    Ok(Nil)
  }
  result.map_error(checked, fn(error) {
    let _ = native.stderr(name <> " FAILED: " <> error <> "\n")
    name
  })
}

fn prepare(root: String, module: d.Value, logs: String) -> Result(Nil, String) {
  let name = d.s(module, "name")
  let path = d.s(module, "path")
  use _ <- result.try(c.require(
    f.safe_name(name) && f.module_path(path),
    "Invalid module batch identity",
  ))
  use _ <- result.try(commands.logged(
    ["fluentci", "install", "--frozen-lockfile"],
    root <> "/" <> path,
    logs <> "/" <> name <> ".log",
    1_200_000,
    False,
  ))
  Ok(Nil)
}

fn finish(root: String, module: d.Value, logs: String) -> Result(Nil, String) {
  let name = d.s(module, "name")
  let directory = root <> "/" <> d.s(module, "path")
  let log = logs <> "/" <> name <> ".log"
  let checked = {
    use artifact <- result.try(artifacts.prepare(root, name, directory, log))
    use _ <- result.try(commands.logged(
      ["fluentci", "run", "--wasm", artifact, "--help"],
      directory,
      log,
      60_000,
      False,
    ))
    let _ = native.stdout(name <> " passed\n")
    Ok(Nil)
  }
  result.map_error(checked, fn(error) {
    let _ = native.stderr(name <> " FAILED: " <> error <> "\n")
    name
  })
}
