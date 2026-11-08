# Setup MacPorts

Install the official signed MacPorts system package for the current macOS
release and verify `/opt/local/bin/port`. This typed PureScript Wasm component
requires FluentCI v0.17.2+.

```sh
fluentci run setup-macports setup --version 2.12.7 --packages git,cmake,ninja --sudo
fluentci run setup-macports setup --help
```

macOS only, on Intel and Apple Silicon. Setup selects the release `.pkg` matching
`sw_vers -productVersion`, verifies the upstream SHA-256 and package signature,
then invokes Apple's `installer`. A missing matching package or digest fails
before installation. Linux and BSD hosts fail before mutation.

The default is `latest`; exact versions may include `v`. A new system install
requires root or explicit `--sudo` (noninteractive `sudo -n`). The official
installer fixes the prefix at `/opt/local`; `--install-dir` and `--package-name`
are rejected. Existing installations are reused only if they match the selected
release; a mismatch fails without replacing the installation. The native package
may initialize its ports tree as part of its upstream post-install procedure.

`packages` optionally installs a comma-separated list of port names, such as
`git,cmake,ninja,python312`, after the CLI is verified. Whitespace around names is
trimmed; omitted or blank values retain CLI-only setup. Empty entries and invalid
names fail before any host command. Package versions come from the configured
ports tree; this argument does not fetch arbitrary historical versions.

Setup invokes `/opt/local/bin/port -N install` with the requested names. Use
`--sudo` for noninteractive privilege elevation; otherwise the command runs with
the current user's permissions. A failed package install fails setup without
publishing a successful environment. Already installed files may remain.

Xcode Command Line Tools, accepted licenses, configured sources, and permissions
for port installation remain runner prerequisites. This module always verifies
and invokes native MacPorts at its fixed path, even if the Rust `port`
implementation is earlier on PATH.

Returns `tool`, `version`, `bin-dir`, and `environment`; publishes `/opt/local/bin`
for subsequent host tasks, plus `/opt/local/sbin` when packages are requested. Separate CLI processes must propagate the returned
environment. See [COMPONENT.md](./COMPONENT.md) for typed arguments and returns.

[MacPorts installation guide](https://guide.macports.org/#installing.macports) ·
[Upstream releases](https://github.com/macports/macports-base/releases) ·
[MIT module license](./LICENSE).
