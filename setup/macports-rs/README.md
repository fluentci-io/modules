# Setup MacPorts Rust CLI

Install and verify MacPorts Rust CLI, select its version, and publish PATH for CI/CD tasks.
Requires FluentCI v0.17.2+; implemented as a typed PureScript Wasm component.

```sh
fluentci run setup-macports-rs setup --version 0.1.4 --packages git,cmake,ninja --sudo
fluentci run setup-macports-rs setup --help
```

macOS only, Intel (x86_64) and Apple Silicon (aarch64). Other operating systems fail before installation.

The default is `latest`; exact versions may include `v`. Archive installations
use `$HOME/.local/share/fluentci/macports-rs/VERSION` or an absolute `--install-dir`.
Existing installations are verified before reuse. Downloads verify SHA-256 when
provided by the GitHub release API; macports-rs requires a digest or published checksum sidecar.
Version mismatches and unavailable release assets fail the operation.

Uses [tsirysndr/macports-rs](https://github.com/tsirysndr/macports-rs), a standalone Rust implementation of the MacPorts CLI. Installs `port` and a `portindex` alias without installing native MacPorts or a Tcl runtime. The selected `port` depends on PATH order if native MacPorts is also present. Package installation is optional; build prerequisites depend on the requested ports.

`packages` accepts comma-separated port names such as `git,cmake,ninja,python312`.
Whitespace around names is trimmed. Omitting it or passing a blank value installs
only the CLI. Empty entries and invalid names fail before host commands. Package
versions come from the configured ports tree; arbitrary historical version
selection is not provided by this argument.

After verifying the CLI, setup invokes **its own** `port -N install` with those
names, even if native MacPorts is on PATH. `--sudo` elevates only the package
install with `sudo -n`; the Rust CLI archive always installs as the normal user.
Without `--sudo`, port installation uses the current user's permissions. Omit
`--sudo` for CLI-only setup. Native `--package-name` selectors are not accepted.

Package setup exposes the default package prefix's `/opt/local/bin` and
`/opt/local/sbin` on PATH, while keeping the selected Rust CLI first. The CLI's
`--install-dir` changes where `port` is installed, independently of the package
prefix. Custom prefixes selected through native configuration are not discovered
automatically. Xcode Command Line Tools, configured sources, and suitable
permissions remain prerequisites. A failed install fails setup without publishing
its environment; previously installed files may remain.

Returns `tool`, `version`, `bin-dir`, and `environment`. Environment changes apply
to the host session; separate processes must propagate the returned environment.
See [COMPONENT.md](./COMPONENT.md) for every named argument and return type.

[Upstream releases](https://github.com/tsirysndr/macports-rs/releases) · [MIT License](./LICENSE).
