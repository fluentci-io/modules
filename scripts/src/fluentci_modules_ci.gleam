//// Repository automation compiled to a BEAM escript.

import ci/audit
import ci/batch
import ci/buildx
import ci/catalogs
import ci/common as c
import ci/components
import ci/data as d
import ci/dependencies
import ci/files as f
import ci/native
import ci/registry
import ci/security
import ci/services
import ci/setup
import ci/toolchain
import ci/wasm
import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn flag(args: List(String), name: String, fallback: String) -> String {
  case args {
    [] -> fallback
    [key, value, ..] if key == name -> value
    [_, ..rest] -> flag(rest, name, fallback)
  }
}

fn csv(value: String) -> Result(List(String), String) {
  case string.trim(value) {
    "" -> Ok([])
    _ -> {
      let values = list.map(string.split(value, ","), string.trim)
      use _ <- result.try(c.require(
        list.all(values, fn(v) { v != "" }),
        "CSV entries must not be empty",
      ))
      Ok(values)
    }
  }
}

pub fn generate(root: String, check: Bool) -> Result(Nil, String) {
  use _ <- result.try(catalogs.cli(root, check))
  use _ <- result.try(catalogs.setup(root, check))
  use _ <- result.try(catalogs.service(root, check))
  use _ <- result.try(buildx.run(root, check))
  use _ <- result.try(components.run(root, check))
  use _ <- result.try(dependencies.run(root, check))
  audit.run(root, check)
}

pub fn validate_options(
  command: String,
  args: List(String),
) -> Result(Nil, String) {
  case command, args {
    "setup-toolchain", ["--file", _path, "--", ..] -> Ok(Nil)
    "validate-wasm", [_directory] | "inspect-wasm", [_directory] -> Ok(Nil)
    _, _ -> {
      let switches = case command {
        "generate-buildx" -> ["--check", "--capture"]
        "generate-cli"
        | "generate-setup"
        | "generate-services"
        | "generate-components"
        | "generate-dependencies"
        | "audit-modules" -> ["--check"]
        "validate-modules" -> ["--github-output"]
        _ -> []
      }
      let values = case command {
        "setup-toolchain" -> ["--profile", "--cache-dir"]
        "install-security-test-tools" -> ["--directory", "--tools"]
        "test-module-batch" -> ["--modules-env", "--log-dir"]
        _ -> []
      }
      parse_options(args, switches, values, [])
    }
  }
}

fn parse_options(
  args: List(String),
  switches: List(String),
  values: List(String),
  seen: List(String),
) -> Result(Nil, String) {
  case args {
    [] -> Ok(Nil)
    [key, ..rest] -> {
      use _ <- result.try(c.require(
        !list.contains(seen, key),
        "Duplicate argument: " <> key,
      ))
      case list.contains(switches, key) {
        True -> parse_options(rest, switches, values, [key, ..seen])
        False -> {
          use _ <- result.try(c.require(
            list.contains(values, key),
            "Unknown argument: " <> key,
          ))
          case rest {
            [value, ..rest] -> {
              use _ <- result.try(c.require(
                value != "" && !string.starts_with(value, "--"),
                "Missing value: " <> key,
              ))
              parse_options(rest, switches, values, [key, ..seen])
            }
            _ -> Error("Missing value: " <> key)
          }
        }
      }
    }
  }
}

pub fn dispatch(args: List(String)) -> Result(Nil, String) {
  use _ <- result.try(case args {
    [] -> Ok(Nil)
    [command, ..options] -> validate_options(command, options)
  })
  use root <- result.try(f.root())
  case args {
    [] | ["--help"] -> {
      let _ =
        native.stdout(
          "Usage: escript scripts/fluentci_modules_ci COMMAND [options]\nCommands: generate-all, check-all, generate-cli, generate-setup, generate-services, generate-buildx, generate-components, generate-dependencies, audit-modules, validate-modules, validate-wasm DIRECTORY, inspect-wasm DIRECTORY, setup-toolchain, install-security-test-tools, test-module-batch, test-services, test, export-setup-env\n",
        )
      Ok(Nil)
    }
    ["generate-all"] -> generate(root, False)
    ["check-all"] -> generate(root, True)
    ["generate-cli", ..options] ->
      catalogs.cli(root, list.contains(options, "--check"))
    ["generate-setup", ..options] ->
      catalogs.setup(root, list.contains(options, "--check"))
    ["generate-services", ..options] ->
      catalogs.service(root, list.contains(options, "--check"))
    ["generate-buildx", ..options] -> {
      use _ <- result.try(case list.contains(options, "--capture") {
        True -> buildx.capture(root)
        False -> Ok(Nil)
      })
      buildx.run(root, list.contains(options, "--check"))
    }
    ["generate-components", ..options] ->
      components.run(root, list.contains(options, "--check"))
    ["generate-dependencies", ..options] ->
      dependencies.run(root, list.contains(options, "--check"))
    ["audit-modules", ..options] ->
      audit.run(root, list.contains(options, "--check"))
    ["validate-modules", ..options] ->
      registry.run(root, list.contains(options, "--github-output"))
    ["validate-wasm", directory] -> wasm.run(root, native.absolute(directory))
    ["inspect-wasm", directory] -> {
      use names <- result.try(wasm.validate(root, native.absolute(directory)))
      let _ = native.stdout(d.encode(d.Array(list.map(names, d.Text))) <> "\n")
      Ok(Nil)
    }
    ["setup-toolchain", "--file", path, "--", ..options] ->
      toolchain.local(path, options)
    ["setup-toolchain", ..options] ->
      toolchain.run(
        root,
        flag(options, "--profile", "full"),
        native.absolute(flag(
          options,
          "--cache-dir",
          native.env("HOME") <> "/.cache/fluentci-ci",
        )),
      )
    ["install-security-test-tools", ..options] -> {
      let directory = flag(options, "--directory", "")
      use _ <- result.try(c.require(directory != "", "--directory is required"))
      use names <- result.try(
        csv(flag(options, "--tools", "betterleaks,gitleaks,syft")),
      )
      security.run(root, native.absolute(directory), names)
    }
    ["test-module-batch", ..options] -> {
      let variable = flag(options, "--modules-env", "MODULE_BATCH")
      let logs = flag(options, "--log-dir", "")
      use _ <- result.try(c.require(logs != "", "--log-dir is required"))
      use modules <- result.try(d.parse(native.env(variable)))
      use _ <- result.try(c.require(
        d.array(modules) != [],
        "Module batch must not be empty",
      ))
      batch.run(root, d.array(modules), native.absolute(logs))
    }
    ["test-services"] -> {
      let workers = case native.env("SERVICE_BUILD_CONCURRENCY") {
        "" -> Ok(4)
        value ->
          int.parse(value)
          |> result.map_error(fn(_) {
            "SERVICE_BUILD_CONCURRENCY must be an integer from 1 to 4"
          })
      }
      use workers <- result.try(workers)
      let logs = case native.env("SERVICE_LOG_DIR") {
        "" -> "/tmp/fluentci-service-e2e-logs"
        value -> value
      }
      services.run(root, native.absolute(logs), workers)
    }
    ["test"] ->
      c.stream("gleam", ["test", "--target", "erlang"], root <> "/scripts")
    ["export-setup-env"] -> setup.export()
    _ -> Error("Unknown CI helper command; use --help")
  }
}

pub fn main() {
  case dispatch(native.arguments()) {
    Ok(_) -> Nil
    Error(error) -> {
      let _ = native.stderr("CI helper failed: " <> error <> "\n")
      native.halt(1)
    }
  }
}
