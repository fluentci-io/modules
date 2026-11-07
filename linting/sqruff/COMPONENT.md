# sqruff component functions

Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures
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

## `lint`

Lint SQL without modifying files and fail the pipeline on violations.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `config` | `string` | no | Additional Sqruff configuration file overriding discovered configuration. |
| `dialect` | `string` | no | SQL dialect override, for example postgres, ansi, or bigquery. |
| `format` | `string` | no | Report format: human, github-annotation-native, gitlab, json, sarif, or none. |
| `ignore-local-config` | `boolean` | no | Ignore discovered global and project configuration; explicit config is still loaded. |
| `parsing-errors` | `boolean` | no | Include SQL parsing errors in diagnostics. |
| `disable-noqa` | `boolean` | no | Ignore inline noqa suppression comments. |
| `files` | `array` | no | SQL files or directories to check or fix. Default: ["."]. |
| `write-output` | `string` | no | Destination for a GitLab Code Quality report when using the gitlab format. |
| `annotation-level` | `string` | no | Severity for GitLab findings: notice, warning, failure, or error. |

Returns `Contract.ExecutionResult`.

## `fix`

Apply SQL formatting and fixable lint rules to the selected project files.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `config` | `string` | no | Additional Sqruff configuration file overriding discovered configuration. |
| `dialect` | `string` | no | SQL dialect override, for example postgres, ansi, or bigquery. |
| `format` | `string` | no | Report format: human, github-annotation-native, gitlab, json, sarif, or none. |
| `ignore-local-config` | `boolean` | no | Ignore discovered global and project configuration; explicit config is still loaded. |
| `parsing-errors` | `boolean` | no | Include SQL parsing errors in diagnostics. |
| `disable-noqa` | `boolean` | no | Ignore inline noqa suppression comments. |
| `files` | `array` | no | SQL files or directories to check or fix. Default: ["."]. |

Returns `Contract.ExecutionResult`.
