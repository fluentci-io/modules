# rclone module arguments

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

## `copy`

copy

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `checksum` | `boolean` | `--checksum` | Omitted |
| `immutable` | `boolean` | `--immutable` | Omitted |
| `transfers` | `integer` | `--transfers=<value>` | Omitted |
| `source` | `string` | `<source>` | Required |
| `destination` | `string` | `<destination>` | Required |

## `copyto`

copyto

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `checksum` | `boolean` | `--checksum` | Omitted |
| `immutable` | `boolean` | `--immutable` | Omitted |
| `source` | `string` | `<source>` | Required |
| `destination` | `string` | `<destination>` | Required |

## `check`

Verify transferred artifact content against the source.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `oneWay` | `boolean` | `--one-way` | Omitted |
| `source` | `string` | `<source>` | Required |
| `destination` | `string` | `<destination>` | Required |

## `lsjson`

lsjson

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `recursive` | `boolean` | `--recursive` | Omitted |
| `path` | `string` | `<path>` | Required |
