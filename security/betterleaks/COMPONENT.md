# betterleaks component functions

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

## `scan-dir`

Scan files using Betterleaks 1.x with redaction and credential validation disabled.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `config` | `string` | no | Named configuration selected by the native tool. |
| `report-format` | `string` | no | Report Format supplied to the betterleaks scan_dir operation. Default: "json". Allowed values: json, csv, junit, sarif. |
| `report-path` | `string` | no | Report Path supplied to the betterleaks scan_dir operation. |
| `confidence` | `string` | no | Confidence supplied to the betterleaks scan_dir operation. Allowed values: low, medium, high. |
| `enable-rule` | `array` | no | Enable Rule supplied to the betterleaks scan_dir operation. |
| `disable-rule` | `array` | no | Disable Rule supplied to the betterleaks scan_dir operation. |
| `directory` | `string` | no | Input directory containing the package tree to validate and build. Default: ".". |

Returns `Contract.ExecutionResult`.

## `scan-git`

Scan Git history with Betterleaks 1.x, failing on detected secrets.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `config` | `string` | no | Named configuration selected by the native tool. |
| `report-format` | `string` | no | Report Format supplied to the betterleaks scan_git operation. Default: "json". Allowed values: json, csv, junit, sarif. |
| `report-path` | `string` | no | Report Path supplied to the betterleaks scan_git operation. |
| `confidence` | `string` | no | Confidence supplied to the betterleaks scan_git operation. Allowed values: low, medium, high. |
| `enable-rule` | `array` | no | Enable Rule supplied to the betterleaks scan_git operation. |
| `disable-rule` | `array` | no | Disable Rule supplied to the betterleaks scan_git operation. |
| `log-opts` | `string` | no | Log Opts supplied to the betterleaks scan_git operation. |
| `repository` | `string` | no | Repository supplied to the betterleaks scan_git operation. Default: ".". |

Returns `Contract.ExecutionResult`.
