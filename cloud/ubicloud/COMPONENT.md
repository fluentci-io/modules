# ubicloud component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `run`

Execute additional ubi CLI commands with literal CSV arguments. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | yes | Required comma-separated literal ubi command tokens; CSV quotes preserve commas within a token. |

Returns `Contract.ExecutionResult`.

## `ai-api-key-create`

Create an inference API key. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `ai-api-key-list`

List inference API keys. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `no-headers` | `boolean` | no | do not show headers. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `ai-api-key-destroy`

Destroy an inference API key. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before destroy. |
| `confirm` | `string` | no | Explicit native confirmation value; no automatic approval is applied. |
| `force` | `boolean` | no | do not require confirmation. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `ai-api-key-show`

Show details for an inference API key. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before show. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `ai-endpoint-list`

List inference endpoints. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `fields` | `string` | no | show specific fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `no-headers` | `boolean` | no | do not show headers. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `al-search`

Search project audit log entries in CSV format. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `no-headers` | `boolean` | no | do not show headers. |
| `action` | `string` | no | only show entries for the given action. |
| `end` | `string` | no | only show prior to end date. |
| `object` | `string` | no | only show entries affecting the given object ID. |
| `subject` | `string` | no | only show entries with the given account name/email/ID. |
| `limit` | `integer` | no | limit number of records returned. |
| `pagination-key` | `string` | no | continue a previous search. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `fw-list`

List firewall resources. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `fields` | `string` | no | Comma-separated output column names. Comma-separated values; surrounding whitespace is trimmed. |
| `location` | `string` | no | Limit results to this location. |
| `no-headers` | `boolean` | no | Suppress column headers. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `fw-add-rule`

Add a firewall rule. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before add-rule. |
| `start-port` | `integer` | no | starting (or only) port to allow (default: 0). |
| `end-port` | `integer` | no | ending port to allow (default: 65535). |
| `protocol` | `string` | no | protocol to allow (tcp or udp, default: tcp). |
| `description` | `string` | no | description of rule. |
| `cidr` | `string` | yes | Literal cidr operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `fw-attach-subnet`

Attach a private subnet to a firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before attach-subnet. |
| `subnet` | `string` | yes | Literal subnet operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `fw-create`

Create a firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before create. |
| `description` | `string` | no | description for firewall. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `fw-delete-rule`

Remove a firewall rule. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before delete-rule. |
| `rule-id` | `string` | yes | Literal ruleId operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `fw-destroy`

Destroy firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before destroy. |
| `confirm` | `string` | no | Explicit native confirmation value; no automatic approval is applied. |
| `force` | `boolean` | no | Explicitly skip native destructive confirmation. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `fw-detach-subnet`

Detach a private subnet from a firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before detach-subnet. |
| `subnet` | `string` | yes | Literal subnet operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `fw-modify-rule`

Modify a firewall rule. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before modify-rule. |
| `cidr` | `string` | no | IPv4 or IPv6 range to allow. |
| `start-port` | `integer` | no | starting (or only) port to allow (default: 0). |
| `end-port` | `integer` | no | ending port to allow (default: 65535). |
| `protocol` | `string` | no | protocol to allow (tcp or udp). |
| `description` | `string` | no | description of rule. |
| `rule-id` | `string` | yes | Literal ruleId operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `fw-rename`

Rename firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before rename. |
| `name` | `string` | yes | Literal name operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `fw-show`

Show details for a firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before show. |
| `fields` | `string` | no | show specific fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `nic-fields` | `string` | no | show specific nic fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `priv-subnet-fields` | `string` | no | show specific private subnet fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `rule-fields` | `string` | no | show specific firewall rule fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `fw-update-description`

Update the description for a firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before update-description. |
| `description` | `string` | yes | Literal description operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `gh-installation-list`

List GitHub installations. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `no-headers` | `boolean` | no | do not show headers. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `gh-installation-list-repositories`

List GitHub repositories for an installation. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before list-repositories. |
| `no-headers` | `boolean` | no | do not show headers. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `gh-list-cache-entries`

List cache entries for a GitHub repository. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before list-cache-entries. |
| `no-headers` | `boolean` | no | do not show headers. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `gh-remove-all-cache-entries`

Remove all cache entries for a GitHub repository. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before remove-all-cache-entries. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `gh-remove-cache-entry`

Remove cache entry for a GitHub repository. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before remove-cache-entry. |
| `cache-entry-id` | `string` | yes | Literal cacheEntryId operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `help`

Get command help. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `recursive` | `boolean` | no | also show documentation for all subcommands of command. |
| `usage` | `boolean` | no | only show usage. |
| `command` | `string` | no | Optional comma-separated command path, for example vm,show. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `kc-list`

List Kubernetes cluster resources. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `fields` | `string` | no | Comma-separated output column names. Comma-separated values; surrounding whitespace is trimmed. |
| `location` | `string` | no | Limit results to this location. |
| `no-headers` | `boolean` | no | Suppress column headers. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `kc-create-nodepool`

Create a nodepool on a Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before create-nodepool. |
| `name` | `string` | yes | Literal name operand in the native command. |
| `size` | `string` | yes | Literal size operand in the native command. |
| `count` | `integer` | yes | Literal count operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `kc-create`

Create a Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before create. |
| `version` | `string` | no | Kubernetes version. |
| `cp-node-count` | `integer` | no | Control plane node count. |
| `worker-node-count` | `integer` | no | Worker node count. |
| `worker-size` | `string` | no | Worker size. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `kc-destroy-nodepool`

Destroy a nodepool of a Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before destroy-nodepool. |
| `confirm` | `string` | no | Explicit native confirmation value; no automatic approval is applied. |
| `force` | `boolean` | no | do not require confirmation. |
| `nodepool` | `string` | yes | Literal nodepool operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `kc-destroy`

Destroy Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before destroy. |
| `confirm` | `string` | no | Explicit native confirmation value; no automatic approval is applied. |
| `force` | `boolean` | no | Explicitly skip native destructive confirmation. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `kc-kubeconfig`

Print kubeconfig.yaml for a Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before kubeconfig. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `kc-rename`

Rename Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before rename. |
| `name` | `string` | yes | Literal name operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `kc-resize-nodepool`

Resize a Kubernetes cluster nodepool. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before resize-nodepool. |
| `nodepool` | `string` | yes | Literal nodepool operand in the native command. |
| `count` | `integer` | yes | Literal count operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `kc-retire-node`

Retire a worker node from a Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before retire-node. |
| `node` | `string` | yes | Literal node operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `kc-show`

Show details for a Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before show. |
| `fields` | `string` | no | show specific fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `nodepool-fields` | `string` | no | show specific nodepool fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `vm-fields` | `string` | no | show specific virtual machine fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `kc-upgrade-nodepool`

Upgrade a nodepool of a Kubernetes cluster to the cluster's version. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before upgrade-nodepool. |
| `nodepool` | `string` | yes | Literal nodepool operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `kc-upgrade`

Upgrade a Kubernetes cluster to the next supported version. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before upgrade. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `lb-list`

List load balancer resources. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `fields` | `string` | no | Comma-separated output column names. Comma-separated values; surrounding whitespace is trimmed. |
| `location` | `string` | no | Limit results to this location. |
| `no-headers` | `boolean` | no | Suppress column headers. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `lb-attach-vm`

Attach a virtual machine to a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before attach-vm. |
| `vm` | `string` | yes | Literal vm operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `lb-create`

Create a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before create. |
| `algorithm` | `string` | no | set the algorithm to use. |
| `check-endpoint` | `string` | no | set the health check endpoint (default: native default). |
| `check-protocol` | `string` | no | set the health check protocol. |
| `stack` | `string` | no | set the stack. |
| `cert-enabled` | `string` | no | SSL certificate enabled. |
| `subnet` | `string` | yes | Literal subnet operand in the native command. |
| `source-port` | `integer` | yes | Literal sourcePort operand in the native command. |
| `destination-port` | `integer` | yes | Literal destinationPort operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `lb-destroy`

Destroy load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before destroy. |
| `confirm` | `string` | no | Explicit native confirmation value; no automatic approval is applied. |
| `force` | `boolean` | no | Explicitly skip native destructive confirmation. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `lb-detach-vm`

Detach a virtual machine from a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before detach-vm. |
| `vm` | `string` | yes | Literal vm operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `lb-disable-ssl-certificate`

Disable the SSL certificate for a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before disable-ssl-certificate. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `lb-enable-ssl-certificate`

Enable the SSL certificate for a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before enable-ssl-certificate. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `lb-rename`

Rename load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before rename. |
| `name` | `string` | yes | Literal name operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `lb-show`

Show details for a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before show. |
| `fields` | `string` | no | show specific fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `lb-update`

Update a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before update. |
| `algorithm` | `string` | yes | Literal algorithm operand in the native command. |
| `source-port` | `integer` | yes | Literal sourcePort operand in the native command. |
| `destination-port` | `integer` | yes | Literal destinationPort operand in the native command. |
| `health-check-endpoint` | `string` | yes | Literal healthCheckEndpoint operand in the native command. |
| `certificate-enabled` | `boolean` | yes | Literal certificateEnabled operand in the native command. |
| `vms` | `string` | no | Comma-separated vms; entries are passed as literal positional tokens. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `mi-list`

List machine image resources. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `fields` | `string` | no | Comma-separated output column names. Comma-separated values; surrounding whitespace is trimmed. |
| `location` | `string` | no | Limit results to this location. |
| `no-headers` | `boolean` | no | Suppress column headers. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `mi-create-version`

Create a new version of a machine image from a stopped VM. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before create-version. |
| `version` | `string` | no | version label (default: timestamp). |
| `destroy-source` | `boolean` | no | destroy the source VM after capture. |
| `vm` | `string` | yes | Literal vm operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `mi-create`

Create a machine image from a stopped VM. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before create. |
| `version` | `string` | no | version label (default: timestamp). |
| `destroy-source` | `boolean` | no | destroy the source VM after capture. |
| `vm` | `string` | yes | Literal vm operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `mi-destroy-version`

Destroy a non-latest version of a machine image. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before destroy-version. |
| `confirm` | `string` | no | Explicit native confirmation value; no automatic approval is applied. |
| `force` | `boolean` | no | do not require confirmation. |
| `version` | `string` | yes | Literal version operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `mi-destroy`

Destroy machine image. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before destroy. |
| `confirm` | `string` | no | Explicit native confirmation value; no automatic approval is applied. |
| `force` | `boolean` | no | Explicitly skip native destructive confirmation. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `mi-list-versions`

List versions of a machine image. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before list-versions. |
| `fields` | `string` | no | show specific fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `no-headers` | `boolean` | no | do not show headers. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `mi-rename`

Rename machine image. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before rename. |
| `name` | `string` | yes | Literal name operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `mi-set-latest`

Set the latest version of a machine image. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before set-latest. |
| `version` | `string` | yes | Literal version operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `mi-show`

Show details for a machine image. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before show. |
| `fields` | `string` | no | show specific fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-list`

List PostgreSQL database resources. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `fields` | `string` | no | Comma-separated output column names. Comma-separated values; surrounding whitespace is trimmed. |
| `location` | `string` | no | Limit results to this location. |
| `no-headers` | `boolean` | no | Suppress column headers. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-add-bearer-metric-destination`

Add a PostgreSQL metric destination using bearer token authentication. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before add-bearer-metric-destination. |
| `url` | `string` | yes | Literal url operand in the native command. |
| `token` | `string` | yes | Sensitive native token operand; native argv and execution reports can contain this value. Protect the run directory. |
| `headers` | `string` | no | Comma-separated headers; entries are passed as literal positional tokens. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-add-cert-auth-user`

Add user to list of users authenticating with client certificate authentication. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before add-cert-auth-user. |
| `name` | `string` | yes | Literal name operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-add-config-entries`

Add configuration entries to a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before add-config-entries. |
| `entries` | `string` | yes | Comma-separated entries; entries are passed as literal positional tokens. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-add-firewall-rule`

Add a PostgreSQL firewall rule. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before add-firewall-rule. |
| `description` | `string` | no | description of rule. |
| `cidr` | `string` | yes | Literal cidr operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-add-metric-destination`

Add a PostgreSQL metric destination. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before add-metric-destination. |
| `username` | `string` | yes | Literal username operand in the native command. |
| `password` | `string` | yes | Sensitive native password operand; native argv and execution reports can contain this value. Protect the run directory. |
| `url` | `string` | yes | Literal url operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-add-otlp-log-destination`

Add an OTLP HTTP log destination to a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before add-otlp-log-destination. |
| `name` | `string` | yes | Literal name operand in the native command. |
| `url` | `string` | yes | Literal url operand in the native command. |
| `headers` | `string` | no | Comma-separated headers; entries are passed as literal positional tokens. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-add-pgbouncer-config-entries`

Add pgbouncer configuration entries to a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before add-pgbouncer-config-entries. |
| `entries` | `string` | yes | Comma-separated entries; entries are passed as literal positional tokens. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-add-syslog-log-destination`

Add a syslog (RFC 5424 over TLS) log destination to a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before add-syslog-log-destination. |
| `name` | `string` | yes | Literal name operand in the native command. |
| `host` | `string` | yes | Literal host operand in the native command. |
| `port` | `integer` | no | Literal port operand in the native command. |
| `structured-data` | `string` | no | Optional comma-separated sd-id/key=value entries for native syslog structured data. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-ca-certificates`

Print CA certificates for a PostgreSQL database (if available). Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before ca-certificates. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-create-backup-credentials`

Create temporary, read-only credentials for downloading PostgreSQL backups. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before create-backup-credentials. |
| `format` | `string` | no | output format: table (default), env, or json. Allowed values: table, env, json. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-create-client-cert-keypair`

Create client certificate keypair with given common name, expiring after a duration of seconds. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before create-client-cert-keypair. |
| `common-name` | `string` | yes | Literal commonName operand in the native command. |
| `duration` | `integer` | yes | Literal duration operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-create-read-replica`

Create a read replica for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before create-read-replica. |
| `pg-config` | `string` | no | postgres config (e.g key1=value1,key2=value2). Comma-separated KEY=VALUE entries. |
| `pgbouncer-config` | `string` | no | pgbouncer config (e.g. key1=value1,key2=value2). Comma-separated KEY=VALUE entries. |
| `tags` | `string` | no | tags (e.g. key1=value1,key2=value2). Comma-separated KEY=VALUE entries. |
| `name` | `string` | yes | Literal name operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-create`

Create a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before create. |
| `flavor` | `string` | no | flavor (deprecated and ignored). |
| `ha-type` | `string` | no | replication type. |
| `size` | `string` | no | server size. |
| `storage-size` | `string` | no | storage size GB. |
| `version` | `string` | no | PostgreSQL version. |
| `pg-config` | `string` | no | postgres config (e.g. key1=value1,key2=value2). Comma-separated KEY=VALUE entries. |
| `pgbouncer-config` | `string` | no | pgbouncer config (e.g. key1=value1,key2=value2). Comma-separated KEY=VALUE entries. |
| `tags` | `string` | no | tags (e.g. key1=value1,key2=value2). Comma-separated KEY=VALUE entries. |
| `restrict-by-default` | `boolean` | no | restrict access by default (add firewall rules to allow access). |
| `private-subnet-name` | `string` | no | override name of created private subnet. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-delete-firewall-rule`

Delete a PostgreSQL firewall rule. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before delete-firewall-rule. |
| `rule-id` | `string` | yes | Literal ruleId operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-delete-log-destination`

Delete a PostgreSQL log destination. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before delete-log-destination. |
| `destination-id` | `string` | yes | Literal destinationId operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-delete-metric-destination`

Delete a PostgreSQL metric destination. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before delete-metric-destination. |
| `destination-id` | `string` | yes | Literal destinationId operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-destroy`

Destroy PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before destroy. |
| `confirm` | `string` | no | Explicit native confirmation value; no automatic approval is applied. |
| `force` | `boolean` | no | Explicitly skip native destructive confirmation. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-get-logs`

Fetch logs for a PostgreSQL database in CSV format. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before get-logs. |
| `start` | `string` | no | start time (RFC3339, default: 30 minutes ago). |
| `end` | `string` | no | end time (RFC3339, default: now). |
| `stream-name` | `string` | no | filter by log stream. |
| `server-role` | `string` | no | filter by server role. |
| `severity-level` | `string` | no | filter by log severity level. |
| `query-pattern` | `string` | no | pattern for substring match against log message. |
| `max-log-lines` | `integer` | no | number of log lines to return (default: 50, max: 500). |
| `pagination-key` | `string` | no | continue a previous search. |
| `no-headers` | `boolean` | no | do not show headers. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-list-backups`

List backups for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before list-backups. |
| `no-headers` | `boolean` | no | do not show headers. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-list-servers`

List servers for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before list-servers. |
| `no-headers` | `boolean` | no | do not show headers. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-modify-firewall-rule`

Modify a PostgreSQL firewall rule. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before modify-firewall-rule. |
| `cidr` | `string` | no | ip range to allow in cidr format (e.g. 1.2.3.0/24). |
| `description` | `string` | no | description of rule. |
| `rule-id` | `string` | yes | Literal ruleId operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-modify`

Modify a PostgreSQL database cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before modify. |
| `ha-type` | `string` | no | replication type. |
| `size` | `string` | no | server size. |
| `storage-size` | `string` | no | storage size GB. |
| `tags` | `string` | no | tags (e.g. key1=value1,key2=value2). Comma-separated KEY=VALUE entries. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-pg-dump`

Dump a single PostgreSQL database using `pg_dump`. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before pg_dump. |
| `database` | `string` | no | Override PostgreSQL database. |
| `username` | `string` | no | Override PostgreSQL username. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-pg-dumpall`

Dump a entire PostgreSQL database cluster using `pg_dumpall`. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before pg_dumpall. |
| `database` | `string` | no | Override PostgreSQL database. |
| `username` | `string` | no | Override PostgreSQL username. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-promote-read-replica`

Promote a read replica PostgreSQL database to a primary. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before promote-read-replica. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-psql`

Connect to a PostgreSQL database using `psql`. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before psql. |
| `database` | `string` | no | Override PostgreSQL database. |
| `username` | `string` | no | Override PostgreSQL username. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-recycle`

Request recycle of primary. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before recycle. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-remove-cert-auth-user`

Remove user from list of users authenticating with client certificate authentication. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before remove-cert-auth-user. |
| `name` | `string` | yes | Literal name operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-remove-config-entries`

Remove configuration entries from a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before remove-config-entries. |
| `keys` | `string` | yes | Comma-separated keys; entries are passed as literal positional tokens. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-remove-pgbouncer-config-entries`

Remove pgbouncer configuration entries from a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before remove-pgbouncer-config-entries. |
| `keys` | `string` | yes | Comma-separated keys; entries are passed as literal positional tokens. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-rename`

Rename PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before rename. |
| `name` | `string` | yes | Literal name operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-reset-superuser-password`

Reset the superuser password for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before reset-superuser-password. |
| `password` | `string` | yes | Sensitive native password operand; native argv and execution reports can contain this value. Protect the run directory. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-restart`

Restart a PostgreSQL database cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before restart. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-restore`

Restore a PostgreSQL database backup to a new database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before restore. |
| `pg-config` | `string` | no | postgres config (e.g. key1=value1,key2=value2). Comma-separated KEY=VALUE entries. |
| `pgbouncer-config` | `string` | no | pgbouncer config (e.g. key1=value1,key2=value2). Comma-separated KEY=VALUE entries. |
| `tags` | `string` | no | tags (e.g. key1=value1,key2=value2). Comma-separated KEY=VALUE entries. |
| `name` | `string` | yes | Literal name operand in the native command. |
| `restore-time` | `string` | yes | Literal restoreTime operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-set-maintenance-window`

Set the maintenance window for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before set-maintenance-window. |
| `days` | `string` | no | days of week the window applies (e.g. mon,wed,fri); default every day. Comma-separated values; surrounding whitespace is trimmed. |
| `start-hour` | `integer` | yes | Literal startHour operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-show-config`

Show configuration for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before show-config. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-show-default-config`

Show default configuration for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before show-default-config. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-show-pgbouncer-config`

Show pgbouncer configuration for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before show-pgbouncer-config. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-show-upgrade-status`

Show the status of a major version upgrade of the PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before show-upgrade-status. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-show`

Show details for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before show. |
| `fields` | `string` | no | show specific fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `pg-upgrade`

Schedule a major version upgrade of the PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before upgrade. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `ps-list`

List private subnet resources. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `fields` | `string` | no | Comma-separated output column names. Comma-separated values; surrounding whitespace is trimmed. |
| `location` | `string` | no | Limit results to this location. |
| `no-headers` | `boolean` | no | Suppress column headers. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `ps-connect`

Connect a private subnet to another private subnet. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before connect. |
| `subnet` | `string` | yes | Literal subnet operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `ps-create`

Create a private subnet. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before create. |
| `firewall-id` | `string` | no | add to given firewall. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `ps-destroy`

Destroy private subnet. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before destroy. |
| `confirm` | `string` | no | Explicit native confirmation value; no automatic approval is applied. |
| `force` | `boolean` | no | Explicitly skip native destructive confirmation. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `ps-disconnect`

Disconnect a private subnet from another private subnet. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before disconnect. |
| `subnet` | `string` | yes | Literal subnet operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `ps-rename`

Rename private subnet. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before rename. |
| `name` | `string` | yes | Literal name operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `ps-show`

Show details for a private subnet. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before show. |
| `fields` | `string` | no | show specific fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `nic-fields` | `string` | no | show specific nic fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `rule-fields` | `string` | no | show specific firewall rule fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `firewall-fields` | `string` | no | show specific firewall fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `sk-list`

List SSH public keys. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `no-headers` | `boolean` | no | do not show headers. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `sk-create`

Register an SSH public key. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before create. |
| `public-key` | `string` | yes | Literal publicKey operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `sk-destroy`

Destroy an SSH public key. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before destroy. |
| `confirm` | `string` | no | Explicit native confirmation value; no automatic approval is applied. |
| `force` | `boolean` | no | do not require confirmation. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `sk-rename`

Rename an SSH public key. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before rename. |
| `name` | `string` | yes | Literal name operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `sk-show`

Show details for an SSH public key. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before show. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `sk-update`

Update an SSH public key. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before update. |
| `public-key` | `string` | yes | Literal publicKey operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `version`

Display CLI program version. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `vm-list`

List virtual machine resources. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `fields` | `string` | no | Comma-separated output column names. Comma-separated values; surrounding whitespace is trimmed. |
| `location` | `string` | no | Limit results to this location. |
| `no-headers` | `boolean` | no | Suppress column headers. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `vm-create`

Create a virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before create. |
| `ipv6-only` | `boolean` | no | do not enable IPv4. |
| `boot-image` | `string` | no | boot image. |
| `init-script` | `string` | no | use given init script. |
| `private-subnet-id` | `string` | no | place VM into specific private subnet (also accepts ps-name). |
| `size` | `string` | no | server size. |
| `storage-size` | `string` | no | storage size. |
| `unix-user` | `string` | no | username (default: ubi). |
| `public-key` | `string` | yes | Literal publicKey operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `vm-destroy`

Destroy virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before destroy. |
| `confirm` | `string` | no | Explicit native confirmation value; no automatic approval is applied. |
| `force` | `boolean` | no | Explicitly skip native destructive confirmation. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `vm-rename`

Rename virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before rename. |
| `name` | `string` | yes | Literal name operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `vm-restart`

Restart a virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before restart. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `vm-scp`

Copy files to or from virtual machine using `scp`. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before scp. |
| `ipv4` | `boolean` | no | Connect over IPv4. |
| `ipv6` | `boolean` | no | Connect over IPv6. |
| `user` | `string` | no | Override SSH username. |
| `source` | `string` | yes | Literal source operand in the native command. |
| `destination` | `string` | yes | Literal destination operand in the native command. |
| `client-arguments` | `string` | no | Optional comma-separated literal scp options placed before source and destination. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `vm-serial-log`

Show a virtual machine's serial console log, fetching it if needed. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before serial-log. |
| `refresh` | `boolean` | no | request a new fetch even if a recent result exists. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `vm-set-maintenance-window`

Set the maintenance window for a virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before set-maintenance-window. |
| `start-hour` | `integer` | yes | Literal startHour operand in the native command. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `vm-sftp`

Copy files to or from virtual machine using `sftp`. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before sftp. |
| `ipv4` | `boolean` | no | Connect over IPv4. |
| `ipv6` | `boolean` | no | Connect over IPv6. |
| `user` | `string` | no | Override SSH username. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `vm-show`

Show details for a virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before show. |
| `fields` | `string` | no | show specific fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `rule-fields` | `string` | no | show specific firewall rule fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `firewall-fields` | `string` | no | show specific firewall fields (comma separated). Comma-separated values; surrounding whitespace is trimmed. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `vm-ssh`

Connect to a virtual machine using `ssh`. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before ssh. |
| `ipv4` | `boolean` | no | Connect over IPv4. |
| `ipv6` | `boolean` | no | Connect over IPv6. |
| `user` | `string` | no | Override SSH username. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `vm-start`

Start a virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before start. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.

## `vm-stop`

Stop a virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `resource` | `string` | yes | Resource ID or native resource reference; creation uses location/name (SSH keys use a key name). Appears before stop. |
| `arguments` | `string` | no | Optional comma-separated literal extra CLI tokens. For ssh include client options,--,remote-command as needed; PostgreSQL clients require local native tools. |

Returns `Contract.ExecutionResult`.
