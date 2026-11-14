# mailcatcher component functions

Requires FluentCI v0.17.4 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `start`

Start an idempotent background service through FluentCI’s native workspace service manager and wait for readiness.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Workspace directory used by every native service manager call. Default: ".". |
| `name` | `string` | no | Full service name, default module-mailcatcher-default; must start with module-mailcatcher- to scope lifecycle operations. |
| `version` | `string` | no | Docker image version tag. Uses the profile default when omitted; cannot be combined with image. |
| `image` | `string` | no | Full Docker image reference, including an optional digest; replaces the default repository and version. |
| `port` | `integer` | no | Host port for the primary endpoint; zero allocates an available loopback port. AWS Emulator uses the same nonzero port inside and outside its container. Default: 0. |
| `ports` | `string` | no | Comma-separated container ports or HOST:CONTAINER bindings. Omit for every profile port with random host bindings. Include the primary port once. |
| `volumes` | `string` | no | Comma-separated /CONTAINER_PATH anonymous volumes or SOURCE:/CONTAINER_PATH[:ro\|rw] mounts. Explicit named/bind data survives stop. |
| `env` | `string` | no | Comma-separated KEY=VALUE test configuration overrides; no JSON object. Use disposable test values because definitions are sent to the manager. |
| `command` | `string` | no | Comma-separated foreground command tokens replacing the image command; literal argv, with no shell expansion. |
| `depends-on` | `string` | no | Comma-separated existing native service names whose readiness must be satisfied before startup. |
| `startup-timeout-ms` | `integer` | no | Readiness deadline, from 100 to 600000 milliseconds; defaults to the service profile. |
| `stop-timeout-ms` | `integer` | no | Graceful shutdown deadline from 100 to 120000 milliseconds. Default: 5000. |
| `restart-policy` | `string` | no | Native restart policy: never, on_failure or always. Default: "never". Allowed values: never, on_failure, always. |
| `max-restarts` | `integer` | no | Maximum automatic restarts, from zero to 100. Default: 0. |
| `health-check` | `boolean` | no | Keep running the readiness probe as the native recurring health check. Default: true. |
| `readiness-command` | `string` | no | Comma-separated literal probe command run inside the owned container; overrides the profile probe. |
| `readiness-path` | `string` | no | HTTP readiness URL path for profiles using an HTTP probe. |

Returns `Native.ServiceResult`.

## `stop`

Stop only this named service through the native manager; preserve explicitly mounted data. Native dependents are stopped too.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Workspace directory used by every native service manager call. Default: ".". |
| `name` | `string` | no | Full service name, default module-mailcatcher-default; must start with module-mailcatcher- to scope lifecycle operations. |

Returns `Native.ServiceResult`.

## `restart`

Restart the existing native service definition and wait for readiness.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Workspace directory used by every native service manager call. Default: ".". |
| `name` | `string` | no | Full service name, default module-mailcatcher-default; must start with module-mailcatcher- to scope lifecycle operations. |

Returns `Native.ServiceResult`.

## `status`

Return the service’s native lifecycle state and actual loopback port bindings.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Workspace directory used by every native service manager call. Default: ".". |
| `name` | `string` | no | Full service name, default module-mailcatcher-default; must start with module-mailcatcher- to scope lifecycle operations. |

Returns `Native.ServiceResult`.

## `logs`

Read native service logs; optionally follow new output until interrupted, without starting or stopping a service.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Workspace directory used by every native service manager call. Default: ".". |
| `name` | `string` | no | Full service name, default module-mailcatcher-default; must start with module-mailcatcher- to scope lifecycle operations. |
| `tail` | `integer` | no | Maximum recent log lines, from 1 to 10000, before optional live output. Default: 100. |
| `follow` | `boolean` | no | Stream new native service logs until interrupted. Default false returns a bounded snapshot. Interrupting logs leaves the background service running. Default: false. |

Returns `String`.
