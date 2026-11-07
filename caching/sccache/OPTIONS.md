# sccache module arguments

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

## `start_server`

start server

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `stop_server`

stop server

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `stats`

stats

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `statsFormat` | `string (text, json)` | `--stats-format=<value>` | Omitted |

## `zero_stats`

zero stats

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `compile`

Compile through sccache using a native compiler and literal arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `compiler` | `string` | `<compiler>` | Required |
| `arguments` | `strings` | `<arguments>` | `[]` |
