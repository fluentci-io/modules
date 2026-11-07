# Yamllint module arguments

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

## `lint`

Lint YAML files and directories.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `configFile` | `string` | `--config-file=<value>` | Omitted |
| `configData` | `string` | `--config-data=<value>` | Omitted |
| `format` | `string` | `--format=<value>` | Omitted |
| `strict` | `boolean` | `--strict` | Omitted |
| `files` | `strings` | `<files>` | `["."]` |
