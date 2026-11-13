# Setup SonarQube Scanner

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.2+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run setup-sonarqube-scanner setup --version latest
```

```sh
fluentci run setup-sonarqube-scanner --help
fluentci run setup-sonarqube-scanner setup --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use comma-separated
strings; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Installs and verifies `sonar-scanner`, then returns `tool`, `version`, `bin-dir`, and
`environment` (a list of `{name, value}` records). Environment updates are visible
to later tasks in the same host session. Separate shell invocations must add the
returned installation directory to PATH explicitly.



Linux/macOS download the portable SonarScanner CLI ZIP from SonarSource. Install
Java separately at the version required by the selected Scanner release. BSD uses
native pkg, pkg_add, or pkgin repositories; unavailable packages/versions fail
clearly. `packageName` can select a native repository package and `sudo` permits
noninteractive elevation for native installation. The portable installation is
per-user and rejects those system-install options.

This setup installs `sonar-scanner`. Use
[setup-sonarqube](../sonarqube/README.md) for the separate `sonar` CLI.
Scanner authentication uses `SONAR_TOKEN` and optionally `SONAR_HOST_URL`.

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
