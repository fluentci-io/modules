# Kubectl module arguments

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

## `apply`

apply

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `context` | `string` | `--context=<value>` (global) | Omitted |
| `namespace` | `string` | `--namespace=<value>` (global) | Omitted |
| `kubeconfig` | `string` | `--kubeconfig=<value>` (global) | Omitted |
| `filename` | `strings` | `--filename=<value>` | Required |
| `recursive` | `boolean` | `--recursive` | Omitted |

## `get`

get

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `context` | `string` | `--context=<value>` (global) | Omitted |
| `namespace` | `string` | `--namespace=<value>` (global) | Omitted |
| `kubeconfig` | `string` | `--kubeconfig=<value>` (global) | Omitted |
| `output` | `string` | `--output=<value>` | Omitted |
| `resource` | `string` | `<resource>` | Required |
| `name` | `string` | `<name>` | Omitted |

## `delete_resources`

delete

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `context` | `string` | `--context=<value>` (global) | Omitted |
| `namespace` | `string` | `--namespace=<value>` (global) | Omitted |
| `kubeconfig` | `string` | `--kubeconfig=<value>` (global) | Omitted |
| `filename` | `strings` | `--filename=<value>` | Required |
| `ignoreNotFound` | `boolean` | `--ignore-not-found` | Omitted |

## `rollout_status`

rollout status

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `context` | `string` | `--context=<value>` (global) | Omitted |
| `namespace` | `string` | `--namespace=<value>` (global) | Omitted |
| `kubeconfig` | `string` | `--kubeconfig=<value>` (global) | Omitted |
| `timeout` | `string` | `--timeout=<value>` | Omitted |
| `resource` | `string` | `<resource>` | Required |
