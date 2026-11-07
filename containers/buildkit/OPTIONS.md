# BuildKit module arguments

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

## `build`

Build a Dockerfile with named local context and dockerfile directories.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `addr` | `string` | `--addr=<value>` (global) | Omitted |
| `context` | `string` | `--local=context=<value>` | `"."` |
| `dockerfileDir` | `string` | `--local=dockerfile=<value>` | `"."` |
| `opt` | `strings` | `--opt=<value>` | Omitted |
| `output` | `strings` | `--output=<value>` | Omitted |
| `importCache` | `strings` | `--import-cache=<value>` | Omitted |
| `exportCache` | `strings` | `--export-cache=<value>` | Omitted |
| `secret` | `strings` | `--secret=<value>` | Omitted |
| `ssh` | `strings` | `--ssh=<value>` | Omitted |
| `noCache` | `boolean` | `--no-cache` | Omitted |
| `progress` | `string` | `--progress=<value>` | Omitted |

## `prune`

Prune the selected BuildKit daemon cache.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `addr` | `string` | `--addr=<value>` (global) | Omitted |
| `all` | `boolean` | `--all` | Omitted |
| `filter` | `strings` | `--filter=<value>` | Omitted |

## `du`

Inspect BuildKit cache usage.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `addr` | `string` | `--addr=<value>` (global) | Omitted |
| `verbose` | `boolean` | `--verbose` | Omitted |
| `filter` | `strings` | `--filter=<value>` | Omitted |
