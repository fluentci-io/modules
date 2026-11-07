# trivy component functions

Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `run`

Execute arbitrary literal CLI arguments.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `arguments` | `array` | yes | Literal native CLI argument tokens, passed without shell expansion. |

Returns `Contract.ExecutionResult`.

## `version`

Print the CLI version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |

Returns `Contract.ExecutionResult`.

## `filesystem`

Scan a filesystem and fail when selected findings are present.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `severity` | `string` | no | Severity supplied to the trivy filesystem operation. Default: "HIGH,CRITICAL". |
| `format` | `string` | no | Format supplied to the trivy filesystem operation. Default: "json". |
| `output` | `string` | no | Destination path for generated packages. |
| `scanners` | `string` | no | Scanners supplied to the trivy filesystem operation. |
| `ignore-unfixed` | `boolean` | no | Ignore Unfixed supplied to the trivy filesystem operation. |
| `skip-db-update` | `boolean` | no | Skip Db Update supplied to the trivy filesystem operation. |
| `offline-scan` | `boolean` | no | Offline Scan supplied to the trivy filesystem operation. |
| `directory` | `string` | no | Input directory containing the package tree to validate and build. Default: ".". |

Returns `Contract.ExecutionResult`.

## `image`

Scan a container image and fail at the selected severity.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `severity` | `string` | no | Severity supplied to the trivy image operation. Default: "HIGH,CRITICAL". |
| `format` | `string` | no | Format supplied to the trivy image operation. Default: "json". |
| `output` | `string` | no | Destination path for generated packages. |
| `scanners` | `string` | no | Scanners supplied to the trivy image operation. |
| `ignore-unfixed` | `boolean` | no | Ignore Unfixed supplied to the trivy image operation. |
| `skip-db-update` | `boolean` | no | Skip Db Update supplied to the trivy image operation. |
| `offline-scan` | `boolean` | no | Offline Scan supplied to the trivy image operation. |
| `image` | `string` | yes | Image supplied to the trivy image operation. |

Returns `Contract.ExecutionResult`.

## `config`

Scan infrastructure configuration for misconfigurations.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `severity` | `string` | no | Severity supplied to the trivy config operation. Default: "HIGH,CRITICAL". |
| `format` | `string` | no | Format supplied to the trivy config operation. Default: "json". |
| `output` | `string` | no | Destination path for generated packages. |
| `skip-check-update` | `boolean` | no | Skip Check Update supplied to the trivy config operation. |
| `directory` | `string` | no | Input directory containing the package tree to validate and build. Default: ".". |

Returns `Contract.ExecutionResult`.

## `sbom`

Scan an existing SBOM for vulnerabilities.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `severity` | `string` | no | Severity supplied to the trivy sbom operation. Default: "HIGH,CRITICAL". |
| `format` | `string` | no | Format supplied to the trivy sbom operation. Default: "json". |
| `output` | `string` | no | Destination path for generated packages. |
| `skip-db-update` | `boolean` | no | Skip Db Update supplied to the trivy sbom operation. |
| `file` | `string` | yes | File supplied to the trivy sbom operation. |

Returns `Contract.ExecutionResult`.
