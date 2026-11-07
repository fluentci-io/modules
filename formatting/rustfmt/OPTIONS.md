# Rustfmt module arguments

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

Format explicit Rust source files.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `edition` | `string (2015, 2018, 2021, 2024)` | `--edition=<value>` | Omitted |
| `configPath` | `string` | `--config-path=<value>` | Omitted |
| `config` | `string` | `--config=<value>` | Omitted |
| `files` | `strings` | `<files>` | Required |

## `check`

Check explicit Rust source files.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `edition` | `string (2015, 2018, 2021, 2024)` | `--edition=<value>` | Omitted |
| `configPath` | `string` | `--config-path=<value>` | Omitted |
| `files` | `strings` | `<files>` | Required |

## `cargo_fmt`

Format a Cargo package or workspace.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `all` | `boolean` | `--all` | Omitted |
| `check` | `boolean` | `--check` | Omitted |
| `manifestPath` | `string` | `--manifest-path=<value>` | Omitted |
