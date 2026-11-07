# Betterleaks module arguments

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

## `scan_dir`

Scan files using Betterleaks 1.x with redaction and credential validation disabled.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `reportFormat` | `string (json, csv, junit, sarif)` | `--report-format=<value>` | `"json"` |
| `reportPath` | `string` | `--report-path=<value>` | Omitted |
| `confidence` | `string (low, medium, high)` | `--confidence=<value>` | Omitted |
| `enableRule` | `strings` | `--enable-rule=<value>` | Omitted |
| `disableRule` | `strings` | `--disable-rule=<value>` | Omitted |
| `directory` | `string` | `<directory>` | `"."` |

## `scan_git`

Scan Git history with Betterleaks 1.x, failing on detected secrets.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `reportFormat` | `string (json, csv, junit, sarif)` | `--report-format=<value>` | `"json"` |
| `reportPath` | `string` | `--report-path=<value>` | Omitted |
| `confidence` | `string (low, medium, high)` | `--confidence=<value>` | Omitted |
| `enableRule` | `strings` | `--enable-rule=<value>` | Omitted |
| `disableRule` | `strings` | `--disable-rule=<value>` | Omitted |
| `logOpts` | `string` | `--log-opts=<value>` | Omitted |
| `repository` | `string` | `<repository>` | `"."` |
