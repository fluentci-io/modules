# Nexus Repository module arguments

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

## `upload`

Upload a file to a Nexus raw-repository URL.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `curlConfig` | `string` | `--config <value>` | Omitted |
| `file` | `string` | `--upload-file <value>` | Required |
| `url` | `string` | `<url>` | Required |

## `download`

Download a raw artifact, failing on HTTP errors.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `curlConfig` | `string` | `--config <value>` | Omitted |
| `output` | `string` | `--output <value>` | Required |
| `url` | `string` | `<url>` | Required |

## `head`

head

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `curlConfig` | `string` | `--config <value>` | Omitted |
| `url` | `string` | `<url>` | Required |
