# garden component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `run`

Execute arbitrary Garden commands with literal CSV arguments.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | yes | Literal extra tokens as a comma-separated string; CSV quotes preserve commas inside tokens. |

Returns `Contract.ExecutionResult`.

## `version`

Print the installed Garden version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `build`

Build selected actions and their build dependencies.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `environment` | `string` | no | Garden environment, optionally prefixed with a namespace (for example pr-123.ci). |
| `variables` | `string` | no | Comma-separated KEY=VALUE variable overrides. For secrets use native environment-backed Garden configuration. |
| `output` | `string` | no | Native structured result format; read it from the returned stdout path. Allowed values: json, yaml. |
| `log-level` | `string` | no | Native log verbosity. Allowed values: error, warn, info, verbose, debug, silly. |
| `yes` | `boolean` | no | Explicitly approve prompts and protected production commands; omitted never auto-approves. |
| `names` | `string` | no | Comma-separated action names or native glob selectors; omitted or blank selects all eligible actions. |
| `force` | `boolean` | no | Rebuild even when an existing build can be reused. |
| `with-dependants` | `boolean` | no | Also rebuild downstream dependants. |
| `arguments` | `string` | no | Literal extra tokens as a comma-separated string; CSV quotes preserve commas inside tokens. |

Returns `Contract.ExecutionResult`.

## `deploy`

Deploy selected actions using the Garden dependency graph.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `environment` | `string` | no | Garden environment, optionally prefixed with a namespace (for example pr-123.ci). |
| `variables` | `string` | no | Comma-separated KEY=VALUE variable overrides. For secrets use native environment-backed Garden configuration. |
| `output` | `string` | no | Native structured result format; read it from the returned stdout path. Allowed values: json, yaml. |
| `log-level` | `string` | no | Native log verbosity. Allowed values: error, warn, info, verbose, debug, silly. |
| `yes` | `boolean` | no | Explicitly approve prompts and protected production commands; omitted never auto-approves. |
| `names` | `string` | no | Comma-separated action names or native glob selectors; omitted or blank selects all eligible actions. |
| `force` | `boolean` | no | Force redeployment. |
| `force-build` | `boolean` | no | Rebuild dependencies before deployment. |
| `plan` | `boolean` | no | Show planned changes without deploying; experimental upstream behavior. |
| `skip` | `string` | no | Comma-separated deployments to skip. |
| `skip-dependencies` | `boolean` | no | Skip runtime dependencies; caller must ensure they are current. |
| `with-dependants` | `boolean` | no | Also deploy downstream dependants. |
| `disable-port-forwards` | `boolean` | no | Disable automatic port forwards. |
| `arguments` | `string` | no | Literal extra tokens as a comma-separated string; CSV quotes preserve commas inside tokens. |

Returns `Contract.ExecutionResult`.

## `test`

Run selected Test actions, including required build and runtime dependencies.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `environment` | `string` | no | Garden environment, optionally prefixed with a namespace (for example pr-123.ci). |
| `variables` | `string` | no | Comma-separated KEY=VALUE variable overrides. For secrets use native environment-backed Garden configuration. |
| `output` | `string` | no | Native structured result format; read it from the returned stdout path. Allowed values: json, yaml. |
| `log-level` | `string` | no | Native log verbosity. Allowed values: error, warn, info, verbose, debug, silly. |
| `yes` | `boolean` | no | Explicitly approve prompts and protected production commands; omitted never auto-approves. |
| `names` | `string` | no | Comma-separated action names or native glob selectors; omitted or blank selects all eligible actions. |
| `force` | `boolean` | no | Rerun tests even when successful cached results exist. |
| `force-build` | `boolean` | no | Rebuild dependencies before testing. |
| `modules` | `string` | no | Comma-separated modules to select tests from. |
| `skip` | `string` | no | Comma-separated tests or native globs to skip. |
| `skip-dependencies` | `boolean` | no | Skip runtime dependencies only when already prepared. |
| `arguments` | `string` | no | Literal extra tokens as a comma-separated string; CSV quotes preserve commas inside tokens. |

Returns `Contract.ExecutionResult`.

## `run-actions`

Execute named Run actions and dependencies for migrations, seed jobs or integration tasks.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `environment` | `string` | no | Garden environment, optionally prefixed with a namespace (for example pr-123.ci). |
| `variables` | `string` | no | Comma-separated KEY=VALUE variable overrides. For secrets use native environment-backed Garden configuration. |
| `output` | `string` | no | Native structured result format; read it from the returned stdout path. Allowed values: json, yaml. |
| `log-level` | `string` | no | Native log verbosity. Allowed values: error, warn, info, verbose, debug, silly. |
| `yes` | `boolean` | no | Explicitly approve prompts and protected production commands; omitted never auto-approves. |
| `names` | `string` | no | Comma-separated action names or native glob selectors; omitted or blank selects all eligible actions. |
| `force` | `boolean` | no | Execute disabled or cached successful actions. |
| `force-build` | `boolean` | no | Rebuild dependencies first. |
| `modules` | `string` | no | Comma-separated modules to select Run actions from. |
| `skip` | `string` | no | Comma-separated Run names or globs to skip. |
| `skip-dependencies` | `boolean` | no | Skip runtime dependencies only when already prepared. |
| `arguments` | `string` | no | Literal extra tokens as a comma-separated string; CSV quotes preserve commas inside tokens. |

Returns `Contract.ExecutionResult`.

## `workflow`

Execute a project-defined workflow in the selected environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `environment` | `string` | no | Garden environment, optionally prefixed with a namespace (for example pr-123.ci). |
| `variables` | `string` | no | Comma-separated KEY=VALUE variable overrides. For secrets use native environment-backed Garden configuration. |
| `output` | `string` | no | Native structured result format; read it from the returned stdout path. Allowed values: json, yaml. |
| `log-level` | `string` | no | Native log verbosity. Allowed values: error, warn, info, verbose, debug, silly. |
| `yes` | `boolean` | no | Explicitly approve prompts and protected production commands; omitted never auto-approves. |
| `name` | `string` | yes | Garden workflow name. |
| `arguments` | `string` | no | Literal extra tokens as a comma-separated string; CSV quotes preserve commas inside tokens. |

Returns `Contract.ExecutionResult`.

## `status`

Inspect provider and action status for the selected environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `environment` | `string` | no | Garden environment, optionally prefixed with a namespace (for example pr-123.ci). |
| `variables` | `string` | no | Comma-separated KEY=VALUE variable overrides. For secrets use native environment-backed Garden configuration. |
| `output` | `string` | no | Native structured result format; read it from the returned stdout path. Allowed values: json, yaml. |
| `log-level` | `string` | no | Native log verbosity. Allowed values: error, warn, info, verbose, debug, silly. |
| `yes` | `boolean` | no | Explicitly approve prompts and protected production commands; omitted never auto-approves. |
| `skip-detail` | `boolean` | no | Omit provider-specific details from structured results. |
| `arguments` | `string` | no | Literal extra tokens as a comma-separated string; CSV quotes preserve commas inside tokens. |

Returns `Contract.ExecutionResult`.

## `outputs`

Resolve project outputs, including configured runtime output references.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `environment` | `string` | no | Garden environment, optionally prefixed with a namespace (for example pr-123.ci). |
| `variables` | `string` | no | Comma-separated KEY=VALUE variable overrides. For secrets use native environment-backed Garden configuration. |
| `output` | `string` | no | Native structured result format; read it from the returned stdout path. Allowed values: json, yaml. |
| `log-level` | `string` | no | Native log verbosity. Allowed values: error, warn, info, verbose, debug, silly. |
| `yes` | `boolean` | no | Explicitly approve prompts and protected production commands; omitted never auto-approves. |
| `arguments` | `string` | no | Literal extra tokens as a comma-separated string; CSV quotes preserve commas inside tokens. |

Returns `Contract.ExecutionResult`.

## `graph`

Inspect the project dependency graph.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `environment` | `string` | no | Garden environment, optionally prefixed with a namespace (for example pr-123.ci). |
| `variables` | `string` | no | Comma-separated KEY=VALUE variable overrides. For secrets use native environment-backed Garden configuration. |
| `output` | `string` | no | Native structured result format; read it from the returned stdout path. Allowed values: json, yaml. |
| `log-level` | `string` | no | Native log verbosity. Allowed values: error, warn, info, verbose, debug, silly. |
| `yes` | `boolean` | no | Explicitly approve prompts and protected production commands; omitted never auto-approves. |
| `arguments` | `string` | no | Literal extra tokens as a comma-separated string; CSV quotes preserve commas inside tokens. |

Returns `Contract.ExecutionResult`.

## `config`

Inspect resolved project configuration.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `environment` | `string` | no | Garden environment, optionally prefixed with a namespace (for example pr-123.ci). |
| `variables` | `string` | no | Comma-separated KEY=VALUE variable overrides. For secrets use native environment-backed Garden configuration. |
| `output` | `string` | no | Native structured result format; read it from the returned stdout path. Allowed values: json, yaml. |
| `log-level` | `string` | no | Native log verbosity. Allowed values: error, warn, info, verbose, debug, silly. |
| `yes` | `boolean` | no | Explicitly approve prompts and protected production commands; omitted never auto-approves. |
| `arguments` | `string` | no | Literal extra tokens as a comma-separated string; CSV quotes preserve commas inside tokens. |

Returns `Contract.ExecutionResult`.

## `publish`

Build and publish selected artifacts to configured registries.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `environment` | `string` | no | Garden environment, optionally prefixed with a namespace (for example pr-123.ci). |
| `variables` | `string` | no | Comma-separated KEY=VALUE variable overrides. For secrets use native environment-backed Garden configuration. |
| `output` | `string` | no | Native structured result format; read it from the returned stdout path. Allowed values: json, yaml. |
| `log-level` | `string` | no | Native log verbosity. Allowed values: error, warn, info, verbose, debug, silly. |
| `yes` | `boolean` | no | Explicitly approve prompts and protected production commands; omitted never auto-approves. |
| `names` | `string` | no | Comma-separated action names or native glob selectors; omitted or blank selects all eligible actions. |
| `force-build` | `boolean` | no | Rebuild before publishing. |
| `tag` | `string` | no | Registry tag or Garden native template string; passed literally. |
| `arguments` | `string` | no | Literal extra tokens as a comma-separated string; CSV quotes preserve commas inside tokens. |

Returns `Contract.ExecutionResult`.

## `logs`

Collect deployment logs without following by default.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `environment` | `string` | no | Garden environment, optionally prefixed with a namespace (for example pr-123.ci). |
| `variables` | `string` | no | Comma-separated KEY=VALUE variable overrides. For secrets use native environment-backed Garden configuration. |
| `output` | `string` | no | Native structured result format; read it from the returned stdout path. Allowed values: json, yaml. |
| `log-level` | `string` | no | Native log verbosity. Allowed values: error, warn, info, verbose, debug, silly. |
| `yes` | `boolean` | no | Explicitly approve prompts and protected production commands; omitted never auto-approves. |
| `names` | `string` | no | Comma-separated action names or native glob selectors; omitted or blank selects all eligible actions. |
| `since` | `string` | no | Relative duration such as 10m. |
| `tail` | `integer` | no | Maximum log lines per deployment. |
| `follow` | `boolean` | no | Stream continuously; bound with timeout-ms and a scoped lifecycle. |
| `timestamps` | `boolean` | no | Include native log timestamps. |
| `arguments` | `string` | no | Literal extra tokens as a comma-separated string; CSV quotes preserve commas inside tokens. |

Returns `Contract.ExecutionResult`.

## `cleanup-deploy`

Remove selected deployments; omitted names targets all eligible deployments in this project environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `environment` | `string` | no | Garden environment, optionally prefixed with a namespace (for example pr-123.ci). |
| `variables` | `string` | no | Comma-separated KEY=VALUE variable overrides. For secrets use native environment-backed Garden configuration. |
| `output` | `string` | no | Native structured result format; read it from the returned stdout path. Allowed values: json, yaml. |
| `log-level` | `string` | no | Native log verbosity. Allowed values: error, warn, info, verbose, debug, silly. |
| `yes` | `boolean` | no | Explicitly approve prompts and protected production commands; omitted never auto-approves. |
| `names` | `string` | no | Comma-separated action names or native glob selectors; omitted or blank selects all eligible actions. |
| `force` | `boolean` | no | Also remove deployments with removeOnCleanup disabled. |
| `dependants-first` | `boolean` | no | Clean in reverse dependency order. |
| `with-dependants` | `boolean` | no | Also remove downstream dependants. |
| `arguments` | `string` | no | Literal extra tokens as a comma-separated string; CSV quotes preserve commas inside tokens. |

Returns `Contract.ExecutionResult`.

## `cleanup-namespace`

Clean the project environment namespace; explicitly select the intended environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `environment` | `string` | no | Garden environment, optionally prefixed with a namespace (for example pr-123.ci). |
| `variables` | `string` | no | Comma-separated KEY=VALUE variable overrides. For secrets use native environment-backed Garden configuration. |
| `output` | `string` | no | Native structured result format; read it from the returned stdout path. Allowed values: json, yaml. |
| `log-level` | `string` | no | Native log verbosity. Allowed values: error, warn, info, verbose, debug, silly. |
| `yes` | `boolean` | no | Explicitly approve prompts and protected production commands; omitted never auto-approves. |
| `arguments` | `string` | no | Literal extra tokens as a comma-separated string; CSV quotes preserve commas inside tokens. |

Returns `Contract.ExecutionResult`.
