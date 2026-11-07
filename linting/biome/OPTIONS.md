# Biome module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` (an object mapping output names to file paths).

## `run`

Execute arbitrary literal CLI arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `strings` | `<arguments>` | Required |

## `version`

Print the CLI version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `check`

Run formatter, linter, and import checks.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `configPath` | `string` | `--config-path=<value>` | Omitted |
| `write` | `boolean` | `--write` | Omitted |
| `files` | `strings` | `<files>` | `["."]` |

## `lint`

Lint supported source files.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `configPath` | `string` | `--config-path=<value>` | Omitted |
| `write` | `boolean` | `--write` | Omitted |
| `files` | `strings` | `<files>` | `["."]` |

## `format`

Format supported sources in place.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `configPath` | `string` | `--config-path=<value>` | Omitted |
| `files` | `strings` | `<files>` | `["."]` |

## `ci`

Run read-only CI checks.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `configPath` | `string` | `--config-path=<value>` | Omitted |
| `files` | `strings` | `<files>` | `["."]` |
