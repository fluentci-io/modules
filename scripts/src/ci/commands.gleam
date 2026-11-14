import ci/data as d
import ci/files as f
import ci/native
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn logged(
  argv: List(String),
  directory: String,
  log: String,
  timeout: Int,
  allow_failure: Bool,
) -> Result(String, String) {
  use _ <- result.try(native.mkdir(f.parent(log)))
  use _ <- result.try(native.append(
    log,
    "\n$ " <> d.encode(d.Array(list.map(argv, d.Text))) <> "\n",
  ))
  let _ =
    native.stderr("$ " <> d.encode(d.Array(list.map(argv, d.Text))) <> "\n")
  case argv {
    [] -> Error("Empty command")
    [program, ..args] -> {
      let #(code, output) =
        native.execute_timeout(program, args, directory, True, True, timeout)
      use _ <- result.try(native.append(log, output))
      case code == 0 || allow_failure {
        True -> Ok(output)
        False -> {
          let _ =
            native.stderr(
              string.slice(
                output,
                int.max(0, string.length(output) - 12_000),
                12_000,
              )
              <> "\n",
            )
          Error(
            program
            <> " failed ("
            <> int.to_string(code)
            <> "), inspect "
            <> log,
          )
        }
      }
    }
  }
}

pub fn component_limit(value: String, cores: Int) -> Result(Int, String) {
  let parsed = case value {
    "" -> Ok(int.max(1, int.min(32, cores)))
    _ -> int.parse(value)
  }
  use limit <- result.try(
    result.map_error(parsed, fn(_) {
      "COMPONENT_BUILD_CONCURRENCY must be an integer from 1 to 32"
    }),
  )
  case limit >= 1 && limit <= 32 {
    True -> Ok(limit)
    False ->
      Error("COMPONENT_BUILD_CONCURRENCY must be an integer from 1 to 32")
  }
}

pub fn compile(
  argv: List(String),
  directory: String,
  log: String,
  timeout: Int,
  allow_failure: Bool,
) -> Result(String, String) {
  use limit <- result.try(component_limit(
    native.env("COMPONENT_BUILD_CONCURRENCY"),
    native.cpu_cores(),
  ))
  let _ =
    native.stdout(
      "Waiting for component compiler slot: "
      <> directory
      <> " (host CPUs="
      <> int.to_string(native.cpu_cores())
      <> "; compilation limit="
      <> int.to_string(limit)
      <> ")\n",
    )
  native.with_slots("component-compiler", limit, fn() {
    let _ = native.stdout("Compiling component: " <> directory <> "\n")
    logged(argv, directory, log, timeout, allow_failure)
  })
}
