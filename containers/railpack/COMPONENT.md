# railpack component functions

Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures
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

## `prepare`

Generate a build plan and metadata, failing when the project cannot be prepared.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `env-names` | `array` | no | Names of host environment variables to forward to Railpack, without embedding their values. |
| `config-file` | `string` | no | Railpack project configuration file. |
| `build-cmd` | `string` | no | Override the project build command; executed by Railpack inside the build. |
| `start-cmd` | `string` | no | Container start command to include in the image. |
| `previous` | `array` | no | Previously selected package versions as NAME@VERSION entries. |
| `directory` | `string` | no | Project source directory to analyze or build. Default: ".". |
| `plan-out` | `string` | no | Destination for the generated JSON build plan. Default: "railpack-plan.json". |
| `info-out` | `string` | no | Destination for structured project/build metadata. Default: "railpack-info.json". |

Returns `Contract.ExecutionResult`.

## `build`

Build a project into an image through a configured BuildKit daemon.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `env-names` | `array` | no | Names of host environment variables to forward to Railpack, without embedding their values. |
| `config-file` | `string` | no | Railpack project configuration file. |
| `build-cmd` | `string` | no | Override the project build command; executed by Railpack inside the build. |
| `start-cmd` | `string` | no | Container start command to include in the image. |
| `previous` | `array` | no | Previously selected package versions as NAME@VERSION entries. |
| `directory` | `string` | no | Project source directory to analyze or build. Default: ".". |
| `name` | `string` | yes | Container image name/tag to produce. |
| `platform` | `string` | no | Target image platform, for example linux/amd64. |
| `progress` | `string` | no | BuildKit progress mode: auto, plain, or tty. Default: "plain". |
| `output` | `string` | no | Export the final filesystem to a local directory. |
| `cache-from` | `array` | no | BuildKit cache import specifications. |
| `cache-to` | `array` | no | BuildKit cache export specifications. |
| `no-cache` | `boolean` | no | Build without reading cached layers. |

Returns `Contract.ExecutionResult`.

## `info`

Inspect detected runtimes, dependencies, and build requirements.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `format` | `string` | no | Project information output format: json or pretty. Default: "json". |
| `out` | `string` | no | Optional JSON information output file. |
| `directory` | `string` | no | Project source directory. Default: ".". |

Returns `Contract.ExecutionResult`.

## `schema`

Print the Railpack configuration JSON schema.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |

Returns `Contract.ExecutionResult`.
