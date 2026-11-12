# cmake component functions

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

## `configure`

Configure a CMake build tree.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `source-dir` | `string` | no | Directory containing the source project. Default: ".". |
| `build-dir` | `string` | no | Directory containing the configured build tree. Default: "build". |
| `generator` | `string` | no | Generator supplied to the cmake configure operation. |
| `preset` | `string` | no | Preset supplied to the cmake configure operation. |
| `build-type` | `string` | no | Build Type supplied to the cmake configure operation. |
| `definitions` | `array` | no | Definitions supplied to the cmake configure operation. |

Returns `Contract.ExecutionResult`.

## `build`

Build an existing CMake build tree.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `build-dir` | `string` | no | Directory containing the configured build tree. Default: "build". |
| `config` | `string` | no | Named configuration selected by the native tool. |
| `parallel` | `integer` | no | Maximum number of concurrent build or test jobs. |
| `target` | `array` | no | Target selected for this native operation. |
| `clean-first` | `boolean` | no | Clean First supplied to the cmake build operation. |

Returns `Contract.ExecutionResult`.

## `install`

Install build artifacts into the selected prefix.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `build-dir` | `string` | no | Directory containing the configured build tree. Default: "build". |
| `config` | `string` | no | Named configuration selected by the native tool. |
| `prefix` | `string` | no | Prefix supplied to the cmake install operation. |
| `component` | `string` | no | Component supplied to the cmake install operation. |

Returns `Contract.ExecutionResult`.

## `test`

Run CTest tests in a configured build tree.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `build-dir` | `string` | no | Directory containing the configured build tree. Default: "build". |
| `config` | `string` | no | Named configuration selected by the native tool. |
| `parallel` | `integer` | no | Maximum number of concurrent build or test jobs. |
| `output-on-failure` | `boolean` | no | Print failing test output when tests fail. Default: true. |

Returns `Contract.ExecutionResult`.
