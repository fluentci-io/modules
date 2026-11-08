# Setup Erlang/OTP

Install Erlang/OTP for Linux, macOS, FreeBSD, NetBSD, or OpenBSD using a typed
PureScript Wasm component. Requires FluentCI v0.17.2+.

```sh
fluentci run setup-erlang setup --version 28.3.2
fluentci run setup-erlang setup --version 28
fluentci run setup-erlang setup --help
```

`version` accepts an exact release, numeric branch, `OTP-`/`v` prefix, or `latest`.
Archive selection prefers an exact available release; otherwise it selects the
newest matching stable numeric version. Release candidates and development
branches are excluded. Omitting the version selects the latest stable build.

## Platforms

| OS | Installation |
| --- | --- |
| Linux, Ubuntu 22.04/24.04/26.04 | Hex OTP archive for the detected distribution and CPU, followed by `Install -minimal`. |
| Other Linux distributions | Native packages using apt, dnf/yum, apk, pacman, or zypper. |
| macOS | Matching `erlef/otp_builds` archive, verified against the SHA-256 in its build index. |
| FreeBSD | Native `pkg` Erlang package. |
| NetBSD | Native `pkgin` Erlang package. |
| OpenBSD | Native `pkg_add` Erlang package. |

The Linux/macOS archive approach follows [erlef/setup-beam](https://github.com/erlef/setup-beam).
x86_64 and aarch64 are supported, including amd64/arm64 aliases. Linux is detected
from `/etc/os-release`; incompatible Ubuntu archives are not used on another
distribution. Native packages depend on the repository, OS release, CPU, and
available versions. Missing packages and mismatched versions fail explicitly.

Archive installation needs curl, tar, and the runtime libraries expected by its
build platform, including compatible OpenSSL/ncurses libraries. Ubuntu archives
rely on upstream HTTPS; macOS archives additionally use the published SHA-256.
No Linux binaries are downloaded on BSD hosts.

## Configuration and verification

Archives install beneath `$HOME/.local/share/fluentci/erlang/VERSION` or an
absolute `--install-dir`. A verified matching prefix is reused. Failed new
installations are removed; existing directories are preserved.

`--package-name` explicitly selects a native package on any OS. `--sudo` selects
native installation with noninteractive sudo. Native installation requires a
configured package manager/repository and appropriate privileges; it does not
accept `--install-dir`. Pinned native package versions must exist in the selected
repository. Homebrew versioned formulas are resolved through their own prefix:

```sh
fluentci run setup-erlang setup --version 28 --package-name erlang@28
```

Verification checks `erl`, `erlc`, and `escript`, starts Erlang without a shell,
loads the compiler, and reads the installed `OTP_VERSION` file. This verifies
the OTP patch version rather than confusing the ERTS version with the OTP release.

The result contains `tool`, `version`, `bin-dir`, and `environment`. PATH updates
apply within the host session. Separate shell invocations must explicitly add
the returned `bin-dir` to PATH. See [COMPONENT.md](./COMPONENT.md) for named arguments
and return types.

## Development

```sh
bun install --cwd ../../lib/component --frozen-lockfile
npm ci
npm run build
npm test
```

Tests cover archive selection, both CPU families, native package-manager commands,
version verification, failure cleanup, and preservation of existing prefixes.
BSD package-manager tests use host fixtures; availability on a particular BSD
release still needs a real runner. The smoke workflow installs the real archive
on Linux/macOS through this component.

[MIT License](./LICENSE).
