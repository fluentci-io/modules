# TruffleHog module arguments

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

## `filesystem`

Scan local files for secrets without verifying credentials against remote services.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `includeDetectors` | `string` | `--include-detectors=<value>` | Omitted |
| `excludeDetectors` | `string` | `--exclude-detectors=<value>` | Omitted |
| `concurrency` | `integer` | `--concurrency=<value>` | Omitted |
| `paths` | `strings` | `<paths>` | `["."]` |

## `git`

Scan a Git repository without credential verification.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `sinceCommit` | `string` | `--since-commit=<value>` | Omitted |
| `branch` | `string` | `--branch=<value>` | Omitted |
| `maxDepth` | `integer` | `--max-depth=<value>` | Omitted |
| `repository` | `string` | `<repository>` | Required |
