# Nx module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` is a comma-separated NAME=PATH string in the public component contract.

## `run`

Run arbitrary literal Nx CLI arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Required |

## `version`

Print the Nx CLI versions.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `run_target`

Execute one project target, such as app:build:production.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `target` | `string` | `<target>` | Required |
| `configuration` | `string` | `--configuration=<value>` | Omitted |
| `parallel` | `integer` | `--parallel=<value>` | Omitted |
| `exclude` | `string (CSV)` | `--exclude=<comma-separated values>` | Omitted |
| `outputStyle` | `string (static, static-failures-only, stream, stream-without-prefixes, summary, dynamic-legacy, dynamic, tui)` | `--outputStyle=<value>` | `"static"` |
| `skipCache` | `boolean` | `--skipNxCache` | Omitted |
| `skipRemoteCache` | `boolean` | `--skipRemoteCache` | Omitted |
| `bail` | `boolean` | `--nxBail` | Omitted |
| `skipSync` | `boolean` | `--skipSync` | Omitted |
| `graph` | `string` | `--graph=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `run_many`

Execute targets across selected projects; omitted projects selects all eligible projects.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `targets` | `string (CSV)` | `--targets=<comma-separated values>` | Required |
| `projects` | `string (CSV)` | `--projects=<comma-separated values>` | Omitted |
| `configuration` | `string` | `--configuration=<value>` | Omitted |
| `parallel` | `integer` | `--parallel=<value>` | Omitted |
| `exclude` | `string (CSV)` | `--exclude=<comma-separated values>` | Omitted |
| `outputStyle` | `string (static, static-failures-only, stream, stream-without-prefixes, summary, dynamic-legacy, dynamic, tui)` | `--outputStyle=<value>` | `"static"` |
| `skipCache` | `boolean` | `--skipNxCache` | Omitted |
| `skipRemoteCache` | `boolean` | `--skipRemoteCache` | Omitted |
| `bail` | `boolean` | `--nxBail` | Omitted |
| `skipSync` | `boolean` | `--skipSync` | Omitted |
| `graph` | `string` | `--graph=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `affected`

Execute targets only for projects affected by the selected changes.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `targets` | `string (CSV)` | `--targets=<comma-separated values>` | Required |
| `base` | `string` | `--base=<value>` | Omitted |
| `head` | `string` | `--head=<value>` | Omitted |
| `files` | `string (CSV)` | `--files=<comma-separated values>` | Omitted |
| `configuration` | `string` | `--configuration=<value>` | Omitted |
| `parallel` | `integer` | `--parallel=<value>` | Omitted |
| `exclude` | `string (CSV)` | `--exclude=<comma-separated values>` | Omitted |
| `outputStyle` | `string (static, static-failures-only, stream, stream-without-prefixes, summary, dynamic-legacy, dynamic, tui)` | `--outputStyle=<value>` | `"static"` |
| `skipCache` | `boolean` | `--skipNxCache` | Omitted |
| `skipRemoteCache` | `boolean` | `--skipRemoteCache` | Omitted |
| `bail` | `boolean` | `--nxBail` | Omitted |
| `skipSync` | `boolean` | `--skipSync` | Omitted |
| `graph` | `string` | `--graph=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `show_projects`

Print matching project names as JSON without running targets.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `affected` | `boolean` | `--affected` | Omitted |
| `base` | `string` | `--base=<value>` | Omitted |
| `head` | `string` | `--head=<value>` | Omitted |
| `files` | `string (CSV)` | `--files=<comma-separated values>` | Omitted |
| `projects` | `string (CSV)` | `--projects=<comma-separated values>` | Omitted |
| `withTargets` | `string (CSV)` | `--withTarget=<comma-separated values>` | Omitted |
| `exclude` | `string (CSV)` | `--exclude=<comma-separated values>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `show_project`

Print the resolved configuration of a project.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `projectName` | `string` | `<projectName>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `graph`

Write a project graph without opening a browser.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `file` | `string` | `--file=<value>` | Required |
| `focus` | `string` | `--focus=<value>` | Omitted |
| `affected` | `boolean` | `--affected` | Omitted |
| `base` | `string` | `--base=<value>` | Omitted |
| `head` | `string` | `--head=<value>` | Omitted |
| `files` | `string (CSV)` | `--files=<comma-separated values>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `format_check`

Fail when selected workspace files are not formatted.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `base` | `string` | `--base=<value>` | Omitted |
| `head` | `string` | `--head=<value>` | Omitted |
| `files` | `string (CSV)` | `--files=<comma-separated values>` | Omitted |
| `projects` | `string (CSV)` | `--projects=<comma-separated values>` | Omitted |
| `all` | `boolean` | `--all` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `sync_check`

Fail when workspace sync generators would change files.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `report`

Print Nx workspace and plugin version diagnostics.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |
