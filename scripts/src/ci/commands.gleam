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
  case argv {
    [] -> Error("Empty command")
    [program, ..args] -> {
      let #(code, output) =
        native.execute_timeout(program, args, directory, False, True, timeout)
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
