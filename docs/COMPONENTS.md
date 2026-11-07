# Native component modules (0.2.0)

All modules require FluentCI **v0.17.2 or newer** and declare
`runtime = "component"` in `fluentci.toml`. Module versions advance to 0.2.0
because the public invocation and return contracts change.

## Calling functions

Use named, typed flags rather than passing a serialized JSON plugin payload:

```sh
fluentci run setup-node setup --version 22.14.0
fluentci run cmake configure --run-dir .fluentci/configure --build-dir build
fluentci run cmake build --run-dir .fluentci/build --build-dir build --parallel 2
fluentci run dpkg build --directory package --arch arm64 --output dist/app.deb
fluentci run wrangler dry-run --run-dir .fluentci/worker --outdir dist/worker
```

WIT uses kebab-case names: `release_upload` becomes `release-upload`, and
`buildDir` becomes `--build-dir`. Optional arguments can be omitted; module
defaults still apply. Lists use JSON array syntax and booleans accept switches:

```sh
fluentci run prettier check --run-dir .fluentci/format --files '["src","test"]'
fluentci run buildx build --run-dir .fluentci/image --tag '["example/app:ci"]' --push
fluentci run cmake build --run-dir .fluentci/build-2 --clean-first
```

`fluentci run MODULE FUNCTION --help` reads names, types, argument descriptions,
required fields, and the native return type without executing the function.
Each module's generated `COMPONENT.md` and `schema.json` document the same source
contract. Runtime WIT is authoritative.

## Native results

- CLI and Buildx functions return a record with `outcome`, `run-dir`,
  `report-path`, `stdout-path`, and `stderr-path`. A failed command throws;
  a successful record points to the complete executor report and logs.
- Setup functions return `tool`, `version`, `bin-dir`, and `environment`.
  Environment values are a native list of `{name, value}` records. The PureScript
  toolchain also returns the selected Node/Bun/npm/Spago versions.
- Package builders return a native list of package paths; package validation
  returns a boolean after checking the layout and CPU architecture.
- Gemfury returns `{uploaded, files}`. Cachix returns `{enabled, cache}` so an
  absent credential remains visible as a skipped operation.

Credentials remain in the host environment or native configuration. A new
`run-dir` is required for each CLI invocation. Setup environment updates apply
within the host session; separate CLI processes should explicitly add the
installation prefix to PATH.

Output artifact declarations now use typed string lists:

```sh
fluentci run uv build --run-dir .fluentci/package \
  --artifacts '["wheel=dist/app.whl","source=dist/app.tar.gz"]'
```

Each entry is `NAME=PATH`; duplicate names and empty names/paths fail. This
replaces the previous arbitrary JSON object. Gemfury requires `--files` rather
than a raw path or the FURY_PACKAGE fallback. Buildx's `type_` field is `--type`;
`--help` documents the component rather than requesting Docker's help mode.

## Building and testing

Install Node.js 24+, Bun, PureScript 0.15.16, and Spago 1.0.5. From the root:

```sh
bun install --cwd lib/component --frozen-lockfile
npm ci --prefix build/cmake
npm run build --prefix build/cmake
npm test --prefix build/cmake
node scripts/validate_wasm.mjs build/cmake
```

The shared build compiles PureScript, reads fresh compiler docs/CoreFn, generates
WIT and argument adapters, and builds `dist/plugin.wasm` with ComponentizeJS.
It embeds typed metadata and writes a checksummed `dist/fluentci.metadata.json`.
No Extism guest compiler is involved. Preserve `lib/cli`, `lib/setup`, and
`lib/component` when vendoring module sources.

`lib/component/inspection` pins the inspection tools bundled with FluentCI
v0.17.2. A local compiler-driven extension supports structured PureScript record
returns; the upstream MPL-2.0 license is preserved separately from module MIT
licenses. Unsupported return types fail the build.

Buildx's generated decoders use small typed chunks to keep nested bind chains
within the guest engine's initialization limits. Its complete named argument
surface remains available.

`legacy-entry.mjs` and private CJS bundles retain the existing command and
installer regression suites. They are not published ABI entrypoints. Additional
tests call the typed PureScript functions directly, and the binary validator
rejects core Wasm, mismatched exports, missing descriptions, stale checksums,
and native argument/return shapes that disagree with the source schema.

Regenerate source contracts before building:

```sh
python3 scripts/generate_cli_modules.py
python3 scripts/generate_setup_tools.py
python3 containers/buildx/generate.py
python3 scripts/generate_components.py
python3 scripts/audit_modules.py
```

After changing shared contracts, rebuild the affected modules. CI builds and
validates every registered module on Linux/macOS in four batches per OS.
