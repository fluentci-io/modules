# Infisical module arguments

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
| `secretProject` | `string` | `--projectId=<value>` | Omitted |
| `env` | `string` | `--env=<value>` | Omitted |
| `paths` | `strings` | `--path=<value>` | Omitted |
| `recursive` | `boolean` | `--recursive` | Omitted |
| `command` | `strings` | `-- <values...>` | Required |
