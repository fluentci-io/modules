# Setup PlanetScale

Install and verify the PlanetScale CLI and publish PATH for CI/CD pipelines.
Implemented in PureScript as a typed Wasm component for FluentCI v0.17.2+.

```sh
fluentci run setup-planetscale setup --version 0.350.0
fluentci run setup-planetscale setup --help
```

Official PlanetScale release archives for Linux and macOS, on x86_64 or aarch64.

Installs the `pscale` executable from versioned `planetscale/cli` releases. A release API SHA-256 digest is verified when provided, then `pscale version` verifies the selected CLI release.

The default is `latest`; exact releases may include `v`. Per-user installations
use `$HOME/.local/share/fluentci/planetscale/VERSION` or an absolute `--install-dir`.
Existing installations are verified before reuse. Version mismatches, checksum
failures, and missing platform assets fail setup. No authentication, database
creation, or database server installation occurs during setup.

FreeBSD, NetBSD, and OpenBSD attempt the native `pscale` package when available;
upstream provides no BSD binary. Repository availability determines whether this
works. Native packages use their system prefix; omit `--install-dir`, optionally
select an available package using `--package-name`, and use `--sudo` for
noninteractive elevation when needed. Unavailable packages fail clearly.

Returns `tool`, `version`, `bin-dir`, and `environment`. Environment changes apply
to subsequent host tasks; separate processes must propagate the returned
variables. See [COMPONENT.md](./COMPONENT.md) for all typed arguments and returns.

Use [the database module](../../databases/planetscale/README.md) for pipeline operations.
SQL clients required by native shell/connect commands remain runner prerequisites.

[Upstream CLI](https://github.com/planetscale/cli) · [MIT wrapper license](./LICENSE).
