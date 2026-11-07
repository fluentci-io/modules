# SQLFluff module arguments

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

Lint SQL and fail the pipeline on violations or parsing errors.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `dialect` | `string` | `--dialect=<value>` | Omitted |
| `templater` | `string` | `--templater=<value>` | Omitted |
| `rules` | `string` | `--rules=<value>` | Omitted |
| `excludeRules` | `string` | `--exclude-rules=<value>` | Omitted |
| `processes` | `integer` | `--processes=<value>` | Omitted |
| `format` | `string` | `--format=<value>` | Omitted |
| `writeOutput` | `string` | `--write-output=<value>` | Omitted |
| `files` | `strings` | `<files>` | `["."]` |

## `fix`

Apply fixable SQL rules to the selected project files.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `dialect` | `string` | `--dialect=<value>` | Omitted |
| `templater` | `string` | `--templater=<value>` | Omitted |
| `rules` | `string` | `--rules=<value>` | Omitted |
| `excludeRules` | `string` | `--exclude-rules=<value>` | Omitted |
| `processes` | `integer` | `--processes=<value>` | Omitted |
| `files` | `strings` | `<files>` | `["."]` |

## `parse`

Parse SQL to detect syntax and templating errors.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `dialect` | `string` | `--dialect=<value>` | Omitted |
| `templater` | `string` | `--templater=<value>` | Omitted |
| `rules` | `string` | `--rules=<value>` | Omitted |
| `excludeRules` | `string` | `--exclude-rules=<value>` | Omitted |
| `processes` | `integer` | `--processes=<value>` | Omitted |
| `format` | `string` | `--format=<value>` | Omitted |
| `path` | `string` | `<path>` | `"."` |
