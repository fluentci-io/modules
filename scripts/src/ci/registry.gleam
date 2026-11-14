import ci/common as c
import ci/data as d
import ci/files as f
import ci/native
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn entry_points(directory: String) -> Result(List(String), String) {
  use entry <- result.try(c.text(directory <> "/entry.mjs"))
  use _ <- result.try(c.require(
    native.regex(
      "^\\s*export\\s*\\{([^}]+)\\}\\s*from\\s*[\"']([^\"']+)[\"'];?\\s*$",
      entry,
    )
      != [],
    "entry.mjs must declare named re-exports: " <> directory,
  ))
  let tokens = string.split(entry, "{")
  use exports <- result.try(case tokens {
    [prefix, rest] ->
      case string.trim(prefix) == "export" {
        True ->
          case string.split(rest, "}") {
            [names, _] -> Ok(string.split(names, ",") |> list.map(string.trim))
            _ -> Error("Invalid named exports")
          }
        False -> Error("Expected named re-exports")
      }
    _ -> Error("Expected named re-exports")
  })
  use _ <- result.try(c.require(
    exports != [] && list.length(exports) == list.length(list.unique(exports)),
    "Duplicate or empty exports: " <> directory,
  ))
  use _ <- result.try(
    c.all(exports, fn(name) {
      c.require(
        native.regex("^([a-z][a-zA-Z0-9_]*)$", name) != [],
        "Invalid export name",
      )
    }),
  )
  use source <- result.try(c.text(directory <> "/src/CI/Component.purs"))
  use _ <- result.try(
    case native.regex("module CI\\.Component \\(([^)]+)\\) where", source) {
      [[names]] ->
        c.require(
          list.sort(
            list.map(string.split(names, ","), string.trim),
            string.compare,
          )
            == list.sort(exports, string.compare),
          "Entry points and PureScript exports differ",
        )
      _ -> Ok(Nil)
    },
  )
  use schema <- result.try(f.json(directory <> "/schema.json"))
  let names = list.map(d.fields(d.get(schema, "exports")), fn(p) { p.0 })
  use _ <- result.try(c.require(
    list.sort(names, string.compare) == list.sort(exports, string.compare)
      && d.s(schema, "runtime") == "component",
    "Schema exports differ: " <> directory,
  ))
  use _ <- result.try(
    c.all(exports, fn(name) {
      c.require(
        string.contains(source, name <> " :: ")
          && string.contains(source, " -> Effect "),
        "Missing typed declaration: " <> directory <> "/" <> name,
      )
    }),
  )
  Ok(exports)
}

pub fn validate(root: String) -> Result(List(d.Value), String) {
  use modules <- result.try(f.registry(root))
  let names = list.map(modules, fn(m) { d.s(m, "name") })
  let paths = list.map(modules, fn(m) { d.s(m, "path") })
  use _ <- result.try(c.require(
    names != [] && names == list.sort(list.unique(names), string.compare),
    "Module names must be unique and alphabetically sorted",
  ))
  use _ <- result.try(c.require(
    list.length(paths) == list.length(list.unique(paths)),
    "Duplicate module paths",
  ))
  use license <- result.try(c.text(root <> "/LICENSE"))
  use _ <- result.try(c.require(
    string.starts_with(license, "MIT License\n"),
    "Root license must be MIT",
  ))
  use _ <- result.try(
    c.all(
      list.unique(
        list.map(paths, fn(path) {
          string.split(path, "/") |> list.first |> result.unwrap("")
        }),
      ),
      fn(category) {
        use children <- result.try(native.list_dir(root <> "/" <> category))
        c.all(children, fn(name) {
          c.require(
            !native.is_directory(root <> "/" <> category <> "/" <> name)
              || string.starts_with(name, ".")
              || list.contains(paths, category <> "/" <> name),
            "Unregistered module directory: " <> category <> "/" <> name,
          )
        })
      },
    ),
  )
  use _ <- result.try(
    c.all(modules, fn(module) {
      let name = d.s(module, "name")
      let path = d.s(module, "path")
      let directory = root <> "/" <> path
      use _ <- result.try(c.require(
        native.is_directory(directory),
        "Module directory must not be a symlink or escape the repository: "
          <> path,
      ))
      use _ <- result.try(c.require(
        native.regex(
          "^([0-9]+\\.[0-9]+\\.[0-9]+(?:-[0-9A-Za-z.-]+)?(?:\\+[0-9A-Za-z.-]+)?)$",
          d.s(module, "version"),
        )
          != [],
        "Invalid module version: " <> name,
      ))
      use _ <- result.try(c.require(
        f.safe_name(name) && f.module_path(path),
        "Invalid module name/path: " <> name,
      ))
      use _ <- result.try(c.require(
        d.s(module, "runtime") == "component"
          && d.s(module, "sdk") == "purescript",
        "Unsupported module SDK/runtime: " <> name,
      ))
      use manifest <- result.try(f.toml(directory <> "/fluentci-module.toml"))
      use _ <- result.try(c.require(
        d.s(module, "version") == d.s(manifest, "version")
          && d.s(manifest, "name") == name,
        "Registry/manifest identity differs: " <> name,
      ))
      use _ <- result.try(
        c.all(
          [
            "README.md",
            "LICENSE",
            "package.json",
            "package-lock.json",
            "spago.yaml",
            "spago.lock",
            "build.mjs",
            "entry.mjs",
            "schema.json",
            ".gitignore",
          ],
          fn(file) {
            c.require(
              native.regular(directory <> "/" <> file),
              name <> ": missing " <> file,
            )
          },
        ),
      )
      use _ <- result.try(c.require(
        c.text(directory <> "/LICENSE") == Ok(license),
        name <> ": license differs",
      ))
      use readme <- result.try(c.text(directory <> "/README.md"))
      use _ <- result.try(c.require(
        string.starts_with(readme, "# "),
        name <> ": README title missing",
      ))
      use sources <- result.try(f.walk(directory <> "/src"))
      use tests <- result.try(f.walk(directory <> "/test"))
      use _ <- result.try(c.require(
        list.any(sources, fn(p) { string.ends_with(p, ".purs") })
          && list.any(tests, fn(p) { string.ends_with(p, ".test.mjs") }),
        name <> ": missing source/tests",
      ))
      use package <- result.try(f.json(directory <> "/package.json"))
      use lock <- result.try(f.json(directory <> "/package-lock.json"))
      use _ <- result.try(f.json(directory <> "/spago.lock"))
      let locked = d.get(d.get(lock, "packages"), "")
      use _ <- result.try(c.require(
        d.s(package, "license") == "MIT"
          && d.s(locked, "license") == "MIT"
          && d.s(package, "name") == d.s(locked, "name")
          && d.s(package, "name") == d.s(lock, "name"),
        name <> ": npm metadata differs",
      ))
      use _ <- result.try(
        c.all(
          ["dependencies", "devDependencies", "optionalDependencies"],
          fn(key) {
            c.require(
              d.equivalent(d.get(package, key), d.get(locked, key)),
              name <> ": npm lockfile drift in " <> key,
            )
          },
        ),
      )
      use _ <- result.try(
        c.all(["build", "test"], fn(key) {
          c.require(
            d.s(d.get(package, "scripts"), key) != "",
            name <> ": missing npm " <> key,
          )
        }),
      )
      use _ <- result.try(entry_points(directory))
      Ok(Nil)
    }),
  )
  Ok(modules)
}

fn has(names: List(String), values: List(String)) -> d.Value {
  d.Bool(list.any(values, fn(v) { list.contains(names, v) }))
}

pub fn batches(modules: List(d.Value), shards: Int) -> d.Value {
  let count = int.min(shards, list.length(modules))
  let buckets =
    list.map(c.indices(count), fn(index) {
      list.index_map(modules, fn(m, i) { #(m, i) })
      |> list.filter(fn(p) { p.1 % count == index })
      |> list.map(fn(p) {
        d.Object([#("name", d.get(p.0, "name")), #("path", d.get(p.0, "path"))])
      })
    })
  let formatters = [
    "black",
    "prettier",
    "rustfmt",
    "ruff",
    "biome",
    "shellcheck",
    "yamllint",
    "sqlfluff",
    "protolint",
    "sqruff",
  ]
  let include =
    list.flat_map(["ubuntu-24.04", "macos-15"], fn(os) {
      list.index_map(buckets, fn(bucket, index) {
        let names = list.map(bucket, fn(m) { d.s(m, "name") })
        d.Object([
          #("os", d.Text(os)),
          #("shard", d.Number(int.to_string(index + 1))),
          #("modules", d.Array(bucket)),
          #("browser", has(names, ["cypress", "playwright"])),
          #(
            "bun",
            has(
              names,
              list.append(
                [
                  "cypress",
                  "playwright",
                  "gh-artifacts",
                  "gitlab-artifacts",
                  "scorecard",
                  "nix-publish",
                ],
                formatters,
              ),
            ),
          ),
          #("build", has(names, ["cmake", "meson", "ninja", "sccache"])),
          #("formatters", has(names, formatters)),
          #("uv", has(names, ["uv"])),
          #(
            "security",
            d.Array(list.map(
              list.sort(
                list.filter(names, fn(n) {
                  list.contains(["betterleaks", "gitleaks", "syft"], n)
                }),
                string.compare,
              ),
              d.Text,
            )),
          ),
        ])
      })
    })
  d.Object([#("include", d.Array(include))])
}

pub fn run(root: String, github: Bool) -> Result(Nil, String) {
  use modules <- result.try(validate(root))
  let _ =
    native.stdout(
      "Validated " <> int.to_string(list.length(modules)) <> " modules.\n",
    )
  case github {
    True ->
      native.append(
        native.env("GITHUB_OUTPUT"),
        "matrix=" <> d.encode(batches(modules, 4)) <> "\n",
      )
    False -> Ok(Nil)
  }
}
