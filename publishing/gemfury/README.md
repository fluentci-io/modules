# Gemfury

Upload existing Linux packages to any Gemfury account. Package names, versions,
architectures, and build tools belong to your project: this module accepts
literal file paths and does not build packages or require a particular binary.
The module is written in PureScript and compiled to WebAssembly.

## Usage

Register this module as `gemfury` in your `fluentci.toml`. Build your package
with your project's packaging tools, then upload it:

```sh
export FURY_ACCOUNT=my-account
export FURY_USER=publisher
# Supply FURY_TOKEN through your shell or CI secret store.
fluentci run gemfury upload dist/widget_1.2.0_arm64.deb
fluentci run gemfury upload dist/another-app-3.0-1.x86_64.rpm
```

The `upload` export takes one literal path as plugin input. Alternatively, set
`FURY_PACKAGE` and invoke it without input:

```sh
export FURY_PACKAGE="dist/my package.deb"
fluentci run gemfury upload
```

Input takes precedence over `FURY_PACKAGE`. Relative paths resolve from the
current workspace. Paths are not split on spaces or expanded as shell globs.
No filename extension or architecture restriction is imposed; Gemfury decides
whether the uploaded content is a supported package.

## Configuration

| Variable | Meaning |
| --- | --- |
| `FURY_ACCOUNT` | Gemfury destination account; letters, digits, hyphens, and underscores. |
| `FURY_USER` | Gemfury authentication user. |
| `FURY_TOKEN` | Gemfury authentication token. |
| `FURY_PACKAGE` | Package path when plugin input is empty. |

Curl must be installed with support for `--variable` and `--expand-user`.
Credentials are read by curl from the host environment; their values are not
embedded in command arguments. If `FURY_TOKEN` is missing, empty, or
whitespace-only, upload prints a skip message and succeeds without checking
other configuration.

With a token present, each file must be a readable, nonempty regular file.
Empty paths and paths containing NUL or line breaks are rejected. Upload and
preflight errors propagate to FluentCI.

## Compose in PureScript

Use `uploadFiles :: Array String -> Effect Unit` to upload one or more packages:

```purescript
module Main where

import CI.Gemfury as Gemfury
import Effect (Effect)

publish :: Effect Unit
publish = Gemfury.uploadFiles
  [ "dist/widget_1.2.0_arm64.deb"
  , "dist/widget-1.2.0-1.aarch64.rpm"
  ]
```

All files are checked before the first upload. Uploads run sequentially and
stop on the first failure; already completed uploads remain published.
Only `upload` is exported as a WebAssembly entry point.

## Migration

The project-specific `dependencies`, `package`, and `github` exports have been
removed. Install your own packaging tools, build your packages, and manage
GitHub release assets in separate pipeline steps. Replace the old upload's
`TARGET` and `RELEASE_VERSION` configuration with an explicit package path.

## Development

Install Node.js, Spago, the PureScript compiler, and `extism-js`.

```sh
npm ci
npm run build
npm test
```

The build produces `dist/plugin.wasm` and the `dist/plugin.cjs` test bundle.
Tests exercise arbitrary package paths, batch preflight, credential handling,
filename quoting, and failures using a stub host and local file checks. They
do not publish packages or read real credentials.

## License

[MIT](./LICENSE).
