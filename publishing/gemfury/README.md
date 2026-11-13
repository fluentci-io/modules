# Gemfury

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.3+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run gemfury upload --files dist/app.deb,dist/app.rpm
```

```sh
fluentci run gemfury --help
fluentci run gemfury upload --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. List arguments use comma-separated strings. CSV double quotes preserve commas within a filename. Native function/flag names use kebab-case.

## Requirements and behavior

Uploads explicit files using FURY_ACCOUNT, FURY_USER, and FURY_TOKEN from the
host environment. Requires curl with --variable/--expand-user support. Returns
`uploaded` and the decoded `files` array. A missing/blank FURY_TOKEN skips uploads and reports `uploaded: false` for a valid file list; with a token present, FURY_USER and FURY_ACCOUNT are required.
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

## Setup component dependency

This module declares `setup-gemfury` as typed native component dependencies.
FluentCI v0.17.3+ resolves their source references while building and composes
them into the published Wasm. Consumers need no relative source paths.
Available tools are reused; missing prerequisites invoke setup with default
arguments. Explicit executable overrides remain caller-managed. Configure pinned
versions or privileged/custom installations in an earlier setup step.
See [dependency behavior and publishing](../../docs/MODULE_DEPENDENCIES.md) for
command-specific prerequisites, validation, credential skips, and CI coverage.

`files` is a required comma-separated string. Whitespace around unquoted entries is trimmed. Blank lists, empty entries between commas, malformed CSV, NUL characters and line breaks in paths are rejected before host commands or setup. To upload a filename containing a comma, quote that CSV entry, for example `--files '"dist/file,one.deb",dist/second.rpm'`. Paths are passed as literal argv values with curl multipart escaping, without shell expansion. Internal PureScript upload APIs and the returned `files` value continue to use arrays.
