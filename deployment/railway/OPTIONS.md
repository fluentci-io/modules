# Railway module arguments

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

## `up`

up

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `service` | `string` | `--service=<value>` | Omitted |
| `environment` | `string` | `--environment=<value>` | Omitted |
| `path` | `string` | `<path>` | `"."` |

## `status`

status

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `redeploy`

redeploy

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `service` | `string` | `--service=<value>` | Omitted |
