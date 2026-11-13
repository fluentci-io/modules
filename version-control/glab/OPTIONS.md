# GitLab CLI module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` is a comma-separated NAME=PATH string in the public component contract.

## `run`

Run any native glab command with literal argv.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Required |

## `version`

Report the installed glab CLI version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `auth_status`

Check inherited GitLab authentication without interactive login.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `hostname` | `string` | `--hostname=<value>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `repo_view`

Inspect GitLab repository metadata without opening a browser.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `mr_create`

Create a noninteractive merge request with explicit title and description.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `title` | `string` | `--title=<value>` | Required |
| `description` | `string` | `--description=<value>` | Required |
| `sourceBranch` | `string` | `--source-branch=<value>` | Omitted |
| `targetBranch` | `string` | `--target-branch=<value>` | Omitted |
| `draft` | `boolean` | `--draft` | Omitted |
| `yes` | `boolean` | `--yes` | `true` |
| `labels` | `string (CSV)` | `--label=<value>` | Omitted |
| `reviewers` | `string (CSV)` | `--reviewer=<value>` | Omitted |
| `assignees` | `string (CSV)` | `--assignee=<value>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `mr_view`

Read a merge request and its state.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `number` | `string` | `<number>` | Required |
| `output` | `string (json, text)` | `--output=<value>` | `"json"` |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `mr_list`

List merge requests in a machine-readable format.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `sourceBranch` | `string` | `--source-branch=<value>` | Omitted |
| `targetBranch` | `string` | `--target-branch=<value>` | Omitted |
| `output` | `string (json, text)` | `--output=<value>` | `"json"` |
| `perPage` | `integer` | `--per-page=<value>` | `30` |
| `page` | `integer` | `--page=<value>` | `1` |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `mr_checkout`

Check out a merge request locally.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `number` | `string` | `<number>` | Required |
| `branch` | `string` | `--branch=<value>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `mr_note`

Publish a pipeline comment on a merge request.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `number` | `string` | `<number>` | Required |
| `message` | `string` | `--message=<value>` | Required |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `mr_merge`

Merge a selected merge request; source branch deletion remains opt-in.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `number` | `string` | `<number>` | Required |
| `yes` | `boolean` | `--yes` | `true` |
| `squash` | `boolean` | `--squash` | Omitted |
| `removeSourceBranch` | `boolean` | `--remove-source-branch` | Omitted |
| `sha` | `string` | `--sha=<value>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `release_create`

Create a GitLab release and attach optional assets; existing releases are protected by default.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `tag` | `string` | `<tag>` | Required |
| `files` | `string (CSV)` | `<files>` | Omitted |
| `name` | `string` | `--name=<value>` | Omitted |
| `notes` | `string` | `--notes=<value>` | Omitted |
| `notesFile` | `string` | `--notes-file=<value>` | Omitted |
| `ref` | `string` | `--ref=<value>` | Omitted |
| `noUpdate` | `boolean` | `--no-update` | `true` |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `release_upload`

Upload files to an existing GitLab release.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `tag` | `string` | `<tag>` | Required |
| `files` | `string (CSV)` | `<files>` | Required |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `release_download`

Download selected GitLab release assets.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `tag` | `string` | `<tag>` | Omitted |
| `assetNames` | `string (CSV)` | `--asset-name=<value>` | Omitted |
| `directory` | `string` | `--dir=<value>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `ci_run`

Create a GitLab pipeline with named variables or inputs.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `branch` | `string` | `--branch=<value>` | Omitted |
| `mr` | `boolean` | `--mr` | Omitted |
| `variables` | `string (CSV)` | `--variables-env=<value>` | Omitted |
| `inputs` | `string (CSV)` | `--input=<value>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `ci_status`

Inspect or watch a GitLab pipeline status.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `branch` | `string` | `--branch=<value>` | Omitted |
| `live` | `boolean` | `--live` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `ci_get`

Read detailed pipeline information.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `pipelineId` | `integer` | `--pipeline-id=<value>` | Omitted |
| `branch` | `string` | `--branch=<value>` | Omitted |
| `output` | `string (json, text)` | `--output=<value>` | `"json"` |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `ci_retry`

Retry one explicitly selected GitLab CI job, optionally within a selected pipeline.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `job` | `string` | `<job>` | Required |
| `pipelineId` | `integer` | `--pipeline-id=<value>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `ci_cancel`

Cancel one explicitly selected pipeline using glab ci cancel pipeline.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `pipelineId` | `integer` | `<pipelineId>` | Required |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `ci_lint`

Validate GitLab CI configuration using the native server lint API.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `file` | `string` | `<file>` | Omitted |
| `dryRun` | `boolean` | `--dry-run` | Omitted |
| `ref` | `string` | `--ref=<value>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `api`

Call the authenticated GitLab API with scalar fields or a body file.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `endpoint` | `string` | `<endpoint>` | Required |
| `method` | `string` | `--method=<value>` | Omitted |
| `hostname` | `string` | `--hostname=<value>` | Omitted |
| `fields` | `string (CSV)` | `--raw-field=<value>` | Omitted |
| `inputFile` | `string` | `--input=<value>` | Omitted |
| `paginate` | `boolean` | `--paginate` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |
