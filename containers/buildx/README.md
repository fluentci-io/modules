# Docker Buildx

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.3+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run buildx setup --version latest
fluentci run buildx build --project /path/to/project --run-dir /tmp/buildx-build-001 --context . --file Dockerfile --tag example/app:latest --platform linux/amd64,linux/arm64 --push
```

```sh
fluentci run buildx --help
fluentci run buildx build --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use comma-separated strings; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Every operation checks Docker and Buildx first and installs missing prerequisites
through setup-docker and setup-buildx. Existing usable tools skip installation,
even when a custom Docker executable is selected. Explicit `setup` accepts version,
install-dir, package-name and sudo options for the Buildx plugin. Requested versions
are verified; a mismatching installation is replaced in the managed prefix.
A reachable daemon is required for daemon-backed operations. Returns a typed
execution result containing the report/log paths. All Docker options remain named
and typed; the component CLI reserves `--help` for its own contract documentation.
The Docker `type_` argument is now the native named flag `--type`.

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

This module declares `setup-docker` and `setup-buildx` as typed native component dependencies.
FluentCI v0.17.3+ resolves their source references while building and composes
them into the published Wasm. Consumers need no relative source paths.
Available tools are reused; missing prerequisites invoke setup with default
arguments. Explicit executable overrides remain caller-managed. Configure pinned
versions or privileged/custom installations in an earlier setup step.
See [dependency behavior and publishing](../../docs/MODULE_DEPENDENCIES.md) for
command-specific prerequisites, validation, credential skips, and CI coverage.
