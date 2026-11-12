# Setup Nx

Install a selected Nx CLI release, verify its version, and publish PATH for CI/CD tasks. Implemented in PureScript as a typed Wasm component.

```sh
fluentci run setup-nx setup --version 24.0.6
fluentci run setup-nx setup --help
```

Default version: **24.0.6**. Use `--version` for another exact compatible npm release, or explicitly request `latest`. Linux and macOS install `nx@VERSION` with Bun, ensuring Node.js and Bun are available. Configure a compatible Node.js version with setup-node first when the runner already has an older Node.js installation. Bun's default trusted dependency list permits Nx's native postinstall script.

The per-user prefix is `$HOME/.local/share/fluentci/nx/VERSION`; an absolute `--install-dir` overrides it. Verified installations are reused. The version check reads the installed global Nx version when the CLI reports both local and global versions, avoiding a false mismatch from the current workspace. Failed installation or version checks never publish successful setup; failed newly created prefixes are cleaned up.

FreeBSD, OpenBSD and NetBSD use native `nx` packages when available in the configured repositories. Availability and compatible native dependencies are repository-dependent; missing packages fail explicitly. For native installations omit `--install-dir`, optionally set `--package-name`, and use `--sudo` for noninteractive elevation if required.

Setup does not initialize a workspace or install its plugins, executor packages or task dependencies. Install workspace dependencies using the project lockfile. Nx may delegate subsequent commands to the workspace-local version; pin that version alongside the setup version.

Returns typed `tool`, `version`, `bin-dir` and `environment`. Environment updates apply to subsequent host tasks; separate processes must propagate the returned PATH. See [COMPONENT.md](./COMPONENT.md) for all options and return descriptions, and [the Nx build module](../../build/nx/README.md) for task orchestration.

[Official installation guide](https://nx.dev/docs/getting-started/installation) · [MIT wrapper license](./LICENSE).
