# playwright component functions

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
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `arguments` | `array` | yes | Literal native CLI argument tokens, passed without shell expansion. |

Returns `Contract.ExecutionResult`.

## `version`

Print the CLI version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |

Returns `Contract.ExecutionResult`.

## `setup`

Install the test framework in project using Bun. Browser binaries are installed separately with install.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `version` | `string` | no | Framework version or release tag to install with Bun. Default: "latest". |

Returns `Contract.ExecutionResult`.

## `test`

Run Playwright Test headlessly, optionally filtering projects and tests.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `config` | `string` | no | Named configuration selected by the native tool. |
| `test-project` | `array` | no | Test Project supplied to the playwright test operation. |
| `grep` | `string` | no | Grep supplied to the playwright test operation. |
| `grep-invert` | `string` | no | Grep Invert supplied to the playwright test operation. |
| `workers` | `integer` | no | Workers supplied to the playwright test operation. |
| `reporter` | `string` | no | Reporter supplied to the playwright test operation. |
| `output` | `string` | no | Destination path for generated packages. |
| `retries` | `integer` | no | Retries supplied to the playwright test operation. |
| `shard` | `string` | no | Shard supplied to the playwright test operation. |
| `forbid-only` | `boolean` | no | Forbid Only supplied to the playwright test operation. |
| `fail-on-flaky-tests` | `boolean` | no | Fail On Flaky Tests supplied to the playwright test operation. |
| `update-snapshots` | `boolean` | no | Update Snapshots supplied to the playwright test operation. |
| `tests` | `array` | no | Tests supplied to the playwright test operation. Default: []. |

Returns `Contract.ExecutionResult`.

## `list`

List matching tests without launching browsers.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `config` | `string` | no | Named configuration selected by the native tool. |
| `test-project` | `array` | no | Test Project supplied to the playwright list operation. |
| `grep` | `string` | no | Grep supplied to the playwright list operation. |
| `grep-invert` | `string` | no | Grep Invert supplied to the playwright list operation. |
| `workers` | `integer` | no | Workers supplied to the playwright list operation. |
| `tests` | `array` | no | Tests supplied to the playwright list operation. Default: []. |

Returns `Contract.ExecutionResult`.

## `install`

Install browser binaries matching the installed Playwright package.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `with-deps` | `boolean` | no | With Deps supplied to the playwright install operation. |
| `only-shell` | `boolean` | no | Only Shell supplied to the playwright install operation. |
| `browsers` | `array` | no | Browsers supplied to the playwright install operation. Default: []. |

Returns `Contract.ExecutionResult`.

## `install-deps`

Install operating-system browser dependencies; may require elevated privileges.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `browsers` | `array` | no | Browsers supplied to the playwright install_deps operation. Default: []. |

Returns `Contract.ExecutionResult`.
