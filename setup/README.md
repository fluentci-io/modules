# Setup modules

Install Bun, Deno, Elixir, Gleam, Go, Java, Node.js, Pkl, Rust, Zig, Nix, or
Determinate Nix from FluentCI. Every module exports a typed native `setup` function.
Private PureScript helpers compose the underlying installers.

The [PureScript toolchain module](./purescript/README.md) composes runtime setup
with npm, the compiler, and Spago, with independent version selection.

## Platforms

| Host OS | Runtime modules | Nix and Determinate Nix |
| --- | --- | --- |
| Linux | Upstream archives or installers, on x86_64 and aarch64. | Supported. |
| macOS | Upstream archives or installers, on x86_64 and aarch64. | Supported where the upstream release supplies a compatible installer. |
| FreeBSD | Native `pkg` repository. | Rejected before executing commands. |
| OpenBSD | Native `pkg_add` repository. | Rejected before executing commands. |
| NetBSD | Native `pkgin` repository. | Rejected before executing commands. |

BSD support depends on the packages available for your OS release and CPU.
Bun and Deno, in particular, do not provide official binaries for every BSD.
The module asks the native package manager for a package and fails clearly
if it is unavailable. It never downloads a Linux binary for a BSD host.

The modules detect the actual host OS and CPU. They do not cross-install for
a different machine. Other operating systems are rejected.

## Usage

Setup modules expose typed native functions on FluentCI v0.17.2+:

```sh
fluentci run setup-node setup --version 22.14.0
fluentci run setup-go setup --version 1.24.0
fluentci run setup-rust setup --version stable
fluentci run setup-node setup --help
```

Optional flags include `--install-dir`, `--package-name`, and `--sudo`.
Tool-specific flags are documented in each module's `COMPONENT.md` and embedded
help. Results contain tool/version/bin-dir plus a list of environment name/value
records. The [component guide](../docs/COMPONENTS.md) describes native results and
migration from raw JSON input.

## Version selection

| Module | Linux/macOS version selection |
| --- | --- |
| [bun](./bun/README.md) | Exact release or `latest`. Optional `baseline` and `libc`. |
| [deno](./deno/README.md) | Exact release or `latest`. |
| [elixir](./elixir/README.md) | Exact release or `latest`, matched to installed Erlang/OTP. Optional `otpVersion`. |
| [gleam](./gleam/README.md) | Exact release or `latest`. |
| [go](./go/README.md) | Exact release or `latest`. |
| [java](./java/README.md) | JDK major, exact Temurin release such as `21.0.5+11`, or `latest` LTS. Default `21`. |
| [node](./node/README.md) | Exact release, `latest`, or `lts`. |
| [pkl](./pkl/README.md) | Exact release or `latest`; optional `libc`. Uses upstream `jpkl` with Java 17+ on macOS x86_64 and musl aarch64. |
| [purescript](./purescript/README.md) | Compiler, Node, Bun, npm, and Spago versions can be selected independently. |
| [rust](./rust/README.md) | Exact release, `stable`, `beta`, `nightly`, or dated rustup toolchain. Default `stable`. |
| [zig](./zig/README.md) | Exact release in the official index or `latest` stable. |
| [nix](./nix/README.md) | Exact upstream Nix release or `latest`. Optional `daemon`. |
| [determinate-nix](./determinate-nix/README.md) | Exact **installer** release or `latest`, which selects its associated Determinate Nix release. Optional `init`. |

For BSD, `latest` means the default package in the configured repository.
The default JDK branch is 21; a numeric Java request selects the corresponding
native JDK branch. Other pinned versions generate `NAME-VERSION` selectors,
unless `packageName` is provided. Repository package versions and language
versions can differ, so use `packageName` for versioned ports, package revisions,
or flavors. For example, on FreeBSD:

```sh
fluentci run setup-go setup --version 1.24.0 --package-name go124 --sudo
```

This succeeds only if the selected repository package reports Go 1.24.0.
Unavailable versions fail rather than silently falling back to another
version. Fully qualified package identifiers can pin a repository revision.
The modules inspect package-owned executables, verify the requested runtime
version, and create per-user shims when a package installs versioned commands.
BSD package operations use the system installation prefix and require root
or explicitly configured passwordless sudo. Package managers are not bootstrapped.

## Installation and environment

On Linux/macOS, archives are installed beneath
`$HOME/.local/share/fluentci/TOOL/VERSION` by default. The complete runtime tree
is retained, including Node's npm files, Go's toolchain, Java's JDK, and Zig's
libraries. Rust uses isolated `cargo/` and `rustup/` directories beneath its
installation directory. Elixir requires Erlang/OTP to be installed first;
it does not install Erlang itself. If the newest Elixir release has no build
for your installed OTP, select a compatible Elixir release or upgrade Erlang.

Archive installs stage and verify an executable before promoting the directory.
An existing installation is reused only after version verification. Use a
separate installation directory to select a different release. Rustup updates
the selected toolchain in its isolated prefix. Avoid concurrent installations
into the same directory; directory locking is not provided.

Nix installers manage `/nix`, profiles, and system services. They need suitable
privileges and do not use `installDir`. Nix defaults to daemon mode; Linux can
select `daemon: false`. Determinate Nix can select `init: "none"` on Linux
containers without systemd. macOS Nix requires daemon mode. Existing Nix
installations are checked for distribution and version; switching between
upstream Nix and Determinate Nix requires an explicit uninstall. A pinned
Determinate request also checks `/nix/nix-installer`'s version.

After verification, setup updates the **FluentCI engine environment** for later
commands and returns a native record (rendered as JSON by the CLI):

```json
{
  "tool": "node",
  "version": "22.14.0",
  "bin-dir": "/home/runner/tools/node/bin",
  "environment": [
    {"name": "PATH", "value": "/home/runner/tools/node/bin:/usr/bin:/bin"}
  ]
}
```

Java also publishes `JAVA_HOME`; Go publishes `GOROOT`; Rustup publishes
`CARGO_HOME`, `RUSTUP_HOME`, and `RUSTUP_TOOLCHAIN`. This does not update your
parent terminal's environment. The wrappers do not edit shell startup files;
upstream Nix installers still make their normal system-level changes.

Downloads use HTTPS with HTTP failures propagated. Zig archives are checked
against the SHA-256 digest in the official download index. Other runtime
archives rely on upstream HTTPS downloads and executable/version verification.
Installer scripts are downloaded to a temporary file and then executed;
failed downloads are never piped into a shell. Temporary download directories
are cleaned after success or failure.

## Development

Each module builds independently and depends on the checked-in
[`lib/setup`](../lib/setup/README.md) PureScript library. Keep that directory
when using module sources from a checkout.

```sh
cd setup/node
npm ci
npm run build
npm test
```

Install Node.js, Bun, Spago, and the PureScript compiler; initialize the shared
component toolchain with `bun install --cwd lib/component --frozen-lockfile` from
the repository root. Build before
testing: tests load the compiled plugin. All modules produce `dist/plugin.wasm`.
Common host fixtures and tests live in [`test/setup`](../test/setup).

Tests cover Linux, macOS, and each BSD through a stub FluentCI host, plus real
filesystem extraction and execution using local fixture archives on Linux/macOS.
They do not install system packages or run the real Nix installers. Native BSD
repository behavior still needs a suitable BSD runner for end-to-end testing.

Opt into smoke tests that download and execute real upstream releases in
temporary directories:

```sh
FLUENTCI_SETUP_LIVE=1 npm test
```

Live tests exclude Nix because its installers change system state. The Elixir
live test skips if Erlang is unavailable. Standard tests require no network;
fixture archive tests need `tar` and, for ZIP-based runtimes, `zip` and `unzip`.
For the Elixir live test, `FLUENTCI_SETUP_ELIXIR_VERSION` can select a release
compatible with the installed OTP instead of the latest Elixir.

A disposable Linux test image is provided at `test/setup/Dockerfile`. After
building the plugins on the host, run the offline test suite from the repository
root:

```sh
docker build -t fluentci-setup-tests -f test/setup/Dockerfile test/setup
docker run --rm --network none -v "$PWD:/repo:ro" fluentci-setup-tests \
  node --test setup/*/test/setup.test.mjs
```

## License

All setup modules and their shared library use the [MIT License](../LICENSE).

## Tool installers

Every operational tool has a `setup-<tool>` companion in the alphabetical root
registry. Additional installers cover Babashka, Clojure, tg, mise, Turborepo,
Expo CLI, Binaryen, the Extism toolchain, Railpack, apko, Devbox, devenv, Flox, pkgx, SQLFluff, protolint, and Buf. The
[installer catalog](../lib/setup/tools.json) records the executable, package,
release backend, native package selectors, and version probe for each tool.

Linux/macOS installers use official binary archives, isolated Python virtual
environments, Bun packages, Go installs, Ruby gems, or native package repositories.
Bun-based installers bootstrap Node.js and Bun when absent. Other runtime
prerequisites are explicit in each installer README. Versioned GitHub archives
resolve their actual release before choosing a cache prefix. Ecosystem installs
using `latest` reuse that prefix; pin a version or choose a fresh installDir to
upgrade. Failed owned installations are removed; existing prefixes are verified
before reuse. Native installers reuse an already available matching executable.

`setup-sccache` also publishes `RUSTC_WRAPPER`. `setup-buildx` registers the Docker
CLI plugin and requires Docker. `setup-gh-artifact` installs the Actions artifact
client with Bun; job uploads need the Actions runtime. `setup-extism` installs
Extism CLI, JS/Python PDK compilers, XTP, and Binaryen with separate version fields.
The Python compiler publishes its private WASI dependency directory. XTP historical
versions and Python PDK Linux ARM64 builds are unavailable upstream and fail clearly.

Tool installation does not configure accounts, start daemons, install native mobile
SDKs, or authenticate remote caches. Use your CI runner's secret store and native
credential/configuration mechanisms for subsequent commands.

Tools without a safe version subcommand verify that the executable exists and
is executable. Go installs additionally read Go module build metadata; other
backends can only report the requested selector for those tools. Select a trusted package identity explicitly when a
repository uses a different name.

Devbox needs Nix to create environments. devenv installs a selected upstream
flake into a private Nix profile and requires Nix with flakes support. Flox
uses native packages: Homebrew on macOS, and a configured package source or
a preinstalled official package on Linux. pkgx installs its upstream launcher;
packages it subsequently runs have their own platform requirements. See each
installer README for version and privilege restrictions.
