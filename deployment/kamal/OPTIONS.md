# Kamal module arguments

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
| `destination` | `string` | `--destination=<value>` | Omitted |
| `configFile` | `string` | `--config-file=<value>` | Omitted |

## `setup`

setup

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `destination` | `string` | `--destination=<value>` | Omitted |
| `configFile` | `string` | `--config-file=<value>` | Omitted |

## `details`

details

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `destination` | `string` | `--destination=<value>` | Omitted |
| `configFile` | `string` | `--config-file=<value>` | Omitted |

## `rollback`

rollback

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `destination` | `string` | `--destination=<value>` | Omitted |
| `configFile` | `string` | `--config-file=<value>` | Omitted |
| `version` | `string` | `<version>` | Required |
