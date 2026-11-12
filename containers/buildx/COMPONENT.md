# buildx component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `buildx`

Run Docker Buildx buildx and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `arguments` | `array` | no | Subcommand positional arguments; prefer the corresponding named export. Default: []. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |

Returns `Contract.ExecutionResult`.

## `dap`

Run Docker Buildx dap and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `arguments` | `array` | no | Subcommand positional arguments; prefer the corresponding named export. Default: []. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |

Returns `Contract.ExecutionResult`.

## `debug`

Run Docker Buildx debug and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `arguments` | `array` | no | Subcommand positional arguments; prefer the corresponding named export. Default: []. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `invoke` | `string` | no | --invoke: Launch a monitor with executing specified |
| `on` | `string` | no | --on: When to launch the monitor ([always, error]) |

Returns `Contract.ExecutionResult`.

## `history`

Run Docker Buildx history and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `arguments` | `array` | no | Subcommand positional arguments; prefer the corresponding named export. Default: []. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |

Returns `Contract.ExecutionResult`.

## `imagetools`

Run Docker Buildx imagetools and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `arguments` | `array` | no | Subcommand positional arguments; prefer the corresponding named export. Default: []. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |

Returns `Contract.ExecutionResult`.

## `policy`

Run Docker Buildx policy and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `arguments` | `array` | no | Subcommand positional arguments; prefer the corresponding named export. Default: []. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |

Returns `Contract.ExecutionResult`.

## `bake`

Run Docker Buildx bake and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `targets` | `array` | no | Bake targets. Default: []. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `allow` | `array` | no | --allow: Allow build to access specified resources |
| `call` | `string` | no | --call: Set method for evaluating build ("check", |
| `check` | `boolean` | no | --check: Shorthand for "--call=check" |
| `file` | `array` | no | --file: Build definition file |
| `list` | `string` | no | --list: List targets or variables |
| `load` | `boolean` | no | --load: Shorthand for |
| `metadata-file` | `string` | no | --metadata-file: Write build result metadata to a file |
| `no-cache` | `boolean` | no | --no-cache: Do not use cache when building the image |
| `policy` | `array` | no | --policy: Global policy evaluation options (format: |
| `print` | `boolean` | no | --print: Print the options without building |
| `progress` | `string` | no | --progress: Set type of progress output ("auto", |
| `provenance` | `string` | no | --provenance: Shorthand for "--set=*.attest=type=provenance" |
| `pull` | `boolean` | no | --pull: Always attempt to pull all referenced images |
| `push` | `boolean` | no | --push: Shorthand for |
| `sbom` | `string` | no | --sbom: Shorthand for "--set=*.attest=type=sbom" |
| `set` | `array` | no | --set: Override target value (e.g., |
| `var` | `array` | no | --var: Set a variable value (e.g., "name=value") |

Returns `Contract.ExecutionResult`.

## `build`

Run Docker Buildx build and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `context` | `string` | no | Build context: path, URL or '-' (stdin is not forwarded by the guest). Default: ".". |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `add-host` | `array` | no | --add-host: Add a custom host-to-IP mapping |
| `allow` | `array` | no | --allow: Allow extra privileged entitlement |
| `annotation` | `array` | no | --annotation: Add annotation to the image |
| `attest` | `array` | no | --attest: Attestation parameters (format: |
| `build-arg` | `array` | no | --build-arg: Set build-time variables |
| `build-context` | `array` | no | --build-context: Additional build contexts (e.g., |
| `cache-from` | `array` | no | --cache-from: External cache sources (e.g., |
| `cache-to` | `array` | no | --cache-to: Cache export destinations (e.g., |
| `call` | `string` | no | --call: Set method for evaluating build |
| `cgroup-parent` | `string` | no | --cgroup-parent: Set the parent cgroup for the "RUN" |
| `check` | `boolean` | no | --check: Shorthand for "--call=check" |
| `file` | `string` | no | --file: Name of the Dockerfile (default: |
| `iidfile` | `string` | no | --iidfile: Write the image ID to a file |
| `label` | `array` | no | --label: Set metadata for an image |
| `load` | `boolean` | no | --load: Shorthand for "--output=type=docker" |
| `metadata-file` | `string` | no | --metadata-file: Write build result metadata to a file |
| `network` | `string` | no | --network: Set the networking mode for the |
| `no-cache` | `boolean` | no | --no-cache: Do not use cache when building the image |
| `no-cache-filter` | `array` | no | --no-cache-filter: Do not cache specified stages |
| `output` | `array` | no | --output: Output destination (format: |
| `platform` | `array` | no | --platform: Set target platform for build |
| `policy` | `array` | no | --policy: Policy configuration (format: |
| `progress` | `string` | no | --progress: Set type of progress output |
| `provenance` | `string` | no | --provenance: Shorthand for "--attest=type=provenance" |
| `pull` | `boolean` | no | --pull: Always attempt to pull all |
| `push` | `boolean` | no | --push: Shorthand for |
| `quiet` | `boolean` | no | --quiet: Suppress the build output and print |
| `resource` | `array` | no | --resource: Resource limits for build |
| `sbom` | `string` | no | --sbom: Shorthand for "--attest=type=sbom" |
| `secret` | `array` | no | --secret: Secret to expose to the build |
| `shm-size` | `string` | no | --shm-size: Shared memory size for build containers |
| `ssh` | `array` | no | --ssh: SSH agent socket or keys to expose |
| `tag` | `array` | no | --tag: Image identifier (format: |
| `target` | `string` | no | --target: Set the target build stage to build |
| `ulimit` | `array` | no | --ulimit: Ulimit options (default []) |

Returns `Contract.ExecutionResult`.

## `create`

Run Docker Buildx create and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `endpoint` | `string` | no | Builder context or endpoint. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `append` | `boolean` | no | --append: Append a node to builder instead of |
| `bootstrap` | `boolean` | no | --bootstrap: Boot builder after creation |
| `buildkitd-config` | `string` | no | --buildkitd-config: BuildKit daemon config file |
| `buildkitd-flags` | `string` | no | --buildkitd-flags: BuildKit daemon flags |
| `driver` | `string` | no | --driver: Driver to use (available: "cloud", |
| `driver-opt` | `array` | no | --driver-opt: Options for the driver |
| `leave` | `boolean` | no | --leave: Remove a node from builder instead of |
| `name` | `string` | no | --name: Builder instance name |
| `node` | `string` | no | --node: Create/modify node with given name |
| `platform` | `array` | no | --platform: Fixed platforms for current node |
| `timeout` | `string` | no | --timeout: Override the default timeout for |
| `use` | `boolean` | no | --use: Set the current builder instance |

Returns `Contract.ExecutionResult`.

## `dial-stdio`

Run Docker Buildx dial stdio and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `platform` | `string` | no | --platform: Target platform: this is used for node selection |
| `progress` | `string` | no | --progress: Set type of progress output ("auto", "plain", |

Returns `Contract.ExecutionResult`.

## `du`

Run Docker Buildx du and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `filter` | `array` | no | --filter: Provide filter values |
| `format` | `string` | no | --format: Format the output |
| `timeout` | `string` | no | --timeout: Override the default timeout for loading |
| `verbose` | `boolean` | no | --verbose: Shorthand for "--format=pretty" |

Returns `Contract.ExecutionResult`.

## `inspect`

Run Docker Buildx inspect and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `name` | `string` | no | Builder instance name. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `bootstrap` | `boolean` | no | --bootstrap: Ensure builder has booted before inspecting |
| `timeout` | `string` | no | --timeout: Override the default timeout for loading |

Returns `Contract.ExecutionResult`.

## `ls`

Run Docker Buildx ls and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `format` | `string` | no | --format: Format the output (default "table") |
| `no-trunc` | `boolean` | no | --no-trunc: Don't truncate output |
| `timeout` | `string` | no | --timeout: Override the default timeout for loading |

Returns `Contract.ExecutionResult`.

## `prune`

Run Docker Buildx prune and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `all` | `boolean` | no | --all: Include internal/frontend images |
| `filter` | `array` | no | --filter: Provide filter values |
| `force` | `boolean` | no | --force: Do not prompt for confirmation |
| `max-used-space` | `string` | no | --max-used-space: Maximum amount of disk space allowed to |
| `min-free-space` | `string` | no | --min-free-space: Target amount of free disk space after pruning |
| `reserved-space` | `string` | no | --reserved-space: Amount of disk space always allowed to |
| `timeout` | `string` | no | --timeout: Override the default timeout for loading |
| `verbose` | `boolean` | no | --verbose: Provide a more verbose output |

Returns `Contract.ExecutionResult`.

## `rm`

Run Docker Buildx rm and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `names` | `array` | no | Builder instance names. Default: []. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `all-inactive` | `boolean` | no | --all-inactive: Remove all inactive builders |
| `force` | `boolean` | no | --force: Do not prompt for confirmation |
| `keep-daemon` | `boolean` | no | --keep-daemon: Keep the BuildKit daemon running |
| `keep-state` | `boolean` | no | --keep-state: Keep BuildKit state |
| `timeout` | `string` | no | --timeout: Override the default timeout for loading |

Returns `Contract.ExecutionResult`.

## `stop`

Run Docker Buildx stop and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `name` | `string` | no | Builder instance name. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |

Returns `Contract.ExecutionResult`.

## `use`

Run Docker Buildx use and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `name` | `string` | no | Required builder/image name. Default: "". |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `default` | `boolean` | no | --default: Set builder as default for current context |
| `global` | `boolean` | no | --global: Builder persists context changes |

Returns `Contract.ExecutionResult`.

## `version`

Run Docker Buildx version and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |

Returns `Contract.ExecutionResult`.

## `dap-build`

Run Docker Buildx dap build and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `context` | `string` | no | Build context: path, URL or '-' (stdin is not forwarded by the guest). Default: ".". |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `add-host` | `array` | no | --add-host: Add a custom host-to-IP mapping |
| `allow` | `array` | no | --allow: Allow extra privileged entitlement |
| `annotation` | `array` | no | --annotation: Add annotation to the image |
| `attest` | `array` | no | --attest: Attestation parameters (format: |
| `build-arg` | `array` | no | --build-arg: Set build-time variables |
| `build-context` | `array` | no | --build-context: Additional build contexts (e.g., |
| `cache-from` | `array` | no | --cache-from: External cache sources (e.g., |
| `cache-to` | `array` | no | --cache-to: Cache export destinations (e.g., |
| `call` | `string` | no | --call: Set method for evaluating build |
| `cgroup-parent` | `string` | no | --cgroup-parent: Set the parent cgroup for the "RUN" |
| `check` | `boolean` | no | --check: Shorthand for "--call=check" |
| `file` | `string` | no | --file: Name of the Dockerfile (default: |
| `iidfile` | `string` | no | --iidfile: Write the image ID to a file |
| `label` | `array` | no | --label: Set metadata for an image |
| `load` | `boolean` | no | --load: Shorthand for "--output=type=docker" |
| `metadata-file` | `string` | no | --metadata-file: Write build result metadata to a file |
| `network` | `string` | no | --network: Set the networking mode for the |
| `no-cache` | `boolean` | no | --no-cache: Do not use cache when building the image |
| `no-cache-filter` | `array` | no | --no-cache-filter: Do not cache specified stages |
| `output` | `array` | no | --output: Output destination (format: |
| `platform` | `array` | no | --platform: Set target platform for build |
| `policy` | `array` | no | --policy: Policy configuration (format: |
| `progress` | `string` | no | --progress: Set type of progress output |
| `provenance` | `string` | no | --provenance: Shorthand for "--attest=type=provenance" |
| `pull` | `boolean` | no | --pull: Always attempt to pull all |
| `push` | `boolean` | no | --push: Shorthand for |
| `quiet` | `boolean` | no | --quiet: Suppress the build output and print |
| `resource` | `array` | no | --resource: Resource limits for build |
| `sbom` | `string` | no | --sbom: Shorthand for "--attest=type=sbom" |
| `secret` | `array` | no | --secret: Secret to expose to the build |
| `shm-size` | `string` | no | --shm-size: Shared memory size for build containers |
| `ssh` | `array` | no | --ssh: SSH agent socket or keys to expose |
| `tag` | `array` | no | --tag: Image identifier (format: |
| `target` | `string` | no | --target: Set the target build stage to build |
| `ulimit` | `array` | no | --ulimit: Ulimit options (default []) |

Returns `Contract.ExecutionResult`.

## `debug-build`

Run Docker Buildx debug build and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `context` | `string` | no | Build context: path, URL or '-' (stdin is not forwarded by the guest). Default: ".". |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `invoke` | `string` | no | --invoke: Launch a monitor with executing specified |
| `on` | `string` | no | --on: When to launch the monitor ([always, error]) |
| `add-host` | `array` | no | --add-host: Add a custom host-to-IP mapping |
| `allow` | `array` | no | --allow: Allow extra privileged entitlement |
| `annotation` | `array` | no | --annotation: Add annotation to the image |
| `attest` | `array` | no | --attest: Attestation parameters (format: |
| `build-arg` | `array` | no | --build-arg: Set build-time variables |
| `build-context` | `array` | no | --build-context: Additional build contexts (e.g., |
| `cache-from` | `array` | no | --cache-from: External cache sources (e.g., |
| `cache-to` | `array` | no | --cache-to: Cache export destinations (e.g., |
| `call` | `string` | no | --call: Set method for evaluating build |
| `cgroup-parent` | `string` | no | --cgroup-parent: Set the parent cgroup for the "RUN" |
| `check` | `boolean` | no | --check: Shorthand for "--call=check" |
| `file` | `string` | no | --file: Name of the Dockerfile (default: |
| `iidfile` | `string` | no | --iidfile: Write the image ID to a file |
| `label` | `array` | no | --label: Set metadata for an image |
| `load` | `boolean` | no | --load: Shorthand for "--output=type=docker" |
| `metadata-file` | `string` | no | --metadata-file: Write build result metadata to a file |
| `network` | `string` | no | --network: Set the networking mode for the |
| `no-cache` | `boolean` | no | --no-cache: Do not use cache when building the image |
| `no-cache-filter` | `array` | no | --no-cache-filter: Do not cache specified stages |
| `output` | `array` | no | --output: Output destination (format: |
| `platform` | `array` | no | --platform: Set target platform for build |
| `policy` | `array` | no | --policy: Policy configuration (format: |
| `progress` | `string` | no | --progress: Set type of progress output |
| `provenance` | `string` | no | --provenance: Shorthand for "--attest=type=provenance" |
| `pull` | `boolean` | no | --pull: Always attempt to pull all |
| `push` | `boolean` | no | --push: Shorthand for |
| `quiet` | `boolean` | no | --quiet: Suppress the build output and print |
| `resource` | `array` | no | --resource: Resource limits for build |
| `sbom` | `string` | no | --sbom: Shorthand for "--attest=type=sbom" |
| `secret` | `array` | no | --secret: Secret to expose to the build |
| `shm-size` | `string` | no | --shm-size: Shared memory size for build containers |
| `ssh` | `array` | no | --ssh: SSH agent socket or keys to expose |
| `tag` | `array` | no | --tag: Image identifier (format: |
| `target` | `string` | no | --target: Set the target build stage to build |
| `ulimit` | `array` | no | --ulimit: Ulimit options (default []) |

Returns `Contract.ExecutionResult`.

## `history-inspect`

Run Docker Buildx history inspect and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `arguments` | `array` | no | Subcommand positional arguments; prefer the corresponding named export. Default: []. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `format` | `string` | no | --format: Format the output (default "pretty") |

Returns `Contract.ExecutionResult`.

## `history-export`

Run Docker Buildx history export and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `refs` | `array` | no | Build record references. Default: []. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `all` | `boolean` | no | --all: Export all build records for the builder |
| `finalize` | `boolean` | no | --finalize: Ensure build records are finalized before exporting |
| `output` | `string` | no | --output: Output file path |

Returns `Contract.ExecutionResult`.

## `history-import`

Run Docker Buildx history import and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `arguments` | `array` | no | Import positional arguments; use the file option instead of interactive stdin. Default: []. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `file` | `array` | no | --file: Import from a file path |

Returns `Contract.ExecutionResult`.

## `history-logs`

Run Docker Buildx history logs and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `ref` | `string` | no | Build record reference. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `progress` | `string` | no | --progress: Set type of progress output (plain, rawjson, |

Returns `Contract.ExecutionResult`.

## `history-ls`

Run Docker Buildx history ls and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `filter` | `array` | no | --filter: Provide filter values (e.g., "status=error") |
| `format` | `string` | no | --format: Format the output (default "table") |
| `local` | `boolean` | no | --local: List records for current repository only |
| `no-trunc` | `boolean` | no | --no-trunc: Don't truncate output |

Returns `Contract.ExecutionResult`.

## `history-open`

Run Docker Buildx history open and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `ref` | `string` | no | Build record reference. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |

Returns `Contract.ExecutionResult`.

## `history-rm`

Run Docker Buildx history rm and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `refs` | `array` | no | Build record references. Default: []. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `all` | `boolean` | no | --all: Remove all build records |

Returns `Contract.ExecutionResult`.

## `history-trace`

Run Docker Buildx history trace and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `ref` | `string` | no | Build record reference. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `addr` | `string` | no | --addr: Address to bind the UI server (default "127.0.0.1:0") |
| `compare` | `string` | no | --compare: Compare with another build record |

Returns `Contract.ExecutionResult`.

## `imagetools-create`

Run Docker Buildx imagetools create and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `sources` | `array` | no | Image source references. Default: []. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `annotation` | `array` | no | --annotation: Add annotation to the image |
| `append` | `boolean` | no | --append: Append to existing manifest |
| `dry-run` | `boolean` | no | --dry-run: Show final image instead of pushing |
| `file` | `array` | no | --file: Read source descriptor from file |
| `metadata-file` | `string` | no | --metadata-file: Write create result metadata to a file |
| `platform` | `array` | no | --platform: Filter specified platforms of target image |
| `prefer-index` | `boolean` | no | --prefer-index: When only a single source is specified, |
| `progress` | `string` | no | --progress: Set type of progress output ("auto", |
| `tag` | `array` | no | --tag: Set reference for new image |

Returns `Contract.ExecutionResult`.

## `imagetools-inspect`

Run Docker Buildx imagetools inspect and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `name` | `string` | no | Required builder/image name. Default: "". |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `format` | `string` | no | --format: Format the output using the given Go template |
| `raw` | `boolean` | no | --raw: Show original, unformatted JSON manifest |

Returns `Contract.ExecutionResult`.

## `policy-eval`

Run Docker Buildx policy eval and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `source` | `string` | no | Required policy evaluation source. Default: "". |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `fields` | `array` | no | --fields: Fields to evaluate |
| `file` | `string` | no | --file: Policy filename to evaluate (default "Dockerfile") |
| `platform` | `string` | no | --platform: Target platform for policy evaluation |
| `print` | `boolean` | no | --print: Print policy output |

Returns `Contract.ExecutionResult`.

## `policy-test`

Run Docker Buildx policy test and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `path` | `string` | no | Policy test directory. Default: ".". |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `filename` | `string` | no | --filename: Name of the Dockerfile to validate (default |
| `run` | `string` | no | --run: Run only tests with name containing this substring |

Returns `Contract.ExecutionResult`.

## `history-inspect-attachment`

Run Docker Buildx history inspect attachment and return execution report paths.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `docker` | `string` | no | Docker executable name or absolute path. Default: "docker". |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `experimental` | `boolean` | no | Enable experimental Docker Buildx features. Default: false. |
| `references` | `array` | no | Optional REF and DIGEST positional arguments. Default: []. |
| `builder` | `string` | no | --builder: Override the configured builder instance |
| `debug` | `boolean` | no | --debug: Enable debug logging |
| `format` | `string` | no | --format: Format the output (default "pretty") |
| `platform` | `string` | no | --platform: Platform of attachment |
| `type` | `string` | no | --type: Type of attachment |

Returns `Contract.ExecutionResult`.
