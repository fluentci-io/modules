# Gitleaks module arguments

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

Scan directory contents with findings redacted and a failing exit status on leaks.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `reportFormat` | `string (json, csv, junit, sarif)` | `--report-format=<value>` | `"json"` |
| `reportPath` | `string` | `--report-path=<value>` | Omitted |
| `directory` | `string` | `<directory>` | `"."` |

## `scan_git`

Scan Git history, failing on detected leaks.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `reportFormat` | `string (json, csv, junit, sarif)` | `--report-format=<value>` | `"json"` |
| `reportPath` | `string` | `--report-path=<value>` | Omitted |
| `logOpts` | `string` | `--log-opts=<value>` | Omitted |
| `repository` | `string` | `<repository>` | `"."` |
