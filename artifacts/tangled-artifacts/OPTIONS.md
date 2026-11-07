# Tangled release artifacts module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` (an object mapping output names to file paths).

## `run`

Execute arbitrary literal CLI arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `strings` | `<arguments>` | Required |

## `upload`

Upload files as assets attached to an existing annotated Tangled tag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `username` | `string` | `--username=<value>` | Required |
| `tag` | `string` | `--repo-tag=<value>` | Required |
| `repository` | `string` | `--target-repo=<value>` | Required |
| `files` | `strings` | `<files>` | Required |
