# planetscale component functions

Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `run`

Execute any PlanetScale CLI feature with literal CSV arguments.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | yes | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `version`

Print the installed pscale CLI version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `agents`

Run the complete pscale agents command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `login`

Run the complete pscale login command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `logout`

Run the complete pscale logout command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `agent-guide`

Run the complete pscale agent-guide command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `api`

Run the complete pscale api command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `audit-log`

Run the complete pscale audit-log command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `auth`

Run the complete pscale auth command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `billing`

Run the complete pscale billing command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `completion`

Run the complete pscale completion command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `org`

Run the complete pscale org command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `ping`

Run the complete pscale ping command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `region`

Run the complete pscale region command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `signup`

Run the complete pscale signup command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `size`

Run the complete pscale size command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `service-token`

Run the complete pscale service-token command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `backup`

Run the complete pscale backup command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `branch`

Run the complete pscale branch command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `database`

Run the complete pscale database command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `insights`

Run the complete pscale insights command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `inspect`

Run the complete pscale inspect command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `logs`

Run the complete pscale logs command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `metrics`

Run the complete pscale metrics command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `webhook`

Run the complete pscale webhook command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `connect`

Run the complete pscale connect command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `deploy-request`

Run the complete pscale deploy-request command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `keyspace`

Run the complete pscale keyspace command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `maintenance`

Run the complete pscale maintenance command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `password`

Run the complete pscale password command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `shell`

Run the complete pscale shell command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `import-command`

Run the complete pscale import command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `sql`

Run the complete pscale sql command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `workflow`

Run the complete pscale workflow command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `role-command`

Run the complete pscale role command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `pgbouncer`

Run the complete pscale pgbouncer command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `dedicated-read-replica`

Run the complete pscale dedicated-read-replica command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `read-only-replica`

Run the complete pscale read-only-replica command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `traffic-control`

Run the complete pscale traffic-control command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `branch-create`

Create a preview branch and wait for readiness by default.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `database` | `string` | yes | Source database name. |
| `branch` | `string` | yes | New branch name. |
| `organization` | `string` | no | PlanetScale organization name. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `from-branch` | `string` | no | Parent branch to fork. |
| `region` | `string` | no | Region for the branch. |
| `cluster-size` | `string` | no | Compute cluster size. |
| `wait` | `boolean` | no | Wait for the new branch to be ready. Default: true. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `branch-list`

List database branches for preview environment discovery.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `database` | `string` | yes | Database whose branches are listed. |
| `organization` | `string` | no | PlanetScale organization name. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `branch-show`

Inspect a database branch and its readiness information.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `database` | `string` | yes | Database. |
| `branch` | `string` | yes | Branch. |
| `organization` | `string` | no | PlanetScale organization name. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `branch-delete`

Delete a preview branch during pipeline cleanup.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `database` | `string` | yes | Database. |
| `branch` | `string` | yes | Branch. |
| `organization` | `string` | no | PlanetScale organization name. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `force` | `boolean` | no | Confirm deletion without an interactive prompt. |
| `delete-descendants` | `boolean` | no | Also delete descendant branches. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `branch-schema`

Retrieve a branch schema for inspection or artifact collection.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `database` | `string` | yes | Database. |
| `branch` | `string` | yes | Branch. |
| `organization` | `string` | no | PlanetScale organization name. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `database-list`

List databases visible to the pipeline credentials.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `organization` | `string` | no | PlanetScale organization name. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `deploy-request-create`

Open a schema deploy request from a branch.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `database` | `string` | yes | Database. |
| `branch` | `string` | yes | Branch containing the schema changes. |
| `organization` | `string` | no | PlanetScale organization name. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `into` | `string` | no | Destination branch; native parent/default is used when omitted. |
| `notes` | `string` | no | Notes attached to the deploy request. |
| `auto-delete-branch` | `boolean` | no | Delete the source branch after deployment completes. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `deploy-request-show`

Inspect a deploy request before applying schema changes.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `database` | `string` | yes | Database. |
| `request` | `string` | yes | Deploy request number or source branch. |
| `organization` | `string` | no | PlanetScale organization name. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `deploy-request-diff`

Inspect schema changes in a deploy request.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `database` | `string` | yes | Database. |
| `request-number` | `integer` | yes | Numeric deploy request number. |
| `organization` | `string` | no | PlanetScale organization name. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `deploy-request-deploy`

Deploy a schema request and wait for completion by default.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `database` | `string` | yes | Database. |
| `request` | `string` | yes | Deploy request number or source branch. |
| `organization` | `string` | no | PlanetScale organization name. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `wait` | `boolean` | no | Wait until deployment finishes. Default: true. |
| `strategy` | `string` | no | Native deployment strategy. Allowed values: serial, parallel. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `sql-query`

Execute a noninteractive SQL query and propagate query failures.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `database` | `string` | yes | Database. |
| `branch` | `string` | yes | Branch. |
| `organization` | `string` | no | PlanetScale organization name. |
| `output-format` | `string` | no | Native output format. Allowed values: human, json, csv. |
| `query` | `string` | yes | SQL text passed literally as one argument. |
| `role` | `string` | no | Database access role. |
| `dbname` | `string` | no | PostgreSQL database name. |
| `keyspace` | `string` | no | Vitess keyspace or shard target. |
| `replica` | `boolean` | no | Use a read replica. |
| `force` | `boolean` | no | Enable native execution of destructive SQL. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.
