# Doppler module arguments

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

## `run_command`

Run a child process with secrets injected into its environment.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `dopplerProject` | `string` | `--project=<value>` (global) | Omitted |
| `config` | `string` | `--config=<value>` (global) | Omitted |
| `noCache` | `boolean` | `--no-cache` | Omitted |
| `command` | `strings` | `-- <values...>` | Required |

## `names`

List secret names without retrieving their values.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `dopplerProject` | `string` | `--project=<value>` (global) | Omitted |
| `config` | `string` | `--config=<value>` (global) | Omitted |

## `upload`

Upload a JSON or dotenv file without printing its secret values.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `dopplerProject` | `string` | `--project=<value>` (global) | Omitted |
| `config` | `string` | `--config=<value>` (global) | Omitted |
| `file` | `string` | `<file>` | Required |
