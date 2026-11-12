# Drizzle Kit module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` is a comma-separated NAME=PATH string in the public component contract.

## `run`

Execute literal Drizzle Kit arguments for additional upstream features.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Required |

## `version`

Print the Drizzle Kit version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `generate`

Generate SQL migrations; custom creates an empty migration for handwritten SQL.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `name` | `string` | `--name=<value>` | Omitted |
| `custom` | `boolean` | `--custom` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `migrate`

Apply committed SQL migrations using the project database configuration.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `push`

Apply schema changes directly; destructive approval is opt-in through force.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `strict` | `boolean` | `--strict` | Omitted |
| `verbose` | `boolean` | `--verbose` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pull`

Introspect the configured database into Drizzle schema files.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `check`

Check generated migrations for collisions before merging.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `up`

Upgrade existing migration snapshots to the installed Kit format.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `export_sql`

Print SQL DDL from the configured TypeScript schema.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `studio`

Start the long-running Studio server; use a bounded timeout and scoped service lifecycle.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config <value>` | Omitted |
| `host` | `string` | `--host=<value>` | Omitted |
| `port` | `integer` | `--port=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |
