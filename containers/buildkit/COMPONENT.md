# buildkit component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
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

## `build`

Build a Dockerfile with named local context and dockerfile directories.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `addr` | `string` | no | Addr supplied to the buildkit build operation. |
| `context` | `string` | no | Context supplied to the buildkit build operation. Default: ".". |
| `dockerfile-dir` | `string` | no | Dockerfile Dir supplied to the buildkit build operation. Default: ".". |
| `opt` | `array` | no | Opt supplied to the buildkit build operation. |
| `output` | `array` | no | Destination path for generated packages. |
| `import-cache` | `array` | no | Import Cache supplied to the buildkit build operation. |
| `export-cache` | `array` | no | Export Cache supplied to the buildkit build operation. |
| `secret` | `array` | no | Secret supplied to the buildkit build operation. |
| `ssh` | `array` | no | Ssh supplied to the buildkit build operation. |
| `no-cache` | `boolean` | no | No Cache supplied to the buildkit build operation. |
| `progress` | `string` | no | Progress supplied to the buildkit build operation. |

Returns `Contract.ExecutionResult`.

## `prune`

Prune the selected BuildKit daemon cache.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `addr` | `string` | no | Addr supplied to the buildkit prune operation. |
| `all` | `boolean` | no | All supplied to the buildkit prune operation. |
| `filter` | `array` | no | Filter supplied to the buildkit prune operation. |

Returns `Contract.ExecutionResult`.

## `du`

Inspect BuildKit cache usage.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `addr` | `string` | no | Addr supplied to the buildkit du operation. |
| `verbose` | `boolean` | no | Verbose supplied to the buildkit du operation. |
| `filter` | `array` | no | Filter supplied to the buildkit du operation. |

Returns `Contract.ExecutionResult`.
