# setup-extism component functions

Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `setup`

Install and verify extism, select its version, and publish its environment for subsequent tasks.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `version` | `string` | no | Tool release or supported channel to install; omitted values use the documented default. |
| `install-dir` | `string` | no | Absolute per-user installation prefix; omit for native package installations. |
| `package-name` | `string` | no | Native package or port selector overriding the default repository package name. |
| `sudo` | `boolean` | no | Use noninteractive sudo for native package or system installation; defaults to false. |
| `cli-version` | `string` | no | Extism CLI release; takes precedence over version. |
| `js-version` | `string` | no | Extism JavaScript PDK compiler release. |
| `python-version` | `string` | no | Extism Python PDK compiler release. |
| `xtp-version` | `string` | no | Expected XTP version; upstream exposes a latest-only download. |
| `binaryen-version` | `string` | no | Binaryen release providing wasm-opt and wasm-merge. |

Returns `Contract.SetupResult`.
