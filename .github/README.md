# Continuous integration

## Pull requests and pushes

[CI](./workflows/ci.yml) runs on every push, pull request, and manual dispatch.
It validates the registry, npm metadata and lockfiles, source/test presence,
MIT licenses, guest entry point declarations, generated Buildx and CLI files, and the
workflow syntax. Validator tests run alongside these checks.

The build matrix is generated from `fluentci.toml`: every registered module
runs on Ubuntu 24.04 and macOS 15. Each job installs dependencies with `npm ci`,
builds the WebAssembly plugin, runs the entire module test suite, and checks
that compiled public WASM exports match `entry.mjs`. Builds must preserve the
committed source and lockfiles. Test logs and plugins are retained for seven
days. Matrix jobs continue after another module fails so failures remain visible.

Linux jobs install Debian and RPM packaging tools and require native integration
tests to execute. Those packaging tests intentionally skip on macOS, where their
modules reject execution. Runtime fixture extraction tests run on both hosts;
missing prerequisites fail CI instead of silently skipping them. BSD routing is
covered by stub-host tests, not native BSD virtual machines.

Use **All modules passed** as the aggregate branch-protection check. It fails
if registry validation or any module/OS job fails or is cancelled.

CLI module tests cover every named export and field, supported host routing,
missing tools, and execution failures. Local executable fixtures exercise plan
execution on both hosts. Formatter and linter jobs also install pinned Python
and Node tools and require native formatting/linting tests. Provider commands
use controlled host responses; CI does not deploy to real accounts or clusters.

## Live runtime smoke tests

[Runtime setup smoke tests](./workflows/setup-smoke.yml) run weekly on Mondays
at 04:23 UTC and on manual dispatch. They build every setup module on both
hosts, then download and execute real runtime releases in temporary directories.
The PureScript smoke test also installs its Node, Bun, npm, compiler, and Spago
dependencies. The two Nix installers are excluded from live installation because
they modify system services; their command planning and validation tests run in
ordinary CI.

Erlang is installed for the Elixir smoke test. Linux selects Elixir 1.18.0 for
the distribution's OTP version; macOS uses current Elixir with Homebrew Erlang.
Upstream release changes or download failures can fail smoke tests independently
of the deterministic PR test suite.

## Toolchain and local checks

The [composite action](./actions/setup-toolchain/action.yml) uses Node 24 and
Python 3.12. PureScript 0.15.16 and Spago 1.0.5 are pinned in
[`toolchain/package-lock.json`](./toolchain/package-lock.json). Extism JS PDK
v1.7.0 and Binaryen version_125 downloads are pinned by URL and SHA-256 in
[`toolchain/releases.json`](./toolchain/releases.json). Changing these files
invalidates the compiler cache. Spago dependencies are cached by platform,
module, and lockfile. Workflow actions are pinned to commit hashes.

Run registry and artifact checks locally:

```sh
python3 scripts/validate_modules.py
python3 -m unittest discover -s test/ci -p 'test_*.py' -v
node --test test/ci/*.test.mjs
python3 containers/buildx/generate.py --check
python3 scripts/generate_cli_modules.py --check
node scripts/validate_wasm.mjs setup/purescript
```

Artifact validation requires building the module first. To install the same
compiler toolchain in a separate directory, run
`python3 scripts/install_ci_toolchain.py --directory /tmp/fluentci-ci-tools`
and add the printed directories to PATH. Python 3.12 or newer is required.

[`test/ci/Dockerfile`](../test/ci/Dockerfile) provides the Ubuntu/Node environment
for source-only checkout verification. It does not contain compiler caches,
installed module dependencies, or prebuilt plugins.
