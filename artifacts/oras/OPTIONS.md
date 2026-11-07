# ORAS module arguments

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

## `push`

Publish typed artifacts to an OCI registry.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `artifactType` | `string` | `--artifact-type=<value>` | Omitted |
| `annotation` | `strings` | `--annotation=<value>` | Omitted |
| `reference` | `string` | `<reference>` | Required |
| `files` | `strings` | `<files>` | Required |

## `pull`

pull

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `output` | `string` | `--output=<value>` | `"dist"` |
| `reference` | `string` | `<reference>` | Required |

## `copy`

copy

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `recursive` | `boolean` | `--recursive` | Omitted |
| `source` | `string` | `<source>` | Required |
| `destination` | `string` | `<destination>` | Required |

## `discover`

discover

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `format` | `string` | `--format=<value>` | `"json"` |
| `reference` | `string` | `<reference>` | Required |
