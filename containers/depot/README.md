# Depot

Typed PureScript WebAssembly component for Depot remote container builds. Requires FluentCI v0.17.3+.

```sh
fluentci run depot setup --version latest
fluentci run depot build --run-dir /tmp/depot-build-001 --project-id my-project --context . --tags ghcr.io/acme/app:latest --platforms linux/amd64,linux/arm64 --push
fluentci run depot bake --run-dir /tmp/depot-bake-001 --files docker-bake.hcl --targets app,worker --push
fluentci run depot list-builds --run-dir /tmp/depot-list-001 --project-id my-project
fluentci run depot run --run-dir /tmp/depot-native-001 --arguments projects,trust-policy,list,--output,json
```

Every operation runs a setup preflight, including calls with an explicit executable.
A usable installed Depot CLI skips installation; missing tools use the typed
[setup-depot](../../setup/depot/README.md) dependency and are checked again before execution.
Explicit `setup` installs or reuses a verified version, returns tool/version/bin-dir/environment,
and accepts version, install-dir, package-name and sudo. Official archive installs are per-user;
omit package-name and sudo. An explicit install-dir selects a managed prefix.
Only Linux and macOS on x86_64/aarch64 are supported; other hosts fail before installation.

Authentication uses inherited `DEPOT_TOKEN` or Depot's native CI OIDC support.
Configure `DEPOT_PROJECT_ID`, commit depot.json, or pass project-id. Do not pass tokens
in argument lists. Remote builds do not require a local Docker daemon; load and
configure-docker require Docker. Organization-level operations require the appropriate
organization token and permissions. Cache reset and build cancellation mutate remote state;
bulk cancellation requires explicit native flags and is never silently approved.

Lists accept comma-separated strings, never JSON arrays or objects. Whitespace is
trimmed and empty entries are rejected before setup. Use CSV double quotes around an
entry containing commas, for example `--cache-to '"type=registry,ref=ghcr.io/acme/cache,mode=max"'`.
Tokens are literal argv, with no shell expansion. Blank optional lists add no arguments.

Exports cover setup, build, bake, build cancellation, cache reset, machine-readable
build/project listings, project creation/inspection, Docker configuration, version,
and a literal `run` escape hatch for every other upstream command. See
[COMPONENT.md](./COMPONENT.md) for typed arguments and returns and [OPTIONS.md](./OPTIONS.md)
for native flags. Each operation needs a fresh run-dir and returns report and log paths.
Nonzero exit, timeout, setup, and transport failures propagate without successful results.

Installation uses official [Depot CLI releases](https://github.com/depot/cli/releases),
checks SHA-256 from GitHub asset metadata or the exact release checksum entry, verifies
its executable version, and publishes PATH. A failed download never reports setup success.
The reviewed native commands are documented in [Depot's CLI reference](https://depot.dev/docs/cli/reference/container-builds).

## Development

CI builds and runs the mocked contract, installer, dependency, and command-plan regression suites.
The shared catalogs and generators keep source descriptions, schemas, WIT inputs, and docs aligned.
License: MIT.
