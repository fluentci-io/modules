# OpenSSF Scorecard

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.2+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run scorecard scan --project . --run-dir .fluentci/runs/scorecard-001 --repo github.com/ossf/scorecard
```

```sh
fluentci run scorecard --help
fluentci run scorecard scan --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Install the OpenSSF Scorecard CLI. Remote repository checks contact GitHub and other project services; use GITHUB_AUTH_TOKEN when required by the upstream CLI. Local mode supports a limited check set. Scorecard exits successfully when it produces scores; low scores do not automatically fail CI. Apply a score policy separately or use the generic run export for supported policy integrations.

The return value is a typed record containing `outcome`, `run-dir`, `report-path`,
`stdout-path`, and `stderr-path`. Each invocation needs a fresh run directory.
Native command failures, cancellation, and timeouts fail the component call.
Use `--artifacts '["package=dist/package.zip"]'` to declare output files for the
execution report. Authentication stays in native configuration or host environment.

`scan` produces findings. `gate --report PATH --minimum 8` enforces a minimum
per reported check and fails on unscored checks. The gate requires Bun.

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
