# git component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `setup`

Ensure git is installed and verified, reusing an available matching version, and publish its environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `version` | `string` | no | Tool release or supported channel to install; omitted values use the documented default. |
| `install-dir` | `string` | no | Absolute per-user installation prefix; omit for native package installations. |
| `package-name` | `string` | no | Native package or port selector overriding the default repository package name. |
| `sudo` | `boolean` | no | Use noninteractive sudo for native package or system installation; defaults to false. |

Returns `Contract.SetupResult`.

## `run`

Run any native git command with literal argv.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | yes | Required comma-separated git command and literal argument tokens; never JSON. |

Returns `Contract.ExecutionResult`.

## `version`

Report the installed git CLI version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `clone`

Clone a repository with optional shallow, partial and submodule checkout.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `branch` | `string` | no | Branch or tag to check out. |
| `depth` | `integer` | no | Positive shallow clone depth. |
| `filter` | `string` | no | Partial clone filter, for example blob:none. |
| `recursive` | `boolean` | no | Clone submodules recursively. |
| `single-branch` | `boolean` | no | Fetch only one branch. |
| `url` | `string` | yes | Repository URL or local source path. |
| `directory` | `string` | no | Destination checkout directory; native Git chooses the default when omitted. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `fetch`

Fetch selected refs and tags without merging them.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `prune` | `boolean` | no | Remove stale remote-tracking refs. |
| `tags` | `boolean` | no | Fetch all tags. |
| `depth` | `integer` | no | Positive shallow fetch depth. |
| `remote` | `string` | no | Remote name or URL. Default: "origin". |
| `refspecs` | `string` | no | Refspecs to fetch; omit for the remote defaults. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `checkout`

Check out a revision while retaining native dirty-worktree safety checks.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `detach` | `boolean` | no | Check out a detached revision. |
| `ref` | `string` | yes | Revision or existing branch to check out. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `status`

Inspect checkout and index state with stable machine-readable output.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `porcelain` | `string` | no | Stable machine-readable status format. Default: "v1". Allowed values: v1, v2. |
| `branch` | `boolean` | no | Include branch information. |
| `paths` | `string` | no | Optional pathspecs limiting status. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `diff`

Compare source revisions or the working tree and optionally fail on differences.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `exit-code` | `boolean` | no | Fail when differences exist. Default: true. |
| `cached` | `boolean` | no | Compare the staged index. |
| `stat` | `boolean` | no | Print a diff summary. |
| `revisions` | `string` | no | Optional revisions and path tokens in native order. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `log`

Read bounded commit history for release notes or change detection.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `max-count` | `integer` | no | Maximum commits to print. Default: 20. |
| `format` | `string` | no | Native Git log format. Default: "%H %s". |
| `revision` | `string` | no | Optional revision range. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `show`

Inspect a selected commit, tree or versioned file.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `format` | `string` | no | Native commit formatting string. |
| `stat` | `boolean` | no | Print changed-file statistics. |
| `object` | `string` | no | Revision or object:path selector. Default: "HEAD". |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `rev-parse`

Resolve an exact commit or object identifier.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `verify` | `boolean` | no | Require one valid revision. Default: true. |
| `revision` | `string` | no | Revision expression to resolve. Default: "HEAD". |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `describe`

Derive a release identifier from Git tags and commit history.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `tags` | `boolean` | no | Include lightweight tags. Default: true. |
| `always` | `boolean` | no | Fall back to an abbreviated object name. Default: true. |
| `match` | `string` | no | Tag name pattern. |
| `revision` | `string` | no | Commit to describe. Default: "HEAD". |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `add`

Stage explicitly selected paths without implicitly staging all files.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `paths` | `string` | yes | Required pathspecs to stage; directories are allowed. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `commit`

Create a commit from staged changes using the inherited Git author identity.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `message` | `string` | yes | Literal commit message; an editor is never opened. |
| `allow-empty` | `boolean` | no | Allow a commit with no staged changes. |
| `signoff` | `boolean` | no | Add a signoff trailer. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `tag`

Create an explicitly named release tag without forcing replacement.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `message` | `string` | no | Annotated tag message; omit for a lightweight tag. |
| `sign` | `boolean` | no | Cryptographically sign the tag using configured signing credentials. |
| `name` | `string` | yes | New tag name. |
| `target` | `string` | no | Commit or object to tag. Default: "HEAD". |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `push`

Push selected refs; force updates and tag publication are opt-in.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `tags` | `boolean` | no | Push all local tags. |
| `atomic` | `boolean` | no | Require atomic remote ref updates. |
| `set-upstream` | `boolean` | no | Set upstream tracking for pushed branches. |
| `force-with-lease` | `boolean` | no | Explicitly request guarded forced ref updates; omitted by default. |
| `remote` | `string` | no | Remote name or URL. Default: "origin". |
| `refspecs` | `string` | no | Optional refspecs in native order. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `pull`

Update the checkout, requiring a fast-forward by default.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `ff-only` | `boolean` | no | Require a fast-forward update. Default: true. |
| `remote` | `string` | no | Remote name or URL. Default: "origin". |
| `branch` | `string` | no | Optional branch to pull. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `submodule-update`

Initialize and update submodules at their committed revisions.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `init` | `boolean` | no | Initialize selected submodules. Default: true. |
| `recursive` | `boolean` | no | Update nested submodules. Default: true. |
| `depth` | `integer` | no | Positive shallow submodule depth. |
| `paths` | `string` | no | Optional submodule pathspecs. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `ls-remote`

Inspect remote refs without checking out or modifying repository contents.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `tags` | `boolean` | no | List tags only. |
| `heads` | `boolean` | no | List branch heads only. |
| `remote` | `string` | no | Remote URL or configured name. Default: "origin". |
| `patterns` | `string` | no | Optional ref-name patterns. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `archive`

Create a source release archive from a selected Git tree.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `format` | `string` | no | Archive format. Default: "tar". Allowed values: tar, zip. |
| `output` | `string` | yes | Destination archive file. |
| `prefix` | `string` | no | Prefix for paths inside the archive. |
| `tree` | `string` | no | Tree or commit to archive. Default: "HEAD". |
| `paths` | `string` | no | Optional paths to include. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `config-get`

Read one configured Git value without modifying configuration.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `key` | `string` | yes | Git configuration key to query. |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.

## `remote-get-url`

Read the configured repository remote URL.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `remote` | `string` | no | Remote name to inspect. Default: "origin". |
| `extra-args` | `string` | no | Comma-separated additional literal native tokens; no shell expansion. Empty entries are rejected; CSV quotes preserve literal commas. |

Returns `Contract.ExecutionResult`.
