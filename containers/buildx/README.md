# Docker Buildx

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.2+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run buildx build --project /path/to/project --run-dir /tmp/buildx-build-001 --context . --file Dockerfile --tag '["example/app:latest"]' --platform '["linux/amd64", "linux/arm64"]' --push
```

```sh
fluentci run buildx --help
fluentci run buildx build --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Requires Docker with the Buildx plugin and a reachable daemon. Returns a typed
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
