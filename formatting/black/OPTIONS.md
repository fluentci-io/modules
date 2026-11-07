# Black module arguments

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

## `format`

Format Python files in place.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `lineLength` | `integer` | `--line-length=<value>` | Omitted |
| `targetVersion` | `strings` | `--target-version=<value>` | Omitted |
| `files` | `strings` | `<files>` | `["."]` |

## `check`

Check Python formatting without writing files.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `diff` | `boolean` | `--diff` | Omitted |
| `config` | `string` | `--config=<value>` | Omitted |
| `lineLength` | `integer` | `--line-length=<value>` | Omitted |
| `targetVersion` | `strings` | `--target-version=<value>` | Omitted |
| `files` | `strings` | `<files>` | `["."]` |
