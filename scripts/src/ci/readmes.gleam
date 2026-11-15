import ci/common as c
import ci/data as d
import ci/files as f
import gleam/list
import gleam/result
import gleam/string

const start = "<!-- generated:language-examples -->"

const end = "<!-- /generated:language-examples -->"

fn snake(value: String) -> String {
  f.kebab(value) |> string.replace("-", "_")
}

fn camel(value: String) -> String {
  case string.split(f.kebab(value), "-") {
    [] -> value
    [first, ..rest] -> first <> string.concat(list.map(rest, f.title))
  }
}

fn sample(key: String, prop: d.Value) -> d.Value {
  case d.get(prop, "default") {
    d.Null ->
      case d.array(d.get(prop, "enum")) {
        [value, ..] -> value
        [] ->
          case d.s(prop, "type") {
            "boolean" -> d.Bool(True)
            "integer" | "number" -> d.Number("1")
            _ ->
              d.Text(case key {
                "stateDir" -> "/tmp/fluentci-example-data"
                "runDir" -> "/tmp/fluentci-example-run"
                "files" -> "dist/app.deb,dist/app.rpm"
                "packages" -> "git,cmake"
                "directory" | "dir" | "source" | "path" -> "."
                "file" -> "dist/artifact.tar.gz"
                "message" | "text" -> "CI pipeline completed"
                "url" | "webhookUrl" -> "https://example.com/webhook"
                "tag" -> "v1.0.0"
                "architecture" | "arch" -> "x86_64"
                "name" -> "example"
                _ -> "example-" <> f.kebab(key)
              })
          }
      }
    value -> value
  }
}

pub fn example(schema: d.Value) -> Result(#(String, d.Value), String) {
  let exports = d.get(schema, "exports")
  let preferred = [
    "setup",
    "start",
    "build",
    "test",
    "check",
    "analyze",
    "scan",
    "upload",
    "send",
    "version",
    "run",
  ]
  use operation <- result.try(
    list.find(preferred, fn(name) { d.get(exports, name) != d.Null })
    |> result.or(
      list.first(d.fields(exports)) |> result.map(fn(pair) { pair.0 }),
    )
    |> result.map_error(fn(_) { "Module has no documented example operation" }),
  )
  let input = d.get(d.get(exports, operation), "input")
  let props = d.get(input, "properties")
  let required = d.strings(d.get(input, "required"))
  let keys = list.filter(required, fn(key) { key != "runDir" })
  Ok(#(
    operation,
    d.Object(
      list.map(keys, fn(key) {
        #(key, case operation == "start" && key == "name" {
          True -> d.Text("module-" <> d.s(schema, "name") <> "-ci")
          False ->
            case d.s(schema, "name"), key {
              "codecov", "files" | "coveralls", "files" ->
                d.Text("coverage/lcov.info")
              "rustfmt", "files" -> d.Text("src/main.rs")
              "tangled-artifacts", "files" -> d.Text("dist/app.zip")
              "semgrep", "config" -> d.Text("auto")
              _, _ -> sample(key, d.get(props, key))
            }
        })
      }),
    ),
  ))
}

fn type_name(prop: d.Value, sdk: String) -> String {
  case d.s(prop, "type"), sdk {
    "boolean", "purs" -> "Boolean"
    "integer", "purs" -> "Int"
    "number", "purs" -> "Number"
    _, "purs" -> "String"
    "boolean", "gleam" -> "Bool"
    "integer", "gleam" -> "Int"
    "number", "gleam" -> "Float"
    _, "gleam" -> "String"
    "boolean", _ -> "bool"
    "integer", _ -> "int"
    "number", _ -> "float"
    _, _ -> "string"
  }
}

fn python_value(value: d.Value) -> String {
  case value {
    d.Bool(True) -> "True"
    d.Bool(False) -> "False"
    d.Null -> "None"
    _ -> d.encode(value)
  }
}

fn project(output: d.Value, python: Bool) -> String {
  let preferred = [
    "endpoint",
    "reportPath",
    "version",
    "cache",
    "messageId",
    "binDir",
    "name",
    "files",
  ]
  let field =
    list.find(preferred, fn(key) {
      d.get(d.get(output, "properties"), key) != d.Null
    })
    |> result.unwrap("")
  let prop = case field {
    "" -> output
    _ -> d.get(d.get(output, "properties"), field)
  }
  let access =
    "result"
    <> case field {
      "" -> ""
      _ ->
        "."
        <> case python {
          True -> snake(field)
          False -> camel(field)
        }
    }
  case d.s(prop, "type"), python {
    "array", True -> "\",\".join(" <> access <> ")"
    "array", False -> access <> ".join(\",\")"
    "string", _ -> access
    _, True -> "str(" <> access <> ")"
    _, False -> "String(" <> access <> ")"
  }
}

pub fn section(
  template: String,
  module: d.Value,
  schema: d.Value,
) -> Result(String, String) {
  use selected <- result.try(example(schema))
  let contract = d.get(d.get(schema, "exports"), selected.0)
  let props = d.get(d.get(contract, "input"), "properties")
  let values = d.fields(selected.1)
  let js_object = d.encode(selected.1)
  let properties =
    list.map(values, fn(p) {
      d.quote(camel(p.0)) <> ": " <> type_name(d.get(props, p.0), "rescript")
    })
  let purs_type =
    "{ "
    <> string.join(
      list.map(values, fn(p) {
        d.quote(p.0) <> " :: " <> type_name(d.get(props, p.0), "purs")
      }),
      ", ",
    )
    <> " }"
  let purs_object =
    "{ "
    <> string.join(
      list.map(values, fn(p) { d.quote(p.0) <> ": " <> d.encode(p.1) }),
      ", ",
    )
    <> " }"
  let python_fields =
    list.map(d.fields(props), fn(p) {
      "        "
      <> snake(p.0)
      <> "="
      <> python_value(d.get(selected.1, p.0))
      <> ","
    })
  let rows =
    list.map(d.fields(d.get(schema, "exports")), fn(p) {
      "| `"
      <> p.0
      <> "` | "
      <> string.replace(
        string.replace(d.s(p.1, "description"), "|", "\\|"),
        "\n",
        " ",
      )
      <> " |"
    })
  let lifecycle = case string.starts_with(d.s(module, "path"), "services/") {
    True ->
      "For services, register `stop` with the same project/name in failure-safe cleanup before running tests. A later ordinary `stop` step will be skipped when a preceding step fails. This short example starts the service using its default scoped name; it is not a complete service lifecycle. Elixir Flow does not yet offer failure-safe cleanup."
    False -> ""
  }
  let module_title = f.title(f.kebab(d.s(module, "name")))
  let operation = camel(selected.0)
  let replacements = [
    #("module_pascal", module_title),
    #("function_kebab", f.kebab(selected.0)),
    #(
      "purs_arguments",
      "Dependency."
        <> operation
        <> "Args"
        <> case values {
        [] -> ""
        _ -> " " <> purs_object
      },
    ),
    #(
      "gleam_required",
      string.join(list.map(values, fn(p) { python_value(p.1) }), ", "),
    ),
    #(
      "rescript_arguments",
      "FluentciModules"
        <> module_title
        <> "."
        <> operation
        <> "Args"
        <> case values {
        [] -> ""
        _ ->
          "("
          <> string.join(
            list.map(values, fn(p) { "~" <> camel(p.0) <> "=" <> d.encode(p.1) }),
            ", ",
          )
          <> ")"
      },
    ),
    #(
      "python_arguments",
      "{"
        <> string.join(
        list.map(values, fn(p) {
          d.quote(snake(p.0)) <> ": " <> python_value(p.1)
        }),
        ", ",
      )
        <> "}",
    ),
    #(
      "elixir_arguments",
      "%{"
        <> string.join(
        list.map(values, fn(p) {
          d.quote(snake(p.0)) <> " => " <> d.encode(p.1)
        }),
        ", ",
      )
        <> "}",
    ),
    #(
      "cljs_arguments",
      "{"
        <> string.join(
        list.map(values, fn(p) { ":" <> camel(p.0) <> " " <> d.encode(p.1) }),
        ", ",
      )
        <> "}",
    ),
    #("module", d.s(module, "name")),
    #("path", d.s(module, "path")),
    #("function", selected.0),
    #("js_function", camel(selected.0)),
    #("js_object", js_object),
    #("js_projection", project(d.get(contract, "output"), False)),
    #("python_projection", project(d.get(contract, "output"), True)),
    #("projection_description", "a useful field (or comma-joined list)"),
    #(
      "parameter_names",
      string.join(list.map(values, fn(p) { snake(p.0) }), ", "),
    ),
    #(
      "parameter_object",
      "{"
        <> string.join(
        list.map(values, fn(p) { d.quote(camel(p.0)) <> ": " <> snake(p.0) }),
        ", ",
      )
        <> "}",
    ),
    #(
      "gleam_js_object",
      "{"
        <> string.join(
        list.map(values, fn(p) {
          d.quote(camel(p.0)) <> ": args." <> snake(p.0)
        }),
        ", ",
      )
        <> "}",
    ),
    #("gleam_constructor", case values {
      [] -> "Args"
      _ ->
        "Args("
        <> string.join(
          list.map(values, fn(p) {
            snake(p.0) <> ": " <> type_name(d.get(props, p.0), "gleam")
          }),
          ", ",
        )
        <> ")"
    }),
    #("gleam_args", case values {
      [] -> "Args"
      _ ->
        "Args("
        <> string.join(
          list.map(values, fn(p) {
            snake(p.0)
            <> ": "
            <> case p.1 {
              d.Bool(True) -> "True"
              d.Bool(False) -> "False"
              _ -> d.encode(p.1)
            }
          }),
          ", ",
        )
        <> ")"
    }),
    #("purs_args_type", purs_type),
    #("purs_object", purs_object),
    #(
      "gleam_parameters",
      string.join(
        list.map(values, fn(p) {
          snake(p.0) <> ": " <> type_name(d.get(props, p.0), "gleam")
        }),
        ", ",
      ),
    ),
    #(
      "gleam_values",
      string.join(list.map(values, fn(p) { d.encode(p.1) }), ", "),
    ),
    #(
      "cljs_object",
      "#js {"
        <> string.join(
        list.map(values, fn(p) { ":" <> camel(p.0) <> " " <> d.encode(p.1) }),
        ", ",
      )
        <> "}",
    ),
    #("rescript_args_type", case values {
      [] -> "Js.Dict.t<string>"
      _ -> "{" <> string.join(properties, ", ") <> "}"
    }),
    #("rescript_object", case values {
      [] -> "Js.Dict.empty()"
      _ -> js_object
    }),
    #("python_alias", snake(d.s(module, "name"))),
    #("python_function", snake(selected.0)),
    #("python_args", f.title(f.kebab(selected.0)) <> "Args"),
    #("python_values", string.join(python_fields, "\n")),
    #("lifecycle", lifecycle),
    #("function_rows", string.join(rows, "\n")),
  ]
  Ok(
    list.fold(replacements, template, fn(text, pair) {
      string.replace(text, "{{" <> pair.0 <> "}}", pair.1)
    }),
  )
}

pub fn render(document: String, section: String) -> Result(String, String) {
  case string.split(document, start) {
    [before] -> Ok(string.trim_end(before) <> "\n\n" <> section)
    [before, after] ->
      case string.split(after, end) {
        [_, rest] -> Ok(before <> string.trim_end(section) <> rest)
        _ -> Error("Invalid generated language example section")
      }
    _ -> Error("Duplicate generated language example sections")
  }
}

pub fn run(root: String, check: Bool) -> Result(Nil, String) {
  use modules <- result.try(f.registry(root))
  use template <- result.try(c.text(
    root <> "/scripts/templates/readme-languages.md",
  ))
  c.all(modules, fn(module) {
    let directory = root <> "/" <> d.s(module, "path")
    use schema <- result.try(f.json(directory <> "/schema.json"))
    use examples <- result.try(section(template, module, schema))
    use document <- result.try(c.text(directory <> "/README.md"))
    use rendered <- result.try(render(document, examples))
    f.generated(directory <> "/README.md", rendered, check)
  })
}
