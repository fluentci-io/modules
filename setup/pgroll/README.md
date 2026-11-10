# Setup pgroll

Install a selected pgroll release, verify its version, and configure PATH for
CI/CD pipelines. Implemented in PureScript as a typed Wasm component for
FluentCI v0.17.2+.

```sh
fluentci run setup-pgroll setup --version 0.16.3
fluentci run setup-pgroll setup --help
```

The default version is `latest`; exact releases may include `v`. Linux and macOS
on x86_64 or aarch64 use official `xataio/pgroll` standalone release binaries.
A GitHub release SHA-256 digest is verified when provided, and `pgroll --version`
checks the installed release. Missing platform assets, checksum failures, and
version mismatches fail setup.

Per-user installations use `$HOME/.local/share/fluentci/pgroll/VERSION` or an
absolute `--install-dir`. A verified existing installation is reused. No Go,
Node.js, PostgreSQL server, authentication, or database provisioning is required
for setup itself.

FreeBSD, NetBSD, and OpenBSD use native `pgroll` packages when available; upstream
provides no BSD binary. Package availability depends on the runner's repositories.
For native packages omit `--install-dir`, optionally set `--package-name`, and use
`--sudo` for noninteractive elevation if needed. Unavailable packages fail clearly.

Returns typed `tool`, `version`, `bin-dir`, and `environment` values. Environment
updates apply to subsequent host tasks; separate processes must propagate the
returned variables. See [COMPONENT.md](./COMPONENT.md) for all arguments and returns.

Use [the pgroll database module](../../databases/pgroll/README.md) for migrations.
[Official releases](https://github.com/xataio/pgroll/releases) · [MIT wrapper license](./LICENSE).
