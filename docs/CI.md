# CI coverage and runtime

Pushes and pull requests run the `essential` module profile. Every registered
module still compiles to a native Wasm component and runs its unit/host-fixture
tests and typed component validation on Linux and macOS. Registry, generator,
lockfile, documentation and workflow checks remain mandatory.

Essential runs skip native browser, formatter, build-tool, security-scanner and
upload integration suites. They also skip the final per-module composition/help
pass, which can rebuild shared setup dependencies after component validation.
They retain local filesystem installer and packaging tests. Artifact uploads
contain diagnostic logs rather than hundreds of large Wasm binaries.

The CI workflow runs the full profile nightly at 02:00 UTC. Select `full` when
manually dispatching CI to run those checks immediately. Local helpers retain
the full behavior unless `FLUENTCI_TEST_PROFILE=essential` is explicitly set.

Services E2E runs PostgreSQL, Redis and Caddy lifecycle smoke tests on pushes and
pull requests. The full catalog runs nightly at 02:30 UTC, or with the manual
`full` input, partitioned across eight independent runners. Each shard has a
40-minute deadline, isolated diagnostics and an incremental compiler cache.
Services within a shard remain sequential to avoid competing database processes.
No service profile is removed from full coverage.

`SERVICE_TEST_PROFILE=smoke` selects the smoke catalog. Full runs accept a
zero-based `SERVICE_TEST_SHARD` and `SERVICE_TEST_SHARDS` count; selection uses
catalog index modulo shard count. Defaults remain the full catalog in one shard.
Compiler concurrency continues to follow the host CPU count.

Runtime improvements must be measured in CI; these changes do not establish a
guaranteed completion time or prove that existing service failures are fixed.
