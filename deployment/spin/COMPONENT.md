# spin component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `run`

Execute additional Spin or plugin commands with literal CSV arguments.

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

Print the installed Spin version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `build`

Build application components with the project toolchains.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `from` | `string` | no | Local app manifest/directory or native remote reference where supported; native CLI validates the source. |
| `profile` | `string` | no | Named build profile. |
| `components` | `string` | no | Comma-separated component IDs; omitted builds all components. |
| `skip-target-checks` | `boolean` | no | Skip deployment-target compatibility checks. |
| `skip-generate-wits` | `boolean` | no | Skip generating dependency WIT files. |
| `arguments` | `string` | no | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.

## `registry-push`

Push an application as an OCI artifact using native registry credentials.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `reference` | `string` | yes | OCI registry reference including the desired tag. |
| `from` | `string` | no | Local app manifest/directory or native remote reference where supported; native CLI validates the source. |
| `profile` | `string` | no | Build profile to push. |
| `build` | `boolean` | no | Build before pushing. |
| `compose` | `boolean` | no | Compose component dependencies before pushing. |
| `annotations` | `string` | no | Comma-separated KEY=VALUE OCI image annotations. |
| `cache-dir` | `string` | no | Directory for registry cache data. |
| `insecure` | `boolean` | no | Explicitly ignore registry certificate errors. |
| `arguments` | `string` | no | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.

## `registry-pull`

Pull an application from an OCI registry.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `reference` | `string` | yes | OCI registry reference to pull. |
| `prepare` | `string` | no | Output directory for a prepared app; native CLI requires absent or empty directory. |
| `cache-dir` | `string` | no | Directory for registry cache data. |
| `insecure` | `boolean` | no | Explicitly ignore registry certificate errors. |
| `arguments` | `string` | no | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.

## `deploy`

Deploy through the plugin named by SPIN_DEPLOY_PLUGIN; arguments are plugin-specific.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | no | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.

## `cloud-deploy`

Deploy through the explicitly installed Fermyon cloud plugin.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `from` | `string` | no | Local app manifest/directory or native remote reference where supported; native CLI validates the source. |
| `build` | `boolean` | no | Build the local app before deployment. |
| `environment-name` | `string` | no | Saved Fermyon deployment environment. |
| `readiness-timeout` | `integer` | no | Readiness wait in seconds; zero skips waiting. |
| `variables` | `string` | no | Comma-separated KEY=VALUE app variables. Avoid passing secrets in argv. |
| `key-values` | `string` | no | Comma-separated KEY=VALUE entries for the default store. |
| `links` | `string` | no | Comma-separated explicit resource links, such as sqlite:label=database. |
| `arguments` | `string` | no | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.

## `cloud-login`

Authenticate the cloud plugin using inherited SPIN_AUTH_TOKEN without browser login.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `environment-name` | `string` | no | Name under which to save the login. |
| `url` | `string` | no | Cloud instance URL. |
| `arguments` | `string` | no | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.

## `plugins-install`

Install a selected deployment/runtime plugin explicitly.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `name` | `string` | yes | Plugin name, for example cloud. |
| `plugin-version` | `string` | no | Exact plugin release; omitted uses native selection. |
| `yes` | `boolean` | no | Explicitly accept the plugin installation prompt. |
| `arguments` | `string` | no | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.

## `plugins-list`

Inspect installed Spin plugins.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `installed` | `boolean` | no | List installed plugins only. |
| `arguments` | `string` | no | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.

## `up`

Run an application in the foreground; use a scoped lifecycle and bounded timeout.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `from` | `string` | no | Local app manifest/directory or native remote reference where supported; native CLI validates the source. |
| `build` | `boolean` | no | Build the application first. |
| `env` | `string` | no | Comma-separated KEY=VALUE component environment overrides. |
| `arguments` | `string` | no | Additional literal native tokens in CSV form; CSV quotes preserve commas inside a token. |

Returns `Contract.ExecutionResult`.
