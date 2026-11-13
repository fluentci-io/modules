# Setup Flipt

Install or reuse a verified Flipt CLI and publish its environment for CI/CD tasks.
Typed PureScript Wasm component; requires FluentCI v0.17.3+.

```sh
fluentci run setup-flipt setup --version latest
fluentci run setup-flipt setup --version 2.14.1
```

Supports Linux/macOS on x86_64/aarch64. Unsupported hosts fail explicitly before
installation. An existing PATH executable matching the requested version skips
downloads; latest accepts an installed release. Otherwise setup uses official
[flipt-io/flipt releases](https://github.com/flipt-io/flipt/releases), verifies SHA-256
from the exact asset digest or checksums.txt entry, and verifies its installed version.
Missing checksums, invalid archives and version mismatches fail without successful setup.
An explicit install-dir selects a managed prefix instead of PATH reuse. Omit
package-name and sudo for official per-user archives.

Returns tool, version, bin-dir and environment entries. PATH is published to later
tasks in the same host session. Setup installs the CLI without starting a server,
running database migrations or opening configuration wizards.

The [Flipt operation module](../../deployment/flipt/README.md) exports setup and runs
its preflight before every operation. Named operations target v2; explicit older
versions can use the literal run escape hatch. See [COMPONENT.md](./COMPONENT.md)
for typed arguments, descriptions and return fields. License: MIT.
