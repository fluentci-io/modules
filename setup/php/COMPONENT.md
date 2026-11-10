# setup-php component functions

Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `setup`

Install and verify PHP and optional versioned CI tools, then publish their environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `version` | `string` | no | PHP major/minor prefix or exact upstream release, including prereleases; latest/stable resolves the latest available release. Versions are discovered dynamically by the PHP backend. BSD is limited to native repository packages. Default: "latest". |
| `install-dir` | `string` | no | Absolute per-user prefix for the PHP manager and isolated tool environments; native BSD packages require this to be omitted. |
| `package-name` | `string` | no | Native package or port selector overriding the default repository package name. |
| `sudo` | `boolean` | no | Use noninteractive sudo for native package or system installation; defaults to false. |
| `tools` | `string` | no | Comma-separated PHP tools, optionally name:version, such as composer:2,phpunit:11,phpstan. Blank or none skips module tool installation. Supports documented aliases and vendor/package:version with a matching executable name. Default: "composer". |
| `mise-version` | `string` | no | mise release used to install PHP on Linux/macOS; ignored for native BSD packages. Default: "latest". |

Returns `Contract.SetupResult`.
