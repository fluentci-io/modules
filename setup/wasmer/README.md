# Setup Wasmer

Install a versioned Wasmer CLI and publish PATH for subsequent CI/CD tasks. Implemented in PureScript as a typed Wasm component.

```sh
fluentci run setup-wasmer setup --version 7.5.0
fluentci run setup-wasmer setup --help
```

Default release: **7.5.0**. `--version` accepts another exact release (with or without `v`) or `latest`. Setup downloads matching official GitHub release archives, verifies SHA-256 when provided by release metadata, preserves adjacent resources, and checks the installed CLI version. Missing platform assets, extraction errors, checksum mismatches and wrong versions fail setup. New failed prefixes are cleaned up and do not publish success.

Linux and macOS support x86_64 and aarch64 when the selected release provides a matching archive. Wasmer 7.5.0 provides Linux amd64/aarch64 and macOS arm64 assets, but no macOS Intel asset. Select a release providing that asset for an Intel Mac; setup never substitutes a binary for a different CPU.

FreeBSD, OpenBSD and NetBSD use native repositories when an appropriate package is available. The default selector is `wasmer`; use `--package-name` for the name used by your repository. Unavailable packages and versions fail explicitly.  Native installs omit `--install-dir` and can use `--sudo` for noninteractive elevation. No official BSD archive is assumed.

Managed prefixes default to `$HOME/.local/share/fluentci/wasmer/VERSION`; an absolute `--install-dir` overrides the prefix. Verified existing installations are reused. Setup installs the standalone CLI, not project language toolchains, cloud credentials, or deployment plugins.

Returns typed `tool`, `version`, `bin-dir` and `environment`. Environment updates apply to subsequent host tasks; separate processes must propagate the returned PATH. See [COMPONENT.md](./COMPONENT.md) for every argument and return description, and [the deployment module](../../deployment/wasmer/README.md) for CI/CD operations.

[Official releases](https://github.com/wasmerio/wasmer/releases) · [MIT wrapper license](./LICENSE).
