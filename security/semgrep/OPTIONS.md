# Semgrep module arguments

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

## `scan`

Scan with explicit rule configurations and fail when findings are present.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `strings` | `--config=<value>` | Required |
| `output` | `string` | `--output=<value>` | Omitted |
| `json` | `boolean` | `--json` | `true` |
| `sarif` | `boolean` | `--sarif` | Omitted |
| `exclude` | `strings` | `--exclude=<value>` | Omitted |
| `jobs` | `integer` | `--jobs=<value>` | Omitted |
| `paths` | `strings` | `<paths>` | `["."]` |

## `ci`

Run Semgrep platform CI using the configured project policy.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `json` | `boolean` | `--json` | `true` |
| `output` | `string` | `--output=<value>` | Omitted |
