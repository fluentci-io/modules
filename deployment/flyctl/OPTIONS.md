# Fly.io module arguments

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
| `app` | `string` | `--app=<value>` | Omitted |
| `config` | `string` | `--config=<value>` | Omitted |
| `image` | `string` | `--image=<value>` | Omitted |
| `region` | `string` | `--region=<value>` | Omitted |

## `status`

status

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `app` | `string` | `--app=<value>` | Omitted |
| `json` | `boolean` | `--json` | Omitted |

## `logs`

logs

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `app` | `string` | `--app=<value>` | Omitted |
