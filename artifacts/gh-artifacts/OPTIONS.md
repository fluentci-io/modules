# GitHub artifacts module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` is a comma-separated NAME=PATH string in the public component contract.

## `run`

Execute arbitrary literal CLI arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Required |

## `version`

Print the CLI version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `upload`

Upload job artifacts using GitHub Actions runtime credentials and the official artifact client.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `name` | `string` | `<name>` | Required |
| `rootDirectory` | `string` | `<rootDirectory>` | `"."` |
| `retentionDays` | `integer` | `<retentionDays>` | `14` |
| `files` | `string (CSV)` | `<files>` | Required |

## `download`

download

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `dir` | `string` | `--dir=<value>` | `"dist"` |
| `name` | `string (CSV)` | `--name=<value>` | Omitted |
| `runId` | `string` | `<runId>` | Required |

## `release_upload`

release upload

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `clobber` | `boolean` | `--clobber` | Omitted |
| `tag` | `string` | `<tag>` | Required |
| `files` | `string (CSV)` | `<files>` | Required |

## `release_download`

release download

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `dir` | `string` | `--dir=<value>` | `"dist"` |
| `pattern` | `string (CSV)` | `--pattern=<value>` | Omitted |
| `tag` | `string` | `<tag>` | Required |
