# Coveralls module arguments

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

## `upload`

Upload coverage reports using the universal Coveralls reporter.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `format` | `string (lcov, simplecov, cobertura, jacoco, gcov, luacov, golang, python)` | `--format=<value>` | Omitted |
| `basePath` | `string` | `--base-path=<value>` | Omitted |
| `jobFlag` | `string` | `--job-flag=<value>` | Omitted |
| `buildNumber` | `string` | `--build-number=<value>` | Omitted |
| `parallel` | `boolean` | `--parallel` | Omitted |
| `dryRun` | `boolean` | `--dry-run` | Omitted |
| `files` | `strings` | `<files>` | Required |

## `done`

Close a parallel coverage build.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `buildNumber` | `string` | `--build-number=<value>` | Required |
| `carryforward` | `string` | `--carryforward=<value>` | Omitted |
| `dryRun` | `boolean` | `--dry-run` | Omitted |
