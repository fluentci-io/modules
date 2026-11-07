# Netlify module arguments

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

## `deploy`

deploy

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `dir` | `string` | `--dir=<value>` | Required |
| `site` | `string` | `--site=<value>` | Omitted |
| `prod` | `boolean` | `--prod` | Omitted |
| `message` | `string` | `--message=<value>` | Omitted |

## `build`

build

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `context` | `string` | `--context=<value>` | Omitted |

## `status`

status

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `sites_list`

sites list

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
