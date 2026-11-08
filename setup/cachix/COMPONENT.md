# setup-cachix component functions

Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `setup`

Install and verify cachix, select its version, and publish its environment for subsequent tasks.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `version` | `string` | no | Expected Cachix version from the configured nixpkgs registry entry; latest accepts the packaged version. An explicit version mismatch fails setup. |
| `install-dir` | `string` | no | Absolute per-user installation prefix; omit for native package installations. |
| `package-name` | `string` | no | Native package or port selector overriding the default repository package name. |
| `sudo` | `boolean` | no | Use noninteractive sudo for native package or system installation; defaults to false. |
| `cache` | `string` | no | Cachix cache name to enable with cachix use after installation; omit for CLI-only setup. Public caches need no token; private caches use inherited CACHIX_AUTH_TOKEN. |

Returns `Contract.SetupResult`.
