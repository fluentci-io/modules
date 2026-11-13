# GitHub CLI module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` is a comma-separated NAME=PATH string in the public component contract.

## `run`

Run any native gh command with literal argv.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Required |

## `version`

Report the installed gh CLI version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `auth_status`

Check existing GitHub authentication without interactive login.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `hostname` | `string` | `--hostname=<value>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `repo_view`

Inspect repository metadata.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `<repo>` | Omitted |
| `jsonFields` | `string (CSV)` | `--json=<comma-separated values>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `pr_create`

Create a pull request with explicit noninteractive title and description.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `title` | `string` | `--title=<value>` | Required |
| `body` | `string` | `--body=<value>` | Required |
| `base` | `string` | `--base=<value>` | Omitted |
| `head` | `string` | `--head=<value>` | Omitted |
| `draft` | `boolean` | `--draft` | Omitted |
| `labels` | `string (CSV)` | `--label=<value>` | Omitted |
| `reviewers` | `string (CSV)` | `--reviewer=<value>` | Omitted |
| `assignees` | `string (CSV)` | `--assignee=<value>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `pr_view`

Read a pull request and its review state.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `number` | `string` | `<number>` | Required |
| `jsonFields` | `string (CSV)` | `--json=<comma-separated values>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `pr_list`

List pull requests for automated review or release workflows.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `state` | `string (open, closed, merged, all)` | `--state=<value>` | `"open"` |
| `base` | `string` | `--base=<value>` | Omitted |
| `head` | `string` | `--head=<value>` | Omitted |
| `limit` | `integer` | `--limit=<value>` | `30` |
| `jsonFields` | `string (CSV)` | `--json=<comma-separated values>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `pr_checkout`

Check out a pull request into the working tree.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `number` | `string` | `<number>` | Required |
| `branch` | `string` | `--branch=<value>` | Omitted |
| `detach` | `boolean` | `--detach` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `pr_checks`

Inspect or wait for pull request checks; native failing and pending statuses propagate.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `number` | `string` | `<number>` | Required |
| `watch` | `boolean` | `--watch` | Omitted |
| `failFast` | `boolean` | `--fail-fast` | Omitted |
| `required` | `boolean` | `--required` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `pr_comment`

Publish a pipeline comment to a pull request.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `number` | `string` | `<number>` | Required |
| `body` | `string` | `--body=<value>` | Required |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `pr_merge`

Merge a reviewed pull request using an explicitly selected strategy; branch deletion is opt-in.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `method` | `string (squash, merge, rebase)` | `--<value>` | Required |
| `number` | `string` | `<number>` | Required |
| `auto` | `boolean` | `--auto` | Omitted |
| `deleteBranch` | `boolean` | `--delete-branch` | Omitted |
| `matchHeadCommit` | `string` | `--match-head-commit=<value>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `release_create`

Create a GitHub release and optionally attach release assets.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `tag` | `string` | `<tag>` | Required |
| `files` | `string (CSV)` | `<files>` | Omitted |
| `title` | `string` | `--title=<value>` | Omitted |
| `notes` | `string` | `--notes=<value>` | Omitted |
| `notesFile` | `string` | `--notes-file=<value>` | Omitted |
| `target` | `string` | `--target=<value>` | Omitted |
| `draft` | `boolean` | `--draft` | Omitted |
| `prerelease` | `boolean` | `--prerelease` | Omitted |
| `generateNotes` | `boolean` | `--generate-notes` | Omitted |
| `verifyTag` | `boolean` | `--verify-tag` | `true` |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `release_upload`

Upload assets to an existing release; replacement is opt-in.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `tag` | `string` | `<tag>` | Required |
| `files` | `string (CSV)` | `<files>` | Required |
| `clobber` | `boolean` | `--clobber` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `release_download`

Download selected release assets.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `tag` | `string` | `<tag>` | Omitted |
| `patterns` | `string (CSV)` | `--pattern=<value>` | Omitted |
| `directory` | `string` | `--dir=<value>` | Omitted |
| `clobber` | `boolean` | `--clobber` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `workflow_run`

Dispatch a GitHub Actions workflow with named scalar inputs.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `workflow` | `string` | `<workflow>` | Required |
| `ref` | `string` | `--ref=<value>` | Omitted |
| `inputs` | `string (CSV)` | `--raw-field=<value>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `run_list`

List workflow runs for pipeline orchestration.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `workflow` | `string` | `--workflow=<value>` | Omitted |
| `branch` | `string` | `--branch=<value>` | Omitted |
| `status` | `string` | `--status=<value>` | Omitted |
| `limit` | `integer` | `--limit=<value>` | `20` |
| `jsonFields` | `string (CSV)` | `--json=<comma-separated values>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `run_view`

Inspect a workflow run and propagate its failure status.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `runId` | `string` | `<runId>` | Required |
| `exitStatus` | `boolean` | `--exit-status` | `true` |
| `log` | `boolean` | `--log` | Omitted |
| `jsonFields` | `string (CSV)` | `--json=<comma-separated values>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `run_watch`

Wait for a workflow run and propagate failure to the pipeline.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `runId` | `string` | `<runId>` | Required |
| `exitStatus` | `boolean` | `--exit-status` | `true` |
| `interval` | `integer` | `--interval=<value>` | `3` |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `run_rerun`

Rerun a selected workflow run or its failed jobs.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `runId` | `string` | `<runId>` | Required |
| `failed` | `boolean` | `--failed` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `run_cancel`

Cancel a selected workflow run.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string` | `--repo=<value>` | Omitted |
| `runId` | `string` | `<runId>` | Required |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `api`

Call the authenticated GitHub API using scalar fields or a request file.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `endpoint` | `string` | `<endpoint>` | Required |
| `method` | `string` | `--method=<value>` | Omitted |
| `hostname` | `string` | `--hostname=<value>` | Omitted |
| `fields` | `string (CSV)` | `--raw-field=<value>` | Omitted |
| `inputFile` | `string` | `--input=<value>` | Omitted |
| `paginate` | `boolean` | `--paginate` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |
