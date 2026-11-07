# Google Cloud module arguments

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

## `config_list`

config list

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `cloudProject` | `string` | `--project=<value>` (global) | Omitted |
| `account` | `string` | `--account=<value>` (global) | Omitted |

## `run_deploy`

Deploy a container image to Cloud Run.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `cloudProject` | `string` | `--project=<value>` (global) | Omitted |
| `account` | `string` | `--account=<value>` (global) | Omitted |
| `image` | `string` | `--image=<value>` | Required |
| `region` | `string` | `--region=<value>` | Required |
| `service` | `string` | `<service>` | Required |

## `storage_cp`

storage cp

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `cloudProject` | `string` | `--project=<value>` (global) | Omitted |
| `account` | `string` | `--account=<value>` (global) | Omitted |
| `recursive` | `boolean` | `--recursive` | Omitted |
| `source` | `string` | `<source>` | Required |
| `destination` | `string` | `<destination>` | Required |

## `instances_list`

instances list

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `cloudProject` | `string` | `--project=<value>` (global) | Omitted |
| `account` | `string` | `--account=<value>` (global) | Omitted |
