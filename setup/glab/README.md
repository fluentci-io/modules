# Setup GitLab CLI

Install or reuse a verified GitLab CLI CLI and publish its environment for CI/CD.
Native PureScript Wasm component; requires FluentCI v0.17.3+.

```sh
fluentci run setup-glab setup --version latest
```

Supports Linux, macOS, FreeBSD, OpenBSD and NetBSD. Unsupported OS values fail before installation. Archive installers support
x86_64/aarch64; BSD architecture availability follows the native repositories. A usable installed CLI matching the requested version
is reused. Native package availability and permissions determine installation
success; missing packages and version mismatches remain failures.

Linux/macOS x86_64/aarch64 use official gitlab-org/cli release assets. The exact archive SHA-256 is read from its checksums.txt entry and verified before extraction; the installed version must match. Missing/ambiguous checksums, unavailable assets and insecure URLs fail clearly. An explicit install-dir selects a managed prefix. BSD uses native glab packages, requiring install-dir to be omitted.

Use sudo for noninteractive native package elevation when needed; Homebrew must
run as the normal user. This function installs the CLI without logging in or
changing repository contents. Credentials remain in native environment/configuration.
Returns tool, version, bin-dir and environment entries, publishing PATH for later
tasks in the same host session. See [COMPONENT.md](./COMPONENT.md) for named arguments
and return fields and the [glab operation module](../../version-control/glab/README.md)
for checkout/release/pipeline operations with automatic setup. License: MIT.
