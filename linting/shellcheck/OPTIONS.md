# ShellCheck module arguments

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

## `lint`

Check explicit shell scripts.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `shell` | `string (sh, bash, dash, ksh)` | `--shell=<value>` | Omitted |
| `severity` | `string (error, warning, info, style)` | `--severity=<value>` | Omitted |
| `exclude` | `string` | `--exclude=<value>` | Omitted |
| `format` | `string` | `--format=<value>` | Omitted |
| `externalSources` | `boolean` | `--external-sources` | Omitted |
| `files` | `strings` | `<files>` | Required |
