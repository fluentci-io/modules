# prisma component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `run`

Execute literal Prisma CLI arguments, including version-specific features.

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

Print the Prisma CLI and engine versions.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `init`

Initialize a Prisma project; configure the datasource explicitly for unattended jobs.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `datasource-provider` | `string` | no | Database provider for the generated schema. Allowed values: postgresql, sqlite, mysql, sqlserver, mongodb, cockroachdb. |
| `generator-provider` | `string` | no | Generator provider for the initial schema. |
| `output` | `string` | no | Output path for generated client code. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `generate`

Generate project clients from the Prisma schema without applying migrations.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `schema` | `string` | no | Prisma schema file or schema directory; otherwise use project configuration. |
| `generators` | `string` | no | Comma-separated generator names; omitted runs all configured generators. |
| `no-hints` | `boolean` | no | Suppress usage hints in CI logs. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `validate`

Validate the project Prisma schema.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `schema` | `string` | no | Prisma schema file or schema directory; otherwise use project configuration. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `format`

Format schemas or fail a formatting check without writing changes.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `schema` | `string` | no | Prisma schema file or schema directory; otherwise use project configuration. |
| `check` | `boolean` | no | Fail when schema files need formatting. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `db-pull`

Introspect the database; print avoids rewriting the project schema.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `schema` | `string` | no | Prisma schema file or schema directory; otherwise use project configuration. |
| `print` | `boolean` | no | Print the introspected schema instead of writing it. |
| `force` | `boolean` | no | Explicitly overwrite manual schema changes. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `db-push`

Synchronize schema without migrations; data loss and reset flags are explicit.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `schema` | `string` | no | Prisma schema file or schema directory; otherwise use project configuration. |
| `accept-data-loss` | `boolean` | no | Approve potentially destructive changes. |
| `force-reset` | `boolean` | no | Explicitly reset the database before pushing; destroys data. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `db-seed`

Run the project seed command configured in Prisma config.

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

## `db-execute`

Execute an existing SQL script using the configured datasource.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `file` | `string` | yes | Existing SQL script to execute. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `migrate-deploy`

Apply pending committed migrations noninteractively in deployment pipelines.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `schema` | `string` | no | Prisma schema file or schema directory; otherwise use project configuration. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `migrate-status`

Report migration status; propagate divergence and pending-migration failures.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `schema` | `string` | no | Prisma schema file or schema directory; otherwise use project configuration. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `migrate-dev`

Create and apply development migrations; use migrate-deploy for production.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `schema` | `string` | no | Prisma schema file or schema directory; otherwise use project configuration. |
| `name` | `string` | no | Name for a new migration. |
| `create-only` | `boolean` | no | Create a migration without applying it. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `migrate-reset`

Reset a disposable development database; destructive confirmation is explicit.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `schema` | `string` | no | Prisma schema file or schema directory; otherwise use project configuration. |
| `force` | `boolean` | no | Explicitly skip reset confirmation; destroys all database data. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `migrate-resolve`

Record a migration as applied or rolled back; choose exactly one in Prisma.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `schema` | `string` | no | Prisma schema file or schema directory; otherwise use project configuration. |
| `applied` | `string` | no | Migration directory name to mark as applied. |
| `rolled-back` | `string` | no | Migration directory name to mark as rolled back. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `migrate-diff`

Compare schema sources; native Prisma requires exactly one from and one to source.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `from-empty` | `boolean` | no | Compare from an empty schema. |
| `from-schema` | `string` | no | Existing source Prisma schema file. |
| `from-migrations` | `string` | no | Existing source migrations directory. |
| `from-config-datasource` | `boolean` | no | Use the configured database as the source. |
| `to-empty` | `boolean` | no | Compare to an empty schema. |
| `to-schema` | `string` | no | Existing target Prisma schema file. |
| `to-migrations` | `string` | no | Existing target migrations directory. |
| `to-config-datasource` | `boolean` | no | Use the configured database as the target. |
| `script` | `boolean` | no | Print SQL instead of a human-readable summary. |
| `exit-code` | `boolean` | no | Fail on nonempty differences (native exit code 2). |
| `output` | `string` | no | Write the diff to this output file. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `debug`

Print Prisma diagnostic information for troubleshooting.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `schema` | `string` | no | Prisma schema file or schema directory; otherwise use project configuration. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.

## `studio`

Run the long-lived Studio server within a scoped service lifecycle.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Path to an existing project configuration file; otherwise use native discovery. |
| `port` | `integer` | no | Studio listening port. |
| `browser` | `string` | no | Browser to launch; use none on a headless runner. |
| `arguments` | `string` | no | Additional literal CLI tokens as a comma-separated string. Quote a token containing a comma using CSV quotes. |

Returns `Contract.ExecutionResult`.
