# Native service module library

PureScript service lifecycle and AWS Emulator image-building logic shared by every
services/* component. Profiles are defined in catalog.json; regenerate their
PureScript representation with `escript scripts/fluentci_modules_ci generate-services`.

Uses FluentCI's native workspace manager API through the documented host exec
JSON interface. It never uses the legacy asService/process-compose provider,
Docker detach, global docker cleanup, or an unrelated process manager. Native
manager readiness, health, restart, loopback port binding and owned-container
cleanup remain authoritative. Plan-local services are scoped to a single plan;
these modules deliberately use the workspace API so separate start/stop calls work.

Runtime checks belong in CI. The dedicated Services E2E workflow executes every
real service component and its native lifecycle on one sequential Ubuntu runner.

Readiness must verify the published endpoint. The etcd and Consul profiles use native
HTTP health endpoints through `${port:2379}` and `${port:8500}`, so an in-container health success
cannot hide an undiscovered host binding. Stop and log operations validate native
service ownership independently of endpoint metadata, allowing diagnosis and
cleanup when a ready service has missing bindings. Failed fresh starts are stopped
through the native manager before the original error is propagated; previously
running services are preserved.
