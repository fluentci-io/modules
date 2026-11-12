# snyk component functions

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

## `setup`

Install a selected Snyk CLI release in project using Bun.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `version` | `string` | no | Tool release or supported channel to install; omitted values use the documented default. Default: "latest". |

Returns `Contract.ExecutionResult`.

## `test`

Test application dependencies and fail on vulnerabilities selected by policy.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `org` | `string` | no | Org supplied to the snyk test operation. |
| `severity-threshold` | `string` | no | Severity Threshold supplied to the snyk test operation. Allowed values: low, medium, high, critical. |
| `file` | `string` | no | File supplied to the snyk test operation. |
| `all-projects` | `boolean` | no | All Projects supplied to the snyk test operation. |
| `exclude` | `string` | no | Exclude supplied to the snyk test operation. |
| `path` | `string` | no | Path supplied to the snyk test operation. Default: ".". |

Returns `Contract.ExecutionResult`.

## `code-test`

Run Snyk Code analysis using the configured Snyk service.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `org` | `string` | no | Org supplied to the snyk code_test operation. |
| `severity-threshold` | `string` | no | Severity Threshold supplied to the snyk code_test operation. Allowed values: low, medium, high, critical. |
| `path` | `string` | no | Path supplied to the snyk code_test operation. Default: ".". |

Returns `Contract.ExecutionResult`.

## `iac-test`

Scan infrastructure-as-code configuration.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `org` | `string` | no | Org supplied to the snyk iac_test operation. |
| `severity-threshold` | `string` | no | Severity Threshold supplied to the snyk iac_test operation. Allowed values: low, medium, high, critical. |
| `path` | `string` | no | Path supplied to the snyk iac_test operation. Default: ".". |

Returns `Contract.ExecutionResult`.

## `container-test`

Test a container image for vulnerabilities.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `org` | `string` | no | Org supplied to the snyk container_test operation. |
| `severity-threshold` | `string` | no | Severity Threshold supplied to the snyk container_test operation. Allowed values: low, medium, high, critical. |
| `file` | `string` | no | File supplied to the snyk container_test operation. |
| `image` | `string` | yes | Image supplied to the snyk container_test operation. |

Returns `Contract.ExecutionResult`.

## `monitor`

Publish a dependency snapshot for ongoing monitoring.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `org` | `string` | no | Org supplied to the snyk monitor operation. |
| `file` | `string` | no | File supplied to the snyk monitor operation. |
| `all-projects` | `boolean` | no | All Projects supplied to the snyk monitor operation. |
| `path` | `string` | no | Path supplied to the snyk monitor operation. Default: ".". |

Returns `Contract.ExecutionResult`.
