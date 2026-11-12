# sqlfluff component functions

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

## `lint`

Lint SQL and fail the pipeline on violations or parsing errors.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `config` | `string` | no | SQLFluff configuration file; repository configuration remains available when omitted. |
| `dialect` | `string` | no | SQL dialect, such as postgres, ansi, bigquery, or snowflake. |
| `templater` | `string` | no | Template engine; requires its Python dependencies in the SQLFluff environment. |
| `rules` | `string` | no | Comma-separated rule codes to enable. |
| `exclude-rules` | `string` | no | Comma-separated rule codes to exclude. |
| `processes` | `integer` | no | Worker count; zero uses all CPUs and negative values reserve CPUs. |
| `format` | `string` | no | Report format, for example human, json, github-annotation, or sarif. |
| `write-output` | `string` | no | Report output file to retain as an artifact. |
| `files` | `array` | no | SQL files or directories to process. Default: ["."]. |

Returns `Contract.ExecutionResult`.

## `fix`

Apply fixable SQL rules to the selected project files.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `config` | `string` | no | SQLFluff configuration file; repository configuration remains available when omitted. |
| `dialect` | `string` | no | SQL dialect, such as postgres, ansi, bigquery, or snowflake. |
| `templater` | `string` | no | Template engine; requires its Python dependencies in the SQLFluff environment. |
| `rules` | `string` | no | Comma-separated rule codes to enable. |
| `exclude-rules` | `string` | no | Comma-separated rule codes to exclude. |
| `processes` | `integer` | no | Worker count; zero uses all CPUs and negative values reserve CPUs. |
| `files` | `array` | no | SQL files or directories to process. Default: ["."]. |

Returns `Contract.ExecutionResult`.

## `parse`

Parse SQL to detect syntax and templating errors.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `config` | `string` | no | SQLFluff configuration file; repository configuration remains available when omitted. |
| `dialect` | `string` | no | SQL dialect, such as postgres, ansi, bigquery, or snowflake. |
| `templater` | `string` | no | Template engine; requires its Python dependencies in the SQLFluff environment. |
| `rules` | `string` | no | Comma-separated rule codes to enable. |
| `exclude-rules` | `string` | no | Comma-separated rule codes to exclude. |
| `processes` | `integer` | no | Worker count; zero uses all CPUs and negative values reserve CPUs. |
| `format` | `string` | no | Parse output format, such as yaml or json. |
| `path` | `string` | no | SQL file or directory to parse. Default: ".". |

Returns `Contract.ExecutionResult`.
