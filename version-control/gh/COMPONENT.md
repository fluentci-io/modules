# gh component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `setup`

Ensure gh is installed and verified, reusing an available matching version, and publish its environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `version` | `string` | no | Tool release or supported channel to install; omitted values use the documented default. |
| `install-dir` | `string` | no | Absolute per-user installation prefix; omit for native package installations. |
| `package-name` | `string` | no | Native package or port selector overriding the default repository package name. |
| `sudo` | `boolean` | no | Use noninteractive sudo for native package or system installation; defaults to false. |

Returns `Contract.SetupResult`.

## `run`

Run any native gh command with literal argv.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | yes | Required comma-separated gh command and literal argument tokens; never JSON. |

Returns `Contract.ExecutionResult`.

## `version`

Report the installed gh CLI version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `auth-status`

Check existing GitHub authentication without interactive login.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `hostname` | `string` | no | GitHub hostname to inspect. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `repo-view`

Inspect repository metadata.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Repository OWNER/REPO or URL; omit to use the current checkout. |
| `json-fields` | `string` | no | Comma-separated result field names, such as name,url,defaultBranchRef. Empty entries are rejected; CSV quotes preserve literal commas. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `pr-create`

Create a pull request with explicit noninteractive title and description.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `title` | `string` | yes | Pull request title. |
| `body` | `string` | yes | Literal pull request description; no editor is opened. |
| `base` | `string` | no | Base branch. |
| `head` | `string` | no | Head branch or OWNER:BRANCH. |
| `draft` | `boolean` | no | Create a draft pull request. |
| `labels` | `string` | no | Comma-separated label names. Empty entries are rejected; CSV quotes preserve literal commas. |
| `reviewers` | `string` | no | Comma-separated reviewer handles or team names. Empty entries are rejected; CSV quotes preserve literal commas. |
| `assignees` | `string` | no | Comma-separated assignee handles. Empty entries are rejected; CSV quotes preserve literal commas. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `pr-view`

Read a pull request and its review state.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `number` | `string` | yes | Pull request number, URL or branch selector. |
| `json-fields` | `string` | no | Comma-separated result fields. Empty entries are rejected; CSV quotes preserve literal commas. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `pr-list`

List pull requests for automated review or release workflows.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `state` | `string` | no | Pull request state filter. Default: "open". Allowed values: open, closed, merged, all. |
| `base` | `string` | no | Base branch filter. |
| `head` | `string` | no | Head branch filter. |
| `limit` | `integer` | no | Maximum results. Default: 30. |
| `json-fields` | `string` | no | Comma-separated result fields. Empty entries are rejected; CSV quotes preserve literal commas. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `pr-checkout`

Check out a pull request into the working tree.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `number` | `string` | yes | Pull request number, URL or branch selector. |
| `branch` | `string` | no | Local branch name. |
| `detach` | `boolean` | no | Use a detached checkout. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `pr-checks`

Inspect or wait for pull request checks; native failing and pending statuses propagate.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `number` | `string` | yes | Pull request number, URL or branch selector. |
| `watch` | `boolean` | no | Wait for checks to complete. |
| `fail-fast` | `boolean` | no | Stop watching after the first failed check. |
| `required` | `boolean` | no | Show required checks only. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `pr-comment`

Publish a pipeline comment to a pull request.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `number` | `string` | yes | Pull request number, URL or branch selector. |
| `body` | `string` | yes | Literal review or pipeline comment. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `pr-merge`

Merge a reviewed pull request using an explicitly selected strategy; branch deletion is opt-in.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `method` | `string` | yes | Required merge strategy: squash, merge, or rebase; no interactive selection. Allowed values: squash, merge, rebase. |
| `number` | `string` | yes | Pull request number, URL or branch selector. |
| `auto` | `boolean` | no | Enable automatic merge after checks pass. |
| `delete-branch` | `boolean` | no | Delete the branch after merge. |
| `match-head-commit` | `string` | no | Require the expected head commit before merging. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `release-create`

Create a GitHub release and optionally attach release assets.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `tag` | `string` | yes | Release tag. |
| `files` | `string` | no | Optional existing release asset paths; filenames must be literal, without shell globs. |
| `title` | `string` | no | Release title. |
| `notes` | `string` | no | Literal release notes. |
| `notes-file` | `string` | no | Existing release-notes file. |
| `target` | `string` | no | Commit or branch used for a missing tag. |
| `draft` | `boolean` | no | Create a draft release. |
| `prerelease` | `boolean` | no | Mark as a prerelease. |
| `generate-notes` | `boolean` | no | Generate release notes on GitHub. |
| `verify-tag` | `boolean` | no | Require the tag to already exist. Default: true. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `release-upload`

Upload assets to an existing release; replacement is opt-in.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `tag` | `string` | yes | Existing release tag. |
| `files` | `string` | yes | Required comma-separated existing asset paths. |
| `clobber` | `boolean` | no | Explicitly replace existing assets with matching names. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `release-download`

Download selected release assets.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `tag` | `string` | no | Release tag; omitted selects the native latest release. |
| `patterns` | `string` | no | Comma-separated asset filename patterns. Empty entries are rejected; CSV quotes preserve literal commas. |
| `directory` | `string` | no | Destination download directory. |
| `clobber` | `boolean` | no | Explicitly overwrite existing files. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `workflow-run`

Dispatch a GitHub Actions workflow with named scalar inputs.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `workflow` | `string` | yes | Workflow ID, name or filename. |
| `ref` | `string` | no | Branch or tag to dispatch. |
| `inputs` | `string` | no | Comma-separated workflow input KEY=VALUE entries; values stay strings. Empty entries are rejected; CSV quotes preserve literal commas. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `run-list`

List workflow runs for pipeline orchestration.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `workflow` | `string` | no | Workflow selector. |
| `branch` | `string` | no | Branch filter. |
| `status` | `string` | no | Native run status filter. |
| `limit` | `integer` | no | Maximum results. Default: 20. |
| `json-fields` | `string` | no | Comma-separated result fields. Empty entries are rejected; CSV quotes preserve literal commas. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `run-view`

Inspect a workflow run and propagate its failure status.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `run-id` | `string` | yes | Workflow run ID. |
| `exit-status` | `boolean` | no | Fail when the run failed. Default: true. |
| `log` | `boolean` | no | Print job logs. |
| `json-fields` | `string` | no | Comma-separated result fields. Empty entries are rejected; CSV quotes preserve literal commas. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `run-watch`

Wait for a workflow run and propagate failure to the pipeline.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `run-id` | `string` | yes | Workflow run ID. |
| `exit-status` | `boolean` | no | Fail when the watched run failed. Default: true. |
| `interval` | `integer` | no | Polling interval in seconds. Default: 3. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `run-rerun`

Rerun a selected workflow run or its failed jobs.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `run-id` | `string` | yes | Workflow run ID. |
| `failed` | `boolean` | no | Rerun only failed jobs. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `run-cancel`

Cancel a selected workflow run.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `run-id` | `string` | yes | Workflow run ID. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `api`

Call the authenticated GitHub API using scalar fields or a request file.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `endpoint` | `string` | yes | GitHub REST endpoint or graphql. |
| `method` | `string` | no | HTTP method such as GET or POST. |
| `hostname` | `string` | no | GitHub hostname. |
| `fields` | `string` | no | Comma-separated request KEY=VALUE fields. Empty entries are rejected; CSV quotes preserve literal commas. |
| `input-file` | `string` | no | Existing request-body file; no JSON object is required as a CLI argument. |
| `paginate` | `boolean` | no | Fetch all response pages. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.
