# jfrog-cli component functions

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

## `upload`

Upload build artifacts using a configured JFrog server.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `server-id` | `string` | no | Server Id supplied to the jfrog-cli upload operation. |
| `flat` | `boolean` | no | Flat supplied to the jfrog-cli upload operation. |
| `recursive` | `boolean` | no | Recursive supplied to the jfrog-cli upload operation. |
| `build-name` | `string` | no | Build Name supplied to the jfrog-cli upload operation. |
| `build-number` | `string` | no | Build Number supplied to the jfrog-cli upload operation. |
| `pattern` | `string` | yes | Pattern supplied to the jfrog-cli upload operation. |
| `target` | `string` | yes | Target selected for this native operation. |

Returns `Contract.ExecutionResult`.

## `download`

download

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `server-id` | `string` | no | Server Id supplied to the jfrog-cli download operation. |
| `flat` | `boolean` | no | Flat supplied to the jfrog-cli download operation. |
| `pattern` | `string` | yes | Pattern supplied to the jfrog-cli download operation. |
| `destination` | `string` | no | Destination supplied to the jfrog-cli download operation. Default: "dist/". |

Returns `Contract.ExecutionResult`.

## `search`

search

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `server-id` | `string` | no | Server Id supplied to the jfrog-cli search operation. |
| `pattern` | `string` | yes | Pattern supplied to the jfrog-cli search operation. |

Returns `Contract.ExecutionResult`.

## `build-publish`

build publish

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `server-id` | `string` | no | Server Id supplied to the jfrog-cli build_publish operation. |
| `build-name` | `string` | yes | Build Name supplied to the jfrog-cli build_publish operation. |
| `build-number` | `string` | yes | Build Number supplied to the jfrog-cli build_publish operation. |

Returns `Contract.ExecutionResult`.

## `build-promote`

build promote

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `server-id` | `string` | no | Server Id supplied to the jfrog-cli build_promote operation. |
| `copy` | `boolean` | no | Copy supplied to the jfrog-cli build_promote operation. |
| `status` | `string` | no | Status supplied to the jfrog-cli build_promote operation. |
| `build-name` | `string` | yes | Build Name supplied to the jfrog-cli build_promote operation. |
| `build-number` | `string` | yes | Build Number supplied to the jfrog-cli build_promote operation. |
| `target-repository` | `string` | yes | Target Repository supplied to the jfrog-cli build_promote operation. |

Returns `Contract.ExecutionResult`.
