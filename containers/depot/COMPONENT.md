# depot component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `setup`

Ensure depot is installed and verified, reusing an available matching version, and publish its environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `version` | `string` | no | Tool release or supported channel to install; omitted values use the documented default. |
| `install-dir` | `string` | no | Absolute per-user installation prefix; omit for native package installations. |
| `package-name` | `string` | no | Native package or port selector overriding the default repository package name. |
| `sudo` | `boolean` | no | Use noninteractive sudo for native package or system installation; defaults to false. |

Returns `Contract.SetupResult`.

## `run`

Run any Depot CLI command using literal comma-separated tokens.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | yes | Native Depot command and argument tokens as comma-separated text; never JSON. |

Returns `Contract.ExecutionResult`.

## `version`

Report the installed Depot CLI version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `build`

Build container images on Depot remote builders, optionally pushing, loading, or saving the result.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `project-id` | `string` | no | Depot project ID; otherwise native DEPOT_PROJECT_ID or depot.json is used. |
| `file` | `string` | no | Existing Dockerfile path relative to the project directory. |
| `tags` | `string` | no | Comma-separated image names and tags. |
| `platforms` | `string` | no | Comma-separated target platforms, for example linux/amd64,linux/arm64. |
| `build-args` | `string` | no | Comma-separated KEY=VALUE build arguments. Use native secret mounts for sensitive values. |
| `labels` | `string` | no | Comma-separated image metadata KEY=VALUE entries. |
| `secrets` | `string` | no | Comma-separated BuildKit secret specifications; CSV-quote specifications containing commas. Values should reference files or environment variable names. |
| `ssh` | `string` | no | Comma-separated SSH agent specifications. |
| `cache-from` | `string` | no | Comma-separated external cache specifications; CSV-quote entries containing commas. |
| `cache-to` | `string` | no | Comma-separated cache export specifications; CSV-quote entries containing commas. |
| `target` | `string` | no | Target Dockerfile build stage. |
| `output` | `string` | no | Native output specification, for example type=local,dest=dist. |
| `metadata-file` | `string` | no | Destination for build result metadata. |
| `progress` | `string` | no | Build progress output mode. Default: "plain". Allowed values: auto, plain, tty, rawjson. |
| `build-platform` | `string` | no | Depot builder architecture. Allowed values: dynamic, linux/amd64, linux/arm64. |
| `push` | `boolean` | no | Push the resulting image to its registry. |
| `load` | `boolean` | no | Load the image into the local Docker daemon; requires Docker. |
| `save` | `boolean` | no | Save the image in the Depot Registry. |
| `pull` | `boolean` | no | Always pull referenced base images. |
| `no-cache` | `boolean` | no | Build without reading cached layers. |
| `lint` | `boolean` | no | Lint Dockerfiles before building. |
| `context` | `string` | no | Build context directory or URL. Default: ".". |
| `extra-args` | `string` | no | Additional literal native argument tokens as comma-separated text. Quote CSV entries that contain commas; no shell expansion. |

Returns `Contract.ExecutionResult`.

## `bake`

Build multiple targets from Bake or Compose definitions.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `project-id` | `string` | no | Depot project ID; otherwise native DEPOT_PROJECT_ID or depot.json is used. |
| `files` | `string` | no | Comma-separated existing Bake HCL, JSON, or Compose files. |
| `set` | `string` | no | Comma-separated targetpattern.key=value overrides; CSV-quote values containing commas. |
| `targets` | `string` | no | Comma-separated Bake targets; blank selects native defaults. |
| `push` | `boolean` | no | Push built target images. |
| `load` | `boolean` | no | Load images into the local Docker daemon. |
| `print` | `boolean` | no | Print the resolved build definition without building. |
| `no-cache` | `boolean` | no | Disable layer cache reads. |
| `metadata-file` | `string` | no | Destination for build metadata. |
| `progress` | `string` | no | Build progress mode. Default: "plain". |
| `extra-args` | `string` | no | Additional literal native argument tokens as comma-separated text. Quote CSV entries that contain commas; no shell expansion. |

Returns `Contract.ExecutionResult`.

## `cache-reset`

Reset the selected project build cache.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `project-id` | `string` | no | Depot project ID; otherwise native DEPOT_PROJECT_ID or depot.json is used. |
| `extra-args` | `string` | no | Additional literal native argument tokens as comma-separated text. Quote CSV entries that contain commas; no shell expansion. |

Returns `Contract.ExecutionResult`.

## `list-builds`

List recent builds with machine-readable output.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `project-id` | `string` | no | Depot project ID; otherwise native DEPOT_PROJECT_ID or depot.json is used. |
| `output` | `string` | no | Noninteractive result format. Default: "json". Allowed values: json, csv. |
| `extra-args` | `string` | no | Additional literal native argument tokens as comma-separated text. Quote CSV entries that contain commas; no shell expansion. |

Returns `Contract.ExecutionResult`.

## `projects-list`

List accessible projects without opening an interactive selector.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `output` | `string` | no | Noninteractive result format. Default: "json". Allowed values: json, csv. |
| `extra-args` | `string` | no | Additional literal native argument tokens as comma-separated text. Quote CSV entries that contain commas; no shell expansion. |

Returns `Contract.ExecutionResult`.

## `projects-get`

Read project configuration using an organization token.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `project-id` | `string` | no | Project ID; otherwise native project configuration is used. |
| `output` | `string` | no | Machine-readable result format. Default: "json". Allowed values: json. |
| `extra-args` | `string` | no | Additional literal native argument tokens as comma-separated text. Quote CSV entries that contain commas; no shell expansion. |

Returns `Contract.ExecutionResult`.

## `projects-create`

Create a Depot project with explicit organization and build storage settings.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `name` | `string` | yes | New project name. |
| `organization` | `string` | no | Depot organization ID. |
| `region` | `string` | no | Build data region. |
| `cache-storage-policy` | `integer` | no | Cache storage in GB; upstream validates supported limits. |
| `extra-args` | `string` | no | Additional literal native argument tokens as comma-separated text. Quote CSV entries that contain commas; no shell expansion. |

Returns `Contract.ExecutionResult`.

## `build-cancel`

Cancel selected builds or explicitly preview/bulk-cancel running project builds. Requires an organization API token.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `project-id` | `string` | no | Depot project ID; otherwise native DEPOT_PROJECT_ID or depot.json is used. |
| `build-ids` | `string` | no | Comma-separated build IDs; native bulk selection requires allRunning and projectId. |
| `all-running` | `boolean` | no | Select all running builds in the explicitly selected project. |
| `dry-run` | `boolean` | no | Preview cancellation without changing builds. |
| `yes` | `boolean` | no | Explicitly approve bulk cancellation without prompting. |
| `output` | `string` | no | Machine-readable output. Default: "json". Allowed values: json. |
| `extra-args` | `string` | no | Additional literal native argument tokens as comma-separated text. Quote CSV entries that contain commas; no shell expansion. |

Returns `Contract.ExecutionResult`.

## `configure-docker`

Configure or remove Depot Docker integration; requires Docker.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `uninstall` | `boolean` | no | Remove the Depot Docker integration instead of configuring it. |
| `extra-args` | `string` | no | Additional literal native argument tokens as comma-separated text. Quote CSV entries that contain commas; no shell expansion. |

Returns `Contract.ExecutionResult`.
