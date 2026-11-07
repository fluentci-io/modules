# DigitalOcean module arguments

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

## `account_get`

account get

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `droplets_list`

droplets list

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `apps_create`

apps create

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `spec` | `string` | `--spec=<value>` | Required |

## `apps_update`

apps update

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `spec` | `string` | `--spec=<value>` | Required |
| `app` | `string` | `<app>` | Required |

## `apps_deploy`

apps deploy

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `forceRebuild` | `boolean` | `--force-rebuild` | Omitted |
| `wait` | `boolean` | `--wait` | Omitted |
| `app` | `string` | `<app>` | Required |
