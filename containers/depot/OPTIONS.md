# Depot module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` is a comma-separated NAME=PATH string in the public component contract.

## `run`

Run any Depot CLI command using literal comma-separated tokens.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Required |

## `version`

Report the installed Depot CLI version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `build`

Build container images on Depot remote builders, optionally pushing, loading, or saving the result.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `projectId` | `string` | `--project=<value>` | Omitted |
| `file` | `string` | `--file=<value>` | Omitted |
| `tags` | `string (CSV)` | `--tag=<value>` | Omitted |
| `platforms` | `string (CSV)` | `--platform=<comma-separated values>` | Omitted |
| `buildArgs` | `string (CSV)` | `--build-arg=<value>` | Omitted |
| `labels` | `string (CSV)` | `--label=<value>` | Omitted |
| `secrets` | `string (CSV)` | `--secret=<value>` | Omitted |
| `ssh` | `string (CSV)` | `--ssh=<value>` | Omitted |
| `cacheFrom` | `string (CSV)` | `--cache-from=<value>` | Omitted |
| `cacheTo` | `string (CSV)` | `--cache-to=<value>` | Omitted |
| `target` | `string` | `--target=<value>` | Omitted |
| `output` | `string` | `--output=<value>` | Omitted |
| `metadataFile` | `string` | `--metadata-file=<value>` | Omitted |
| `progress` | `string (auto, plain, tty, rawjson)` | `--progress=<value>` | `"plain"` |
| `buildPlatform` | `string (dynamic, linux/amd64, linux/arm64)` | `--build-platform=<value>` | Omitted |
| `push` | `boolean` | `--push` | Omitted |
| `load` | `boolean` | `--load` | Omitted |
| `save` | `boolean` | `--save` | Omitted |
| `pull` | `boolean` | `--pull` | Omitted |
| `noCache` | `boolean` | `--no-cache` | Omitted |
| `lint` | `boolean` | `--lint` | Omitted |
| `context` | `string` | `<context>` | `"."` |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `bake`

Build multiple targets from Bake or Compose definitions.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `projectId` | `string` | `--project=<value>` | Omitted |
| `files` | `string (CSV)` | `--file=<value>` | Omitted |
| `set` | `string (CSV)` | `--set=<value>` | Omitted |
| `targets` | `string (CSV)` | `<targets>` | Omitted |
| `push` | `boolean` | `--push` | Omitted |
| `load` | `boolean` | `--load` | Omitted |
| `print` | `boolean` | `--print` | Omitted |
| `noCache` | `boolean` | `--no-cache` | Omitted |
| `metadataFile` | `string` | `--metadata-file=<value>` | Omitted |
| `progress` | `string` | `--progress=<value>` | `"plain"` |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `cache_reset`

Reset the selected project build cache.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `projectId` | `string` | `--project=<value>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `list_builds`

List recent builds with machine-readable output.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `projectId` | `string` | `--project=<value>` | Omitted |
| `output` | `string (json, csv)` | `--output=<value>` | `"json"` |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `projects_list`

List accessible projects without opening an interactive selector.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `output` | `string (json, csv)` | `--output=<value>` | `"json"` |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `projects_get`

Read project configuration using an organization token.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `projectId` | `string` | `--project-id=<value>` | Omitted |
| `output` | `string (json)` | `--output=<value>` | `"json"` |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `projects_create`

Create a Depot project with explicit organization and build storage settings.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `name` | `string` | `<name>` | Required |
| `organization` | `string` | `--organization=<value>` | Omitted |
| `region` | `string` | `--region=<value>` | Omitted |
| `cacheStoragePolicy` | `integer` | `--cache-storage-policy=<value>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `build_cancel`

Cancel selected builds or explicitly preview/bulk-cancel running project builds. Requires an organization API token.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `projectId` | `string` | `--project=<value>` | Omitted |
| `buildIds` | `string (CSV)` | `<buildIds>` | Omitted |
| `allRunning` | `boolean` | `--all-running` | Omitted |
| `dryRun` | `boolean` | `--dry-run` | Omitted |
| `yes` | `boolean` | `--yes` | Omitted |
| `output` | `string (json)` | `--output=<value>` | `"json"` |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `configure_docker`

Configure or remove Depot Docker integration; requires Docker.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `uninstall` | `boolean` | `--uninstall` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |
