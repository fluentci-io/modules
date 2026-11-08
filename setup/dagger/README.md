# Setup Dagger

Install and verify Dagger, select its version, and publish PATH for CI/CD tasks.
Requires FluentCI v0.17.2+; implemented as a typed PureScript Wasm component.

```sh
fluentci run setup-dagger setup --version 0.21.11
fluentci run setup-dagger setup --help
```

Official Dagger archives for Linux/macOS on x86_64 and aarch64.

The default is `latest`; exact versions may include `v`. Archive installations
use `$HOME/.local/share/fluentci/dagger/VERSION` or an absolute `--install-dir`.
Existing installations are verified before reuse. Downloads verify SHA-256 when
provided by the GitHub release API.
Version mismatches and unavailable release assets fail the operation.

This installs the Dagger CLI. Pipeline execution requires a reachable Dagger engine and its supported container runtime; installing the CLI does not provision or start an engine.

Returns `tool`, `version`, `bin-dir`, and `environment`. Environment changes apply
to the host session; separate processes must propagate the returned environment.
See [COMPONENT.md](./COMPONENT.md) for every named argument and return type.

[Upstream releases](https://github.com/dagger/dagger/releases) · [MIT License](./LICENSE).
