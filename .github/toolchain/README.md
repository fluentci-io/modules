# CI toolchain

CI installs the published `fluentci.io` components `setup-node@0.2.0`,
`setup-bun@0.2.0`, `setup-uv@0.2.0`, and `setup-purescript@0.2.0`.
[versions.json](./versions.json) pins module versions, runtime versions, the
publisher DID, and SHA-256 digests for each bootstrap CLI archive.

The runner's existing Python 3.9+ downloads and verifies the CLI archive. No
`actions/setup-node`, `actions/setup-python`, or `oven-sh/setup-bun` is used.
uv installs the requested managed Python version. The full profile also uses
`setup-purescript` to install the compiler, Spago, and npm with explicit versions.

The released CLI bootstrap is currently v0.17.2. The v0.17.3 source fix has been
pushed, but that release was not available when this workflow was updated.
v0.17.2 can execute native components from files but rejects their registry
downloads during its old core-Wasm validation. The helper therefore resolves an
exact published version over HTTPS, verifies its publisher DID and SHA-256,
and executes the downloaded component file explicitly. It never selects a local
source module with the same name or builds a setup module during bootstrap.
Update the CLI version and all archive digests together when a newer release is
available; component versions remain independently pinned.

All setup results must contain native `bin-dir` and `environment` values. The
helper applies the returned environment to subsequent component calls, then
writes the final PATH and environment changes to `GITHUB_PATH` and `GITHUB_ENV`
for later workflow steps. This includes environment changes from a local setup
component invoked with `--file` in the smoke job.

Caches are separated by OS, architecture, profile, and toolchain configuration.
Each cached CLI archive and component is checksum-verified before use. Native
component build dependencies use the frozen Bun lockfile in `lib/component`.
The existing eight module batches are retained.

Bootstrap logic and environment propagation have isolated tests under `test/ci`.
Runtime setup, package downloads, and new plugin execution run in CI.
