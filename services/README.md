# Background test services

Every service exposes typed PureScript start, stop, restart, status and logs
functions backed by FluentCI's native workspace service manager. Docker is the
service backend; FluentCI supervises its foreground process and owned container.
There is no docker run -d, legacy asService provider, or external process manager.

Service modules require **FluentCI v0.17.4 or newer**. Dynamic port placeholders
resolve to the complete loopback address (`127.0.0.1:PORT`). HTTP probes use
`http://${port:CONTAINER}/path`; TCP probes use `${port:CONTAINER}`. Version
0.17.4 validates HTTP URLs after placeholder substitution.

```sh
fluentci run redis start --version 7-alpine
fluentci run redis status
fluentci run redis logs --tail 50
fluentci run redis logs --tail 50 --follow true
fluentci run redis restart
fluentci run redis stop
```

Start waits for the configured readiness probe, returns the allocated loopback
ports, and reuses an unchanged running definition. Stop is idempotent and targets
only the module's named service; the native manager also stops its dependents.
Restart reuses the existing definition. Changing image/version, mounts, ports or
configuration requires stopping first. Logs return bounded snapshots by default. Set --follow true to stream new output
until interrupted; interrupting the log viewer leaves the service running.

The native shorthand `fluentci logs module-redis-default -f` follows the same
service in the current workspace. Module arguments use the named `--follow true`
option. A follow call stays attached and does not return a snapshot while active;
use the default snapshot mode in CI steps that must finish.

Names default to module-TOOL-default. Custom names must start with module-TOOL-.
Use the same project workspace and name across calls. Services span calls, so CI
must stop manually started services in cleanup/finally steps. Native
fluentci services run --service NAME -- COMMAND provides leased test execution;
a service manually started with these modules still needs an explicit stop.

Docker must be installed and its daemon reachable. Missing Docker CLI tools use
the typed setup-docker dependency, while status/logs/stop do not install anything.
Linux and macOS Docker Desktop/VM environments can expose the returned loopback
ports directly. BSD requires a suitable daemon and forwarding its loopback-bound
ports to the caller. Image architecture support remains an upstream constraint;
older images may require Docker emulation.

--version selects a Docker tag. --image selects a full reference, including a
sha256 digest; the two options are mutually exclusive. Image defaults are listed
in each module README. Pin an exact version or digest for reproducible pipelines.
Ports default to dynamically allocated loopback host ports. --port fixes the primary
host port; --ports configures comma-separated CONTAINER or HOST:CONTAINER mappings.
Only TCP mappings are supported by the native manager. Each module returns name,
state, backend, host, primary port, endpoint and all container/host port bindings.
An absent/stopped service has no active endpoint or stale port bindings.

All list inputs are CSV strings: ports, volumes, env KEY=VALUE, command tokens,
depends-on names, and readiness-command tokens. Whitespace is trimmed, blank
optional lists keep defaults, and empty entries are rejected before setup.
CSV double quotes preserve literal commas. No public input requires JSON objects
or arrays. Commands are literal argv without shell expansion. Override env and
readiness-command together when an application probe depends on changed settings.

Data is disposable by default. --volumes accepts anonymous /CONTAINER paths,
named-volume:/CONTAINER paths, and absolute-host:/CONTAINER[:ro|rw] bindings.
Explicit named/bind data is preserved by stop; deleting it is a separate user
operation. Database profiles use documented synthetic test credentials, not
production secrets. Environment overrides are included in the manager definition,
so use disposable test configuration values.

AWS Emulator is the official aws/aws-emulator project. It has a dedicated build
function for its official RPM, fixed matched host/container ports, and caller-owned
TLS/credential material. See its README rather than treating it as a public
prebuilt image or a different AWS emulator.

CI's dedicated Services E2E workflow builds and composes all real Wasm modules,
checks readiness and connectivity, proves idempotent start and real restart,
reads bounded logs, verifies Redis log streaming and interruption without stopping
the service, stops every service, and verifies named-volume preservation.

Component builds use four workers on the same runner. Set
`SERVICE_BUILD_CONCURRENCY` to an integer from 1 to 4 to adjust the pool. Shared
setup-dependency preparation and composition are serialized to protect their
build directories. Docker lifecycle checks stay sequential to limit memory use.
It uses one Ubuntu runner with sequential services and a path-filtered trigger.
