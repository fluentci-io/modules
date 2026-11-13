# Setup Depot

Install or reuse a verified Depot CLI and publish its environment for CI/CD tasks.
Native Wasm component written in PureScript; requires FluentCI v0.17.3+.

```sh
fluentci run setup-depot setup --version latest
fluentci run setup-depot setup --version 2.103.12
```

Supports Linux/macOS on x86_64/aarch64 only. Unsupported hosts fail explicitly.
An existing CLI on PATH with a matching requested version skips downloads; latest
accepts the installed version. Otherwise the official depot/cli GitHub release archive
is SHA-256 checked, extracted into a versioned per-user prefix, and version-verified.
Missing checksums or a wrong version fail without publishing success.
An explicit install-dir selects a managed installation instead of reusing PATH.
Native package-name and sudo options are not used for official per-user archives.

Returns tool, version, bin-dir, and environment entries. Later tasks in the same
host session inherit PATH. Credentials remain inherited through DEPOT_TOKEN or
native CI OIDC. Installation does not authenticate or start a build.

See [COMPONENT.md](./COMPONENT.md) for all named arguments and their descriptions.
The [Depot operation module](../../containers/depot/README.md) exposes setup and
runs its preflight before every command. License: MIT.
