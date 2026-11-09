# setup-rust component functions

Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `setup`

Install and verify rust, select its version, and publish its environment for subsequent tasks.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `version` | `string` | no | Tool release or supported channel to install; omitted values use the documented default. |
| `install-dir` | `string` | no | Absolute per-user installation prefix; omit for native package installations. |
| `package-name` | `string` | no | Native package or port selector overriding the default repository package name. |
| `sudo` | `boolean` | no | Use noninteractive sudo for native package or system installation; defaults to false. |
| `toolchain` | `string` | no | Rustup toolchain channel or exact release; alias for version. Both must agree when provided. |
| `components` | `string` | no | Comma-separated Rustup components to install, such as rustfmt,clippy; omitted or blank values add no components. |
| `targets` | `string` | no | Comma-separated Rust target triples to install, such as wasm32-wasip2,wasm32-unknown-unknown; omitted or blank values add no targets. |
| `profile` | `string` | no | Rustup installation profile: minimal (default), default, or complete. |

Returns `Contract.SetupResult`.
