# bazel component functions

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

## `build`

Build selected Bazel targets.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `config` | `string` | no | Named configuration selected by the native tool. |
| `compilation-mode` | `string` | no | Compilation Mode supplied to the bazel build operation. Allowed values: fastbuild, dbg, opt. |
| `jobs` | `integer` | no | Jobs supplied to the bazel build operation. |
| `define` | `array` | no | Define supplied to the bazel build operation. |
| `copt` | `array` | no | Copt supplied to the bazel build operation. |
| `targets` | `array` | no | Targets supplied to the bazel build operation. Default: ["//..."]. |

Returns `Contract.ExecutionResult`.

## `test`

Build and test selected Bazel targets.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `config` | `string` | no | Named configuration selected by the native tool. |
| `compilation-mode` | `string` | no | Compilation Mode supplied to the bazel test operation. Allowed values: fastbuild, dbg, opt. |
| `jobs` | `integer` | no | Jobs supplied to the bazel test operation. |
| `define` | `array` | no | Define supplied to the bazel test operation. |
| `copt` | `array` | no | Copt supplied to the bazel test operation. |
| `test-output` | `string` | no | Test Output supplied to the bazel test operation. Allowed values: summary, errors, all, streamed. |
| `targets` | `array` | no | Targets supplied to the bazel test operation. Default: ["//..."]. |

Returns `Contract.ExecutionResult`.

## `run-target`

Build and run a target with literal program arguments.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `config` | `string` | no | Named configuration selected by the native tool. |
| `compilation-mode` | `string` | no | Compilation Mode supplied to the bazel run_target operation. Allowed values: fastbuild, dbg, opt. |
| `jobs` | `integer` | no | Jobs supplied to the bazel run_target operation. |
| `define` | `array` | no | Define supplied to the bazel run_target operation. |
| `copt` | `array` | no | Copt supplied to the bazel run_target operation. |
| `target` | `string` | yes | Target selected for this native operation. |
| `arguments` | `array` | no | Literal native CLI argument tokens, passed without shell expansion. |

Returns `Contract.ExecutionResult`.

## `query`

query

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `output` | `string` | no | Destination path for generated packages. |
| `expression` | `string` | yes | Expression supplied to the bazel query operation. |

Returns `Contract.ExecutionResult`.

## `clean`

clean

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `expunge` | `boolean` | no | Expunge supplied to the bazel clean operation. |

Returns `Contract.ExecutionResult`.
