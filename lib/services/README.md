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
