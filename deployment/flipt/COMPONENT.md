# flipt component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `setup`

Ensure flipt is installed and verified, reusing an available matching version, and publish its environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `version` | `string` | no | Tool release or supported channel to install; omitted values use the documented default. |
| `install-dir` | `string` | no | Absolute per-user installation prefix; omit for native package installations. |
| `package-name` | `string` | no | Native package or port selector overriding the default repository package name. |
| `sudo` | `boolean` | no | Use noninteractive sudo for native package or system installation; defaults to false. |

Returns `Contract.SetupResult`.

## `run`

Run any Flipt CLI command as literal native arguments.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | yes | Native Flipt command and argument tokens as comma-separated text; never JSON objects or arrays. |

Returns `Contract.ExecutionResult`.

## `version`

Report the installed Flipt version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `validate`

Validate flag-state YAML and fail the pipeline on validation issues.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `files` | `string` | no | Comma-separated YAML flag-state paths, relative to workDir; omitted or blank validates the configured state tree. |
| `work-dir` | `string` | no | Existing directory used as the flag-state filesystem root. |
| `extra-schema` | `string` | no | Existing schema extension file with additional validation constraints. |
| `format` | `string` | no | Validation output format. Default: "json". Allowed values: json, text. |
| `issue-exit-code` | `integer` | no | Positive exit code for validation findings; zero is deliberately disallowed so this function remains a CI gate. Default: 1. |
| `extra-args` | `string` | no | Additional literal native tokens as comma-separated text; CSV quotes preserve commas. Do not include secrets, since command arguments are recorded in reports. |

Returns `Contract.ExecutionResult`.

## `migrate`

Run pending Flipt v2 analytics database migrations with the selected server configuration.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Existing Flipt server configuration file; credentials can remain in native server configuration or environment. |
| `extra-args` | `string` | no | Additional literal native tokens as comma-separated text; CSV quotes preserve commas. Do not include secrets, since command arguments are recorded in reports. |

Returns `Contract.ExecutionResult`.

## `license-check`

Check the configured Flipt Pro license status with the native licensing service.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `config` | `string` | no | Existing Flipt server configuration file; credentials can remain in native server configuration or environment. |
| `extra-args` | `string` | no | Additional literal native tokens as comma-separated text; CSV quotes preserve commas. Do not include secrets, since command arguments are recorded in reports. |

Returns `Contract.ExecutionResult`.

## `evaluate`

Evaluate a feature flag once without watch mode; upstream evaluation failures propagate.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `flag-key` | `string` | yes | Feature flag key to evaluate once. |
| `address` | `string` | no | HTTP or gRPC address of the Flipt instance; defaults to the native localhost endpoint. |
| `environment` | `string` | no | Flipt environment key. |
| `namespace` | `string` | no | Flipt namespace key. |
| `entity-id` | `string` | no | Stable evaluation entity ID for reproducible pipeline checks. |
| `request-id` | `string` | no | Evaluation request correlation ID. |
| `context` | `string` | no | Comma-separated evaluation KEY=VALUE context entries; no JSON object is accepted. |
| `extra-args` | `string` | no | Additional literal native tokens as comma-separated text; CSV quotes preserve commas. Do not include secrets, since command arguments are recorded in reports. |

Returns `Contract.ExecutionResult`.
