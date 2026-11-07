# Render module arguments

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

## `services`

services

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `deploy`

deploy

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `wait` | `boolean` | `--wait` | Omitted |
| `commit` | `string` | `--commit=<value>` | Omitted |
| `service` | `string` | `<service>` | Required |

## `deploys_list`

deploys list

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `service` | `string` | `<service>` | Required |
