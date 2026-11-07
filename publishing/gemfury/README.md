# Gemfury

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.2+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run gemfury upload --files '["dist/package.zip"]'
```

```sh
fluentci run gemfury --help
fluentci run gemfury upload --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Uploads explicit files using FURY_ACCOUNT, FURY_USER, and FURY_TOKEN from the
host environment. Requires curl with --variable/--expand-user support. Returns
`uploaded` and the input `files`; missing/empty credentials report `uploaded: false`.
All package files are checked before uploading; successful earlier uploads remain
published if a later upload fails. FURY_PACKAGE fallback is replaced by `--files`.

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
