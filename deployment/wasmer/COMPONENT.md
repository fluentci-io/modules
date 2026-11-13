# wasmer component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `run`

Execute additional Wasmer CLI commands with literal CSV arguments.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | yes | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.

## `version`

Print the installed Wasmer version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `deploy`

Deploy an application to Wasmer Edge without interactive prompts.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `directory` | `string` | no | Existing directory containing app.yaml. |
| `path` | `string` | no | Existing app.yaml file; mutually exclusive with directory in Wasmer. |
| `env-file` | `string` | no | Existing dotenv file for deployment; protect its contents and native logs. |
| `owner` | `string` | no | Owner user or namespace. |
| `name` | `string` | no | Name of the application. |
| `publish-package` | `boolean` | no | Publish a local package referenced by app.yaml. |
| `build-remote` | `boolean` | no | Use the remote autobuild pipeline. |
| `no-wait` | `boolean` | no | Return before the application becomes reachable. |
| `no-default` | `boolean` | no | Deploy without activating the new app version. |
| `no-persist-id` | `boolean` | no | Do not persist app_id into app.yaml. |
| `format` | `string` | no | Native output format; read results from stdout. Default: "json". Allowed values: json, yaml, table. |
| `arguments` | `string` | no | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.

## `publish`

Publish a local package to the Wasmer registry without prompts.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `directory` | `string` | no | Existing package directory containing wasmer.toml. |
| `namespace` | `string` | no | Registry namespace. |
| `name` | `string` | no | Published package name. |
| `package-version` | `string` | no | Published package version. |
| `dry-run` | `boolean` | no | Run native publication validation without uploading. |
| `wait` | `string` | no | Artifacts to wait for before returning. Allowed values: none, container, native-executables, bindings, all. |
| `query-timeout` | `string` | no | Timeout per registry query, such as 5m. |
| `arguments` | `string` | no | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.

## `validate`

Validate a local WebAssembly file before publishing.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `file` | `string` | yes | Existing WebAssembly module to validate. |
| `arguments` | `string` | no | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.

## `app-list`

List accessible Wasmer Edge applications.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `namespace` | `string` | no | Owner namespace to list. |
| `all` | `boolean` | no | Include all accessible applications. |
| `max` | `integer` | no | Maximum applications to display. |
| `format` | `string` | no | Native output format; read results from stdout. Default: "json". Allowed values: json, yaml, table. |
| `arguments` | `string` | no | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.

## `app-get`

Inspect a Wasmer Edge application.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `app` | `string` | no | App ID, namespace/name or alias; omitted uses the local app configuration. |
| `format` | `string` | no | Native output format; read results from stdout. Default: "json". Allowed values: json, yaml, table. |
| `arguments` | `string` | no | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.

## `app-logs`

Retrieve logs without continuous watching by default.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `app` | `string` | no | App ID, namespace/name or alias; omitted uses the local app configuration. |
| `from` | `string` | no | Earliest timestamp or relative duration. |
| `until` | `string` | no | Latest timestamp or relative duration. |
| `max` | `integer` | no | Maximum log lines. |
| `watch` | `boolean` | no | Watch continuously; bound the module timeout. |
| `streams` | `string` | no | Comma-separated log stream names. |
| `format` | `string` | no | Native output format; read results from stdout. Default: "json". Allowed values: json, yaml, table. |
| `arguments` | `string` | no | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.

## `app-delete`

Delete the explicitly identified application; destructive native operation.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `app` | `string` | yes | App ID, namespace/name or alias; omitted uses the local app configuration. |
| `arguments` | `string` | no | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.

## `deployments-list`

Inspect deployment history for an application.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `app` | `string` | no | App ID, namespace/name or alias; omitted uses the local app configuration. |
| `offset` | `integer` | no | Pagination offset. |
| `limit` | `integer` | no | Maximum deployment records. |
| `arguments` | `string` | no | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.

## `version-activate`

Activate a selected unique version ID for rollback or promotion.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `version-id` | `string` | yes | Unique application version ID, not a version name. |
| `format` | `string` | no | Native output format; read results from stdout. Default: "json". Allowed values: json, yaml, table. |
| `arguments` | `string` | no | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.
