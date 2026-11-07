# Setup Turborepo

Install the `turbo` CLI with Bun and publish its directory on PATH for later
FluentCI tasks. Node.js and Bun are installed first when missing.

```sh
fluentci run setup-turborepo setup 2.5.6
```

Omit input to install `latest`, or pass JSON:

```json
{"version":"2.5.6","installDir":"/home/runner/tools/turbo"}
```

The `setup` export returns the verified `version`, `binDir`, and `environment`.
The PureScript `setupWith` helper accepts the shared setup configuration.
Linux and macOS use the official `turbo` npm package, installed through Bun into
an isolated prefix. FreeBSD, OpenBSD, and NetBSD use their native package
repositories; unavailable packages or versions fail clearly. `packageName` can
select a locally available port. Native packages require installation privileges.

Use Turborepo after setup to build or test a monorepo, for example `turbo run
build test`. Configure remote cache credentials through `TURBO_TOKEN` and
`TURBO_TEAM` in your CI secret store. Setup does not require those credentials.
A prefix installed with `latest` is reused until removed; pin a release for
reproducible builds or choose a fresh `installDir` when upgrading.

See the [shared setup guide](../README.md), [configuration schema](./schema.json),
and [official Turborepo installation guide](https://turborepo.com/docs/getting-started/installation).

## Development

```sh
npm ci
npm run build
npm test
```

[MIT License](./LICENSE).
