# Setup Black

Install `black` for a FluentCI pipeline using the shared PureScript setup library.

```sh
fluentci run setup-black setup
```

Pass a release version/tag as plain input, or use JSON:

```json
{"version":"latest"}
```

The `setup` export installs and verifies the executable, returns `tool`, `version`,
`binDir`, and `environment`, and publishes PATH for later FluentCI tasks. The
PureScript `setupWith` helper accepts the same shared configuration. This module
installs a tool; it does not authenticate accounts, start remote services, or run
builds/deployments.

## Installation

Backend: `python`.

Linux/macOS use official releases or the native language ecosystem where available.
JavaScript tools use Bun; missing Node.js/Bun are bootstrapped through their setup
installers. Python tools require Python 3 with venv/pip support. Ruby tools require
Ruby/gem, and Go tools require Go. Native repository installers require the package
manager, a configured vendor repository when needed, and installation privileges.
Use `sudo: true` for noninteractive native package installation when appropriate.

FreeBSD uses pkg, OpenBSD pkg_add, and NetBSD pkgin. Package availability and exact
versions depend on the selected native repository; unavailable packages fail
clearly. dpkg and rpmbuild are Linux-only. Pinned native package versions must exist
in the repository; `packageName` can select a versioned port or package identifier.

`version` defaults to `latest`. `installDir` selects an absolute
per-user prefix for release/ecosystem installs; omit it for native packages.
Downloaded versioned prefixes are verified before reuse. Failed new installs are
removed. Run concurrent installs with separate prefixes. Credentials remain in
native configuration and environment variables; they are not setup arguments.

See the [shared setup guide](../README.md), [installer catalog](../../lib/setup/tools.json),
and [schema](./schema.json). Official project reference: black.

## Development

```sh
npm ci
npm run build
npm test
```

Sources and schema are generated with `python3 ../../scripts/generate_setup_tools.py`.
Tests exercise compiled PureScript against controlled package-manager/release hosts.
They do not install system packages or contact authenticated services.

[MIT License](./LICENSE).
