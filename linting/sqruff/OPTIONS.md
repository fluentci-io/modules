# Sqruff module arguments

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

Lint SQL without modifying files and fail the pipeline on violations.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `dialect` | `string` | `--dialect=<value>` | Omitted |
| `format` | `string` | `--format=<value>` | Omitted |
| `ignoreLocalConfig` | `boolean` | `--ignore-local-config` | Omitted |
| `parsingErrors` | `boolean` | `--parsing-errors` | Omitted |
| `disableNoqa` | `boolean` | `--disable-noqa` | Omitted |
| `files` | `strings` | `<files>` | `["."]` |
| `writeOutput` | `string` | `--write-output=<value>` | Omitted |
| `annotationLevel` | `string` | `--annotation-level=<value>` | Omitted |

## `fix`

Apply SQL formatting and fixable lint rules to the selected project files.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `dialect` | `string` | `--dialect=<value>` | Omitted |
| `format` | `string` | `--format=<value>` | Omitted |
| `ignoreLocalConfig` | `boolean` | `--ignore-local-config` | Omitted |
| `parsingErrors` | `boolean` | `--parsing-errors` | Omitted |
| `disableNoqa` | `boolean` | `--disable-noqa` | Omitted |
| `files` | `strings` | `<files>` | `["."]` |
