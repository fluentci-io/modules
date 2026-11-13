# GitHub artifacts

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.3+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run gh-artifacts upload --project . --run-dir .fluentci/runs/gh-artifacts-001 --name build-artifact --files dist/app.zip
```

```sh
fluentci run gh-artifacts --help
fluentci run gh-artifacts upload --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use comma-separated strings; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Use setup-gh-artifacts to install gh and the official @actions/artifact client. Job-artifact upload is GitHub Actions-only and needs ACTIONS_RUNTIME_TOKEN/ACTIONS_RESULTS_URL; outside Actions, use release_upload or another artifact backend. GH_TOKEN authenticates gh operations. FLUENTCI_GH_ARTIFACT_CLIENT selects the installed client module. Uploaded job artifacts are immutable; choose unique names per producer. Download by run ID or release tag for downstream stages.

The return value is a typed record containing `outcome`, `run-dir`, `report-path`,
`stdout-path`, and `stderr-path`. Each invocation needs a fresh run directory.
Native command failures, cancellation, and timeouts fail the component call.
Use `--artifacts package=dist/package.zip` to declare output files for the
execution report. Authentication stays in native configuration or host environment.

## Development

From this module directory, with Node.js, Bun, PureScript, and Spago installed:

```sh
bun install --cwd ../../lib/component --frozen-lockfile
npm ci
npm run build
npm test
```

`dist/plugin.wasm` is the native component; `dist/fluentci.metadata.json` is its
checksummed contract sidecar. The CJS bundles and `legacy-entry.mjs` exist only for
private regression tests and are not the published module interface.

See the [component migration guide](../../docs/COMPONENTS.md) and
[MIT License](./LICENSE).

## Setup component dependency

This module declares `setup-gh-artifacts` as typed native component dependencies.
FluentCI v0.17.3+ resolves their source references while building and composes
them into the published Wasm. Consumers need no relative source paths.
Available tools are reused; missing prerequisites invoke setup with default
arguments. Explicit executable overrides remain caller-managed. Configure pinned
versions or privileged/custom installations in an earlier setup step.
See [dependency behavior and publishing](../../docs/MODULE_DEPENDENCIES.md) for
command-specific prerequisites, validation, credential skips, and CI coverage.

The public module name is `gh-artifacts`, with the companion `setup-gh-artifacts`. List arguments such as `files`, `name`, `pattern`, `arguments` and `artifacts` accept comma-separated strings. Whitespace is trimmed; malformed CSV and empty entries are rejected before host commands. CSV double quotes preserve literal commas inside a token. The native `gh` command, official `@actions/artifact` package and `FLUENTCI_GH_ARTIFACT_CLIENT` environment variable keep their existing names.
