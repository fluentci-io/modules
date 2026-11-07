# Grype module arguments

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

Scan an image, directory, or SBOM and fail on the configured severity threshold.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `failOn` | `string (negligible, low, medium, high, critical)` | `--fail-on=<value>` | `"high"` |
| `output` | `string` | `--output=<value>` | `"json"` |
| `file` | `string` | `--file=<value>` | Omitted |
| `config` | `string` | `--config=<value>` | Omitted |
| `onlyFixed` | `boolean` | `--only-fixed` | Omitted |
| `source` | `string` | `<source>` | Required |

## `db_update`

Download the current vulnerability database.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
