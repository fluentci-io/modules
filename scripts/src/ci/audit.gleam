import ci/common as c
import ci/data as d
import ci/files as f
import ci/registry
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn run(root: String, check: Bool) -> Result(Nil, String) {
  use modules <- result.try(f.registry(root))
  use purposes <- result.try(f.json(
    root <> "/scripts/templates/pipeline-purposes.json",
  ))
  use header <- result.try(c.text(root <> "/scripts/templates/audit-header.md"))
  use catalog <- result.try(f.json(root <> "/lib/cli/catalog.json"))
  use rows <- result.try(
    list.try_map(modules, fn(module) {
      let name = d.s(module, "name")
      let path = d.s(module, "path")
      let category = string.split(path, "/") |> list.first |> result.unwrap("")
      use _ <- result.try(c.require(
        d.s(purposes, category) != "",
        "Missing pipeline purpose: " <> path,
      ))
      use exports <- result.try(registry.entry_points(root <> "/" <> path))
      use manifest <- result.try(f.toml(
        root <> "/" <> path <> "/fluentci-module.toml",
      ))
      use _ <- result.try(case category {
        "setup" ->
          c.require(
            name
              == "setup-"
              <> { string.split(path, "/") |> list.last |> result.unwrap("") },
            "Setup names require setup- prefix",
          )
        _ ->
          c.require(
            d.fields(d.get(manifest, "dependencies")) != [],
            "Operation has no setup companion: " <> name,
          )
      })
      let tool =
        list.find(d.array(catalog), fn(t) { d.s(t, "name") == name })
        |> result.unwrap(d.Null)
      let commands = d.array(d.get(tool, "commands"))
      use _ <- result.try(
        c.all(commands, fn(command) {
          c.require(
            d.s(command, "description") != ""
              && list.contains(exports, d.s(command, "name")),
            "Missing reviewed pipeline operation: " <> name,
          )
        }),
      )
      let functions =
        list.map(exports, fn(name) {
          let role = case name {
            "run" -> "escape hatch"
            _ ->
              case
                list.contains(
                  [
                    "version",
                    "help",
                    "du",
                    "stats",
                    "cache_list",
                    "targets",
                    "query",
                    "lsjson",
                  ],
                  name,
                )
              {
                True -> "diagnostic"
                False -> "pipeline operation"
              }
          }
          "`" <> f.kebab(name) <> "` (" <> role <> ")"
        })
      Ok(
        "| ["
        <> name
        <> "](../"
        <> path
        <> "/README.md) | "
        <> d.s(purposes, category)
        <> " | "
        <> string.join(functions, ", ")
        <> " |",
      )
    }),
  )
  f.generated(
    root <> "/docs/PIPELINE_AUDIT.md",
    string.replace(header, "{{count}}", int.to_string(list.length(modules)))
      <> "## Export inventory\n\n| Module | CI/CD purpose | Public functions |\n| --- | --- | --- |\n"
      <> string.join(rows, "\n")
      <> "\n",
    check,
  )
}
