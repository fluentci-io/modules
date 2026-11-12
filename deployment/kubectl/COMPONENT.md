# kubectl component functions

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

## `apply`

apply

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `context` | `string` | no | Context supplied to the kubectl apply operation. |
| `namespace` | `string` | no | Namespace supplied to the kubectl apply operation. |
| `kubeconfig` | `string` | no | Kubeconfig supplied to the kubectl apply operation. |
| `filename` | `array` | yes | Filename supplied to the kubectl apply operation. |
| `recursive` | `boolean` | no | Recursive supplied to the kubectl apply operation. |

Returns `Contract.ExecutionResult`.

## `get`

get

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `context` | `string` | no | Context supplied to the kubectl get operation. |
| `namespace` | `string` | no | Namespace supplied to the kubectl get operation. |
| `kubeconfig` | `string` | no | Kubeconfig supplied to the kubectl get operation. |
| `output` | `string` | no | Destination path for generated packages. |
| `resource` | `string` | yes | Resource supplied to the kubectl get operation. |
| `name` | `string` | no | Name supplied to the kubectl get operation. |

Returns `Contract.ExecutionResult`.

## `delete-resources`

delete

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `context` | `string` | no | Context supplied to the kubectl delete_resources operation. |
| `namespace` | `string` | no | Namespace supplied to the kubectl delete_resources operation. |
| `kubeconfig` | `string` | no | Kubeconfig supplied to the kubectl delete_resources operation. |
| `filename` | `array` | yes | Filename supplied to the kubectl delete_resources operation. |
| `ignore-not-found` | `boolean` | no | Ignore Not Found supplied to the kubectl delete_resources operation. |

Returns `Contract.ExecutionResult`.

## `rollout-status`

rollout status

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `context` | `string` | no | Context supplied to the kubectl rollout_status operation. |
| `namespace` | `string` | no | Namespace supplied to the kubectl rollout_status operation. |
| `kubeconfig` | `string` | no | Kubeconfig supplied to the kubectl rollout_status operation. |
| `timeout` | `string` | no | Timeout supplied to the kubectl rollout_status operation. |
| `resource` | `string` | yes | Resource supplied to the kubectl rollout_status operation. |

Returns `Contract.ExecutionResult`.
