# GitLab artifacts module arguments

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

## `upload`

Upload a prebuilt ZIP to the current job using GitLab job-token authentication.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `archive` | `string` | `<archive>` | Required |
| `jobId` | `string` | `<jobId>` | Required |
| `apiUrl` | `string` | `<apiUrl>` | `"https://gitlab.com/api/v4"` |

## `download`

download

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `job` | `string` | `--job=<value>` | Required |
| `path` | `string` | `--path=<value>` | `"dist"` |
| `ref` | `string` | `<ref>` | Required |

## `release_upload`

release upload

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `tag` | `string` | `<tag>` | Required |
| `files` | `strings` | `<files>` | Required |
