# pgroll module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` is a comma-separated NAME=PATH string in the public component contract.

## `run`

Execute any pgroll feature with literal CSV arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Required |

## `version`

Print the installed pgroll version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `init`

Initialize pgroll state in the target database; no migration file is required.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `postgresUrl` | `string` | `--postgres-url=<value>` | Omitted |
| `schema` | `string` | `--schema=<value>` | Omitted |
| `stateSchema` | `string` | `--pgroll-schema=<value>` | Omitted |
| `lockTimeout` | `integer` | `--lock-timeout=<value>` | Omitted |
| `role` | `string` | `--role=<value>` | Omitted |
| `useVersionSchema` | `boolean` | `--use-version-schema=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `validate`

Validate a migration file against the target database before application.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `postgresUrl` | `string` | `--postgres-url=<value>` | Omitted |
| `schema` | `string` | `--schema=<value>` | Omitted |
| `stateSchema` | `string` | `--pgroll-schema=<value>` | Omitted |
| `lockTimeout` | `integer` | `--lock-timeout=<value>` | Omitted |
| `role` | `string` | `--role=<value>` | Omitted |
| `useVersionSchema` | `boolean` | `--use-version-schema=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose=<value>` | Omitted |
| `file` | `string` | `<file>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `start`

Start a migration, backfill data, and optionally complete it.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `postgresUrl` | `string` | `--postgres-url=<value>` | Omitted |
| `schema` | `string` | `--schema=<value>` | Omitted |
| `stateSchema` | `string` | `--pgroll-schema=<value>` | Omitted |
| `lockTimeout` | `integer` | `--lock-timeout=<value>` | Omitted |
| `role` | `string` | `--role=<value>` | Omitted |
| `useVersionSchema` | `boolean` | `--use-version-schema=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose=<value>` | Omitted |
| `file` | `string` | `<file>` | Required |
| `backfillBatchDelay` | `string` | `--backfill-batch-delay=<value>` | Omitted |
| `backfillBatchSize` | `integer` | `--backfill-batch-size=<value>` | Omitted |
| `complete` | `boolean` | `--complete=<value>` | Omitted |
| `skipValidation` | `boolean` | `--skip-validation=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `complete`

Complete the currently active migration in the database; no migration file is required.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `postgresUrl` | `string` | `--postgres-url=<value>` | Omitted |
| `schema` | `string` | `--schema=<value>` | Omitted |
| `stateSchema` | `string` | `--pgroll-schema=<value>` | Omitted |
| `lockTimeout` | `integer` | `--lock-timeout=<value>` | Omitted |
| `role` | `string` | `--role=<value>` | Omitted |
| `useVersionSchema` | `boolean` | `--use-version-schema=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `rollback`

Roll back the currently active migration; completed migrations retain native rollback limitations.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `postgresUrl` | `string` | `--postgres-url=<value>` | Omitted |
| `schema` | `string` | `--schema=<value>` | Omitted |
| `stateSchema` | `string` | `--pgroll-schema=<value>` | Omitted |
| `lockTimeout` | `integer` | `--lock-timeout=<value>` | Omitted |
| `role` | `string` | `--role=<value>` | Omitted |
| `useVersionSchema` | `boolean` | `--use-version-schema=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `migrate`

Apply outstanding migrations from a directory and propagate native failures.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `postgresUrl` | `string` | `--postgres-url=<value>` | Omitted |
| `schema` | `string` | `--schema=<value>` | Omitted |
| `stateSchema` | `string` | `--pgroll-schema=<value>` | Omitted |
| `lockTimeout` | `integer` | `--lock-timeout=<value>` | Omitted |
| `role` | `string` | `--role=<value>` | Omitted |
| `useVersionSchema` | `boolean` | `--use-version-schema=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose=<value>` | Omitted |
| `directory` | `string` | `<directory>` | Required |
| `backfillBatchDelay` | `string` | `--backfill-batch-delay=<value>` | Omitted |
| `backfillBatchSize` | `integer` | `--backfill-batch-size=<value>` | Omitted |
| `complete` | `boolean` | `--complete=<value>` | Omitted |
| `expectOne` | `boolean` | `--expect-one=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `status`

Report active migration and schema state in the target database.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `postgresUrl` | `string` | `--postgres-url=<value>` | Omitted |
| `schema` | `string` | `--schema=<value>` | Omitted |
| `stateSchema` | `string` | `--pgroll-schema=<value>` | Omitted |
| `lockTimeout` | `integer` | `--lock-timeout=<value>` | Omitted |
| `role` | `string` | `--role=<value>` | Omitted |
| `useVersionSchema` | `boolean` | `--use-version-schema=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `analyze`

Analyze the target database SQL schema using the native hidden diagnostic command.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `postgresUrl` | `string` | `--postgres-url=<value>` | Omitted |
| `schema` | `string` | `--schema=<value>` | Omitted |
| `stateSchema` | `string` | `--pgroll-schema=<value>` | Omitted |
| `lockTimeout` | `integer` | `--lock-timeout=<value>` | Omitted |
| `role` | `string` | `--role=<value>` | Omitted |
| `useVersionSchema` | `boolean` | `--use-version-schema=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `baseline`

Reset migration history to a baseline and write its placeholder file without a confirmation prompt.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `postgresUrl` | `string` | `--postgres-url=<value>` | Omitted |
| `schema` | `string` | `--schema=<value>` | Omitted |
| `stateSchema` | `string` | `--pgroll-schema=<value>` | Omitted |
| `lockTimeout` | `integer` | `--lock-timeout=<value>` | Omitted |
| `role` | `string` | `--role=<value>` | Omitted |
| `useVersionSchema` | `boolean` | `--use-version-schema=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose=<value>` | Omitted |
| `baselineVersion` | `string` | `<baselineVersion>` | Required |
| `directory` | `string` | `<directory>` | Required |
| `json` | `boolean` | `--json=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pull`

Pull missing migration history from the database into local files.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `postgresUrl` | `string` | `--postgres-url=<value>` | Omitted |
| `schema` | `string` | `--schema=<value>` | Omitted |
| `stateSchema` | `string` | `--pgroll-schema=<value>` | Omitted |
| `lockTimeout` | `integer` | `--lock-timeout=<value>` | Omitted |
| `role` | `string` | `--role=<value>` | Omitted |
| `useVersionSchema` | `boolean` | `--use-version-schema=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose=<value>` | Omitted |
| `directory` | `string` | `<directory>` | Required |
| `json` | `boolean` | `--json=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `convert`

Convert SQL statements from a file to a pgroll migration using native conversion rules.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `postgresUrl` | `string` | `--postgres-url=<value>` | Omitted |
| `schema` | `string` | `--schema=<value>` | Omitted |
| `stateSchema` | `string` | `--pgroll-schema=<value>` | Omitted |
| `lockTimeout` | `integer` | `--lock-timeout=<value>` | Omitted |
| `role` | `string` | `--role=<value>` | Omitted |
| `useVersionSchema` | `boolean` | `--use-version-schema=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose=<value>` | Omitted |
| `file` | `string` | `<file>` | Required |
| `json` | `boolean` | `--json=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `update`

Rewrite outdated migration files in place; review changes before committing them.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `postgresUrl` | `string` | `--postgres-url=<value>` | Omitted |
| `schema` | `string` | `--schema=<value>` | Omitted |
| `stateSchema` | `string` | `--pgroll-schema=<value>` | Omitted |
| `lockTimeout` | `integer` | `--lock-timeout=<value>` | Omitted |
| `role` | `string` | `--role=<value>` | Omitted |
| `useVersionSchema` | `boolean` | `--use-version-schema=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose=<value>` | Omitted |
| `directory` | `string` | `<directory>` | Required |
| `json` | `boolean` | `--json=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `create`

Create an empty named migration file noninteractively in the working directory.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `postgresUrl` | `string` | `--postgres-url=<value>` | Omitted |
| `schema` | `string` | `--schema=<value>` | Omitted |
| `stateSchema` | `string` | `--pgroll-schema=<value>` | Omitted |
| `lockTimeout` | `integer` | `--lock-timeout=<value>` | Omitted |
| `role` | `string` | `--role=<value>` | Omitted |
| `useVersionSchema` | `boolean` | `--use-version-schema=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose=<value>` | Omitted |
| `name` | `string` | `--name=<value>` | Required |
| `json` | `boolean` | `--json=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `latest`

Access native latest subcommands through the CSV arguments string.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `postgresUrl` | `string` | `--postgres-url=<value>` | Omitted |
| `schema` | `string` | `--schema=<value>` | Omitted |
| `stateSchema` | `string` | `--pgroll-schema=<value>` | Omitted |
| `lockTimeout` | `integer` | `--lock-timeout=<value>` | Omitted |
| `role` | `string` | `--role=<value>` | Omitted |
| `useVersionSchema` | `boolean` | `--use-version-schema=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `latest_migration`

Print the latest migration from the target database or local migration directory.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `postgresUrl` | `string` | `--postgres-url=<value>` | Omitted |
| `schema` | `string` | `--schema=<value>` | Omitted |
| `stateSchema` | `string` | `--pgroll-schema=<value>` | Omitted |
| `lockTimeout` | `integer` | `--lock-timeout=<value>` | Omitted |
| `role` | `string` | `--role=<value>` | Omitted |
| `useVersionSchema` | `boolean` | `--use-version-schema=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose=<value>` | Omitted |
| `local` | `string` | `--local=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `latest_schema`

Print the latest schema from the target database or local migration directory.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `postgresUrl` | `string` | `--postgres-url=<value>` | Omitted |
| `schema` | `string` | `--schema=<value>` | Omitted |
| `stateSchema` | `string` | `--pgroll-schema=<value>` | Omitted |
| `lockTimeout` | `integer` | `--lock-timeout=<value>` | Omitted |
| `role` | `string` | `--role=<value>` | Omitted |
| `useVersionSchema` | `boolean` | `--use-version-schema=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose=<value>` | Omitted |
| `local` | `string` | `--local=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `latest_url`

Print the latest connection URL with version schema search_path from the target database or local migration directory.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `postgresUrl` | `string` | `--postgres-url=<value>` | Omitted |
| `schema` | `string` | `--schema=<value>` | Omitted |
| `stateSchema` | `string` | `--pgroll-schema=<value>` | Omitted |
| `lockTimeout` | `integer` | `--lock-timeout=<value>` | Omitted |
| `role` | `string` | `--role=<value>` | Omitted |
| `useVersionSchema` | `boolean` | `--use-version-schema=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose=<value>` | Omitted |
| `local` | `string` | `--local=<value>` | Omitted |
| `connectionString` | `string` | `<connectionString>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `completion`

Generate shell completion scripts through literal native CSV arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |
