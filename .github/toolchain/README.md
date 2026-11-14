# CI toolchain

[versions.json](./versions.json) pins FluentCI v0.17.4 archive URLs and SHA-256
checksums for Linux/macOS on x86_64/aarch64, the registry publisher DID, setup
component versions, and tool versions.

The composite action first uses the runner's curl, jq, tar, and checksum utility
to install the verified CLI. It calls published `setup-erlang@0.2.0` and
`setup-gleam@0.2.0`, publishes their explicit per-job installation paths, then
compiles `scripts/fluentci_modules_ci` for BEAM with OTP 29.1.2 / Gleam 1.19.2. The
minimal shell bootstrap breaks the cycle before any escript exists; all later
bootstrap and environment policy is implemented in Gleam. Registry bootstrap calls
run in a dedicated workspace under `RUNNER_TEMP`, so resolving Erlang and Gleam
cannot add packages to the repository’s `fluentci.lock`.

The escript resolves exact published `fluentci.io` components, verifies publisher,
name, version, SHA-256 and component format, and executes their downloaded files
explicitly. It never accidentally selects local modules sharing those names.
The base profile installs Node, Bun, uv and managed Python. The full profile uses
setup-purescript once to compose Node/Bun, PureScript, Spago and npm, then installs
uv and managed Python. Module build adapters still use the JavaScript component
compiler with its frozen Bun lockfile.

Native setup results must contain validated bin-dir and environment records.
The helper applies them to subsequent component calls and exports the final
PATH precedence and changed variables to GITHUB_PATH/GITHUB_ENV, using collision
resistant delimiters for multiline values. Local setup smoke components use the
same handoff through `setup-toolchain --file ... -- ...`.

Published 0.2.0 setup modules cannot reliably reuse existing runtime prefixes.
The helper therefore allocates fresh per-job prefixes, caches verified downloads
and uv-managed Python data, and avoids installing PureScript prerequisites twice.
OTP/Gleam bootstrap prefixes are also fresh for each runner job.

CI keeps four module batches per OS and up to 32 service build workers on one runner.
Helper unit tests live in `scripts/test`; SDK fixture tests remain under `test/ci`.
Runtime setup, plugins, installers, Docker and VM verification run only in CI.
See [the BEAM helper guide](../../scripts/README.md) for commands and port details.
