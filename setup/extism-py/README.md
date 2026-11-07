# Setup Extism-Py

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.2+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run setup-extism-py setup --version latest
```

```sh
fluentci run setup-extism-py --help
fluentci run setup-extism-py setup --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Installs and verifies `extism-py`, then returns `tool`, `version`, `bin-dir`, and
`environment` (a list of `{name, value}` records). Environment updates are visible
to later tasks in the same host session. Separate shell invocations must add the
returned installation directory to PATH explicitly.



Linux/macOS use the configured upstream or ecosystem installer. JavaScript tools
are installed through Bun, bootstrapping Node.js/Bun when missing. Python, Go,
Ruby, and Java prerequisites depend on the selected tool. BSD uses native pkg,
pkg_add, or pkgin repositories; missing packages/versions fail clearly. Nix and
Determinate Nix support Linux/macOS only; dpkg/rpmbuild installers are Linux-only.

## Extism toolchain constraints

`setup-extism` installs Binaryen (`wasm-opt` and `wasm-merge`), Extism CLI,
`extism-js`, `extism-py`, and XTP. Select versions independently with `cliVersion`,
`jsVersion`, `pythonVersion`, `binaryenVersion`, and `xtpVersion`; `version` is
an alias for the CLI version. The Python compiler's packaged WASI dependencies
stay in the private prefix; `EXTISM_PYTHON_WASI_DEPS_DIR` points to them.
The Python PDK v0.1.5 has no official Linux ARM64 release, so that combination
fails clearly instead of downloading an incompatible executable. Native BSD
packages must exist in the configured repository for each component.

XTP currently publishes a latest-only binary endpoint. A requested `xtpVersion`
is checked against that binary and fails if it differs; the installer cannot
retrieve historical XTP releases. Pin other components for repeatable builds.

When installing this compiler separately, provide `wasm-opt` and `wasm-merge`
through `setup-binaryen` before compiling a plugin. `setup-extism` installs these
dependencies first. The private launcher restores the WASI resource path during
the compiler's recursive invocation, without modifying the user's global data
directory.

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
