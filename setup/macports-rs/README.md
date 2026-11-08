# Setup MacPorts Rust CLI

Install and verify MacPorts Rust CLI, select its version, and publish PATH for CI/CD tasks.
Requires FluentCI v0.17.2+; implemented as a typed PureScript Wasm component.

```sh
fluentci run setup-macports-rs setup --version 0.1.4
fluentci run setup-macports-rs setup --help
```

macOS only, Intel (x86_64) and Apple Silicon (aarch64). Other operating systems fail before installation.

The default is `latest`; exact versions may include `v`. Archive installations
use `$HOME/.local/share/fluentci/macports-rs/VERSION` or an absolute `--install-dir`.
Existing installations are verified before reuse. Downloads verify SHA-256 when
provided by the GitHub release API; macports-rs requires a digest or published checksum sidecar.
Version mismatches and unavailable release assets fail the operation.

Uses [tsirysndr/macports-rs](https://github.com/tsirysndr/macports-rs), a standalone Rust implementation of the MacPorts CLI. Installs `port` and a `portindex` alias without installing native MacPorts or a Tcl runtime. The selected `port` depends on PATH order if native MacPorts is also present. Package installation and build prerequisites remain separate from CLI setup.

Per-user installation does not accept `--sudo` or native package selectors.

Returns `tool`, `version`, `bin-dir`, and `environment`. Environment changes apply
to the host session; separate processes must propagate the returned environment.
See [COMPONENT.md](./COMPONENT.md) for every named argument and return type.

[Upstream releases](https://github.com/tsirysndr/macports-rs/releases) · [MIT License](./LICENSE).
