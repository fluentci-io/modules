# Prisma module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` is a comma-separated NAME=PATH string in the public component contract.

## `run`

Execute literal Prisma CLI arguments, including version-specific features.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Required |

## `version`

Print the Prisma CLI and engine versions.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `init`

Initialize a Prisma project; configure the datasource explicitly for unattended jobs.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `datasourceProvider` | `string (postgresql, sqlite, mysql, sqlserver, mongodb, cockroachdb)` | `--datasource-provider=<value>` | Omitted |
| `generatorProvider` | `string` | `--generator-provider=<value>` | Omitted |
| `output` | `string` | `--output=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `generate`

Generate project clients from the Prisma schema without applying migrations.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `schema` | `string` | `--schema <value>` | Omitted |
| `generators` | `string (CSV)` | `--generator=<value>` | Omitted |
| `noHints` | `boolean` | `--no-hints` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `validate`

Validate the project Prisma schema.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `schema` | `string` | `--schema <value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `format`

Format schemas or fail a formatting check without writing changes.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `schema` | `string` | `--schema <value>` | Omitted |
| `check` | `boolean` | `--check` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `db_pull`

Introspect the database; print avoids rewriting the project schema.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `schema` | `string` | `--schema <value>` | Omitted |
| `print` | `boolean` | `--print` | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `db_push`

Synchronize schema without migrations; data loss and reset flags are explicit.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `schema` | `string` | `--schema <value>` | Omitted |
| `acceptDataLoss` | `boolean` | `--accept-data-loss` | Omitted |
| `forceReset` | `boolean` | `--force-reset` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `db_seed`

Run the project seed command configured in Prisma config.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `db_execute`

Execute an existing SQL script using the configured datasource.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `file` | `string` | `--file <value>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `migrate_deploy`

Apply pending committed migrations noninteractively in deployment pipelines.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `schema` | `string` | `--schema <value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `migrate_status`

Report migration status; propagate divergence and pending-migration failures.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `schema` | `string` | `--schema <value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `migrate_dev`

Create and apply development migrations; use migrate-deploy for production.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `schema` | `string` | `--schema <value>` | Omitted |
| `name` | `string` | `--name=<value>` | Omitted |
| `createOnly` | `boolean` | `--create-only` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `migrate_reset`

Reset a disposable development database; destructive confirmation is explicit.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `schema` | `string` | `--schema <value>` | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `migrate_resolve`

Record a migration as applied or rolled back; choose exactly one in Prisma.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `schema` | `string` | `--schema <value>` | Omitted |
| `applied` | `string` | `--applied=<value>` | Omitted |
| `rolledBack` | `string` | `--rolled-back=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `migrate_diff`

Compare schema sources; native Prisma requires exactly one from and one to source.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `fromEmpty` | `boolean` | `--from-empty` | Omitted |
| `fromSchema` | `string` | `--from-schema <value>` | Omitted |
| `fromMigrations` | `string` | `--from-migrations <value>` | Omitted |
| `fromConfigDatasource` | `boolean` | `--from-config-datasource` | Omitted |
| `toEmpty` | `boolean` | `--to-empty` | Omitted |
| `toSchema` | `string` | `--to-schema <value>` | Omitted |
| `toMigrations` | `string` | `--to-migrations <value>` | Omitted |
| `toConfigDatasource` | `boolean` | `--to-config-datasource` | Omitted |
| `script` | `boolean` | `--script` | Omitted |
| `exitCode` | `boolean` | `--exit-code` | Omitted |
| `output` | `string` | `--output=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `debug`

Print Prisma diagnostic information for troubleshooting.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `schema` | `string` | `--schema <value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `studio`

Run the long-lived Studio server within a scoped service lifecycle.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `port` | `integer` | `--port=<value>` | Omitted |
| `browser` | `string` | `--browser=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |
