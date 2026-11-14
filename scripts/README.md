# Repository automation on BEAM

All automation in this directory is implemented in Gleam targeting Erlang/OTP
and distributed as the ignored `fluentci_modules_ci` escript. Erlang FFI provides
filesystem, process, archive, cryptographic, socket, and process-isolation
primitives. Validation, generation, registry policy, build scheduling, and service
lifecycle assertions live in Gleam.

CI installs OTP 29.1.2 and Gleam 1.19.2 through the published `setup-erlang` and
`setup-gleam` modules, then compiles with warnings treated as errors. A small
checksum-verified shell bootstrap installs FluentCI first to break the toolchain
bootstrap cycle. No Python interpreter is needed to run these helpers.

When compilation and source generation are authorized:

```sh
(cd scripts && gleam build --target erlang --warnings-as-errors && gleam export escript)
escript scripts/fluentci_modules_ci generate-all
escript scripts/fluentci_modules_ci check-all
escript scripts/fluentci_modules_ci validate-modules
```

`generate-all` runs these generators in dependency order:

- `generate-cli`: CLI source catalog, private schemas, entrypoints, option references.
- `generate-setup`: setup catalog, private schemas, and legacy adapters.
- `generate-services`: native service profiles.
- `generate-buildx`: named Buildx arguments, shallow decoders, private schemas,
  and references. Explicit `--capture` refreshes the committed snapshot from
  Docker Buildx help; it executes the CLI and must be authorized locally.
- `generate-components`: typed PureScript public functions, argument descriptions,
  native return schemas, entrypoints, and component documentation.
- `generate-dependencies`: installer imports, manifests, frozen source locks,
  dependency regression wrappers, and prerequisite inventory.
- `audit-modules`: reviewed pipeline purposes and export inventory.

Each individual generator supports `--check`. Templates hold declarative
contracts and static source/prose fragments; schemas and executable source remain
generated from the reviewed catalogs and those templates. Public list fields
remain comma-separated strings where declared; no JSON CLI objects are added.

CI-only commands:

```sh
escript scripts/fluentci_modules_ci setup-toolchain --profile full
escript scripts/fluentci_modules_ci setup-toolchain --file setup/erlang/dist/plugin.wasm -- --version 29.1.2
escript scripts/fluentci_modules_ci install-security-test-tools --directory /tmp/security-tools --tools betterleaks,gitleaks,syft
escript scripts/fluentci_modules_ci test-module-batch --modules-env MODULE_BATCH --log-dir /tmp/module-logs
escript scripts/fluentci_modules_ci validate-wasm packaging/dpkg
escript scripts/fluentci_modules_ci test-services
escript scripts/fluentci_modules_ci test
```

`MODULE_BATCH` is internal JSON supplied by the GitHub matrix; its environment
variable name is passed on the command line. It is not a public module argument.
Downloads require HTTPS and verified SHA-256 hashes. Published setup components
also require the pinned publisher DID, name, version, and native component header.
Fresh setup prefixes preserve compatibility with published 0.2.0 installers.

Service builds use up to six BEAM workers; shared dependency preparation and
composition are serialized. Native service lifecycle tests run sequentially in an
isolated workspace, check TCP/HTTP/TLS and application protocols, exercise live
log interruption, and clean up owned services, volumes, and images. Build and E2E commands stream output immediately. Lifecycle operations print
timings, and silent commands emit an idle heartbeat every 30 seconds while
preserving their original deadlines. Diagnostic
artifacts contain logs/status, never generated AWS credential file contents.
`SERVICE_BUILD_CONCURRENCY` accepts 1–6; `SERVICE_LOG_DIR` selects diagnostics.

`lib/component/build-cli.mjs` and `inspect-abi.mjs` are small adapters to the
existing JavaScript component compiler and TypeScript AST APIs. The validator
compares their ABI data in Gleam. Module `build.mjs` entrypoints and JavaScript
SDK internals remain the existing compiler adapters. JavaScript Wasm fixture tests
call the BEAM validator through `lib/component/validate-wasm.mjs`.

Helper regression tests are under `scripts/test`; they do not start Docker,
install tools, or execute FluentCI plugins. Real builds and lifecycle verification
remain in CI. Follow AGENTS.md before local compilation or test execution.
