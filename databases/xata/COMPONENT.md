# xata component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `run`

Execute any Xata CLI feature with literal CSV arguments.

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

Print the installed Xata CLI version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `skill`

Run the complete xata skill command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `init`

Run the complete xata init command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `onboard`

Run the complete xata onboard command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `auth`

Run the complete xata auth command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `organization`

Run the complete xata organization command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `project`

Run the complete xata project command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `branch`

Run the complete xata branch command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `keys`

Run the complete xata keys command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `roll`

Run the complete xata roll command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `clone`

Run the complete xata clone command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `stream`

Run the complete xata stream command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `status`

Run the complete xata status command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `licenses`

Run the complete xata licenses command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `checkout`

Run the complete xata checkout command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `scratch`

Run the complete xata scratch command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `console`

Run the complete xata console command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `upgrade`

Run the complete xata upgrade command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `completions`

Run the complete xata completions command surface, including every nested subcommand and native flag.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `branch-create`

Create a preview database branch; use branch-wait-ready before running tests.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `organization-id` | `string` | no | Xata organization ID. |
| `project-id` | `string` | no | Xata project ID; native checkout context is used when omitted. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `name` | `string` | yes | Name of the new branch. |
| `parent-branch` | `string` | no | Parent branch ID or name to fork. |
| `no-parent` | `boolean` | no | Create a root branch instead of forking. |
| `region` | `string` | no | Region for a new root branch. |
| `instance-type` | `string` | no | Compute instance type for a new root branch. |
| `postgres-version` | `string` | no | PostgreSQL image version for a new root branch. |
| `description` | `string` | no | Description of the preview branch. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `branch-delete`

Delete a database branch during pipeline cleanup.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `organization-id` | `string` | no | Xata organization ID. |
| `project-id` | `string` | no | Xata project ID; native checkout context is used when omitted. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `branch` | `string` | yes | Branch ID or name to delete. |
| `yes` | `boolean` | no | Confirm branch deletion without an interactive prompt. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `branch-list`

List database branches for the selected project.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `organization-id` | `string` | no | Xata organization ID. |
| `project-id` | `string` | no | Xata project ID; native checkout context is used when omitted. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `branch-describe`

Inspect a database branch and its current state.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `organization-id` | `string` | no | Xata organization ID. |
| `project-id` | `string` | no | Xata project ID; native checkout context is used when omitted. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `branch` | `string` | yes | Branch ID or name to inspect. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `branch-wait-ready`

Block the pipeline until a branch is healthy; task timeoutMs bounds the wait.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `organization-id` | `string` | no | Xata organization ID. |
| `project-id` | `string` | no | Xata project ID; native checkout context is used when omitted. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `branch` | `string` | yes | Branch ID or name to wait for. |
| `wake` | `boolean` | no | Wake a hibernated branch while waiting. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `branch-url`

Write the selected branch connection string to the task stdout file.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `organization-id` | `string` | no | Xata organization ID. |
| `project-id` | `string` | no | Xata project ID; native checkout context is used when omitted. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `branch` | `string` | yes | Branch ID or name whose connection string is requested. |
| `database` | `string` | no | PostgreSQL database name. |
| `connection-type` | `string` | no | Connection routing type. Allowed values: primary, primary-or-replica, replica, pooler. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `project-create`

Create a Xata project and its initial branch using explicit CI configuration.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `organization-id` | `string` | no | Xata organization ID. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `name` | `string` | yes | Name of the project. |
| `region` | `string` | no | Region for the first branch. |
| `instance-type` | `string` | no | Compute instance type for the first branch. |
| `postgres-version` | `string` | no | PostgreSQL image version for the first branch. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `migration-init`

Run pgroll init for the selected database branch and propagate migration failures.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `organization-id` | `string` | no | Xata organization ID. |
| `project-id` | `string` | no | Xata project ID; native checkout context is used when omitted. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `branch` | `string` | no | Target Xata branch ID or name. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `migration-start`

Run pgroll start for the selected database branch and propagate migration failures.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `organization-id` | `string` | no | Xata organization ID. |
| `project-id` | `string` | no | Xata project ID; native checkout context is used when omitted. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `branch` | `string` | no | Target Xata branch ID or name. |
| `migration-file` | `string` | yes | Local pgroll migration file to start. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `migration-complete`

Run pgroll complete for the selected database branch and propagate migration failures.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `organization-id` | `string` | no | Xata organization ID. |
| `project-id` | `string` | no | Xata project ID; native checkout context is used when omitted. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `branch` | `string` | no | Target Xata branch ID or name. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `migration-rollback`

Run pgroll rollback for the selected database branch and propagate migration failures.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `organization-id` | `string` | no | Xata organization ID. |
| `project-id` | `string` | no | Xata project ID; native checkout context is used when omitted. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `branch` | `string` | no | Target Xata branch ID or name. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `migration-status`

Run pgroll status for the selected database branch and propagate migration failures.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `organization-id` | `string` | no | Xata organization ID. |
| `project-id` | `string` | no | Xata project ID; native checkout context is used when omitted. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `branch` | `string` | no | Target Xata branch ID or name. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `migration-migrate`

Run pgroll migrate for the selected database branch and propagate migration failures.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `organization-id` | `string` | no | Xata organization ID. |
| `project-id` | `string` | no | Xata project ID; native checkout context is used when omitted. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `branch` | `string` | no | Target Xata branch ID or name. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `migration-pull`

Run pgroll pull for the selected database branch and propagate migration failures.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `organization-id` | `string` | no | Xata organization ID. |
| `project-id` | `string` | no | Xata project ID; native checkout context is used when omitted. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `branch` | `string` | no | Target Xata branch ID or name. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `migration-baseline`

Run pgroll baseline for the selected database branch and propagate migration failures.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `organization-id` | `string` | no | Xata organization ID. |
| `project-id` | `string` | no | Xata project ID; native checkout context is used when omitted. |
| `profile` | `string` | no | Existing Xata authentication profile; credentials remain in the host environment or native configuration. |
| `json` | `boolean` | no | Request JSON output where supported by the native command. |
| `branch` | `string` | no | Target Xata branch ID or name. |
| `arguments` | `string` | no | Additional native argument tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.
