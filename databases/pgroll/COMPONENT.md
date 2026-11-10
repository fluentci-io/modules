# pgroll component functions

Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `run`

Execute any pgroll feature with literal CSV arguments.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | yes | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `version`

Print the installed pgroll version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `init`

Initialize pgroll state in the target database; no migration file is required.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `postgres-url` | `string` | no | PostgreSQL connection URL; prefer inherited PGROLL_PG_URL for credentials because explicit arguments appear in execution plans. |
| `schema` | `string` | no | PostgreSQL schema to migrate; native default public. |
| `state-schema` | `string` | no | Schema containing pgroll internal state; native default pgroll. |
| `lock-timeout` | `integer` | no | PostgreSQL DDL lock timeout in milliseconds; native default 500. |
| `role` | `string` | no | Optional PostgreSQL role used while executing migrations. |
| `use-version-schema` | `boolean` | no | Create version schemas for migrations; native default true. Explicit false is passed through. |
| `verbose` | `boolean` | no | Enable native verbose logging. |
| `arguments` | `string` | no | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `validate`

Validate a migration file against the target database before application.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `postgres-url` | `string` | no | PostgreSQL connection URL; prefer inherited PGROLL_PG_URL for credentials because explicit arguments appear in execution plans. |
| `schema` | `string` | no | PostgreSQL schema to migrate; native default public. |
| `state-schema` | `string` | no | Schema containing pgroll internal state; native default pgroll. |
| `lock-timeout` | `integer` | no | PostgreSQL DDL lock timeout in milliseconds; native default 500. |
| `role` | `string` | no | Optional PostgreSQL role used while executing migrations. |
| `use-version-schema` | `boolean` | no | Create version schemas for migrations; native default true. Explicit false is passed through. |
| `verbose` | `boolean` | no | Enable native verbose logging. |
| `file` | `string` | yes | Existing YAML or JSON migration file to validate against the target database. |
| `arguments` | `string` | no | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `start`

Start a migration, backfill data, and optionally complete it.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `postgres-url` | `string` | no | PostgreSQL connection URL; prefer inherited PGROLL_PG_URL for credentials because explicit arguments appear in execution plans. |
| `schema` | `string` | no | PostgreSQL schema to migrate; native default public. |
| `state-schema` | `string` | no | Schema containing pgroll internal state; native default pgroll. |
| `lock-timeout` | `integer` | no | PostgreSQL DDL lock timeout in milliseconds; native default 500. |
| `role` | `string` | no | Optional PostgreSQL role used while executing migrations. |
| `use-version-schema` | `boolean` | no | Create version schemas for migrations; native default true. Explicit false is passed through. |
| `verbose` | `boolean` | no | Enable native verbose logging. |
| `file` | `string` | yes | Existing YAML or JSON migration file to start. |
| `backfill-batch-delay` | `string` | no | Delay between backfill batches as a Go duration, for example 1s or 1000ms. |
| `backfill-batch-size` | `integer` | no | Positive number of rows per backfill batch; native default 1000. |
| `complete` | `boolean` | no | Complete the migration immediately after applying it; native default false. |
| `skip-validation` | `boolean` | no | Explicitly bypass native migration validation; native default false. |
| `arguments` | `string` | no | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `complete`

Complete the currently active migration in the database; no migration file is required.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `postgres-url` | `string` | no | PostgreSQL connection URL; prefer inherited PGROLL_PG_URL for credentials because explicit arguments appear in execution plans. |
| `schema` | `string` | no | PostgreSQL schema to migrate; native default public. |
| `state-schema` | `string` | no | Schema containing pgroll internal state; native default pgroll. |
| `lock-timeout` | `integer` | no | PostgreSQL DDL lock timeout in milliseconds; native default 500. |
| `role` | `string` | no | Optional PostgreSQL role used while executing migrations. |
| `use-version-schema` | `boolean` | no | Create version schemas for migrations; native default true. Explicit false is passed through. |
| `verbose` | `boolean` | no | Enable native verbose logging. |
| `arguments` | `string` | no | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `rollback`

Roll back the currently active migration; completed migrations retain native rollback limitations.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `postgres-url` | `string` | no | PostgreSQL connection URL; prefer inherited PGROLL_PG_URL for credentials because explicit arguments appear in execution plans. |
| `schema` | `string` | no | PostgreSQL schema to migrate; native default public. |
| `state-schema` | `string` | no | Schema containing pgroll internal state; native default pgroll. |
| `lock-timeout` | `integer` | no | PostgreSQL DDL lock timeout in milliseconds; native default 500. |
| `role` | `string` | no | Optional PostgreSQL role used while executing migrations. |
| `use-version-schema` | `boolean` | no | Create version schemas for migrations; native default true. Explicit false is passed through. |
| `verbose` | `boolean` | no | Enable native verbose logging. |
| `arguments` | `string` | no | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `migrate`

Apply outstanding migrations from a directory and propagate native failures.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `postgres-url` | `string` | no | PostgreSQL connection URL; prefer inherited PGROLL_PG_URL for credentials because explicit arguments appear in execution plans. |
| `schema` | `string` | no | PostgreSQL schema to migrate; native default public. |
| `state-schema` | `string` | no | Schema containing pgroll internal state; native default pgroll. |
| `lock-timeout` | `integer` | no | PostgreSQL DDL lock timeout in milliseconds; native default 500. |
| `role` | `string` | no | Optional PostgreSQL role used while executing migrations. |
| `use-version-schema` | `boolean` | no | Create version schemas for migrations; native default true. Explicit false is passed through. |
| `verbose` | `boolean` | no | Enable native verbose logging. |
| `directory` | `string` | yes | Existing directory containing ordered migration files. |
| `backfill-batch-delay` | `string` | no | Delay between backfill batches as a Go duration, for example 1s or 1000ms. |
| `backfill-batch-size` | `integer` | no | Positive number of rows per backfill batch; native default 1000. |
| `complete` | `boolean` | no | Complete the final migration instead of leaving it active. |
| `expect-one` | `boolean` | no | Abort when more than one outstanding migration would be applied. |
| `arguments` | `string` | no | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `status`

Report active migration and schema state in the target database.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `postgres-url` | `string` | no | PostgreSQL connection URL; prefer inherited PGROLL_PG_URL for credentials because explicit arguments appear in execution plans. |
| `schema` | `string` | no | PostgreSQL schema to migrate; native default public. |
| `state-schema` | `string` | no | Schema containing pgroll internal state; native default pgroll. |
| `lock-timeout` | `integer` | no | PostgreSQL DDL lock timeout in milliseconds; native default 500. |
| `role` | `string` | no | Optional PostgreSQL role used while executing migrations. |
| `use-version-schema` | `boolean` | no | Create version schemas for migrations; native default true. Explicit false is passed through. |
| `verbose` | `boolean` | no | Enable native verbose logging. |
| `arguments` | `string` | no | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `analyze`

Analyze the target database SQL schema using the native hidden diagnostic command.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `postgres-url` | `string` | no | PostgreSQL connection URL; prefer inherited PGROLL_PG_URL for credentials because explicit arguments appear in execution plans. |
| `schema` | `string` | no | PostgreSQL schema to migrate; native default public. |
| `state-schema` | `string` | no | Schema containing pgroll internal state; native default pgroll. |
| `lock-timeout` | `integer` | no | PostgreSQL DDL lock timeout in milliseconds; native default 500. |
| `role` | `string` | no | Optional PostgreSQL role used while executing migrations. |
| `use-version-schema` | `boolean` | no | Create version schemas for migrations; native default true. Explicit false is passed through. |
| `verbose` | `boolean` | no | Enable native verbose logging. |
| `arguments` | `string` | no | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `baseline`

Reset migration history to a baseline and write its placeholder file without a confirmation prompt.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `postgres-url` | `string` | no | PostgreSQL connection URL; prefer inherited PGROLL_PG_URL for credentials because explicit arguments appear in execution plans. |
| `schema` | `string` | no | PostgreSQL schema to migrate; native default public. |
| `state-schema` | `string` | no | Schema containing pgroll internal state; native default pgroll. |
| `lock-timeout` | `integer` | no | PostgreSQL DDL lock timeout in milliseconds; native default 500. |
| `role` | `string` | no | Optional PostgreSQL role used while executing migrations. |
| `use-version-schema` | `boolean` | no | Create version schemas for migrations; native default true. Explicit false is passed through. |
| `verbose` | `boolean` | no | Enable native verbose logging. |
| `baseline-version` | `string` | yes | Name of the baseline migration; this resets migration history. |
| `directory` | `string` | yes | Directory for the generated baseline file; created by pgroll if absent. |
| `json` | `boolean` | no | Write migration files in JSON instead of YAML. |
| `arguments` | `string` | no | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `pull`

Pull missing migration history from the database into local files.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `postgres-url` | `string` | no | PostgreSQL connection URL; prefer inherited PGROLL_PG_URL for credentials because explicit arguments appear in execution plans. |
| `schema` | `string` | no | PostgreSQL schema to migrate; native default public. |
| `state-schema` | `string` | no | Schema containing pgroll internal state; native default pgroll. |
| `lock-timeout` | `integer` | no | PostgreSQL DDL lock timeout in milliseconds; native default 500. |
| `role` | `string` | no | Optional PostgreSQL role used while executing migrations. |
| `use-version-schema` | `boolean` | no | Create version schemas for migrations; native default true. Explicit false is passed through. |
| `verbose` | `boolean` | no | Enable native verbose logging. |
| `directory` | `string` | yes | Destination directory for migration history; created by pgroll if absent. |
| `json` | `boolean` | no | Write migration files in JSON instead of YAML. |
| `arguments` | `string` | no | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `convert`

Convert SQL statements from a file to a pgroll migration using native conversion rules.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `postgres-url` | `string` | no | PostgreSQL connection URL; prefer inherited PGROLL_PG_URL for credentials because explicit arguments appear in execution plans. |
| `schema` | `string` | no | PostgreSQL schema to migrate; native default public. |
| `state-schema` | `string` | no | Schema containing pgroll internal state; native default pgroll. |
| `lock-timeout` | `integer` | no | PostgreSQL DDL lock timeout in milliseconds; native default 500. |
| `role` | `string` | no | Optional PostgreSQL role used while executing migrations. |
| `use-version-schema` | `boolean` | no | Create version schemas for migrations; native default true. Explicit false is passed through. |
| `verbose` | `boolean` | no | Enable native verbose logging. |
| `file` | `string` | yes | Existing SQL input file to convert to a pgroll migration. |
| `json` | `boolean` | no | Write migration files in JSON instead of YAML. |
| `arguments` | `string` | no | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `update`

Rewrite outdated migration files in place; review changes before committing them.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `postgres-url` | `string` | no | PostgreSQL connection URL; prefer inherited PGROLL_PG_URL for credentials because explicit arguments appear in execution plans. |
| `schema` | `string` | no | PostgreSQL schema to migrate; native default public. |
| `state-schema` | `string` | no | Schema containing pgroll internal state; native default pgroll. |
| `lock-timeout` | `integer` | no | PostgreSQL DDL lock timeout in milliseconds; native default 500. |
| `role` | `string` | no | Optional PostgreSQL role used while executing migrations. |
| `use-version-schema` | `boolean` | no | Create version schemas for migrations; native default true. Explicit false is passed through. |
| `verbose` | `boolean` | no | Enable native verbose logging. |
| `directory` | `string` | yes | Existing directory of migration files to rewrite to the current format. |
| `json` | `boolean` | no | Write migration files in JSON instead of YAML. |
| `arguments` | `string` | no | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `create`

Create an empty named migration file noninteractively in the working directory.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `postgres-url` | `string` | no | PostgreSQL connection URL; prefer inherited PGROLL_PG_URL for credentials because explicit arguments appear in execution plans. |
| `schema` | `string` | no | PostgreSQL schema to migrate; native default public. |
| `state-schema` | `string` | no | Schema containing pgroll internal state; native default pgroll. |
| `lock-timeout` | `integer` | no | PostgreSQL DDL lock timeout in milliseconds; native default 500. |
| `role` | `string` | no | Optional PostgreSQL role used while executing migrations. |
| `use-version-schema` | `boolean` | no | Create version schemas for migrations; native default true. Explicit false is passed through. |
| `verbose` | `boolean` | no | Enable native verbose logging. |
| `name` | `string` | yes | Migration filename stem, including a relative path if desired; pgroll adds .yaml or .json. |
| `json` | `boolean` | no | Write migration files in JSON instead of YAML. |
| `arguments` | `string` | no | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `latest`

Access native latest subcommands through the CSV arguments string.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `postgres-url` | `string` | no | PostgreSQL connection URL; prefer inherited PGROLL_PG_URL for credentials because explicit arguments appear in execution plans. |
| `schema` | `string` | no | PostgreSQL schema to migrate; native default public. |
| `state-schema` | `string` | no | Schema containing pgroll internal state; native default pgroll. |
| `lock-timeout` | `integer` | no | PostgreSQL DDL lock timeout in milliseconds; native default 500. |
| `role` | `string` | no | Optional PostgreSQL role used while executing migrations. |
| `use-version-schema` | `boolean` | no | Create version schemas for migrations; native default true. Explicit false is passed through. |
| `verbose` | `boolean` | no | Enable native verbose logging. |
| `arguments` | `string` | no | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `latest-migration`

Print the latest migration from the target database or local migration directory.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `postgres-url` | `string` | no | PostgreSQL connection URL; prefer inherited PGROLL_PG_URL for credentials because explicit arguments appear in execution plans. |
| `schema` | `string` | no | PostgreSQL schema to migrate; native default public. |
| `state-schema` | `string` | no | Schema containing pgroll internal state; native default pgroll. |
| `lock-timeout` | `integer` | no | PostgreSQL DDL lock timeout in milliseconds; native default 500. |
| `role` | `string` | no | Optional PostgreSQL role used while executing migrations. |
| `use-version-schema` | `boolean` | no | Create version schemas for migrations; native default true. Explicit false is passed through. |
| `verbose` | `boolean` | no | Enable native verbose logging. |
| `local` | `string` | no | Existing local migration directory; omit to discover the latest version from the target database. |
| `arguments` | `string` | no | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `latest-schema`

Print the latest schema from the target database or local migration directory.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `postgres-url` | `string` | no | PostgreSQL connection URL; prefer inherited PGROLL_PG_URL for credentials because explicit arguments appear in execution plans. |
| `schema` | `string` | no | PostgreSQL schema to migrate; native default public. |
| `state-schema` | `string` | no | Schema containing pgroll internal state; native default pgroll. |
| `lock-timeout` | `integer` | no | PostgreSQL DDL lock timeout in milliseconds; native default 500. |
| `role` | `string` | no | Optional PostgreSQL role used while executing migrations. |
| `use-version-schema` | `boolean` | no | Create version schemas for migrations; native default true. Explicit false is passed through. |
| `verbose` | `boolean` | no | Enable native verbose logging. |
| `local` | `string` | no | Existing local migration directory; omit to discover the latest version from the target database. |
| `arguments` | `string` | no | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `latest-url`

Print the latest connection URL with version schema search_path from the target database or local migration directory.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `postgres-url` | `string` | no | PostgreSQL connection URL; prefer inherited PGROLL_PG_URL for credentials because explicit arguments appear in execution plans. |
| `schema` | `string` | no | PostgreSQL schema to migrate; native default public. |
| `state-schema` | `string` | no | Schema containing pgroll internal state; native default pgroll. |
| `lock-timeout` | `integer` | no | PostgreSQL DDL lock timeout in milliseconds; native default 500. |
| `role` | `string` | no | Optional PostgreSQL role used while executing migrations. |
| `use-version-schema` | `boolean` | no | Create version schemas for migrations; native default true. Explicit false is passed through. |
| `verbose` | `boolean` | no | Enable native verbose logging. |
| `local` | `string` | no | Existing local migration directory; omit to discover the latest version from the target database. |
| `connection-string` | `string` | no | Optional connection URL to rewrite; omit to use PGROLL_PG_URL or postgresUrl. Output may contain credentials. |
| `arguments` | `string` | no | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.

## `completion`

Generate shell completion scripts through literal native CSV arguments.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | no | Additional literal CLI tokens as comma-separated text; double-quote CSV entries containing commas and double embedded quotes. No shell expansion occurs. |

Returns `Contract.ExecutionResult`.
