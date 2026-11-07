# setup-purescript component functions

Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `setup`

Install and verify purescript, select its version, and publish its environment for subsequent tasks.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `version` | `string` | no | Tool release or supported channel to install; omitted values use the documented default. |
| `install-dir` | `string` | no | Absolute per-user installation prefix; omit for native package installations. |
| `package-name` | `string` | no | Native package or port selector overriding the default repository package name. |
| `sudo` | `boolean` | no | Use noninteractive sudo for native package or system installation; defaults to false. |
| `node-version` | `string` | no | Node.js release or channel to install for the PureScript toolchain. |
| `bun-version` | `string` | no | Bun release to install for the PureScript toolchain. |
| `npm-version` | `string` | no | npm release to install for the PureScript toolchain. |
| `spago-version` | `string` | no | Spago release to install for the PureScript toolchain. |
| `node-package-name` | `string` | no | Native Node.js package selector for BSD toolchain installation. |
| `bun-package-name` | `string` | no | Native Bun package selector for BSD toolchain installation. |

Returns `{ tool :: String, version :: String, binDir :: String, environment :: Array Contract.Variable, nodeVersion :: String, bunVersion :: String, npmVersion :: String, spagoVersion :: String }`.
