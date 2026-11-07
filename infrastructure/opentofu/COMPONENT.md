# opentofu component functions

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

## `init`

Initialize providers and the configured backend noninteractively.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `backend` | `boolean` | no | Backend supplied to the opentofu init operation. |
| `backend-config` | `array` | no | Backend Config supplied to the opentofu init operation. |
| `upgrade` | `boolean` | no | Upgrade supplied to the opentofu init operation. |
| `reconfigure` | `boolean` | no | Reconfigure supplied to the opentofu init operation. |

Returns `Contract.ExecutionResult`.

## `validate`

Validate the initialized configuration.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `json` | `boolean` | no | Json supplied to the opentofu validate operation. |

Returns `Contract.ExecutionResult`.

## `fmt`

Format configuration, or check when check=true.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `check` | `boolean` | no | Check supplied to the opentofu fmt operation. |
| `diff` | `boolean` | no | Diff supplied to the opentofu fmt operation. |
| `recursive` | `boolean` | no | Recursive supplied to the opentofu fmt operation. |

Returns `Contract.ExecutionResult`.

## `plan`

Create an infrastructure plan without applying it.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `out` | `string` | no | Out supplied to the opentofu plan operation. |
| `refresh` | `boolean` | no | Refresh supplied to the opentofu plan operation. |
| `lock` | `boolean` | no | Lock supplied to the opentofu plan operation. |
| `var` | `array` | no | Var supplied to the opentofu plan operation. |
| `var-file` | `array` | no | Var File supplied to the opentofu plan operation. |
| `target` | `array` | no | Target selected for this native operation. |

Returns `Contract.ExecutionResult`.

## `apply`

Apply changes; use a saved plan or autoApprove=true.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `auto-approve` | `boolean` | no | Auto Approve supplied to the opentofu apply operation. |
| `var` | `array` | no | Var supplied to the opentofu apply operation. |
| `var-file` | `array` | no | Var File supplied to the opentofu apply operation. |
| `target` | `array` | no | Target selected for this native operation. |
| `plan-file` | `string` | no | Plan File supplied to the opentofu apply operation. |

Returns `Contract.ExecutionResult`.

## `destroy`

Destroy managed infrastructure; autoApprove=true is required for unattended runs.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `auto-approve` | `boolean` | no | Auto Approve supplied to the opentofu destroy operation. |
| `var` | `array` | no | Var supplied to the opentofu destroy operation. |
| `var-file` | `array` | no | Var File supplied to the opentofu destroy operation. |
| `target` | `array` | no | Target selected for this native operation. |

Returns `Contract.ExecutionResult`.

## `output`

Read state output values.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `json` | `boolean` | no | Json supplied to the opentofu output operation. |
| `raw` | `boolean` | no | Raw supplied to the opentofu output operation. |
| `name` | `string` | no | Name supplied to the opentofu output operation. |

Returns `Contract.ExecutionResult`.
