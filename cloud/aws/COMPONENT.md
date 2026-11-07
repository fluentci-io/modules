# aws component functions

Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures
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

## `identity`

Inspect the authenticated AWS principal.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `region` | `string` | no | Region supplied to the aws identity operation. |
| `profile` | `string` | no | Profile supplied to the aws identity operation. |
| `endpoint-url` | `string` | no | Endpoint Url supplied to the aws identity operation. |
| `output` | `string` | no | Destination path for generated packages. Allowed values: json, text, table, yaml, yaml-stream. |

Returns `Contract.ExecutionResult`.

## `s3-cp`

Copy files to, from, or between S3 locations.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `region` | `string` | no | Region supplied to the aws s3_cp operation. |
| `profile` | `string` | no | Profile supplied to the aws s3_cp operation. |
| `endpoint-url` | `string` | no | Endpoint Url supplied to the aws s3_cp operation. |
| `recursive` | `boolean` | no | Recursive supplied to the aws s3_cp operation. |
| `exclude` | `array` | no | Exclude supplied to the aws s3_cp operation. |
| `include` | `array` | no | Include supplied to the aws s3_cp operation. |
| `source` | `string` | yes | Source supplied to the aws s3_cp operation. |
| `destination` | `string` | yes | Destination supplied to the aws s3_cp operation. |

Returns `Contract.ExecutionResult`.

## `s3-sync`

Synchronize a directory or S3 prefix.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `region` | `string` | no | Region supplied to the aws s3_sync operation. |
| `profile` | `string` | no | Profile supplied to the aws s3_sync operation. |
| `endpoint-url` | `string` | no | Endpoint Url supplied to the aws s3_sync operation. |
| `delete` | `boolean` | no | Delete supplied to the aws s3_sync operation. |
| `dryrun` | `boolean` | no | Dryrun supplied to the aws s3_sync operation. |
| `exclude` | `array` | no | Exclude supplied to the aws s3_sync operation. |
| `include` | `array` | no | Include supplied to the aws s3_sync operation. |
| `source` | `string` | yes | Source supplied to the aws s3_sync operation. |
| `destination` | `string` | yes | Destination supplied to the aws s3_sync operation. |

Returns `Contract.ExecutionResult`.

## `cloudformation-deploy`

Deploy a CloudFormation template.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `region` | `string` | no | Region supplied to the aws cloudformation_deploy operation. |
| `profile` | `string` | no | Profile supplied to the aws cloudformation_deploy operation. |
| `endpoint-url` | `string` | no | Endpoint Url supplied to the aws cloudformation_deploy operation. |
| `template-file` | `string` | yes | Template File supplied to the aws cloudformation_deploy operation. |
| `stack-name` | `string` | yes | Stack Name supplied to the aws cloudformation_deploy operation. |
| `capabilities` | `array` | no | Capabilities supplied to the aws cloudformation_deploy operation. |
| `parameter-overrides` | `array` | no | Parameter Overrides supplied to the aws cloudformation_deploy operation. |
| `no-fail-on-empty-changeset` | `boolean` | no | No Fail On Empty Changeset supplied to the aws cloudformation_deploy operation. |

Returns `Contract.ExecutionResult`.
