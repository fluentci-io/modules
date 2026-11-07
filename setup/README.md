# Runtime setup modules

Install Bun, Deno, Elixir, Gleam, Go, Java, Node.js, Rust, Zig, Nix, or
Determinate Nix from FluentCI. Every module exports `setup` and has a
`setupWith` PureScript helper.

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

The modules are registered by name in the repository's `fluentci.toml`:

```sh
fluentci run node setup 22.14.0
fluentci run go setup 1.24.0
fluentci run rust setup stable
```

Omit input to use the module's default version. For more options, provide a
JSON object as plugin input to `setup`:

```json
{
  "version": "22.14.0",
  "installDir": "/home/runner/tools/node"
}
```

| Argument | Meaning |
| --- | --- |
| `version` | Release version or a documented channel. Defaults to `latest`, except Java (`21`) and Rust (`stable`). |
| `installDir` | Optional absolute installation directory for Linux/macOS user installations. Omit for BSD and Nix. |
| `packageName` | Optional native BSD package name, exact package identifier, or branch selector. Replaces the generated repository selector. |
| `sudo` | Use `sudo -n` for BSD package installation or Nix installation. Default `false`; requires passwordless sudo. |

Unknown fields, incorrect types, nulls, unsafe package selectors, and malformed
version tokens are rejected. Installation directories cannot be `/`, contain
parent traversal, NULs, line breaks, or colons. Host commands receive literal
arguments; version strings and paths are not interpolated into shell commands.

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

```json
{
  "version": "1.24.0",
  "packageName": "go124",
  "sudo": true
}
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
commands and outputs a JSON result:

```json
{
  "tool": "node",
  "version": "22.14.0",
  "binDir": "/home/runner/tools/node/bin",
  "environment": {
    "PATH": "/home/runner/tools/node/bin:/usr/bin:/bin"
  }
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

Install Node.js, Spago, the PureScript compiler, and `extism-js`. Build before
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
