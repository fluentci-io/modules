# Setup GitHub CLI

Install a selected GitHub CLI release and configure PATH for CI/CD pipelines.
This PureScript Wasm component requires FluentCI v0.17.2+.

```sh
fluentci run setup-gh setup --version 2.103.3
fluentci run setup-gh setup --help
```

## Platforms

| OS | Installation |
| --- | --- |
| Linux | Official GitHub CLI tar.gz release for amd64 or arm64. |
| macOS | Official GitHub CLI ZIP release for amd64 or arm64. |
| FreeBSD | Native `gh` package using `pkg`. |
| NetBSD | Native `gh` package using `pkgin`. |
| OpenBSD | Native `gh` package using `pkg_add`. |

Linux/macOS support x86_64/aarch64 CPU aliases. The default version is `latest`;
exact releases may include the `v` prefix. Archive downloads verify an upstream
SHA-256 digest when the GitHub release API provides one, then execute `gh --version`
to verify the selected release.

BSD support uses native packages, never Linux binaries. Package/version
availability depends on the configured repository and OS/CPU. Use `--package-name`
for an explicit native package selector and `--sudo` for noninteractive privilege
elevation when needed. Missing packages or version mismatches fail the call.
BSD command selection is tested with fixtures; a particular package repository
still needs verification on a real BSD runner.

Archive installs preserve adjacent resources under
`$HOME/.local/share/fluentci/gh/VERSION`, or an absolute `--install-dir`. Existing
matching installations are verified and reused. Native packages use the system
prefix and do not accept a custom installation directory.

No login or authenticated GitHub operation is performed during setup. Supply
`GH_TOKEN` or native GitHub CLI authentication separately for later pipeline
commands.

The result contains `tool`, `version`, `bin-dir`, and `environment` records.
Environment updates apply within the host session. Separate CLI processes must
add the returned installation directory to PATH explicitly. See
[COMPONENT.md](./COMPONENT.md) for all typed arguments and returns.

## Development

```sh
bun install --cwd ../../lib/component --frozen-lockfile
npm ci
npm run build
npm test
```

[GitHub CLI releases](https://github.com/cli/cli/releases) · [MIT License](./LICENSE).
