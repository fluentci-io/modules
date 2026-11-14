import ci/artifacts
import ci/batch
import ci/common as c
import ci/data as d
import ci/dependencies
import ci/download
import ci/files as f
import ci/native
import ci/registry
import ci/services
import ci/setup
import ci/toolchain
import ci/wasm
import fluentci_modules_ci as cli
import gleam/bit_array
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn ordered_json_preserves_fields_unicode_quotes_and_native_types_test() {
  let text =
    "{\"z\":1,\"a\":[true,null,\"quotes \\\" and \\u2019\"],\"empty\":{}}"
  let assert Ok(value) = d.parse(text)
  list.map(d.fields(value), fn(p) { p.0 }) |> should.equal(["z", "a", "empty"])
  d.parse(d.encode(value)) |> should.equal(Ok(value))
  d.parse(d.pretty(value)) |> should.equal(Ok(value))
  for_invalid_json([
    "{\"a\":1,\"a\":2}",
    "[1,]",
    "{\"a\":1,}",
    "true trailing",
    "\"unterminated",
  ])
}

fn for_invalid_json(values: List(String)) {
  list.each(values, fn(value) {
    d.parse(value) |> result.is_error |> should.be_true
  })
}

pub fn toml_registry_and_inline_dependencies_decode_without_python_test() {
  let assert Ok(value) =
    d.parse_toml(
      "[[modules]]\nname='setup-node'\nversion='0.2.0'\n[dependencies]\nsetup-node={path='../node',sdk='purescript',runtime='component'}\n",
    )
  d.array(d.get(value, "modules")) |> list.length |> should.equal(1)
  d.s(d.get(d.get(value, "dependencies"), "setup-node"), "runtime")
  |> should.equal("component")
}

pub fn json_objects_compare_semantically_without_reordering_public_fields_test() {
  d.equivalent(
    d.Object([#("a", d.Number("1")), #("b", d.Text("2"))]),
    d.Object([#("b", d.Text("2")), #("a", d.Number("1"))]),
  )
  |> should.be_true
  d.equivalent(
    d.Array([d.Number("1"), d.Number("2")]),
    d.Array([d.Number("2"), d.Number("1")]),
  )
  |> should.be_false
}

pub fn service_output_separates_strings_logs_and_typed_records_test() {
  services.value(
    "build",
    "> build\nDocker output\nfluentci/aws-emulator:e2e-123\n",
  )
  |> should.equal(Ok(d.Text("fluentci/aws-emulator:e2e-123")))
  services.value("logs", "123\n{not JSON}\n")
  |> should.equal(Ok(d.Text("123\n{not JSON}\n")))
  services.value("logs", "") |> should.equal(Ok(d.Text("")))
  let record =
    d.Object([
      #("name", d.Text("module-redis-default")),
      #("state", d.Text("ready")),
      #("ports", d.Array([])),
    ])
  services.value(
    "start",
    "progress\n" <> d.pretty(record) <> "warning after result\n",
  )
  |> should.equal(Ok(record))
  list.each(["", "{}", "\"not a record\"", "build succeeded"], fn(value) {
    services.value("start", value) |> result.is_error |> should.be_true
  })
}

pub fn native_service_invocations_keep_named_arguments_and_literal_values_test() {
  services.invocation(
    "/tmp/prebuilt/redis.wasm",
    "logs",
    "/tmp/workspace with ' quotes",
    [
      #("follow", d.Bool(True)),
      #("tail", d.Number("20")),
    ],
  )
  |> should.equal([
    "fluentci",
    "run",
    "--wasm",
    "/tmp/prebuilt/redis.wasm",
    "logs",
    "--project",
    "/tmp/workspace with ' quotes",
    "--follow=true",
    "--tail=20",
  ])
}

pub fn module_matrix_bounds_runners_and_covers_each_module_per_os_test() {
  let modules =
    list.map(c.indices(160), fn(i) {
      d.Object([
        #("name", d.Text("module-" <> int.to_string(i))),
        #("path", d.Text("setup/module-" <> int.to_string(i))),
      ])
    })
  let buckets = d.array(d.get(registry.batches(modules, 4), "include"))
  list.length(buckets) |> should.equal(8)
  list.each(["ubuntu-24.04", "macos-15"], fn(os) {
    let actual =
      buckets
      |> list.filter(fn(b) { d.s(b, "os") == os })
      |> list.flat_map(fn(b) { d.array(d.get(b, "modules")) })
    list.length(actual) |> should.equal(160)
    list.length(list.unique(actual)) |> should.equal(160)
  })
  d.array(d.get(registry.batches(list.take(modules, 2), 4), "include"))
  |> list.length
  |> should.equal(4)
}

pub fn setup_results_accept_progress_multiline_json_and_validate_before_effects_test() {
  let record =
    "{\"tool\":\"node\",\"version\":\"24.22.2\",\"bin-dir\":\"/tools/bin\",\"environment\":[{\"name\":\"PATH\",\"value\":\"/tools/bin:/usr/bin\"}]}"
  let assert Ok(parsed) = d.parse(record)
  toolchain.parse_output(
    "checking tools\n" <> d.pretty(parsed) <> "trailing diagnostic\n",
  )
  |> should.equal(Ok(d.encode(parsed)))
  toolchain.parse_output("installation failed\n")
  |> result.is_error
  |> should.be_true
  let assert Ok(value) = setup.parse(record)
  setup.validate(value, "/usr/bin") |> result.is_ok |> should.be_true
  list.each(
    [
      setup.Setup("relative", []),
      setup.Setup("/tools/bin", [setup.Variable("PATH", "/usr/bin")]),
      setup.Setup("/tools/bin", [
        setup.Variable("PATH", "/tools/bin:/usr/bin"),
        setup.Variable("GITHUB_TOKEN", "fixture"),
      ]),
      setup.Setup("/tools/bin", [
        setup.Variable("PATH", "/tools/bin:/usr/bin"),
        setup.Variable("A", "one"),
        setup.Variable("A", "two"),
      ]),
    ],
    fn(value) {
      setup.validate(value, "/usr/bin") |> result.is_error |> should.be_true
    },
  )
}

pub fn setup_exports_reverse_path_order_and_safe_multiline_environment_test() {
  let old_path = native.env("GITHUB_PATH")
  let old_env = native.env("GITHUB_ENV")
  let assert Ok(Nil) =
    c.with_temp("fluentci-helper-env-", fn(root) {
      let _ = native.set_env("GITHUB_PATH", root <> "/paths")
      let _ = native.set_env("GITHUB_ENV", root <> "/env")
      let setup =
        setup.Setup("/new/bin", [
          setup.Variable("PATH", "/new/bin:/extra/bin:" <> native.env("PATH")),
          setup.Variable("JAVA_HOME", "/tools/java"),
          setup.Variable("LITERAL", "a\n$(not-run)"),
        ])
      use _ <- result.try(setup.github(setup))
      c.text(root <> "/paths") |> should.equal(Ok("/extra/bin\n/new/bin\n"))
      use env <- result.try(c.text(root <> "/env"))
      string.contains(env, "JAVA_HOME<<") |> should.be_true
      string.contains(env, "LITERAL<<") |> should.be_true
      string.contains(env, "PATH<<") |> should.be_false
      let _ = native.set_env("GITHUB_PATH", old_path)
      let _ = native.set_env("GITHUB_ENV", old_env)
      Ok(Nil)
    })
}

pub fn verified_download_reuses_only_matching_cache_and_rejects_bad_fetch_test() {
  let assert Ok(Nil) =
    c.with_temp("fluentci-helper-download-", fn(root) {
      let content = bit_array.from_string("component fixture")
      let digest = native.sha256(content)
      let path = root <> "/cache.wasm"
      use _ <- result.try(native.write(path, content))
      download.verified_with_fetch(
        "https://example.test/tool.wasm",
        digest,
        path,
        fn(_) { Error("must not fetch cached content") },
      )
      |> should.equal(Ok(path))
      download.verified_with_fetch(
        "https://example.test/tool.wasm",
        string.repeat("0", 64),
        path,
        fn(partial) { native.write(partial, <<1>>) },
      )
      |> result.is_error
      |> should.be_true
      native.read(path) |> should.equal(Ok(content))
      download.verified_with_fetch(
        "http://example.test/tool.wasm",
        digest,
        path,
        fn(_) { Error("must not fetch insecure URLs") },
      )
      |> result.is_error
      |> should.be_true
      Ok(Nil)
    })
}

pub fn published_setup_identity_checksum_and_url_are_required_test() {
  let registry = d.Object([#("publisherDid", d.Text("did:plc:fixture"))])
  let definition =
    d.Object([#("name", d.Text("setup-node")), #("version", d.Text("0.2.0"))])
  let package =
    d.merge(
      definition,
      d.Object([
        #("author", d.Text("did:plc:fixture")),
        #("url", d.Text("https://example.test/module.wasm")),
        #("sha256", d.Text(string.repeat("a", 64))),
      ]),
    )
  download.validate_package(registry, definition, package)
  |> should.equal(Ok(Nil))
  list.each(
    [
      #("author", d.Text("did:plc:other")),
      #("name", d.Text("different")),
      #("version", d.Text("0.3.0")),
      #("sha256", d.Text("")),
      #("url", d.Text("http://example.test/tool.wasm")),
    ],
    fn(p) {
      download.validate_package(registry, definition, d.put(package, p.0, p.1))
      |> result.is_error
      |> should.be_true
    },
  )
}

fn leb(value: Int) -> BitArray {
  case value < 128 {
    True -> <<value:8>>
    False -> <<
      { int.bitwise_or(int.bitwise_and(value, 127), 128) }:8,
      { leb(value / 128) }:bits,
    >>
  }
}

fn metadata_section(json: String) -> BitArray {
  let name = bit_array.from_string("fluentci:metadata")
  let payload = <<
    { leb(bit_array.byte_size(name)) }:bits,
    name:bits,
    { bit_array.from_string(json) }:bits,
  >>
  <<0, { leb(bit_array.byte_size(payload)) }:bits, payload:bits>>
}

pub fn native_wasm_metadata_rejects_core_modules_truncation_and_duplicates_test() {
  let header = <<0, 97, 115, 109, 13, 0, 1, 0>>
  let json =
    "{\"functions\":[{\"name\":\"setup\",\"description\":\"Fixture\"}]}"
  let section = metadata_section(json)
  let assert Ok(expected) = d.parse(json)
  wasm.metadata(<<header:bits, section:bits>>) |> should.equal(Ok(expected))
  list.each(
    [
      <<0, 97, 115, 109, 1, 0, 0, 0>>,
      <<header:bits, 0, 255>>,
      <<header:bits, section:bits, section:bits>>,
    ],
    fn(bytes) { wasm.metadata(bytes) |> result.is_error |> should.be_true },
  )
}

pub fn dependency_paths_and_runtime_contracts_use_installer_companions_test() {
  dependencies.relative("setup/java", "setup/android")
  |> should.equal("../java")
  dependencies.relative("setup/node", "build/nx")
  |> should.equal("../../setup/node")
  let service =
    d.Object([
      #("name", d.Text("aws-emulator")),
      #("path", d.Text("services/aws-emulator")),
    ])
  dependencies.definitions(service, d.Array([]), d.Array([]))
  |> list.map(fn(r) { d.s(r, "alias") })
  |> should.equal(["setup-docker", "setup-curl"])
  let notification =
    d.Object([
      #("name", d.Text("discord")),
      #("path", d.Text("notifications/discord")),
    ])
  dependencies.definitions(notification, d.Array([]), d.Array([]))
  |> list.map(fn(r) { d.s(r, "alias") })
  |> should.equal(["setup-curl"])
}

pub fn generated_catalog_field_names_and_paths_remain_safe_test() {
  f.module_path("setup/example") |> should.be_true
  list.each(
    ["../outside", "/setup/example", "setup/../outside", "setup/example/extra"],
    fn(path) { f.module_path(path) |> should.be_false },
  )
  f.label("serverId") |> should.equal("Server Id")
  f.kebab("containerPort") |> should.equal("container-port")
}

fn registry_fixture(root: String) -> Result(Nil, String) {
  let module = root <> "/setup/example"
  let package =
    "{\"name\":\"example\",\"license\":\"MIT\",\"scripts\":{\"build\":\"node build.mjs\",\"test\":\"node --test\"}}"
  let files = [
    #("LICENSE", "MIT License\n"),
    #(
      "fluentci.toml",
      "[[modules]]\nname='example'\nversion='0.1.0'\npath='setup/example'\nsdk='purescript'\nruntime='component'\n",
    ),
    #(
      "setup/example/fluentci-module.toml",
      "name='example'\nversion='0.1.0'\nsdk='purescript'\nruntime='component'\n",
    ),
    #("setup/example/LICENSE", "MIT License\n"),
    #("setup/example/README.md", "# Example\n"),
    #("setup/example/package.json", package),
    #(
      "setup/example/package-lock.json",
      "{\"name\":\"example\",\"packages\":{\"\":{\"name\":\"example\",\"license\":\"MIT\"}}}",
    ),
    #("setup/example/spago.yaml", "package:\n  name: example\n"),
    #("setup/example/spago.lock", "{}"),
    #("setup/example/build.mjs", ""),
    #(
      "setup/example/entry.mjs",
      "export { setup } from \"./output/CI.Component/index.js\";\n",
    ),
    #(
      "setup/example/schema.json",
      "{\"runtime\":\"component\",\"exports\":{\"setup\":{}}}",
    ),
    #("setup/example/.gitignore", "dist/\n"),
    #("setup/example/test/setup.test.mjs", ""),
    #(
      "setup/example/src/CI/Component.purs",
      "module CI.Component (setup) where\nsetup :: { version :: String } -> Effect String\n",
    ),
  ]
  use _ <- result.try(native.mkdir(module))
  c.all(files, fn(pair) { f.write(root <> "/" <> pair.0, pair.1) })
}

pub fn module_validator_preserves_metadata_source_and_registration_guards_test() {
  let assert Ok(Nil) =
    c.with_temp("fluentci-module-validator-", fn(root) {
      use _ <- result.try(registry_fixture(root))
      registry.validate(root) |> result.is_ok |> should.be_true
      use _ <- result.try(native.mkdir(root <> "/setup/unregistered"))
      registry.validate(root) |> result.is_error |> should.be_true
      use _ <- result.try(native.remove(root <> "/setup/unregistered"))
      use _ <- result.try(native.remove(
        root <> "/setup/example/test/setup.test.mjs",
      ))
      registry.validate(root) |> result.is_error |> should.be_true
      use _ <- result.try(f.write(
        root <> "/setup/example/test/setup.test.mjs",
        "",
      ))
      use _ <- result.try(c.write(
        root <> "/setup/example/package.json",
        "{\"name\":\"example\",\"license\":\"MIT\",\"scripts\":{\"build\":\"node build.mjs\",\"test\":\"node --test\"},\"devDependencies\":{\"esbuild\":\"0.25.3\"}}",
      ))
      registry.validate(root) |> result.is_error |> should.be_true
      use _ <- result.try(registry_fixture(root))
      use _ <- result.try(c.write(
        root <> "/setup/example/src/CI/Component.purs",
        "module CI.Component (other) where\nsetup :: { version :: String } -> Effect String\n",
      ))
      registry.validate(root) |> result.is_error |> should.be_true
      use _ <- result.try(registry_fixture(root))
      use original <- result.try(c.text(root <> "/fluentci.toml"))
      use _ <- result.try(c.write(
        root <> "/fluentci.toml",
        original <> original,
      ))
      registry.validate(root) |> result.is_error |> should.be_true
      use _ <- result.try(c.write(
        root <> "/fluentci.toml",
        string.replace(original, "setup/example", "../outside"),
      ))
      registry.validate(root) |> result.is_error |> should.be_true
      Ok(Nil)
    })
}

pub fn unknown_duplicate_and_malformed_helper_options_fail_before_effects_test() {
  cli.validate_options("setup-toolchain", ["--profile", "full"])
  |> should.equal(Ok(Nil))
  cli.validate_options("generate-buildx", ["--capture", "--check"])
  |> should.equal(Ok(Nil))
  list.each(
    [
      ["--unknown"],
      ["--profile"],
      ["--profile", "--cache-dir"],
      ["--profile", "full", "--profile", "base"],
    ],
    fn(args) {
      cli.validate_options("setup-toolchain", args)
      |> result.is_error
      |> should.be_true
    },
  )
}

pub fn prebuilt_artifacts_require_one_matching_module_and_absolute_wasm_path_test() {
  let record =
    "{\"modules\":[{\"name\":\"redis\",\"wasm\":\"/tmp/composed/redis.wasm\"}]}"
  artifacts.path("build output\n" <> record <> "\n", "redis")
  |> should.equal(Ok("/tmp/composed/redis.wasm"))
  artifacts.path(record, "postgres") |> result.is_error |> should.be_true
  artifacts.path("{\"modules\":[]}", "redis")
  |> result.is_error
  |> should.be_true
  artifacts.path(
    "{\"modules\":[{\"name\":\"redis\",\"wasm\":\"relative.wasm\"}]}",
    "redis",
  )
  |> result.is_error
  |> should.be_true
}

pub fn module_build_worker_count_is_bounded_test() {
  batch.concurrency("") |> should.equal(Ok(32))
  batch.concurrency("32") |> should.equal(Ok(32))
  list.each(["0", "33", "invalid", "-1"], fn(value) {
    batch.concurrency(value) |> result.is_error |> should.be_true
  })
}
