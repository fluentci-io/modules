# glab component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `setup`

Ensure glab is installed and verified, reusing an available matching version, and publish its environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `version` | `string` | no | Tool release or supported channel to install; omitted values use the documented default. |
| `install-dir` | `string` | no | Absolute per-user installation prefix; omit for native package installations. |
| `package-name` | `string` | no | Native package or port selector overriding the default repository package name. |
| `sudo` | `boolean` | no | Use noninteractive sudo for native package or system installation; defaults to false. |

Returns `Contract.SetupResult`.

## `run`

Run any native glab command with literal argv.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | yes | Required comma-separated glab command and literal argument tokens; never JSON. |

Returns `Contract.ExecutionResult`.

## `version`

Report the installed glab CLI version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `auth-status`

Check inherited GitLab authentication without interactive login.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `hostname` | `string` | no | GitLab hostname to inspect. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `repo-view`

Inspect GitLab repository metadata without opening a browser.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `mr-create`

Create a noninteractive merge request with explicit title and description.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `title` | `string` | yes | Merge request title. |
| `description` | `string` | yes | Literal merge request description. |
| `source-branch` | `string` | no | Source branch. |
| `target-branch` | `string` | no | Target branch. |
| `draft` | `boolean` | no | Create a draft merge request. |
| `yes` | `boolean` | no | Skip confirmation after explicit title and description. Default: true. |
| `labels` | `string` | no | Comma-separated label names. Empty entries are rejected; CSV quotes preserve literal commas. |
| `reviewers` | `string` | no | Comma-separated reviewer handles. Empty entries are rejected; CSV quotes preserve literal commas. |
| `assignees` | `string` | no | Comma-separated assignee handles. Empty entries are rejected; CSV quotes preserve literal commas. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `mr-view`

Read a merge request and its state.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `number` | `string` | yes | Merge request IID, branch or URL selector. |
| `output` | `string` | no | Result format. Default: "json". Allowed values: json, text. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `mr-list`

List merge requests in a machine-readable format.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `source-branch` | `string` | no | Source branch filter. |
| `target-branch` | `string` | no | Target branch filter. |
| `output` | `string` | no | Result format. Default: "json". Allowed values: json, text. |
| `per-page` | `integer` | no | Results per page. Default: 30. |
| `page` | `integer` | no | Page number. Default: 1. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `mr-checkout`

Check out a merge request locally.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `number` | `string` | yes | Merge request IID, branch or URL selector. |
| `branch` | `string` | no | Local branch name. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `mr-note`

Publish a pipeline comment on a merge request.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `number` | `string` | yes | Merge request IID, branch or URL selector. |
| `message` | `string` | yes | Literal merge request comment. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `mr-merge`

Merge a selected merge request; source branch deletion remains opt-in.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `number` | `string` | yes | Merge request IID, branch or URL selector. |
| `yes` | `boolean` | no | Skip confirmation for this explicitly requested merge. Default: true. |
| `squash` | `boolean` | no | Squash commits before merging. |
| `remove-source-branch` | `boolean` | no | Explicitly delete the source branch after merge. |
| `sha` | `string` | no | Expected source commit SHA. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `release-create`

Create a GitLab release and attach optional assets; existing releases are protected by default.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `tag` | `string` | yes | Release tag. |
| `files` | `string` | no | Optional asset paths. |
| `name` | `string` | no | Release title. |
| `notes` | `string` | no | Literal release notes. |
| `notes-file` | `string` | no | Existing release-notes file. |
| `ref` | `string` | no | Commit or branch used when creating a missing tag. |
| `no-update` | `boolean` | no | Refuse to update an existing release. Default: true. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `release-upload`

Upload files to an existing GitLab release.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `tag` | `string` | yes | Existing release tag. |
| `files` | `string` | yes | Required comma-separated existing release asset paths. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `release-download`

Download selected GitLab release assets.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `tag` | `string` | no | Release tag; omitted selects the native latest release. |
| `asset-names` | `string` | no | Comma-separated asset filename patterns. Empty entries are rejected; CSV quotes preserve literal commas. |
| `directory` | `string` | no | Destination directory. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `ci-run`

Create a GitLab pipeline with named variables or inputs.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `branch` | `string` | no | Branch or ref to run. |
| `mr` | `boolean` | no | Run the merge request pipeline. |
| `variables` | `string` | no | Comma-separated KEY:VALUE pipeline variables. Empty entries are rejected; CSV quotes preserve literal commas. |
| `inputs` | `string` | no | Comma-separated KEY:VALUE or KEY:type(value) pipeline inputs. Empty entries are rejected; CSV quotes preserve literal commas. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `ci-status`

Inspect or watch a GitLab pipeline status.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `branch` | `string` | no | Branch selector. |
| `live` | `boolean` | no | Watch pipeline status until completion. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `ci-get`

Read detailed pipeline information.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `pipeline-id` | `integer` | no | Pipeline ID. |
| `branch` | `string` | no | Branch selector. |
| `output` | `string` | no | Result format. Default: "json". Allowed values: json, text. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `ci-retry`

Retry one explicitly selected GitLab CI job, optionally within a selected pipeline.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `job` | `string` | yes | Required job ID or job name; prevents interactive job selection. |
| `pipeline-id` | `integer` | no | Pipeline to search for the selected job. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `ci-cancel`

Cancel one explicitly selected pipeline using glab ci cancel pipeline.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `pipeline-id` | `integer` | yes | Pipeline ID to cancel. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `ci-lint`

Validate GitLab CI configuration using the native server lint API.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Target OWNER/REPO, GitLab group/project, or repository URL; omit to use the local checkout. |
| `file` | `string` | no | Existing GitLab CI configuration file. |
| `dry-run` | `boolean` | no | Simulate pipeline creation. |
| `ref` | `string` | no | Branch or tag used for simulation. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `api`

Call the authenticated GitLab API with scalar fields or a body file.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `endpoint` | `string` | yes | GitLab API endpoint path. |
| `method` | `string` | no | HTTP request method. |
| `hostname` | `string` | no | GitLab hostname. |
| `fields` | `string` | no | Comma-separated request KEY=VALUE fields. Empty entries are rejected; CSV quotes preserve literal commas. |
| `input-file` | `string` | no | Existing request-body file. |
| `paginate` | `boolean` | no | Fetch every result page. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.
