# Vercel module arguments

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

## `deploy`

deploy

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `prod` | `boolean` | `--prod` | Omitted |
| `prebuilt` | `boolean` | `--prebuilt` | Omitted |
| `path` | `string` | `<path>` | `"."` |

## `build`

build

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `prod` | `boolean` | `--prod` | Omitted |

## `pull`

pull

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `environment` | `string (production, preview, development)` | `--environment=<value>` | Omitted |
