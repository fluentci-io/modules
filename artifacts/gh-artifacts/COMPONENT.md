# gh-artifacts component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `run`

Execute arbitrary literal CLI arguments.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | yes | Comma-separated arguments; whitespace is trimmed and values are passed as literal native tokens. |

Returns `Contract.ExecutionResult`.

## `version`

Print the CLI version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `upload`

Upload job artifacts using GitHub Actions runtime credentials and the official artifact client.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `name` | `string` | yes | Name supplied to the gh-artifacts upload operation. |
| `root-directory` | `string` | no | Root Directory supplied to the gh-artifacts upload operation. Default: ".". |
| `retention-days` | `integer` | no | Retention Days supplied to the gh-artifacts upload operation. Default: 14. |
| `files` | `string` | yes | Comma-separated files; whitespace is trimmed and values are passed as literal native tokens. |

Returns `Contract.ExecutionResult`.

## `download`

download

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Repo supplied to the gh-artifacts download operation. |
| `dir` | `string` | no | Dir supplied to the gh-artifacts download operation. Default: "dist". |
| `name` | `string` | no | Comma-separated name; whitespace is trimmed and values are passed as literal native tokens. |
| `run-id` | `string` | yes | Run Id supplied to the gh-artifacts download operation. |

Returns `Contract.ExecutionResult`.

## `release-upload`

release upload

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Repo supplied to the gh-artifacts release_upload operation. |
| `clobber` | `boolean` | no | Clobber supplied to the gh-artifacts release_upload operation. |
| `tag` | `string` | yes | Tag supplied to the gh-artifacts release_upload operation. |
| `files` | `string` | yes | Comma-separated files; whitespace is trimmed and values are passed as literal native tokens. |

Returns `Contract.ExecutionResult`.

## `release-download`

release download

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | Repo supplied to the gh-artifacts release_download operation. |
| `dir` | `string` | no | Dir supplied to the gh-artifacts release_download operation. Default: "dist". |
| `pattern` | `string` | no | Comma-separated pattern; whitespace is trimmed and values are passed as literal native tokens. |
| `tag` | `string` | yes | Tag supplied to the gh-artifacts release_download operation. |

Returns `Contract.ExecutionResult`.
