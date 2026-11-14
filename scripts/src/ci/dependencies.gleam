import ci/common as c
import ci/data as d
import ci/files as f
import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn requirement(alias: String, program: String, probe: List(String)) -> d.Value {
  d.Object([
    #("alias", d.Text(alias)),
    #("program", d.Text(program)),
    #("probe", d.Array(list.map(probe, d.Text))),
  ])
}

pub fn definitions(
  module: d.Value,
  catalog: d.Value,
  tools: d.Value,
) -> List(d.Value) {
  let name = d.s(module, "name")
  let path = d.s(module, "path")
  let tool =
    list.find(d.array(tools), fn(t) { d.s(t, "name") == name })
    |> result.unwrap(d.Null)
  let cli =
    list.find(d.array(catalog), fn(t) { d.s(t, "name") == name })
    |> result.unwrap(d.Null)
  let program = case d.s(tool, "program") {
    "" -> d.s(cli, "program")
    other -> other
  }
  let deps = case string.starts_with(path, "setup/") {
    True ->
      case name {
        "setup-android" -> [
          requirement("setup-java", "java", ["which", "java"]),
        ]
        "setup-buildx" -> [
          requirement("setup-docker", "docker", ["which", "docker"]),
        ]
        _ -> []
      }
    False ->
      case string.starts_with(path, "services/") {
        True -> [
          requirement("setup-docker", "docker", ["docker", "version"]),
          ..case name {
            "aws-emulator" -> [
              requirement("setup-curl", "curl", ["curl", "--version"]),
            ]
            _ -> []
          }
        ]
        False ->
          case string.starts_with(path, "notifications/") {
            True -> [requirement("setup-curl", "curl", ["which", "curl"])]
            False ->
              case name {
                "nix-publish" -> [
                  requirement("setup-nix", "nix", ["which", "nix"]),
                  requirement("setup-bun", "bun", ["which", "bun"]),
                  requirement("setup-flakehub-push", "flakehub-push", [
                    "which",
                    "flakehub-push",
                  ]),
                ]
                "buildx" -> [
                  requirement("setup-docker", "docker", ["which", "docker"]),
                  requirement("setup-buildx", "docker", [
                    "docker",
                    "buildx",
                    "version",
                  ]),
                ]
                _ -> {
                  let probe = case name {
                    "depot" | "glab" -> [program, "version"]
                    "flipt" | "git" | "gh" -> [program, "--version"]
                    _ -> ["which", program]
                  }
                  let main = [requirement("setup-" <> name, program, probe)]
                  let main = case name {
                    "cachix" -> [
                      requirement("setup-nix", "nix", ["which", "nix"]),
                      ..main
                    ]
                    _ -> main
                  }
                  let extras = case
                    list.any(d.array(d.get(cli, "commands")), fn(cmd) {
                      d.s(cmd, "program") == "bun"
                    })
                  {
                    True -> [requirement("setup-bun", "bun", ["which", "bun"])]
                    False -> []
                  }
                  list.append(list.append(main, extras), case name {
                    "gh" | "glab" -> [
                      requirement("setup-git", "git", ["git", "--version"]),
                    ]
                    _ -> []
                  })
                }
              }
          }
      }
  }
  deps
}

pub fn relative(target: String, base: String) -> String {
  let to = string.split(target, "/")
  let from = string.split(base, "/")
  relative_parts(to, from)
}

fn relative_parts(to: List(String), from: List(String)) -> String {
  case to, from {
    [a, ..xs], [b, ..ys] if a == b -> relative_parts(xs, ys)
    _, _ ->
      string.join(list.append(list.repeat("..", list.length(from)), to), "/")
  }
}

fn declaration(alias: String, path: String) -> String {
  "name = "
  <> d.quote(alias)
  <> "\nruntime = \"component\"\npath = "
  <> d.quote(path)
  <> "\nsdk = \"purescript\"\n"
}

fn module_path(modules: List(d.Value), name: String) -> String {
  modules
  |> list.find(fn(m) { d.s(m, "name") == name })
  |> result.unwrap(d.Null)
  |> d.s("path")
}

fn ensure(requirement: d.Value) -> String {
  "ensure "
  <> d.quote(d.s(requirement, "alias"))
  <> " [ "
  <> string.join(
    list.map(d.strings(d.get(requirement, "probe")), d.quote),
    ", ",
  )
  <> " ]"
}

fn source(
  root: String,
  name: String,
  requirements: List(d.Value),
) -> Result(String, String) {
  use helpers <- result.try(c.text(
    root <> "/scripts/templates/dependency-probes.purs",
  ))
  let unconditional =
    list.contains(["buildx", "cachix", "gh", "glab", "aws-emulator"], name)
  let unused =
    unconditional
    || {
      list.length(requirements) == 1
      && !list.contains(["cmake", "rustfmt"], name)
    }
  let header = [
    "-- Generated by Gleam CI helpers.",
    "module CI.ModuleDependencies (ensureFor) where",
    "",
    "import Prelude",
    "import Data.Either (Either(..))",
    "import Effect (Effect)",
    "import Effect.Exception (throw, try)",
    "import FluentCI.Plugin as P",
  ]
  let header =
    list.append(header, case name {
      "gh-artifacts" -> ["import Data.String.Common (trim)"]
      _ -> []
    })
  let base =
    list.append(header, [
      "",
      helpers,
      "ensureFor :: String -> Effect Unit",
      "ensureFor "
        <> case unused {
        True -> "_"
        False -> "executable"
      }
        <> " = do",
      "  os <- P.getOS >>= case _ of",
      "    Left error -> throw (P.errorMessage error)",
      "    Right value -> pure value",
      "  unless (os == \"linux\" || os == \"macos\" || os == \"freebsd\" || os == \"openbsd\" || os == \"netbsd\") $",
      "    throw (\"Unsupported setup dependency OS: \" <> os)",
    ])
  let main = list.first(requirements) |> result.unwrap(d.Null)
  let calls = case unconditional {
    True -> list.map(requirements, fn(r) { "  " <> ensure(r) })
    False -> {
      let first = case
        list.contains(["scorecard", "snyk", "gitlab-artifacts"], name)
      {
        True -> "  when (executable /= \"bun\") $ " <> ensure(main)
        False -> "  " <> ensure(main)
      }
      let rest =
        list.map(list.drop(requirements, 1), fn(r) {
          "  when (executable == "
          <> d.quote(d.s(r, "program"))
          <> ") $ "
          <> ensure(r)
        })
      list.append([first], rest)
    }
  }
  use special <- result.try(case name {
    "gh-artifacts" ->
      c.text(root <> "/scripts/templates/gh-artifacts-client.purs")
    _ -> Ok("")
  })
  let alt = case name {
    "cmake" -> ["ctest"]
    "rustfmt" -> ["cargo"]
    _ -> []
  }
  let alt =
    list.map(alt, fn(program) {
      "  when (executable == "
      <> d.quote(program)
      <> ") $ ensure "
      <> d.quote(d.s(main, "alias"))
      <> " [ \"which\", "
      <> d.quote(program)
      <> " ]"
    })
  let extra = case name {
    "dpkg" -> ["dpkg", "realpath"]
    "rpmbuild" -> ["rpmspec", "rpm", "realpath"]
    _ -> []
  }
  let extra =
    list.map(extra, fn(program) {
      "  ensure "
      <> d.quote(d.s(main, "alias"))
      <> " [ \"which\", "
      <> d.quote(program)
      <> " ]"
    })
  Ok(
    f.lines(list.append(
      base,
      list.append(
        calls,
        list.append(
          case special {
            "" -> []
            _ -> [string.trim_end(special)]
          },
          list.append(alt, extra),
        ),
      ),
    ))
    <> "\n",
  )
}

fn nested(
  modules: List(d.Value),
  graph: d.Value,
  owner: String,
  base: String,
  seen: List(String),
) -> Result(List(#(String, d.Value)), String) {
  use _ <- result.try(c.require(
    !list.contains(seen, owner),
    "Cyclic setup dependency: " <> owner,
  ))
  list.try_fold(d.array(d.get(graph, owner)), [], fn(acc, requirement) {
    let alias = d.s(requirement, "alias")
    let source = module_path(modules, alias)
    let source_relative = relative(source, base)
    let rows =
      list.map(d.array(d.get(graph, alias)), fn(child) {
        let target = relative(module_path(modules, d.s(child, "alias")), source)
        #(
          "dependency:" <> source_relative <> ":" <> d.s(child, "alias"),
          d.Text(
            "path:"
            <> declaration(
              d.s(child, "alias"),
              source_relative <> "/" <> target,
            ),
          ),
        )
      })
    use deeper <- result.try(
      nested(modules, graph, alias, base, [owner, ..seen]),
    )
    Ok(list.append(acc, list.append(rows, deeper)))
  })
}

pub fn run(root: String, check: Bool) -> Result(Nil, String) {
  use modules <- result.try(f.registry(root))
  use catalog <- result.try(f.json(root <> "/lib/cli/catalog.json"))
  use tools <- result.try(f.json(root <> "/lib/setup/tools.json"))
  let graph =
    d.Object(
      list.map(modules, fn(m) {
        #(d.s(m, "name"), d.Array(definitions(m, catalog, tools)))
      }),
    )
  use _ <- result.try(
    c.all(modules, fn(module) {
      let name = d.s(module, "name")
      let path = d.s(module, "path")
      let directory = root <> "/" <> path
      let requirements = d.array(d.get(graph, name))
      use existing <- result.try(f.toml(directory <> "/fluentci-module.toml"))
      let metadata =
        list.filter_map(
          [
            "description",
            "repository",
            "readme_url",
            "logo",
            "topics",
            "os",
            "arch",
          ],
          fn(key) {
            case d.get(existing, key) {
              d.Null -> Error(Nil)
              value -> Ok(key <> " = " <> d.encode(value))
            }
          },
        )
      let header = [
        "name = " <> d.quote(name),
        "version = " <> d.quote(d.s(module, "version")),
        "license = \"MIT\"",
        "sdk = \"purescript\"",
        "runtime = \"component\"",
        "entry = \"entry.mjs\"",
        "artifact = \"dist/plugin.wasm\"",
        "build = [\"npm\", \"run\", \"build\"]",
      ]
      use rows <- result.try(
        list.try_map(requirements, fn(requirement) {
          let alias = d.s(requirement, "alias")
          let target = module_path(modules, alias)
          use _ <- result.try(c.require(
            target != "" && d.s(requirement, "program") != "",
            "Missing setup companion: " <> alias,
          ))
          let rel = relative(target, path)
          Ok(#(
            alias
              <> " = { path = "
              <> d.quote(rel)
              <> ", sdk = \"purescript\", runtime = \"component\" }",
            #(
              "dependency::" <> alias,
              d.Text("path:" <> declaration(alias, rel)),
            ),
          ))
        }),
      )
      let dependencies = case rows {
        [] -> []
        _ -> ["", "[dependencies]", ..list.map(rows, fn(p) { p.0 })]
      }
      use _ <- result.try(f.generated(
        directory <> "/fluentci-module.toml",
        f.lines(list.append(header, list.append(metadata, dependencies)))
          <> "\n",
        check,
      ))
      use extra <- result.try(nested(modules, graph, name, path, []))
      let locked =
        list.append(list.map(rows, fn(p) { p.1 }), extra)
        |> list.sort(fn(a, b) { string.compare(a.0, b.0) })
      let lock =
        d.Object([
          #("lockfileVersion", d.Number("1")),
          #("modules", d.Object(locked)),
          #("packages", d.Object([])),
          #("git", d.Object([])),
        ])
      use _ <- result.try(f.generated(
        directory <> "/fluentci.lock",
        d.pretty(lock),
        check,
      ))
      use ignore <- result.try(c.text(directory <> "/.gitignore"))
      let ignore =
        list.fold(
          [
            "/fluentci_modules/",
            "/.fluentci/dependencies/",
            "/.fluentci/dependencies.add.guard",
            "/fluentci.lock.guard",
          ],
          ignore,
          fn(text, line) {
            case list.contains(string.split(text, "\n"), line) {
              True -> text
              False -> string.trim_end(text) <> "\n" <> line <> "\n"
            }
          },
        )
      use _ <- result.try(f.generated(directory <> "/.gitignore", ignore, check))
      case string.starts_with(path, "setup/") && name != "setup-buildx" {
        True -> Ok(Nil)
        False -> {
          use _ <- result.try(f.generated(
            directory <> "/module-dependencies.json",
            d.pretty(
              d.Object([
                #("module", d.Text(name)),
                #("requirements", d.Array(requirements)),
              ]),
            ),
            check,
          ))
          use purs <- result.try(source(root, name, requirements))
          use _ <- result.try(f.generated(
            directory <> "/src/CI/ModuleDependencies.purs",
            purs,
            check,
          ))
          let imports =
            list.index_map(requirements, fn(r, i) {
              "import { setup as setup"
              <> int.to_string(i)
              <> " } from \"fluentci:dependency/"
              <> d.s(r, "alias")
              <> "\";"
            })
          let aliases =
            string.join(
              list.index_map(requirements, fn(r, i) {
                d.quote(d.s(r, "alias")) <> ": setup" <> int.to_string(i)
              }),
              ", ",
            )
          let ffi =
            f.lines(
              list.append(imports, [
                "",
                "const installers = { " <> aliases <> " };",
                "export const installDependency = alias => () => {",
                "  const install = installers[alias];",
                "  if (!install) throw Error(\"Unknown setup dependency: \" + alias);",
                "  install({});",
                "};",
                "",
              ]),
            )
          use _ <- result.try(f.generated(
            directory <> "/src/CI/ModuleDependencies.js",
            ffi,
            check,
          ))
          f.generated(
            directory <> "/test/dependencies.test.mjs",
            "import {dependencySuite} from \"../../../test/dependencies/suite.mjs\";\nawait dependencySuite(new URL(\"../\",import.meta.url));\n",
            check,
          )
        }
      }
    }),
  )
  let inventory =
    d.Object(
      list.filter_map(d.fields(graph), fn(p) {
        case d.array(p.1) {
          [] -> Error(Nil)
          requirements ->
            Ok(#(
              p.0,
              d.Array(list.map(requirements, fn(r) { d.get(r, "alias") })),
            ))
        }
      }),
    )
  f.generated(
    root <> "/docs/module-dependencies.json",
    d.pretty(inventory),
    check,
  )
}
