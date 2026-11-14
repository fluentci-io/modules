# CI workflows

The main [CI workflow](./workflows/ci.yml) validates every registered PureScript
component and generated contract, then builds/tests module batches on bounded
Linux/macOS runners. Toolchains come from checksum-verified published FluentCI
setup components through the local setup-toolchain action.

## Service module end-to-end tests

[Services E2E](./workflows/services-e2e.yml) is path-filtered and can also be run
manually. One Ubuntu runner builds and composes every services/* Wasm component,
then runs all services sequentially through the native workspace service manager.
It verifies idempotent background start, readiness/protocol connectivity, real
restart, bounded logs, stop, and named-volume preservation. AWS Emulator uses the
official RPM image builder and validates its generated TLS/credential material.
Only the private fixture workspace, owned service names, exact test images and
explicit test volume are cleaned up. Diagnostic logs are uploaded on failure.

The runner must provide a FluentCI build containing the native services apply,
status, restart and stop commands. The workflow checks the API before starting
containers. Docker's daemon must be available on the Ubuntu runner. Normal unit
tests mock the manager and do not pull images or start services.
