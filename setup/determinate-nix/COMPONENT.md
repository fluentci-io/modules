# setup-determinate-nix component functions

Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `setup`

Install and verify determinate-nix, select its version, and publish its environment for subsequent tasks.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `version` | `string` | no | Tool release or supported channel to install; omitted values use the documented default. |
| `install-dir` | `string` | no | Absolute per-user installation prefix; omit for native package installations. |
| `package-name` | `string` | no | Native package or port selector overriding the default repository package name. |
| `sudo` | `boolean` | no | Use noninteractive sudo for native package or system installation; defaults to false. |
| `init` | `string` | no | Determinate Nix service integration: systemd or none. |
| `trusted-users` | `string` | no | Comma-separated trusted Nix users or @groups, such as runner,@builders; root is retained. Blank or omitted values add no users. Trust only administrators. |
| `extra-conf` | `string` | no | Comma-separated single-line Nix key=value settings, passed literally to the installer. Quote CSV entries containing commas. Blank or omitted values add no settings. |

Returns `Contract.SetupResult`.
