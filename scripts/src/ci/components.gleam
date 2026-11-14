import ci/common as c
import ci/data as d
import ci/files as f
import gleam/list
import gleam/result
import gleam/string

fn scalar(kind: String) -> String {
  case kind {
    "boolean" -> "Boolean"
    "integer" -> "Int"
    "number" -> "Number"
    "array" -> "Array String"
    _ -> "String"
  }
}

fn quoted(key: String) -> String {
  case
    list.contains(
      [
        "type",
        "data",
        "class",
        "instance",
        "module",
        "import",
        "foreign",
        "in",
        "where",
        "case",
        "of",
        "do",
        "let",
      ],
      key,
    )
  {
    True -> d.quote(key)
    False -> key
  }
}

fn description(
  common: d.Value,
  key: String,
  prop: d.Value,
  context: String,
) -> String {
  let text = case d.s(prop, "description") {
    "" ->
      case
        list.contains(
          [
            "packages",
            "toolchain",
            "components",
            "targets",
            "trustedUsers",
            "extraConf",
            "profile",
          ],
          key,
        )
        && !string.starts_with(context, "setup-")
      {
        True -> ""
        False -> d.s(common, key)
      }
    value ->
      case value == key {
        True ->
          case
            list.contains(
              [
                "packages",
                "toolchain",
                "components",
                "targets",
                "trustedUsers",
                "extraConf",
                "profile",
              ],
              key,
            )
            && !string.starts_with(context, "setup-")
          {
            True -> ""
            False -> d.s(common, key)
          }
        False -> value
      }
  }
  let text = case text {
    "" -> f.label(key) <> " supplied to the " <> context <> " operation."
    other -> other
  }
  let text =
    text
    <> case d.get(prop, "default") {
      d.Null -> ""
      value -> " Default: " <> d.encode(value) <> "."
    }
  text
  <> case d.strings(d.get(prop, "enum")) {
    [] -> ""
    values -> " Allowed values: " <> string.join(values, ", ") <> "."
  }
}

fn execution() -> d.Value {
  let keys = ["outcome", "runDir", "reportPath", "stdoutPath", "stderrPath"]
  d.Object([
    #("type", d.Text("object")),
    #("required", d.Array(list.map(keys, d.Text))),
    #(
      "properties",
      d.Object(
        list.map(keys, fn(k) { #(k, d.Object([#("type", d.Text("string"))])) }),
      ),
    ),
    #("additionalProperties", d.Bool(False)),
  ])
}

fn function(
  description: String,
  input: d.Value,
  output: d.Value,
  returned: String,
  body: String,
) -> d.Value {
  d.Object([
    #("description", d.Text(description)),
    #("input", input),
    #("output", output),
    #("returned", d.Text(returned)),
    #("body", d.Text(body)),
  ])
}

fn cli_functions(
  root: String,
  module: d.Value,
  tool: d.Value,
  common: d.Value,
  templates: d.Value,
) -> Result(d.Value, String) {
  let name = d.s(module, "name")
  use legacy <- result.try(f.json(
    root <> "/" <> d.s(module, "path") <> "/legacy-schema.json",
  ))
  let functions =
    list.map(d.array(d.get(tool, "commands")), fn(command) {
      let name_ = d.s(command, "name")
      let input = d.get(d.get(d.get(legacy, "exports"), name_), "input")
      let props =
        d.put(
          d.get(input, "properties"),
          "artifacts",
          case d.bool(d.get(tool, "csvLists")) {
            True ->
              d.Object([
                #("type", d.Text("string")),
                #(
                  "description",
                  d.Text(
                    "Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas.",
                  ),
                ),
              ])
            False ->
              d.Object([
                #("type", d.Text("array")),
                #("items", d.Object([#("type", d.Text("string"))])),
              ])
          },
        )
      let props =
        d.Object(
          list.map(d.fields(props), fn(p) {
            #(
              p.0,
              d.put(
                p.1,
                "description",
                d.Text(description(common, p.0, p.1, name <> " " <> name_)),
              ),
            )
          }),
        )
      let body =
        "  json <- "
        <> case d.bool(d.get(tool, "csvLists")) {
          True ->
            "Native.csvInput (Contract.input (Contract.encodeInput args)) >>= Contract.cliInput"
          False -> "Contract.cliInput (Contract.encodeInput args)"
        }
        <> "\n  Native.executeWithSetup Dependencies.ensureFor "
        <> d.quote(name)
        <> " "
        <> d.quote(name_)
        <> " json"
      #(
        name_,
        function(
          d.s(command, "description"),
          d.put(input, "properties", props),
          execution(),
          "Contract.ExecutionResult",
          body,
        ),
      )
    })
  let setup = case
    list.contains(["depot", "flipt", "git", "gh", "glab"], name)
  {
    False -> []
    True -> {
      let flavor = case list.contains(["git", "gh", "glab"], name) {
        True -> "version-control"
        False -> "container"
      }
      let encoded =
        d.encode(d.get(templates, "cli-setup-" <> flavor))
        |> string.replace("{{tool}}", name)
      [#("setup", d.parse(encoded) |> result.unwrap(d.Null))]
    }
  }
  Ok(d.Object(list.append(setup, functions)))
}

fn buildx_functions(
  root: String,
  common: d.Value,
  templates: d.Value,
) -> Result(d.Value, String) {
  use legacy <- result.try(f.json(
    root <> "/containers/buildx/legacy-schema.json",
  ))
  let setup = d.get(templates, "cli-setup-container")
  let setup =
    d.parse(string.replace(d.encode(setup), "{{tool}}", "buildx"))
    |> result.unwrap(d.Null)
  let functions =
    list.map(d.fields(d.get(legacy, "exports")), fn(pair) {
      let name = pair.0
      let title = f.title(string.replace(name, "_", "-"))
      let pure =
        string.lowercase(string.slice(title, 0, 1))
        <> string.drop_start(title, 1)
      let input = d.get(pair.1, "input")
      let props = d.get(input, "properties") |> d.delete("help")
      let props = case d.get(props, "type_") {
        d.Null -> props
        value -> d.put(d.delete(props, "type_"), "type", value)
      }
      let lists =
        list.filter_map(d.fields(props), fn(p) {
          case d.s(p.1, "type") {
            "array" -> Ok(p.0)
            _ -> Error(Nil)
          }
        })
      let props =
        d.Object(
          list.map(d.fields(props), fn(p) {
            let prop = case list.contains(lists, p.0) {
              True ->
                d.Object([
                  #("type", d.Text("string")),
                  #(
                    "description",
                    d.Text(
                      string.replace(
                        d.s(p.1, "description"),
                        "(default [])",
                        "(default: none)",
                      )
                      <> " Comma-separated values; CSV quotes preserve literal commas. Blank optional lists add no arguments.",
                    ),
                  ),
                ])
              False -> p.1
            }
            #(
              p.0,
              d.put(
                prop,
                "description",
                d.Text(description(common, p.0, prop, "buildx " <> name)),
              ),
            )
          }),
        )
      let body =
        f.lines([
          "  json <- Contract.csvFields [ "
            <> string.join(list.map(lists, d.quote), ", ")
            <> " ] (Contract.encodeInput args)",
          "  config <- either throw pure (C.decode"
            <> title
            <> "Args (Contract.buildxInput json))",
          "  plan <- either throw pure (C." <> pure <> " config)",
          "  let runtime = C.runtime" <> title <> " config",
          "  Dependencies.ensureFor \"docker\"",
          "  void (B.execute runtime plan)",
          "  pure { outcome: \"succeeded\", runDir: runtime.runDir, reportPath: runtime.runDir <> \"/result.json\", stdoutPath: runtime.runDir <> \"/buildx.stdout\", stderrPath: runtime.runDir <> \"/buildx.stderr\" }",
        ])
      #(
        name,
        function(
          "Run Docker Buildx "
            <> string.replace(name, "_", " ")
            <> " and return execution report paths.",
          d.delete(d.put(input, "properties", props), "contentType"),
          execution(),
          "Contract.ExecutionResult",
          body,
        ),
      )
    })
  Ok(d.Object([#("setup", setup), ..functions]))
}

fn render(
  root: String,
  module: d.Value,
  spec: d.Value,
  check: Bool,
) -> Result(Nil, String) {
  let name = d.s(module, "name")
  let directory = root <> "/" <> d.s(module, "path")
  let functions = d.fields(d.get(spec, "functions"))
  let exports = list.map(functions, fn(p) { p.0 })
  let imports = d.strings(d.get(spec, "imports"))
  let declarations =
    list.flat_map(functions, fn(pair) {
      let contract = pair.1
      let props = d.fields(d.get(d.get(contract, "input"), "properties"))
      let required = d.strings(d.get(d.get(contract, "input"), "required"))
      let signature =
        string.join(
          list.map(props, fn(p) {
            let kind = scalar(d.s(p.1, "type"))
            quoted(p.0)
            <> " :: "
            <> case list.contains(required, p.0) {
              True -> kind
              False ->
                "Maybe "
                <> case d.s(p.1, "type") {
                  "array" -> "(" <> kind <> ")"
                  _ -> kind
                }
            }
          }),
          ", ",
        )
      let comments =
        list.map(props, fn(p) {
          "-- | @param " <> p.0 <> " " <> d.s(p.1, "description")
        })
      let returned = d.s(contract, "returned")
      let returned = case
        string.starts_with(returned, "Array ")
        || string.starts_with(returned, "{")
      {
        True -> "(" <> returned <> ")"
        False -> returned
      }
      list.append(
        ["-- | " <> d.s(contract, "description")],
        list.append(comments, [
          pair.0 <> " :: { " <> signature <> " } -> Effect " <> returned,
          pair.0 <> " args = do",
          d.s(contract, "body"),
          "",
        ]),
      )
    })
  let source =
    f.lines(list.append(
      [
        "-- Generated by Gleam CI helpers.",
        "module CI.Component (" <> string.join(exports, ", ") <> ") where",
        "",
      ],
      list.append(imports, list.append([""], declarations)),
    ))
    <> d.s(spec, "trailer")
  let version = case string.starts_with(d.s(module, "path"), "services/") {
    True -> "0.17.4"
    False ->
      case
        string.starts_with(d.s(module, "path"), "setup/")
        && name != "setup-android"
      {
        True -> "0.17.2"
        False -> "0.17.3"
      }
  }
  let header = [
    "# " <> name <> " component functions",
    "",
    "Requires FluentCI v"
      <> version
      <> " or newer. The compiler derives native WIT signatures",
    "and embedded help from these typed PureScript functions. Optional arguments may be omitted.",
    "",
  ]
  let docs =
    list.flat_map(functions, fn(pair) {
      let input = d.get(pair.1, "input")
      let required = d.strings(d.get(input, "required"))
      let rows =
        list.map(d.fields(d.get(input, "properties")), fn(p) {
          "| `"
          <> f.kebab(p.0)
          <> "` | `"
          <> d.s(p.1, "type")
          <> "` | "
          <> case list.contains(required, p.0) {
            True -> "yes"
            False -> "no"
          }
          <> " | "
          <> string.replace(d.s(p.1, "description"), "|", "\\|")
          <> " |"
        })
      list.append(
        [
          "## `" <> f.kebab(pair.0) <> "`",
          "",
          d.s(pair.1, "description"),
          "",
          "| Argument | Type | Required | Description |",
          "| --- | --- | --- | --- |",
        ],
        list.append(rows, [
          "",
          "Returns `" <> d.s(pair.1, "returned") <> "`.",
          "",
        ]),
      )
    })
  let schema =
    d.Object([
      #("name", d.Text(name)),
      #("runtime", d.Text("component")),
      #(
        "exports",
        d.Object(
          list.map(functions, fn(p) {
            #(
              p.0,
              d.Object(
                list.filter(d.fields(p.1), fn(field) {
                  list.contains(["description", "input", "output"], field.0)
                }),
              ),
            )
          }),
        ),
      ),
    ])
  use _ <- result.try(f.generated(
    directory <> "/src/CI/Component.purs",
    source,
    check,
  ))
  use _ <- result.try(f.generated(
    directory <> "/schema.json",
    d.pretty(schema),
    check,
  ))
  use _ <- result.try(f.generated(
    directory <> "/entry.mjs",
    "export { "
      <> string.join(exports, ", ")
      <> " } from \"./output/CI.Component/index.js\";\n",
    check,
  ))
  f.generated(
    directory <> "/COMPONENT.md",
    f.lines(list.append(header, docs)),
    check,
  )
}

pub fn run(root: String, check: Bool) -> Result(Nil, String) {
  use modules <- result.try(f.registry(root))
  use catalog <- result.try(f.json(root <> "/lib/cli/catalog.json"))
  use templates <- result.try(f.json(
    root <> "/scripts/templates/component-contracts.json",
  ))
  use common <- result.try(f.json(
    root <> "/scripts/templates/argument-descriptions.json",
  ))
  c.all(modules, fn(module) {
    let name = d.s(module, "name")
    let path = d.s(module, "path")
    let tool = list.last(string.split(path, "/")) |> result.unwrap("")
    let cli = list.find(d.array(catalog), fn(t) { d.s(t, "name") == name })
    use spec <- result.try(case cli {
      Ok(catalog) -> {
        use functions <- result.try(cli_functions(
          root,
          module,
          catalog,
          common,
          templates,
        ))
        let native = case name {
          "nix-publish" -> "CI.NixPublish"
          _ -> "CI.CLI"
        }
        let imports = [
          "import Prelude",
          "import CI.Contract as Contract",
          "import Data.Maybe (Maybe)",
          "import Effect (Effect)",
          "import CI.ModuleDependencies as Dependencies",
          "import " <> native <> " as Native",
        ]
        let extra = case
          list.contains(["depot", "flipt", "git", "gh", "glab"], name)
        {
          True -> [
            "import "
            <> case list.contains(["git", "gh", "glab"], name) {
              True -> "CI.ToolSetup"
              False -> "CI.ContainerSetup"
            }
            <> " as ContainerSetup",
          ]
          False -> []
        }
        Ok(
          d.Object([
            #("imports", d.Array(list.map(list.append(imports, extra), d.Text))),
            #("functions", functions),
          ]),
        )
      }
      Error(_) ->
        case name {
          "buildx" -> {
            use functions <- result.try(buildx_functions(
              root,
              common,
              templates,
            ))
            Ok(
              d.Object([
                #(
                  "imports",
                  d.Array(list.map(
                    [
                      "import Prelude",
                      "import CI.Contract as Contract",
                      "import Data.Either (either)",
                      "import Data.Maybe (Maybe)",
                      "import Effect (Effect)",
                      "import Effect.Exception (throw)",
                      "import CI.ModuleDependencies as Dependencies",
                      "import Buildx as B",
                      "import Buildx.Commands as C",
                      "import CI.ContainerSetup as ContainerSetup",
                    ],
                    d.Text,
                  )),
                ),
                #("functions", functions),
              ]),
            )
          }
          _ -> {
            let spec = case d.get(templates, name) {
              d.Null ->
                d.get(templates, case string.starts_with(path, "setup/") {
                  True -> "setup-default"
                  False -> "service-default"
                })
              value -> value
            }
            use _ <- result.try(c.require(
              d.get(templates, name) != d.Null
                || string.starts_with(path, "setup/")
                || string.starts_with(path, "services/"),
              "No typed component contract template: " <> name,
            ))
            d.parse(string.replace(d.encode(spec), "{{tool}}", tool))
          }
        }
    })
    render(root, module, spec, check)
  })
}
