# nix-publish component functions

Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `check`

Evaluate and build flake checks without modifying flake.lock.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `flake` | `string` | no | Local flake path or reference to inspect; defaults to the selected project checkout. Default: ".". |

Returns `Contract.ExecutionResult`.

## `metadata`

Inspect locked flake metadata as JSON without modifying flake.lock.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `flake` | `string` | no | Local flake path or reference to inspect; defaults to the selected project checkout. Default: ".". |

Returns `Contract.ExecutionResult`.

## `outputs`

Inspect flake outputs for every supported system as JSON.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `flake` | `string` | no | Local flake path or reference to inspect; defaults to the selected project checkout. Default: ".". |

Returns `Contract.ExecutionResult`.

## `flakehub`

Publish the checked-out flake release to FlakeHub using GitHub OIDC.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `name` | `string` | yes | FlakeHub flake name as OWNER/REPOSITORY; no repository name is hardcoded. |
| `version` | `string` | yes | Release tag to publish, such as v1.2.3. |
| `visibility` | `string` | no | Flake visibility: public, unlisted, or private. Default: "public". Allowed values: public, unlisted, private. |

Returns `Contract.ExecutionResult`.

## `flakestry`

Publish locked flake metadata and outputs to Flakestry using GitHub OIDC.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `version` | `string` | yes | Release version or tag to publish, such as v1.2.3. |
| `ref` | `string` | yes | Git commit SHA corresponding to the selected release and checkout. |
| `readme` | `string` | no | Repository-relative README filename used by the Flakestry registry. Default: "README.md". |
| `url` | `string` | no | HTTPS Flakestry registry origin; also used as the GitHub OIDC audience. Default: "https://flakestry.dev". |
| `ignore-conflicts` | `boolean` | no | Treat HTTP 409 for an existing release as success; other HTTP errors still fail. Default: false. |

Returns `Contract.ExecutionResult`.
