# Ninja module arguments

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

## `build`

build

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `directory` | `string` | `-C <value>` | `"."` |
| `file` | `string` | `-f <value>` | Omitted |
| `jobs` | `integer` | `-j <value>` | Omitted |
| `verbose` | `boolean` | `-v` | Omitted |
| `dryRun` | `boolean` | `-n` | Omitted |
| `targets` | `strings` | `<targets>` | `[]` |

## `clean`

clean

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `directory` | `string` | `-C <value>` | `"."` |
| `file` | `string` | `-f <value>` | Omitted |
| `jobs` | `integer` | `-j <value>` | Omitted |
| `tool` | `string (clean)` | `-t <value>` | `"clean"` |
| `targets` | `strings` | `<targets>` | `[]` |

## `targets`

targets

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `directory` | `string` | `-C <value>` | `"."` |
| `file` | `string` | `-f <value>` | Omitted |
| `jobs` | `integer` | `-j <value>` | Omitted |
| `tool` | `string (targets)` | `-t <value>` | `"targets"` |
