# Turborepo module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` is a comma-separated NAME=PATH string in the public component contract.

## `run`

Run arbitrary literal Turbo CLI arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Required |

## `version`

Print the Turbo CLI version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `run_tasks`

Run selected workspace tasks with native dependency ordering and caching.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `tasks` | `string (CSV)` | `<tasks>` | Required |
| `affected` | `boolean` | `--affected` | Omitted |
| `filters` | `string (CSV)` | `--filter=<value>` | Omitted |
| `concurrency` | `string` | `--concurrency=<value>` | Omitted |
| `cache` | `string (CSV)` | `--cache=<comma-separated values>` | Omitted |
| `cacheDir` | `string` | `--cache-dir=<value>` | Omitted |
| `envMode` | `string (strict, loose)` | `--env-mode=<value>` | Omitted |
| `continueMode` | `string (never, dependencies-successful, always)` | `--continue=<value>` | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `summarize` | `boolean` | `--summarize` | Omitted |
| `outputLogs` | `string (full, hash-only, new-only, errors-only, none)` | `--output-logs=<value>` | Omitted |
| `ui` | `string (stream, tui)` | `--ui=<value>` | `"stream"` |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `affected`

Run tasks only in affected packages; requires the Git comparison history.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `tasks` | `string (CSV)` | `<tasks>` | Required |
| `filters` | `string (CSV)` | `--filter=<value>` | Omitted |
| `concurrency` | `string` | `--concurrency=<value>` | Omitted |
| `cache` | `string (CSV)` | `--cache=<comma-separated values>` | Omitted |
| `cacheDir` | `string` | `--cache-dir=<value>` | Omitted |
| `envMode` | `string (strict, loose)` | `--env-mode=<value>` | Omitted |
| `continueMode` | `string (never, dependencies-successful, always)` | `--continue=<value>` | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `summarize` | `boolean` | `--summarize` | Omitted |
| `outputLogs` | `string (full, hash-only, new-only, errors-only, none)` | `--output-logs=<value>` | Omitted |
| `ui` | `string (stream, tui)` | `--ui=<value>` | `"stream"` |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `dry_run`

Print a JSON task plan without executing workspace tasks.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `tasks` | `string (CSV)` | `<tasks>` | Required |
| `affected` | `boolean` | `--affected` | Omitted |
| `filters` | `string (CSV)` | `--filter=<value>` | Omitted |
| `concurrency` | `string` | `--concurrency=<value>` | Omitted |
| `cache` | `string (CSV)` | `--cache=<comma-separated values>` | Omitted |
| `cacheDir` | `string` | `--cache-dir=<value>` | Omitted |
| `envMode` | `string (strict, loose)` | `--env-mode=<value>` | Omitted |
| `continueMode` | `string (never, dependencies-successful, always)` | `--continue=<value>` | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `summarize` | `boolean` | `--summarize` | Omitted |
| `outputLogs` | `string (full, hash-only, new-only, errors-only, none)` | `--output-logs=<value>` | Omitted |
| `ui` | `string (stream, tui)` | `--ui=<value>` | `"stream"` |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `prune`

Generate a partial workspace and pruned lockfile for a package.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `package` | `string` | `<package>` | Required |
| `docker` | `boolean` | `--docker` | Omitted |
| `outDir` | `string` | `--out-dir=<value>` | Omitted |
| `useGitignore` | `boolean` | `--use-gitignore=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `list_packages`

Inspect packages, dependencies and tasks without executing tasks.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `packages` | `string (CSV)` | `<packages>` | Omitted |
| `filters` | `string (CSV)` | `--filter=<value>` | Omitted |
| `affected` | `boolean` | `--affected` | Omitted |
| `output` | `string (json, pretty)` | `--output=<value>` | `"json"` |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `info`

Print Turbo environment diagnostics.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |
