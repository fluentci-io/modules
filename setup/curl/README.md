# Setup curl

Install or verify curl with a typed PureScript Wasm component. Requires FluentCI
v0.17.3+. Supports Linux, macOS, FreeBSD, OpenBSD and NetBSD native repositories.

```sh
fluentci run setup-curl setup
fluentci run setup-curl setup --version 8.17.0
fluentci run setup-curl setup --sudo
fluentci run setup-curl setup --help
```

A matching executable already on PATH is verified and reused. Otherwise the
module selects apt/dnf/yum/apk/pacman/zypper, Homebrew/MacPorts, pkg, pkg_add or
pkgin as appropriate. Version pins and `packageName` selectors must be available
in the configured native repository. `sudo` enables noninteractive elevation;
Homebrew runs as the current user. Native packages do not accept `installDir`.

Returns `tool`, `version`, `binDir`, and `environment` (name/value records), and
publishes PATH to later tasks in the same host session. Failures never report a
successful installation. Notification modules require curl >= 8.3.0; an older
system curl must be upgraded to an available compatible version before sending.

See [COMPONENT.md](./COMPONENT.md), the [curl manual](https://curl.se/docs/manpage.html),
and [MIT License](./LICENSE). Runtime build and regression verification run in CI.
