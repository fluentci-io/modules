# coveralls component functions

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
| `artifacts` | `string` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. Comma-separated values; whitespace is trimmed and empty entries are rejected. CSV quotes preserve literal commas. |
| `arguments` | `string` | yes | Literal native CLI argument tokens, passed without shell expansion. Comma-separated values; whitespace is trimmed and empty entries are rejected. CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `version`

Print the CLI version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. Comma-separated values; whitespace is trimmed and empty entries are rejected. CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `upload`

Upload coverage reports using the universal Coveralls reporter.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. Comma-separated values; whitespace is trimmed and empty entries are rejected. CSV quotes preserve literal commas. |
| `format` | `string` | no | Format supplied to the coveralls upload operation. Allowed values: lcov, simplecov, cobertura, jacoco, gcov, luacov, golang, python. |
| `base-path` | `string` | no | Base Path supplied to the coveralls upload operation. |
| `job-flag` | `string` | no | Job Flag supplied to the coveralls upload operation. |
| `build-number` | `string` | no | Build Number supplied to the coveralls upload operation. |
| `parallel` | `boolean` | no | Maximum number of concurrent build or test jobs. |
| `dry-run` | `boolean` | no | Dry Run supplied to the coveralls upload operation. |
| `files` | `string` | yes | Files selected for the native operation; paths are passed literally without shell expansion. Comma-separated values; whitespace is trimmed and empty entries are rejected. CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `done`

Close a parallel coverage build.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. Comma-separated values; whitespace is trimmed and empty entries are rejected. CSV quotes preserve literal commas. |
| `build-number` | `string` | yes | Build Number supplied to the coveralls done operation. |
| `carryforward` | `string` | no | Carryforward supplied to the coveralls done operation. |
| `dry-run` | `boolean` | no | Dry Run supplied to the coveralls done operation. |

Returns `Contract.ExecutionResult`.
