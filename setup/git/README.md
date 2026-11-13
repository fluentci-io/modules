# Setup Git

Install or reuse a verified Git CLI and publish its environment for CI/CD.
Native PureScript Wasm component; requires FluentCI v0.17.3+.

```sh
fluentci run setup-git setup --version latest
```

Supports Linux, macOS, FreeBSD, OpenBSD and NetBSD. Unsupported OS values fail before installation. Archive installers support
x86_64/aarch64; BSD architecture availability follows the native repositories. A usable installed CLI matching the requested version
is reused. Native package availability and permissions determine installation
success; missing packages and version mismatches remain failures.

Git uses native repositories on every supported OS. Exact versions must be available in the configured repository; package-name can select a versioned package. Omit install-dir. The executable version is verified after installation.

Use sudo for noninteractive native package elevation when needed; Homebrew must
run as the normal user. This function installs the CLI without logging in or
changing repository contents. Credentials remain in native environment/configuration.
Returns tool, version, bin-dir and environment entries, publishing PATH for later
tasks in the same host session. See [COMPONENT.md](./COMPONENT.md) for named arguments
and return fields and the [git operation module](../../version-control/git/README.md)
for checkout/release/pipeline operations with automatic setup. License: MIT.
