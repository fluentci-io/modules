# Cachix

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.2+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run cachix setup --cache example
```

```sh
fluentci run cachix --help
fluentci run cachix setup --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Requires Nix and CACHIX_AUTH_TOKEN for the named cache. `setup` configures cache
use; `push` uploads ./result. Returns `enabled` and `cache`, making a skipped
operation visible when the token is absent. Tool installation is `setup-cachix`.

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
