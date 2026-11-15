# semgrep component functions

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

## `scan`

Scan with explicit rule configurations and fail when findings are present.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. Comma-separated values; whitespace is trimmed and empty entries are rejected. CSV quotes preserve literal commas. |
| `config` | `string` | yes | Named configuration selected by the native tool. Comma-separated values; whitespace is trimmed and empty entries are rejected. CSV quotes preserve literal commas. |
| `output` | `string` | no | Destination path for generated packages. |
| `json` | `boolean` | no | Json supplied to the semgrep scan operation. Default: true. |
| `sarif` | `boolean` | no | Sarif supplied to the semgrep scan operation. |
| `exclude` | `string` | no | Exclude supplied to the semgrep scan operation. Comma-separated values; whitespace is trimmed and empty entries are rejected. CSV quotes preserve literal commas. |
| `jobs` | `integer` | no | Jobs supplied to the semgrep scan operation. |
| `paths` | `string` | no | Paths supplied to the semgrep scan operation. Default: ["."]. Comma-separated values; whitespace is trimmed and empty entries are rejected. CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `ci`

Run Semgrep platform CI using the configured project policy.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. Comma-separated values; whitespace is trimmed and empty entries are rejected. CSV quotes preserve literal commas. |
| `json` | `boolean` | no | Json supplied to the semgrep ci operation. Default: true. |
| `output` | `string` | no | Destination path for generated packages. |

Returns `Contract.ExecutionResult`.
