# Playwright

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.2+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run playwright test --project . --run-dir .fluentci/runs/playwright-001
```

```sh
fluentci run playwright --help
fluentci run playwright test --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Install Node.js and @playwright/test in your test project. Add its node_modules/.bin to the host PATH or set executable to the absolute path of node_modules/.bin/playwright. testProject selects a Playwright test project; project selects the local working directory. Use install to download matching browsers and install_deps for system dependencies. Official browser support is limited to supported Linux, macOS, and Windows versions; the module rejects Windows hosts and does not provide BSD browser builds. Tests default to headless execution. Test reports, traces, and screenshots go to Playwright-configured paths under project, separate from the execution report in runDir.

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
