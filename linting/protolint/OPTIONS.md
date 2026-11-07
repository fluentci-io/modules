# Protolint module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` (an object mapping output names to file paths).

## `run`

Run a native command with literal arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `strings` | `<arguments>` | Required |

## `version`

Print the installed tool version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `lint`

Lint Protocol Buffer style and fail on findings or parser errors.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `configPath` | `string` | `-config_path=<value>` | Omitted |
| `configDirPath` | `string` | `-config_dir_path=<value>` | Omitted |
| `reporter` | `string` | `-reporter=<value>` | Omitted |
| `files` | `strings` | `<files>` | `["."]` |

## `fix`

Apply supported Protocol Buffer style fixes to the selected files.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `configPath` | `string` | `-config_path=<value>` | Omitted |
| `configDirPath` | `string` | `-config_dir_path=<value>` | Omitted |
| `reporter` | `string` | `-reporter=<value>` | Omitted |
| `files` | `strings` | `<files>` | `["."]` |
