# uv component functions

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

## `sync`

Create or synchronize a project environment from pyproject.toml and uv.lock.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `locked` | `boolean` | no | Locked supplied to the uv sync operation. |
| `frozen` | `boolean` | no | Frozen supplied to the uv sync operation. |
| `no-dev` | `boolean` | no | No Dev supplied to the uv sync operation. |
| `group` | `string` | no | Group supplied to the uv sync operation. |
| `python` | `string` | no | Python supplied to the uv sync operation. |

Returns `Contract.ExecutionResult`.

## `lock`

Resolve project dependencies or check the existing lockfile.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `check` | `boolean` | no | Check supplied to the uv lock operation. |
| `upgrade` | `boolean` | no | Upgrade supplied to the uv lock operation. |
| `python` | `string` | no | Python supplied to the uv lock operation. |

Returns `Contract.ExecutionResult`.

## `run-command`

Run a command in the project environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `locked` | `boolean` | no | Locked supplied to the uv run_command operation. |
| `frozen` | `boolean` | no | Frozen supplied to the uv run_command operation. |
| `no-sync` | `boolean` | no | No Sync supplied to the uv run_command operation. |
| `python` | `string` | no | Python supplied to the uv run_command operation. |
| `command` | `array` | yes | Command supplied to the uv run_command operation. |

Returns `Contract.ExecutionResult`.

## `build`

Build Python source and wheel distributions.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `out-dir` | `string` | no | Out Dir supplied to the uv build operation. |
| `wheel` | `boolean` | no | Wheel supplied to the uv build operation. |
| `sdist` | `boolean` | no | Sdist supplied to the uv build operation. |
| `python` | `string` | no | Python supplied to the uv build operation. |

Returns `Contract.ExecutionResult`.

## `publish`

Publish distributions to a configured Python package index.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `publish-url` | `string` | no | Publish Url supplied to the uv publish operation. |
| `index` | `string` | no | Index supplied to the uv publish operation. |
| `files` | `array` | no | Files selected for the native operation; paths are passed literally without shell expansion. Default: []. |

Returns `Contract.ExecutionResult`.

## `venv`

Create a Python virtual environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `python` | `string` | no | Python supplied to the uv venv operation. |
| `path` | `string` | no | Path supplied to the uv venv operation. Default: ".venv". |

Returns `Contract.ExecutionResult`.

## `add`

Add project dependencies and update the lockfile.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `dev` | `boolean` | no | Dev supplied to the uv add operation. |
| `group` | `string` | no | Group supplied to the uv add operation. |
| `packages` | `array` | yes | Packages supplied to the uv add operation. |

Returns `Contract.ExecutionResult`.

## `pip-install`

Install packages into a selected virtual environment or interpreter.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `python` | `string` | no | Python supplied to the uv pip_install operation. |
| `system` | `boolean` | no | System supplied to the uv pip_install operation. |
| `packages` | `array` | yes | Packages supplied to the uv pip_install operation. |

Returns `Contract.ExecutionResult`.
