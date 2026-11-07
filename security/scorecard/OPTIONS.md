# OpenSSF Scorecard module arguments

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

Evaluate an upstream repository against OpenSSF Scorecard checks.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `format` | `string (json, sarif, default)` | `--format=<value>` | `"json"` |
| `checks` | `string` | `--checks=<value>` | Omitted |
| `showDetails` | `boolean` | `--show-details` | Omitted |
| `repo` | `string` | `--repo=<value>` | Required |

## `scan_local`

Run supported checks against a local repository.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `format` | `string (json, sarif, default)` | `--format=<value>` | `"json"` |
| `checks` | `string` | `--checks=<value>` | Omitted |
| `showDetails` | `boolean` | `--show-details` | Omitted |
| `local` | `string` | `--local=<value>` | `"."` |
