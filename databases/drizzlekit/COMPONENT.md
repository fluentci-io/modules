# drizzlekit component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `run`

Execute literal Drizzle Kit arguments for additional upstream features.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | yes | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `version`

Print the Drizzle Kit version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `generate`

Generate SQL migrations; custom creates an empty migration for handwritten SQL.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `name` | `string` | no | Name for the generated migration. |
| `custom` | `boolean` | no | Generate an empty custom SQL migration. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `migrate`

Apply committed SQL migrations using the project database configuration.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `push`

Apply schema changes directly; destructive approval is opt-in through force.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `force` | `boolean` | no | Explicitly approve data loss statements; may truncate tables. |
| `strict` | `boolean` | no | Require confirmation for every schema change; avoid unattended pipelines. |
| `verbose` | `boolean` | no | Print SQL statements before applying changes. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `pull`

Introspect the configured database into Drizzle schema files.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `check`

Check generated migrations for collisions before merging.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `up`

Upgrade existing migration snapshots to the installed Kit format.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `export-sql`

Print SQL DDL from the configured TypeScript schema.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `studio`

Start the long-running Studio server; use a bounded timeout and scoped service lifecycle.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `host` | `string` | no | Listening address; bind locally on shared runners. |
| `port` | `integer` | no | Studio listening port. |
| `verbose` | `boolean` | no | Print Studio SQL statements. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.
