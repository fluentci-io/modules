# Rust

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.2+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run setup-rust setup --toolchain stable --components rustfmt,clippy --targets wasm32-wasip2,wasm32-unknown-unknown --profile minimal
```

```sh
fluentci run setup-rust --help
fluentci run setup-rust setup --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. List arguments use
comma-separated text; boolean arguments accept switches. Native function/flag
names use kebab-case.

`--toolchain` selects a channel, dated nightly, or exact release. `--version`
remains an alias; both must agree when supplied together. `--components` and
`--targets` accept comma-separated strings installed for that toolchain, with
duplicates removed and whitespace around entries trimmed. Omitted or blank
values add no components or targets. Empty entries between commas, JSON arrays,
and invalid names are rejected before host commands. Profiles are `minimal` (default), `default`, and `complete`. Explicit
rustup options fail on BSD, which uses native packages. Failed installation
never publishes a successful setup result or activates the installed bin directory.

## Requirements and behavior

Installs and verifies `rust`, then returns `tool`, `version`, `bin-dir`, and
`environment` (a list of `{name, value}` records). Environment updates are visible
to later tasks in the same host session. Separate shell invocations must add the
returned installation directory to PATH explicitly.



Linux/macOS use the configured upstream or ecosystem installer. JavaScript tools
are installed through Bun, bootstrapping Node.js/Bun when missing. Python, Go,
Ruby, and Java prerequisites depend on the selected tool. BSD uses native pkg,
pkg_add, or pkgin repositories; missing packages/versions fail clearly. Nix and
Determinate Nix support Linux/macOS only; dpkg/rpmbuild installers are Linux-only.

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
