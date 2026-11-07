# Ruff module arguments

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

Lint Python sources; fixes require fix=true.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `select` | `string` | `--select=<value>` | Omitted |
| `ignore` | `string` | `--ignore=<value>` | Omitted |
| `outputFormat` | `string` | `--output-format=<value>` | Omitted |
| `fix` | `boolean` | `--fix` | Omitted |
| `files` | `strings` | `<files>` | `["."]` |

## `format`

Format Python sources.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `lineLength` | `integer` | `--line-length=<value>` | Omitted |
| `files` | `strings` | `<files>` | `["."]` |

## `format_check`

Check Python formatting without writing files.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `files` | `strings` | `<files>` | `["."]` |
