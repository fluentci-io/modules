# Setup Garden

Install and verify the Garden CLI for CI/CD pipelines. Implemented in PureScript as a typed Wasm component.

```sh
fluentci run setup-garden setup --version 0.14.20
fluentci run setup-garden setup --help
```

Default version: **0.14.20**, the reviewed Garden Cedar release. An exact version or `latest` can be selected with `--version`. Official release tags do not have a `v` prefix.

Linux and macOS on x86_64/aarch64 use official `garden-io/garden` release archives. Alpine Linux selects the separate `alpine-amd64` archive; unavailable platform/architecture assets fail clearly. Setup requires a valid SHA-256 digest from GitHub release metadata or the release's adjacent `.sha256` file and verifies the downloaded archive before extraction. The full archive layout is preserved, including supporting files next to `garden`. No Node.js or Bun installation is required.

The per-user prefix defaults to `$HOME/.local/share/fluentci/garden/VERSION`; an absolute `--install-dir` overrides it. The resolved release version is used for `latest`. Existing managed installations are verified and reused. Download, checksum, extraction and version failures do not publish a successful setup; newly created failed installations are cleaned up.

FreeBSD, OpenBSD and NetBSD use native package repositories when `garden-cli` is available; there are no official BSD release archives. Package availability is repository-dependent. For native installations omit `--install-dir`, optionally select `--package-name`, and use `--sudo` for noninteractive elevation if needed. An unavailable package fails explicitly.

Returns typed `tool`, `version`, `bin-dir` and `environment`. PATH applies to subsequent host tasks; separate processes must propagate returned environment variables. See [COMPONENT.md](./COMPONENT.md) for all arguments and return descriptions.

Setup installs the CLI only. The [Garden deployment module](../../deployment/garden/README.md) runs project builds, deployments, tests and cleanup. Configure provider credentials, project environments and any required Docker/Kubernetes infrastructure separately.

[Official installation guide](https://docs.garden.io/guides/installation) · [Official releases](https://github.com/garden-io/garden/releases) · [MIT wrapper license](./LICENSE).
