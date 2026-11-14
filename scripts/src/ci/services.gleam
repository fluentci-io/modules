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

pub fn value(operation: String, output: String) -> Result(d.Value, String) {
  case operation {
    "logs" -> Ok(d.Text(output))
    "build" -> {
      let image =
        string.trim_end(output)
        |> string.split("\n")
        |> list.last
        |> result.unwrap("")
        |> string.trim
      use _ <- result.try(c.require(
        image != "",
        "Native build did not return an image reference",
      ))
      Ok(d.Text(image))
    }
    _ -> records(string.split(output, "\n"))
  }
}

fn records(lines: List(String)) -> Result(d.Value, String) {
  case lines {
    [] -> Error("Native operation did not return a JSON service record")
    [_, ..tail] ->
      case d.parse_prefix(string.join(lines, "\n")) {
        Ok(record) ->
          case
            d.s(record, "name") != ""
            && d.s(record, "state") != ""
            && case d.get(record, "ports") {
              d.Array(_) -> True
              _ -> False
            }
          {
            True ->
              case records(tail) {
                Ok(last) -> Ok(last)
                Error(_) -> Ok(record)
              }
            False -> records(tail)
          }
        Error(_) -> records(tail)
      }
  }
}

fn field(value: d.Value, name: String) -> d.Value {
  case d.get(value, name) {
    d.Null -> d.get(value, f.kebab(name))
    other -> other
  }
}

pub fn invocation(
  name: String,
  operation: String,
  project: String,
  fields: List(#(String, d.Value)),
) -> List(String) {
  list.append(
    ["fluentci", "run", name, operation, "--project", project],
    list.map(fields, fn(p) {
      "--"
      <> f.kebab(p.0)
      <> "="
      <> case p.1 {
        d.Text(value) -> value
        other -> d.encode(other)
      }
    }),
  )
}

fn invoke(
  root: String,
  project: String,
  profile: d.Value,
  operation: String,
  fields: List(#(String, d.Value)),
  log: String,
) -> Result(d.Value, String) {
  use output <- result.try(commands.logged(
    invocation(d.s(profile, "name"), operation, project, fields),
    root,
    log,
    case operation {
      "build" -> 2_100_000
      _ -> 1_200_000
    },
    False,
  ))
  let expected =
    list.key_find(fields, "image") |> result.unwrap(d.Null) |> d.text
  case operation == "build" && expected != "" {
    True ->
      c.require(
        list.contains(
          list.map(string.split(output, "\n"), string.trim),
          expected,
        ),
        "Native build did not return its expected image reference",
      )
      |> result.map(fn(_) { d.Text(expected) })
    False -> value(operation, output)
  }
  |> result.map_error(fn(error) {
    d.s(profile, "name")
    <> " "
    <> operation
    <> ": "
    <> error
    <> "; inspect "
    <> log
  })
}

fn build(root: String, profile: d.Value, logs: String) -> Result(Nil, String) {
  let name = d.s(profile, "name")
  let directory = root <> "/services/" <> name
  let log = logs <> "/" <> name <> ".log"
  let _ = native.stdout("Building service component " <> name <> "\n")
  use _ <- result.try(commands.logged(
    ["npm", "ci"],
    directory,
    log,
    900_000,
    False,
  ))
  use _ <- result.try(
    native.serial(fn() {
      commands.logged(
        ["fluentci", "install", "--frozen-lockfile"],
        directory,
        log,
        1_200_000,
        False,
      )
    }),
  )
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
    900_000,
    False,
  ))
  use _ <- result.try(wasm.run(root, directory))
  use _ <- result.try(
    native.serial(fn() {
      commands.logged(
        ["fluentci", "run", name, "--help"],
        root,
        log,
        1_200_000,
        False,
      )
    }),
  )
  let _ = native.stdout("Built service component " <> name <> "\n")
  Ok(Nil)
}

fn build_all(
  root: String,
  profiles: List(d.Value),
  logs: String,
  workers: Int,
) -> Result(Nil, String) {
  case profiles {
    [] -> Ok(Nil)
    _ -> {
      let results =
        native.parallel(list.take(profiles, workers), fn(profile) {
          build(root, profile, logs)
        })
      let failures =
        list.filter_map(results, fn(r) {
          case r {
            Ok(_) -> Error(Nil)
            Error(error) -> Ok(error)
          }
        })
      let rest = build_all(root, list.drop(profiles, workers), logs, workers)
      use _ <- result.try(c.require(
        failures == [],
        "Service build failures: " <> string.join(failures, "; "),
      ))
      rest
    }
  }
}

fn containers(
  root: String,
  name: String,
  log: String,
) -> Result(List(String), String) {
  use output <- result.try(commands.logged(
    [
      "docker",
      "ps",
      "--all",
      "--filter",
      "label=io.fluentci.managed=true",
      "--format",
      "{{.ID}} {{.Names}}",
    ],
    root,
    log,
    10_000,
    False,
  ))
  Ok(
    output
    |> string.split("\n")
    |> list.filter(fn(line) { string.contains(line, "-" <> name <> "-") })
    |> list.map(fn(line) {
      string.split(line, " ") |> list.first |> result.unwrap("")
    }),
  )
}

fn http(
  root: String,
  url: String,
  log: String,
  args: List(String),
) -> Result(String, String) {
  commands.logged(
    list.append(
      ["curl", "--fail", "--silent", "--show-error", "--max-time", "10"],
      list.append(args, [url]),
    ),
    root,
    log,
    15_000,
    False,
  )
}

fn connectivity(
  root: String,
  profile: d.Value,
  record: d.Value,
  state: String,
  log: String,
) -> Result(Nil, String) {
  let port = d.integer(d.get(record, "port"))
  use _ <- result.try(
    c.all(d.array(d.get(record, "ports")), fn(binding) {
      let port = d.integer(d.get(binding, "port"))
      use _ <- result.try(c.require(
        port > 0
          && d.s(binding, "address") == "127.0.0.1:" <> int.to_string(port),
        "Invalid allocated loopback binding",
      ))
      native.tcp(port, "", False) |> result.map(fn(_) { Nil })
    }),
  )
  use _ <- result.try(case d.s(profile, "name") {
    "redis" -> {
      use output <- result.try(native.tcp(port, "PING\r\n", True))
      c.require(string.contains(output, "PONG"), "Unexpected Redis response")
    }
    "mailpit" | "mailhog" | "mailcatcher" -> {
      use banner <- result.try(native.tcp(port, "", True))
      use _ <- result.try(c.require(
        string.contains(banner, "220"),
        "Unexpected SMTP banner",
      ))
      use web <- result.try(
        list.find(d.array(d.get(record, "ports")), fn(binding) {
          d.integer(field(binding, "containerPort")) != 1025
        })
        |> result.map_error(fn(_) { "Missing mail web binding" }),
      )
      http(
        root,
        "http://127.0.0.1:"
          <> int.to_string(d.integer(d.get(web, "port")))
          <> "/",
        log,
        [],
      )
      |> result.map(fn(_) { Nil })
    }
    "aws-emulator" -> {
      let directory = state <> "/" <> int.to_string(port)
      use _ <- result.try(
        c.all(["ca.pem", "emulator_credentials", "config"], fn(file) {
          c.require(
            native.regular(directory <> "/" <> file),
            "AWS Emulator material missing: " <> directory <> "/" <> file,
          )
        }),
      )
      http(root, d.s(record, "endpoint") <> "/__admin/health", log, [
        "--cacert",
        directory <> "/ca.pem",
      ])
      |> result.map(fn(_) { Nil })
    }
    _ -> Ok(Nil)
  })
  use _ <- result.try(case d.s(profile, "probe") {
    "http" ->
      http(root, d.s(record, "endpoint") <> d.s(profile, "path"), log, [])
      |> result.map(fn(_) { Nil })
    _ -> Ok(Nil)
  })
  use _ <- result.try(case d.s(profile, "name") {
    "stripe-mock" ->
      http(root, d.s(record, "endpoint") <> "/v1/charges", log, [
        "--header",
        "Authorization: Bearer sk_test_123",
      ])
      |> result.map(fn(_) { Nil })
    _ -> Ok(Nil)
  })
  case d.s(profile, "name") {
    "consul" -> {
      use response <- result.try(
        http(root, d.s(record, "endpoint") <> "/v1/status/leader", log, []),
      )
      use value <- result.try(d.parse(response))
      c.require(d.text(value) != "", "Consul has no leader")
    }
    _ -> Ok(Nil)
  }
}

fn follow_read(
  process: native.Process,
  log: String,
  buffer: String,
  interrupted: Bool,
  deadline: Int,
) -> Result(Nil, String) {
  let remaining = int.max(0, deadline - native.monotonic_ms())
  case native.read_process(process, remaining) {
    native.Data(data) -> {
      use _ <- result.try(native.append(log, data))
      let buffer = buffer <> data
      let buffer =
        string.slice(buffer, int.max(0, string.length(buffer) - 65_536), 65_536)
      let ready =
        interrupted
        || string.contains(
          string.lowercase(buffer),
          "ready to accept connections",
        )
      case ready && !interrupted {
        True -> {
          let _ = native.signal_process(process, "INT")
          follow_read(
            process,
            log,
            buffer,
            True,
            native.monotonic_ms() + 10_000,
          )
        }
        False -> follow_read(process, log, buffer, interrupted, deadline)
      }
    }
    native.Exited(_) ->
      c.require(interrupted, "Follow exited before interruption")
    native.TimedOut ->
      Error("Follow did not stream readiness or exit after interruption")
  }
}

fn follow(
  root: String,
  project: String,
  profile: d.Value,
  name: String,
  log: String,
) -> Result(Nil, String) {
  let argv =
    invocation(d.s(profile, "name"), "logs", project, [
      #("name", d.Text(name)),
      #("tail", d.Number("100")),
      #("follow", d.Bool(True)),
    ])
  use process <- result.try(native.open_process("setsid", argv, root))
  let result =
    follow_read(process, log, "", False, native.monotonic_ms() + 90_000)
  let _ = native.signal_process(process, "KILL")
  result
}

fn lifecycle(
  root: String,
  project: String,
  profile: d.Value,
  name: String,
  fields: List(#(String, d.Value)),
  state: String,
  volume: String,
  log: String,
) -> Result(Nil, String) {
  let control = [#("name", d.Text(name))]
  use started <- result.try(invoke(root, project, profile, "start", fields, log))
  use _ <- result.try(c.require(
    d.s(started, "name") == name && d.s(started, "state") == "ready",
    "Service did not become ready",
  ))
  use first <- result.try(containers(root, name, log))
  use _ <- result.try(c.require(
    list.length(first) == 1,
    "Expected one owned service container",
  ))
  use same <- result.try(invoke(root, project, profile, "start", fields, log))
  use second <- result.try(containers(root, name, log))
  use _ <- result.try(c.require(
    d.get(same, "port") == d.get(started, "port") && first == second,
    "Idempotent start did not reuse its container",
  ))
  use _ <- result.try(connectivity(root, profile, started, state, log))
  use status <- result.try(invoke(
    root,
    project,
    profile,
    "status",
    control,
    log,
  ))
  use _ <- result.try(c.require(
    d.s(status, "state") == "ready",
    "Service status is not ready",
  ))
  use _ <- result.try(invoke(
    root,
    project,
    profile,
    "logs",
    list.append(control, [#("tail", d.Number("20"))]),
    log,
  ))
  use _ <- result.try(case d.s(profile, "name") {
    "redis" -> {
      use _ <- result.try(follow(root, project, profile, name, log))
      use status <- result.try(invoke(
        root,
        project,
        profile,
        "status",
        control,
        log,
      ))
      use containers <- result.try(containers(root, name, log))
      c.require(
        d.s(status, "state") == "ready" && containers == first,
        "Following logs changed service lifecycle",
      )
    }
    _ -> Ok(Nil)
  })
  use restarted <- result.try(invoke(
    root,
    project,
    profile,
    "restart",
    control,
    log,
  ))
  use changed <- result.try(containers(root, name, log))
  use _ <- result.try(c.require(
    d.s(restarted, "state") == "ready" && changed != first,
    "Restart did not replace the container",
  ))
  use _ <- result.try(connectivity(root, profile, restarted, state, log))
  use _ <- result.try(
    c.all([0, 1], fn(_) {
      use stopped <- result.try(invoke(
        root,
        project,
        profile,
        "stop",
        control,
        log,
      ))
      c.require(d.s(stopped, "state") == "stopped", "Stop is not idempotent")
    }),
  )
  use status <- result.try(invoke(
    root,
    project,
    profile,
    "status",
    control,
    log,
  ))
  use containers <- result.try(containers(root, name, log))
  use _ <- result.try(c.require(
    d.integer(d.get(status, "port")) == 0 && containers == [],
    "Service container leaked after stop",
  ))
  case d.s(profile, "name") {
    "redis" ->
      commands.logged(
        ["docker", "volume", "inspect", volume],
        root,
        log,
        10_000,
        False,
      )
      |> result.map(fn(_) { Nil })
    _ -> Ok(Nil)
  }
}

pub fn run(root: String, logs: String, workers: Int) -> Result(Nil, String) {
  use _ <- result.try(c.require(
    workers >= 1 && workers <= 4,
    "SERVICE_BUILD_CONCURRENCY must be an integer from 1 to 4",
  ))
  use _ <- result.try(native.mkdir(logs))
  use catalog <- result.try(f.json(root <> "/lib/services/catalog.json"))
  let profiles = d.array(catalog)
  use _ <- result.try(c.stream(
    "fluentci",
    ["services", "apply", "--help"],
    root,
  ))
  use _ <- result.try(c.stream("docker", ["info"], root))
  let _ =
    native.stdout(
      "Building service components with concurrency "
      <> int.to_string(workers)
      <> "\n",
    )
  use _ <- result.try(build_all(root, profiles, logs, workers))
  c.with_temp("fluentci-services-e2e-", fn(project) {
    use _ <- result.try(c.write(
      project <> "/fluentci.toml",
      "# Dedicated native service E2E workspace\n",
    ))
    let id = native.nonce()
    let failures =
      list.filter_map(profiles, fn(profile) {
        let tool = d.s(profile, "name")
        let _ = native.stdout("E2E " <> tool <> "\n")
        let name = "module-" <> tool <> "-e2e-" <> id
        let log = logs <> "/" <> tool <> ".log"
        let state = project <> "/aws-material"
        let volume = "fluentci-services-e2e-" <> id
        let image = case tool {
          "aws-emulator" -> "fluentci/aws-emulator:e2e-" <> id
          _ -> d.s(profile, "image") <> ":" <> d.s(profile, "version")
        }
        let fields = [
          #("name", d.Text(name)),
          #("startupTimeoutMs", d.Number("600000")),
          #("stopTimeoutMs", d.Number("10000")),
        ]
        let prepared = case tool {
          "aws-emulator" -> {
            use built <- result.try(invoke(
              root,
              project,
              profile,
              "build",
              [#("image", d.Text(image))],
              log,
            ))
            use _ <- result.try(c.require(
              built == d.Text(image),
              "AWS image build returned a different image",
            ))
            Ok(
              list.append(fields, [
                #("image", d.Text(image)),
                #("stateDir", d.Text(state)),
              ]),
            )
          }
          _ ->
            Ok(list.append(
              fields,
              list.append([#("version", d.get(profile, "version"))], case tool {
                "redis" -> [#("volumes", d.Text(volume <> ":/data"))]
                _ -> []
              }),
            ))
        }
        let tested = case prepared {
          Error(error) -> Error(error)
          Ok(fields) -> {
            let tested =
              lifecycle(
                root,
                project,
                profile,
                name,
                fields,
                state,
                volume,
                log,
              )
            let _ =
              invoke(
                root,
                project,
                profile,
                "logs",
                [#("name", d.Text(name)), #("tail", d.Number("100"))],
                log,
              )
            let stopped =
              invoke(
                root,
                project,
                profile,
                "stop",
                [#("name", d.Text(name))],
                log,
              )
            use _ <- result.try(tested)
            stopped |> result.map(fn(_) { Nil })
          }
        }
        case tool {
          "redis" -> {
            let _ =
              commands.logged(
                ["docker", "volume", "rm", volume],
                root,
                log,
                10_000,
                True,
              )
            Nil
          }
          _ -> Nil
        }
        let _ =
          commands.logged(
            ["docker", "image", "rm", image],
            root,
            log,
            10_000,
            True,
          )
        case tested {
          Ok(_) -> {
            let _ = native.stdout(tool <> " passed\n")
            Error(Nil)
          }
          Error(error) -> {
            let _ = native.stderr(tool <> ": " <> error <> "\n")
            Ok(tool)
          }
        }
      })
    let _ =
      commands.logged(
        ["fluentci", "down"],
        project,
        logs <> "/cleanup.log",
        30_000,
        True,
      )
    let status =
      commands.logged(
        ["fluentci", "services", "status", "--json"],
        project,
        logs <> "/cleanup.log",
        30_000,
        True,
      )
      |> result.unwrap("")
    use _ <- result.try(c.write(logs <> "/final-status.json", status))
    c.require(
      failures == [],
      "Services E2E failures: " <> string.join(failures, ", "),
    )
  })
}
