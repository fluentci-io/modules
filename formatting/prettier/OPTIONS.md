# Prettier module arguments

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

## `format`

Format supported files in place.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `ignorePath` | `string` | `--ignore-path=<value>` | Omitted |
| `parser` | `string` | `--parser=<value>` | Omitted |
| `files` | `strings` | `<files>` | `["."]` |

## `check`

Check formatting without writing files.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `ignorePath` | `string` | `--ignore-path=<value>` | Omitted |
| `files` | `strings` | `<files>` | `["."]` |
