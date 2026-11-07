# Codacy module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` (an object mapping output names to file paths).

## `run`

Execute arbitrary literal CLI arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `strings` | `<arguments>` | Required |

## `help`

help

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `upload`

Upload an existing coverage report to Codacy.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `coverageFile` | `string` | `--coverage-reports <value>` | Required |
| `language` | `string` | `--language <value>` | Omitted |
| `commitUuid` | `string` | `--commit-uuid <value>` | Omitted |
| `prefix` | `string` | `--prefix <value>` | Omitted |
| `forceCoverageParser` | `string (opencover, clover, lcov, phpunit, jacoco, dotcover, cobertura, go)` | `--force-coverage-parser <value>` | Omitted |
