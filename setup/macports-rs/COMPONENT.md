# setup-macports-rs component functions

Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `setup`

Install and verify macports-rs, select its version, and publish its environment for subsequent tasks.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `version` | `string` | no | Tool release or supported channel to install; omitted values use the documented default. |
| `install-dir` | `string` | no | Absolute per-user installation prefix; omit for native package installations. |
| `package-name` | `string` | no | Native package or port selector overriding the default repository package name. |
| `sudo` | `boolean` | no | Use noninteractive sudo for requested port installs; setup-macports also uses it for its system installer. The macports-rs CLI itself is always installed without sudo. |
| `packages` | `string` | no | Comma-separated MacPorts port names to install, such as git,cmake,python312; omit or leave blank for CLI-only setup. Package versions come from the configured ports tree. |

Returns `Contract.SetupResult`.
