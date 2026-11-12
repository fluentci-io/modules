# apko component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `run`

Run a native command with literal arguments.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `arguments` | `array` | yes | Literal native command argument tokens. |

Returns `Contract.ExecutionResult`.

## `version`

Print the installed tool version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |

Returns `Contract.ExecutionResult`.

## `build`

Build an OCI image and SBOM from an APK package configuration.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `arch` | `array` | no | Image CPU architectures such as x86_64 or aarch64; omit to use the configuration. |
| `lockfile` | `string` | no | APK dependency lockfile constraining package versions. |
| `cache-dir` | `string` | no | Directory for cached APK packages and indexes. |
| `offline` | `boolean` | no | Use the pre-populated package cache without network access. |
| `sbom-path` | `string` | no | Directory receiving generated SBOM files. |
| `build-date` | `string` | no | Reproducible image timestamp in RFC3339 format. |
| `config` | `string` | yes | apko YAML configuration file defining packages, repositories, and image metadata. |
| `tag` | `string` | yes | Image name/tag attached to the built image. |
| `output` | `string` | yes | Destination image tarball or OCI layout directory. |

Returns `Contract.ExecutionResult`.

## `publish`

Build and publish an OCI image using native registry credentials.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `arch` | `array` | no | Image CPU architectures such as x86_64 or aarch64; omit to use the configuration. |
| `lockfile` | `string` | no | APK dependency lockfile constraining package versions. |
| `cache-dir` | `string` | no | Directory for cached APK packages and indexes. |
| `offline` | `boolean` | no | Use the pre-populated package cache without network access. |
| `sbom-path` | `string` | no | Directory receiving generated SBOM files. |
| `build-date` | `string` | no | Reproducible image timestamp in RFC3339 format. |
| `config` | `string` | yes | apko YAML configuration file defining packages, repositories, and image metadata. |
| `tags` | `array` | yes | Registry image references to publish. |

Returns `Contract.ExecutionResult`.
