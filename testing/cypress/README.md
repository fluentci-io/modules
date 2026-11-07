# Cypress

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.2+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run cypress test --project . --run-dir .fluentci/runs/cypress-001
```

```sh
fluentci run cypress --help
fluentci run cypress test --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Install Node.js and Cypress in your test project. Add its node_modules/.bin to PATH or set executable to the absolute path of node_modules/.bin/cypress. The project field selects the local working directory containing cypress.config.*. test runs end-to-end specs by default; component=true selects component testing. Install the Cypress binary and required system libraries before testing; Linux also needs Xvfb even for headless Electron. Upstream Cypress supports selected Linux, macOS, and Windows versions; Windows hosts are rejected here, and BSD browser builds are not provided. Cypress Cloud recording is opt-in with record=true; supply CYPRESS_RECORD_KEY through the host environment. Screenshots, videos, and reporter artifacts follow the project configuration.

The return value is a typed record containing `outcome`, `run-dir`, `report-path`,
`stdout-path`, and `stderr-path`. Each invocation needs a fresh run directory.
Native command failures, cancellation, and timeouts fail the component call.
Use `--artifacts '["package=dist/package.zip"]'` to declare output files for the
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
