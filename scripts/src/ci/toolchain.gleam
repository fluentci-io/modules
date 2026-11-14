import ci/common as c
import ci/data as d
import ci/download
import ci/files as f
import ci/native
import ci/setup
import gleam/list
import gleam/result
import gleam/string

pub fn component(
  cli: String,
  path: String,
  args: List(String),
  expected: String,
) -> Result(setup.Setup, String) {
  use output <- result.try(c.run(
    cli,
    list.append(["run", "--wasm", path, "setup"], args),
    native.cwd(),
  ))
  use record <- result.try(parse_output(output))
  use value <- result.try(d.parse(record))
  use _ <- result.try(c.require(
    expected == "" || d.s(value, "tool") == expected,
    "Unexpected tool in setup result",
  ))
  use _ <- result.try(c.require(
    d.s(value, "tool") != "" && d.s(value, "version") != "",
    "Missing setup tool/version",
  ))
  use parsed <- result.try(setup.parse(record))
  use _ <- result.try(setup.validate(parsed, native.env("PATH")))
  list.each(parsed.variables, fn(variable) {
    let _ = native.set_env(variable.name, variable.value)
    Nil
  })
  let _ =
    native.stdout(
      "Configured "
      <> d.s(value, "tool")
      <> " "
      <> d.s(value, "version")
      <> "\n",
    )
  Ok(parsed)
}

pub fn parse_output(output: String) -> Result(String, String) {
  use value <- result.try(
    output
    |> string.split("\n")
    |> tails
    |> list.reverse
    |> list.find_map(fn(candidate) {
      use value <- result.try(d.parse_prefix(candidate))
      use _ <- result.try(c.require(
        d.s(value, "bin-dir") != "" && d.get(value, "environment") != d.Null,
        "Not a setup record",
      ))
      Ok(d.encode(value))
    })
    |> result.map_error(fn(_) {
      "Setup component did not return its typed installation result"
    }),
  )
  Ok(value)
}

fn tails(lines: List(String)) -> List(String) {
  case lines {
    [] -> []
    [_head, ..rest] -> [string.join(lines, "\n"), ..tails(rest)]
  }
}

pub fn run(
  root: String,
  profile: String,
  cache: String,
) -> Result(Nil, String) {
  use _ <- result.try(c.require(
    list.contains(["base", "full"], profile),
    "Unknown setup profile",
  ))
  use config <- result.try(f.json(root <> "/.github/toolchain/versions.json"))
  let before = native.env("PATH")
  use cli <- result.try(download.cli(d.get(config, "fluentci"), cache))
  let _ = native.set_env("PATH", f.parent(cli) <> ":" <> before)
  // Published 0.2.0 components cannot reuse prefixes; leave fresh prefixes alive.
  use runtime <- result.try(native.temp("fluentci-toolchain-"))
  let keys = case profile {
    "full" -> ["purescript", "uv"]
    _ -> ["node", "bun", "uv"]
  }
  use prepared <- result.try(
    list.try_fold(keys, [], fn(acc, key) {
      let definition = d.get(d.get(config, "modules"), key)
      use artifact <- result.try(download.artifact(
        d.get(config, "registry"),
        definition,
        cache,
      ))
      use value <- result.try(component(
        cli,
        artifact,
        list.append(d.strings(d.get(definition, "arguments")), [
          "--install-dir",
          runtime <> "/" <> key,
        ]),
        key,
      ))
      Ok(list.append(acc, value.variables))
    }),
  )
  use _ <- result.try(c.stream(
    "uv",
    ["python", "install", d.s(config, "python")],
    root,
  ))
  use python <- result.try(c.run(
    "uv",
    ["python", "find", "--managed-python", d.s(config, "python")],
    root,
  ))
  let python = string.trim(python)
  use _ <- result.try(c.require(
    string.starts_with(python, "/") && native.regular(python),
    "uv did not return a managed Python executable",
  ))
  let path = f.parent(python) <> ":" <> native.env("PATH")
  let _ = native.set_env("PATH", path)
  use _ <- result.try(
    c.all([cli, "node", "bun", "uv", python], fn(program) {
      c.stream(program, ["--version"], root)
    }),
  )
  use _ <- result.try(case profile {
    "full" ->
      c.all(["purs", "spago"], fn(program) {
        c.stream(program, ["--version"], root)
      })
    _ -> Ok(Nil)
  })
  let variables = list.filter(prepared, fn(v) { v.name != "PATH" })
  setup.github_from(
    setup.Setup(f.parent(python), [
      setup.Variable("PATH", path),
      ..unique(variables)
    ]),
    before,
  )
}

fn unique(variables: List(setup.Variable)) -> List(setup.Variable) {
  list.fold(variables, [], fn(acc, value) {
    list.append(
      list.filter(acc, fn(v: setup.Variable) { v.name != value.name }),
      [value],
    )
  })
}

pub fn local(path: String, args: List(String)) -> Result(Nil, String) {
  let before = native.env("PATH")
  use result <- result.try(component(
    "fluentci",
    native.absolute(path),
    args,
    "",
  ))
  setup.github_from(result, before)
}
