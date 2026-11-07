# Codecov module arguments

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

## `upload`

Create a Codecov report and upload existing coverage files, failing on upload errors.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `files` | `strings` | `-f <value>` | Required |
| `flags` | `strings` | `-F <value>` | Omitted |
| `name` | `string` | `-n <value>` | Omitted |
| `commit` | `string` | `-C <value>` | Omitted |
| `disableSearch` | `boolean` | `--disable-search` | Omitted |
