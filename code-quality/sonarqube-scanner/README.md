# SonarQube Scanner

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.3+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

Use [sonarqube](../sonarqube/README.md) for the separate `sonar` CLI and its analysis, API, architecture, and integration commands.

## Usage

```sh
fluentci run sonarqube-scanner scan --project . --run-dir .fluentci/runs/sonarqube-scanner-001
```

```sh
fluentci run sonarqube-scanner --help
fluentci run sonarqube-scanner scan --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use comma-separated
strings; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Install SonarScanner CLI and the Java runtime required by that release, or use its bundled runtime. Supply SONAR_TOKEN and optionally SONAR_HOST_URL through the environment. Configure sonar-project.properties or typed fields. properties is a comma-separated string containing nonsecret property=value entries; values become literal -Dproperty=value arguments. qualityGateWait=true waits for the server quality gate and fails when it fails. Analysis sends project information to the configured SonarQube service.

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

This module declares `setup-sonarqube-scanner` as typed native component dependencies.
FluentCI v0.17.3+ resolves their source references while building and composes
them into the published Wasm. Consumers need no relative source paths.
Available tools are reused; missing prerequisites invoke setup with default
arguments. Explicit executable overrides remain caller-managed. Configure pinned
versions or privileged/custom installations in an earlier setup step.
See [dependency behavior and publishing](../../docs/MODULE_DEPENDENCIES.md) for
command-specific prerequisites, validation, credential skips, and CI coverage.
