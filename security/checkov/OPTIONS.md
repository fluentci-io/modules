# Checkov module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), and `timeoutMs` (default `900000`).

## `run`

Execute arbitrary literal CLI arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `strings` | `<arguments>` | Required |

## `version`

Print the CLI version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `scan`

Scan infrastructure code, failing when policy checks fail.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `directory` | `string` | `--directory=<value>` | `"."` |
| `framework` | `strings` | `--framework <values...>` | Omitted |
| `configFile` | `string` | `--config-file=<value>` | Omitted |
| `check` | `string` | `--check=<value>` | Omitted |
| `skipCheck` | `string` | `--skip-check=<value>` | Omitted |
| `output` | `string` | `--output=<value>` | `"json"` |
| `outputFilePath` | `string` | `--output-file-path=<value>` | Omitted |
