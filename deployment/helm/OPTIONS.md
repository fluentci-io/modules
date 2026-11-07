# Helm module arguments

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

## `lint`

lint

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `strict` | `boolean` | `--strict` | Omitted |
| `values` | `strings` | `--values=<value>` | Omitted |
| `chart` | `string` | `<chart>` | Required |

## `template`

template

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `namespace` | `string` | `--namespace=<value>` | Omitted |
| `values` | `strings` | `--values=<value>` | Omitted |
| `set` | `strings` | `--set=<value>` | Omitted |
| `release` | `string` | `<release>` | Required |
| `chart` | `string` | `<chart>` | Required |

## `upgrade`

Install or upgrade a release in the configured cluster.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `namespace` | `string` | `--namespace=<value>` | Omitted |
| `values` | `strings` | `--values=<value>` | Omitted |
| `set` | `strings` | `--set=<value>` | Omitted |
| `createNamespace` | `boolean` | `--create-namespace` | Omitted |
| `wait` | `boolean` | `--wait` | Omitted |
| `timeout` | `string` | `--timeout=<value>` | Omitted |
| `release` | `string` | `<release>` | Required |
| `chart` | `string` | `<chart>` | Required |

## `uninstall`

uninstall

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `namespace` | `string` | `--namespace=<value>` | Omitted |
| `wait` | `boolean` | `--wait` | Omitted |
| `release` | `string` | `<release>` | Required |
