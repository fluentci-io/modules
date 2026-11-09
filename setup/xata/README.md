# Setup Xata

Install and verify the Xata CLI and publish PATH for CI/CD pipelines.
Implemented in PureScript as a typed Wasm component for FluentCI v0.17.2+.

```sh
fluentci run setup-xata setup --version 1.18.2
fluentci run setup-xata setup --help
```

Official standalone binaries for Linux with glibc and macOS, on x86_64 or aarch64.

Uses the official Xata version manifest and requires its SHA-256 checksum. The selected binary is verified with `xata --version`. Alpine/musl binaries are unavailable; Alpine is rejected before download. This installs the current Postgres platform CLI, rather than the older npm CLI.

The default is `latest`; exact releases may include `v`. Per-user installations
use `$HOME/.local/share/fluentci/xata/VERSION` or an absolute `--install-dir`.
Existing installations are verified before reuse. Version mismatches, checksum
failures, and missing platform assets fail setup. No authentication, database
creation, or database server installation occurs during setup.

FreeBSD, NetBSD, and OpenBSD attempt the native `xata` package when available;
upstream provides no BSD binary. Repository availability determines whether this
works. Native packages use their system prefix; omit `--install-dir`, optionally
select an available package using `--package-name`, and use `--sudo` for
noninteractive elevation when needed. Unavailable packages fail clearly.

Returns `tool`, `version`, `bin-dir`, and `environment`. Environment changes apply
to subsequent host tasks; separate processes must propagate the returned
variables. See [COMPONENT.md](./COMPONENT.md) for all typed arguments and returns.

Use [the database module](../../databases/xata/README.md) for pipeline operations.
SQL clients required by native shell/connect commands remain runner prerequisites.

[Upstream CLI](https://github.com/xataio/cli) · [MIT wrapper license](./LICENSE).
