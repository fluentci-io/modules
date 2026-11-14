# CI toolchain

CI installs the published `fluentci.io` components `setup-node@0.2.0`,
`setup-bun@0.2.0`, `setup-uv@0.2.0`, and `setup-purescript@0.2.0`.
[versions.json](./versions.json) pins module versions, runtime versions, the
publisher DID, and SHA-256 digests for each bootstrap CLI archive.

The runner's existing Python 3.9+ downloads and verifies the CLI archive. No
`actions/setup-node`, `actions/setup-python`, or `oven-sh/setup-bun` is used.
uv installs the requested managed Python version. The full profile also uses
`setup-purescript` to install the compiler, Spago, and npm with explicit versions.

The CLI bootstrap is pinned to v0.17.4, including the native service HTTP probe
validation fix. The helper resolves exact published setup versions over HTTPS,
verifies the publisher DID and SHA-256, and executes each downloaded component
file explicitly. It never selects a local source module with the same name or
builds a setup module during bootstrap. Update the CLI version and all archive
digests together; component versions remain independently pinned.

All setup results must contain native `bin-dir` and `environment` values. The
helper applies the returned environment to subsequent component calls, then
writes the final PATH and environment changes to `GITHUB_PATH` and `GITHUB_ENV`
for later workflow steps. This includes environment changes from a local setup
component invoked with `--file` in the smoke job.

Download caches are separated by OS, architecture, profile, and toolchain configuration.
Each cached CLI archive and component is checksum-verified before use. Native
component build dependencies use the frozen Bun lockfile in `lib/component`.
The existing eight module batches are retained.

Bootstrap logic and environment propagation have isolated tests under `test/ci`.
Runtime setup, package downloads, and new plugin execution run in CI.

## Published 0.2.0 compatibility

The original setup modules compare a directory probe with `yes`, while the host
returns `yes\n`. Their false negative breaks reuse of an existing prefix. Source
installers now trim this output; patched setup releases must be published before
CI can select that fix from the registry. Until then, bootstrap uses fresh
per-job installation directories and caches downloads rather than installed
FluentCI runtime prefixes. The full profile invokes setup-purescript once to
compose Node/Bun instead of installing its prerequisites a second time.

Managed Python caching remains enabled because uv handles that cache itself.
