# turborepo component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `run`

Run arbitrary literal Turbo CLI arguments.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | yes | Additional literal command tokens in CSV form; include -- as an entry to forward flags to underlying tasks. |

Returns `Contract.ExecutionResult`.

## `version`

Print the Turbo CLI version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `run-tasks`

Run selected workspace tasks with native dependency ordering and caching.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `tasks` | `string` | yes | Comma-separated turbo.json task names, such as build,test,lint. |
| `affected` | `boolean` | no | Select packages changed since the configured Git base/head. |
| `filters` | `string` | no | Comma-separated native package selectors; repeated flags preserve dependency and Git-range syntax. |
| `concurrency` | `string` | no | Maximum concurrent tasks as an integer or percentage, such as 4 or 50%. |
| `cache` | `string` | no | Comma-separated cache source policies, such as local:rw,remote:r. |
| `cache-dir` | `string` | no | Directory for local task cache entries. |
| `env-mode` | `string` | no | Environment filtering mode; strict retains native protection. Allowed values: strict, loose. |
| `continue-mode` | `string` | no | Which tasks may continue after a failure; failures still fail the module. Allowed values: never, dependencies-successful, always. |
| `force` | `boolean` | no | Ignore cached results and rerun tasks. |
| `summarize` | `boolean` | no | Write a native run summary under .turbo/runs. |
| `output-logs` | `string` | no | Task log selection. Allowed values: full, hash-only, new-only, errors-only, none. |
| `ui` | `string` | no | Log interface; defaults to a noninteractive stream. Default: "stream". Allowed values: stream, tui. |
| `arguments` | `string` | no | Additional literal command tokens in CSV form; include -- as an entry to forward flags to underlying tasks. |

Returns `Contract.ExecutionResult`.

## `affected`

Run tasks only in affected packages; requires the Git comparison history.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `tasks` | `string` | yes | Comma-separated turbo.json task names, such as build,test,lint. |
| `filters` | `string` | no | Comma-separated native package selectors; repeated flags preserve dependency and Git-range syntax. |
| `concurrency` | `string` | no | Maximum concurrent tasks as an integer or percentage, such as 4 or 50%. |
| `cache` | `string` | no | Comma-separated cache source policies, such as local:rw,remote:r. |
| `cache-dir` | `string` | no | Directory for local task cache entries. |
| `env-mode` | `string` | no | Environment filtering mode; strict retains native protection. Allowed values: strict, loose. |
| `continue-mode` | `string` | no | Which tasks may continue after a failure; failures still fail the module. Allowed values: never, dependencies-successful, always. |
| `force` | `boolean` | no | Ignore cached results and rerun tasks. |
| `summarize` | `boolean` | no | Write a native run summary under .turbo/runs. |
| `output-logs` | `string` | no | Task log selection. Allowed values: full, hash-only, new-only, errors-only, none. |
| `ui` | `string` | no | Log interface; defaults to a noninteractive stream. Default: "stream". Allowed values: stream, tui. |
| `arguments` | `string` | no | Additional literal command tokens in CSV form; include -- as an entry to forward flags to underlying tasks. |

Returns `Contract.ExecutionResult`.

## `dry-run`

Print a JSON task plan without executing workspace tasks.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `tasks` | `string` | yes | Comma-separated turbo.json task names, such as build,test,lint. |
| `affected` | `boolean` | no | Limit the plan to affected packages. |
| `filters` | `string` | no | Comma-separated native package selectors; repeated flags preserve dependency and Git-range syntax. |
| `concurrency` | `string` | no | Maximum concurrent tasks as an integer or percentage, such as 4 or 50%. |
| `cache` | `string` | no | Comma-separated cache source policies, such as local:rw,remote:r. |
| `cache-dir` | `string` | no | Directory for local task cache entries. |
| `env-mode` | `string` | no | Environment filtering mode; strict retains native protection. Allowed values: strict, loose. |
| `continue-mode` | `string` | no | Which tasks may continue after a failure; failures still fail the module. Allowed values: never, dependencies-successful, always. |
| `force` | `boolean` | no | Ignore cached results and rerun tasks. |
| `summarize` | `boolean` | no | Write a native run summary under .turbo/runs. |
| `output-logs` | `string` | no | Task log selection. Allowed values: full, hash-only, new-only, errors-only, none. |
| `ui` | `string` | no | Log interface; defaults to a noninteractive stream. Default: "stream". Allowed values: stream, tui. |
| `arguments` | `string` | no | Additional literal command tokens in CSV form; include -- as an entry to forward flags to underlying tasks. |

Returns `Contract.ExecutionResult`.

## `prune`

Generate a partial workspace and pruned lockfile for a package.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `package` | `string` | yes | Workspace package to retain. |
| `docker` | `boolean` | no | Separate manifests and source for Docker layer caching. |
| `out-dir` | `string` | no | Destination for the pruned workspace; need not exist. |
| `use-gitignore` | `boolean` | no | Respect gitignore rules when copying files. |
| `arguments` | `string` | no | Additional literal command tokens in CSV form; include -- as an entry to forward flags to underlying tasks. |

Returns `Contract.ExecutionResult`.

## `list-packages`

Inspect packages, dependencies and tasks without executing tasks.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `packages` | `string` | no | Comma-separated package names; omit or leave blank for all packages. |
| `filters` | `string` | no | Comma-separated native package selectors. |
| `affected` | `boolean` | no | List affected packages only. |
| `output` | `string` | no | Output format. Default: "json". Allowed values: json, pretty. |
| `arguments` | `string` | no | Additional literal command tokens in CSV form; include -- as an entry to forward flags to underlying tasks. |

Returns `Contract.ExecutionResult`.

## `info`

Print Turbo environment diagnostics.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | no | Additional literal command tokens in CSV form; include -- as an entry to forward flags to underlying tasks. |

Returns `Contract.ExecutionResult`.
