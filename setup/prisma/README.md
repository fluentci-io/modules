# Setup Prisma

Install a versioned `prisma` CLI, verify its version, and publish PATH for subsequent pipeline tasks. Implemented in PureScript as a typed Wasm component.

```sh
fluentci run setup-prisma setup --version 7.8.0
fluentci run setup-prisma setup --help
```

Default version: **7.8.0**. Override it with an exact compatible npm release using `--version`. The default stays on the reviewed Prisma ORM 7 CLI rather than the incompatible v8 release candidate on the npm latest tag.

Supported hosts: Linux and macOS on x86_64/aarch64. FreeBSD, OpenBSD and NetBSD fail explicitly before host commands because the upstream Prisma engine distribution does not support these systems. Native engine prerequisites, including compatible OpenSSL libraries on Linux, must be available on the runner.

On Linux/macOS the shared installer ensures Node.js and Bun are available, installs `prisma@VERSION` with Bun into `$HOME/.local/share/fluentci/prisma/VERSION`, and links the CLI into that prefix's `bin` directory. Use an absolute `--install-dir` to choose a different prefix. Verified existing installations are reused; version mismatches and failed installations do not publish success. Supply a Node version compatible with the selected CLI (Prisma 7.8 requires Node ^20.19, ^22.12 or >=24). Bun's default trusted package list permits Prisma and its engine installation scripts.

Setup does not create or migrate a database and does not install the project's ORM/client or database drivers. Install those using the project's package manager and lockfile. Keep CLI and project dependency versions compatible. Project configuration imports must resolve from that project's own dependencies.

Returns typed `tool`, `version`, `bin-dir` and `environment`; separate processes must propagate the returned environment. See [COMPONENT.md](./COMPONENT.md) for all options and return descriptions, and [the database module](../../databases/prisma/README.md) for pipeline operations.

[Official CLI documentation](https://www.prisma.io/docs/orm/v7/reference/prisma-cli-reference) · [MIT license](./LICENSE).
