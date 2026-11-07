# Doppler

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.2+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run doppler run-command --project . --run-dir .fluentci/runs/doppler-001 --command '["node", "app.js"]'
```

```sh
fluentci run doppler --help
fluentci run doppler run-command --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Install Doppler CLI and authenticate through DOPPLER_TOKEN or existing CLI configuration. dopplerProject selects the remote project; project is the local directory. run_command injects secrets only into its child process, not later FluentCI tasks. names prints names only, and upload suppresses secret values. Child output is still logged: avoid printing injected credentials.

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
