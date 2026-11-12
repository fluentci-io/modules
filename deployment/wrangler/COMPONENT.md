# wrangler component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `run`

Run a Wrangler operation with literal arguments.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `arguments` | `array` | yes | Literal Wrangler argument tokens. |

Returns `Contract.ExecutionResult`.

## `version`

Report the installed Wrangler version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |

Returns `Contract.ExecutionResult`.

## `deploy`

Deploy a Worker using existing Cloudflare credentials.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `config` | `string` | no | Path to the Wrangler configuration file. |
| `env` | `string` | no | Named Wrangler environment to deploy. |
| `name` | `string` | no | Cloudflare Worker name overriding project configuration. |
| `outdir` | `string` | no | Directory for generated Worker bundle files. |
| `minify` | `boolean` | no | Minify the generated Worker bundle. |
| `script` | `string` | no | Optional Worker entrypoint; omitted values use project configuration. |

Returns `Contract.ExecutionResult`.

## `dry-run`

Bundle a Worker locally without deploying it.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `config` | `string` | no | Path to the Wrangler configuration file. |
| `env` | `string` | no | Named Wrangler environment to deploy. |
| `name` | `string` | no | Cloudflare Worker name overriding project configuration. |
| `outdir` | `string` | no | Directory for generated Worker bundle files. |
| `minify` | `boolean` | no | Minify the generated Worker bundle. |
| `script` | `string` | no | Optional Worker entrypoint; omitted values use project configuration. |

Returns `Contract.ExecutionResult`.

## `versions-upload`

Upload a Worker version without deploying it to traffic.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `config` | `string` | no | Path to the Wrangler configuration file. |
| `env` | `string` | no | Named Wrangler environment to deploy. |
| `name` | `string` | no | Cloudflare Worker name overriding project configuration. |
| `outdir` | `string` | no | Directory for generated Worker bundle files. |
| `minify` | `boolean` | no | Minify the generated Worker bundle. |
| `script` | `string` | no | Optional Worker entrypoint; omitted values use project configuration. |

Returns `Contract.ExecutionResult`.

## `pages-deploy`

Deploy a built site to an existing Cloudflare Pages project.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `project-name` | `string` | yes | Existing Cloudflare Pages project name. |
| `branch` | `string` | no | Git branch name identifying the production or preview deployment. |
| `commit-hash` | `string` | no | Git commit SHA attached to the deployment. |
| `directory` | `string` | yes | Directory containing the built static site to upload. |

Returns `Contract.ExecutionResult`.

## `pages-projects`

List Cloudflare Pages projects available to the authenticated account.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |

Returns `Contract.ExecutionResult`.
