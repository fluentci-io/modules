# Syft module arguments

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

Generate an SBOM for a directory, image, or archive.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `output` | `strings` | `--output=<value>` | `["syft-json"]` |
| `config` | `string` | `--config=<value>` | Omitted |
| `exclude` | `strings` | `--exclude=<value>` | Omitted |
| `source` | `string` | `<source>` | Required |

## `convert`

Convert an existing SBOM to a supported output format.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `output` | `strings` | `--output=<value>` | `["cyclonedx-json"]` |
| `file` | `string` | `<file>` | Required |
