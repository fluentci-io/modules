# Setup Drizzle Kit

Install a versioned `drizzle-kit` CLI, verify its version, and publish PATH for subsequent pipeline tasks. Implemented in PureScript as a typed Wasm component.

```sh
fluentci run setup-drizzlekit setup --version 0.31.11
fluentci run setup-drizzlekit setup --help
```

Default version: **0.31.11**. Override it with an exact compatible npm release using `--version`.

Linux and macOS use the npm CLI installed with Bun. BSD hosts use native repository packages when available; no BSD npm installation is attempted and unavailable packages fail explicitly.

On Linux/macOS the shared installer ensures Node.js and Bun are available, installs `drizzle-kit@VERSION` with Bun into `$HOME/.local/share/fluentci/drizzlekit/VERSION`, and links the CLI into that prefix's `bin` directory. Use an absolute `--install-dir` to choose a different prefix. Verified existing installations are reused; version mismatches and failed installations do not publish success. Supply a Node version compatible with the selected CLI.

Setup does not create or migrate a database and does not install the project's ORM/client or database drivers. Install those using the project's package manager and lockfile. Keep CLI and project dependency versions compatible. Project configuration imports must resolve from that project's own dependencies.

Returns typed `tool`, `version`, `bin-dir` and `environment`; separate processes must propagate the returned environment. See [COMPONENT.md](./COMPONENT.md) for all options and return descriptions, and [the database module](../../databases/drizzlekit/README.md) for pipeline operations.

[Official CLI documentation](https://orm.drizzle.team/docs/kit-overview) · [MIT license](./LICENSE).
