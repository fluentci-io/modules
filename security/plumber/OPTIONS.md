# Plumber module arguments

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

## `analyze`

Audit GitHub Actions/GitLab CI with a score gate and failing provider/collection errors.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `provider` | `string (github, gitlab)` | `--provider=<value>` | Omitted |
| `repository` | `string` | `--project=<value>` | Omitted |
| `config` | `string` | `--config=<value>` | Omitted |
| `minScore` | `string (A, B, C, D, E)` | `--min-score=<value>` | Omitted |
| `minPoints` | `integer` | `--min-points=<value>` | Omitted |
| `output` | `string` | `--output=<value>` | Omitted |
| `sarif` | `string` | `--sarif=<value>` | Omitted |
| `glsast` | `string` | `--glsast=<value>` | Omitted |
| `pbom` | `string` | `--pbom=<value>` | Omitted |
| `branch` | `string` | `--branch=<value>` | Omitted |
| `target` | `string` | `<target>` | Omitted |

## `validate_config`

Validate Plumber policy configuration without running a repository audit.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
