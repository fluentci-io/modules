# Setup Cosign

Install and verify Cosign, select its version, and publish PATH for CI/CD tasks.
Requires FluentCI v0.17.2+; implemented as a typed PureScript Wasm component.

```sh
fluentci run setup-cosign setup --version 3.1.4
fluentci run setup-cosign setup --help
```

Official Sigstore binaries for Linux/macOS on x86_64 and aarch64. FreeBSD, NetBSD, and OpenBSD use native repositories when a matching package is available.

The default is `latest`; exact versions may include `v`. Archive installations
use `$HOME/.local/share/fluentci/cosign/VERSION` or an absolute `--install-dir`.
Existing installations are verified before reuse. Downloads verify SHA-256 when
provided by the GitHub release API.
Version mismatches and unavailable release assets fail the operation.

The CLI does not generate keys or sign artifacts during setup. Supply registry credentials, signing keys, or ambient CI OIDC permissions for subsequent operations. See [the signing module](../../security/cosign/README.md).

Native BSD installations use the system prefix. Omit `--install-dir`; use
`--package-name` for an available native package selector and `--sudo` when
noninteractive privilege elevation is needed. Repository availability determines
which versions can be installed; unavailable packages fail clearly.


Returns `tool`, `version`, `bin-dir`, and `environment`. Environment changes apply
to the host session; separate processes must propagate the returned environment.
See [COMPONENT.md](./COMPONENT.md) for every named argument and return type.

[Upstream releases](https://github.com/sigstore/cosign/releases) · [MIT License](./LICENSE).
