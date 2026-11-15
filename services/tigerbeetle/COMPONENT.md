# tigerbeetle component functions

Requires FluentCI v0.17.4 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `start`

Install a verified prebuilt TigerBeetle release, format a development data file if needed, and start it with FluentCI’s native host service manager.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Workspace directory used for native lifecycle calls and ownership metadata. Default: . |
| `name` | `string` | no | Service name beginning with module-tigerbeetle-. Default module-tigerbeetle-default. |
| `version` | `string` | no | Official prebuilt TigerBeetle release, or latest. Default 0.17.9. Stop before changing versions. |
| `port` | `integer` | no | Explicit loopback host port, from 1 to 65535. Default 3000; native host services do not allocate Docker ports. |
| `state-dir` | `string` | yes | Required absolute caller-owned data directory. Formats a single development replica only when no data file exists; stop preserves data. |
| `cache-grid` | `string` | no | Grid cache size such as 256MiB or 1GiB. Default 256MiB for CI. |
| `extra-args` | `string` | no | Comma-separated extra native option tokens. Whitespace is trimmed and empty entries rejected; use typed port/cacheGrid instead of overriding those flags. |
| `startup-timeout-ms` | `integer` | no | Native TCP readiness deadline, from 100 to 600000 milliseconds. Default 60000. |
| `stop-timeout-ms` | `integer` | no | Native stop deadline, from 100 to 120000 milliseconds. Default 5000. |

Returns `Native.ServiceResult`.

## `stop`

Stop only this named service through the native manager; preserve explicitly mounted data. Native dependents are stopped too.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Workspace directory used by every native service manager call. Default: ".". |
| `name` | `string` | no | Full service name, default module-tigerbeetle-default; must start with module-tigerbeetle- to scope lifecycle operations. |

Returns `Native.ServiceResult`.

## `restart`

Restart the existing native service definition and wait for readiness.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Workspace directory used by every native service manager call. Default: ".". |
| `name` | `string` | no | Full service name, default module-tigerbeetle-default; must start with module-tigerbeetle- to scope lifecycle operations. |

Returns `Native.ServiceResult`.

## `status`

Return the service’s native lifecycle state and actual loopback port bindings.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Workspace directory used by every native service manager call. Default: ".". |
| `name` | `string` | no | Full service name, default module-tigerbeetle-default; must start with module-tigerbeetle- to scope lifecycle operations. |

Returns `Native.ServiceResult`.

## `logs`

Read native service logs; optionally follow new output until interrupted, without starting or stopping a service.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Workspace directory used by every native service manager call. Default: ".". |
| `name` | `string` | no | Full service name, default module-tigerbeetle-default; must start with module-tigerbeetle- to scope lifecycle operations. |
| `tail` | `integer` | no | Maximum recent log lines, from 1 to 10000, before optional live output. Default: 100. |
| `follow` | `boolean` | no | Stream new native service logs until interrupted. Default false returns a bounded snapshot. Interrupting logs leaves the background service running. Default: false. |

Returns `String`.
