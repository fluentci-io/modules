# nx component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `run`

Run arbitrary literal Nx CLI arguments.

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

Print the Nx CLI versions.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `run-target`

Execute one project target, such as app:build:production.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `target` | `string` | yes | Project:target[:configuration] selector. |
| `configuration` | `string` | no | Named workspace task configuration, for example production. |
| `parallel` | `integer` | no | Maximum concurrent task processes. |
| `exclude` | `string` | no | Comma-separated project names or patterns to exclude. |
| `output-style` | `string` | no | Native task log rendering; defaults to stable CI output. Default: "static". Allowed values: static, static-failures-only, stream, stream-without-prefixes, summary, dynamic-legacy, dynamic, tui. |
| `skip-cache` | `boolean` | no | Rerun tasks even when local or remote results are cached. |
| `skip-remote-cache` | `boolean` | no | Disable remote cache access. |
| `bail` | `boolean` | no | Stop after the first task failure. |
| `skip-sync` | `boolean` | no | Skip automatic sync generators before task execution. |
| `graph` | `string` | no | Write the task graph to a file or stdout instead of executing tasks. |
| `arguments` | `string` | no | Additional literal command tokens in CSV form; include -- as an entry to forward flags to underlying tasks. |

Returns `Contract.ExecutionResult`.

## `run-many`

Execute targets across selected projects; omitted projects selects all eligible projects.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `targets` | `string` | yes | Comma-separated targets such as build,test,lint. |
| `projects` | `string` | no | Comma-separated project names, tags or patterns; blank selects all eligible projects. |
| `configuration` | `string` | no | Named workspace task configuration, for example production. |
| `parallel` | `integer` | no | Maximum concurrent task processes. |
| `exclude` | `string` | no | Comma-separated project names or patterns to exclude. |
| `output-style` | `string` | no | Native task log rendering; defaults to stable CI output. Default: "static". Allowed values: static, static-failures-only, stream, stream-without-prefixes, summary, dynamic-legacy, dynamic, tui. |
| `skip-cache` | `boolean` | no | Rerun tasks even when local or remote results are cached. |
| `skip-remote-cache` | `boolean` | no | Disable remote cache access. |
| `bail` | `boolean` | no | Stop after the first task failure. |
| `skip-sync` | `boolean` | no | Skip automatic sync generators before task execution. |
| `graph` | `string` | no | Write the task graph to a file or stdout instead of executing tasks. |
| `arguments` | `string` | no | Additional literal command tokens in CSV form; include -- as an entry to forward flags to underlying tasks. |

Returns `Contract.ExecutionResult`.

## `affected`

Execute targets only for projects affected by the selected changes.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `targets` | `string` | yes | Comma-separated targets such as build,test,lint. |
| `base` | `string` | no | Git base ref or SHA for affected detection. |
| `head` | `string` | no | Git head ref or SHA for affected detection. |
| `files` | `string` | no | Comma-separated changed paths; deleted files do not need to exist. |
| `configuration` | `string` | no | Named workspace task configuration, for example production. |
| `parallel` | `integer` | no | Maximum concurrent task processes. |
| `exclude` | `string` | no | Comma-separated project names or patterns to exclude. |
| `output-style` | `string` | no | Native task log rendering; defaults to stable CI output. Default: "static". Allowed values: static, static-failures-only, stream, stream-without-prefixes, summary, dynamic-legacy, dynamic, tui. |
| `skip-cache` | `boolean` | no | Rerun tasks even when local or remote results are cached. |
| `skip-remote-cache` | `boolean` | no | Disable remote cache access. |
| `bail` | `boolean` | no | Stop after the first task failure. |
| `skip-sync` | `boolean` | no | Skip automatic sync generators before task execution. |
| `graph` | `string` | no | Write the task graph to a file or stdout instead of executing tasks. |
| `arguments` | `string` | no | Additional literal command tokens in CSV form; include -- as an entry to forward flags to underlying tasks. |

Returns `Contract.ExecutionResult`.

## `show-projects`

Print matching project names as JSON without running targets.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `affected` | `boolean` | no | List only affected projects. |
| `base` | `string` | no | Git base ref or SHA for affected detection. |
| `head` | `string` | no | Git head ref or SHA for affected detection. |
| `files` | `string` | no | Comma-separated changed paths; deleted files do not need to exist. |
| `projects` | `string` | no | Comma-separated project selectors. |
| `with-targets` | `string` | no | Comma-separated targets that matching projects must expose. |
| `exclude` | `string` | no | Comma-separated project exclusions. |
| `arguments` | `string` | no | Additional literal command tokens in CSV form; include -- as an entry to forward flags to underlying tasks. |

Returns `Contract.ExecutionResult`.

## `show-project`

Print the resolved configuration of a project.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `project-name` | `string` | yes | Workspace project name. |
| `arguments` | `string` | no | Additional literal command tokens in CSV form; include -- as an entry to forward flags to underlying tasks. |

Returns `Contract.ExecutionResult`.

## `graph`

Write a project graph without opening a browser.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `file` | `string` | yes | Output graph filename, such as graph.json; need not exist. |
| `focus` | `string` | no | Project to focus the graph on. |
| `affected` | `boolean` | no | Include affected projects only. |
| `base` | `string` | no | Git base ref or SHA for affected detection. |
| `head` | `string` | no | Git head ref or SHA for affected detection. |
| `files` | `string` | no | Comma-separated changed paths; deleted files do not need to exist. |
| `arguments` | `string` | no | Additional literal command tokens in CSV form; include -- as an entry to forward flags to underlying tasks. |

Returns `Contract.ExecutionResult`.

## `format-check`

Fail when selected workspace files are not formatted.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `base` | `string` | no | Git base ref or SHA for affected detection. |
| `head` | `string` | no | Git head ref or SHA for affected detection. |
| `files` | `string` | no | Comma-separated changed paths; deleted files do not need to exist. |
| `projects` | `string` | no | Comma-separated projects to check. |
| `all` | `boolean` | no | Check all projects; mutually exclusive with projects in Nx. |
| `arguments` | `string` | no | Additional literal command tokens in CSV form; include -- as an entry to forward flags to underlying tasks. |

Returns `Contract.ExecutionResult`.

## `sync-check`

Fail when workspace sync generators would change files.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | no | Additional literal command tokens in CSV form; include -- as an entry to forward flags to underlying tasks. |

Returns `Contract.ExecutionResult`.

## `report`

Print Nx workspace and plugin version diagnostics.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | no | Additional literal command tokens in CSV form; include -- as an entry to forward flags to underlying tasks. |

Returns `Contract.ExecutionResult`.
