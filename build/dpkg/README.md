# Dpkg for FluentCI

Build a Debian package from a prepared filesystem directory using PureScript
and `dpkg-deb`. Package names, versions, payloads, and dependencies come from
your project's `DEBIAN/control` file.

## Requirements

Execution is Linux-only. Both `validate` and `build` check the host OS first,
then verify that `dpkg-deb`, `dpkg`, and GNU `realpath` can run. Standard tools
`test`, `cat`, `dirname`, and `mkdir` must also be available. On Debian/Ubuntu,
install `dpkg` and `coreutils`. Missing tools cause a clear failure; the module
does not install system packages.

## Directory layout

Prepare a binary package root, with installed paths relative to that root:

```text
package/
├── DEBIAN/
│   └── control
└── usr/
    └── share/
        └── widget/
            └── message.txt
```

For example, `package/DEBIAN/control`:

```debcontrol
Package: widget
Version: 1.2.0
Architecture: arm64
Maintainer: Example <packages@example.org>
Description: My application
```

Use `DEBIAN` in uppercase. A source package's `debian/control` layout is not
accepted. Metadata must contain one binary package paragraph and exactly one
nonempty `Package`, `Version`, `Architecture`, `Maintainer`, and `Description`
field. Package names and versions are validated by `dpkg`. Optional maintainer
scripts belong under `DEBIAN/` and must have the permissions required by dpkg.
Payload paths and dependencies are your choice; metadata-only packages are
also supported.

## Usage

The module is registered as `dpkg` in the repository's `fluentci.toml`. Invoke
its `validate` or `build` WebAssembly export with JSON plugin input:

```json
{
  "directory": "package",
  "arch": "arm64",
  "output": "dist/widget_1.2.0_arm64.deb"
}
```

| Argument | Meaning |
| --- | --- |
| `directory` | Required package root directory. |
| `arch` | Required Debian architecture; `x86_64`, `aarch64`, and `i686` are aliases for `amd64`, `arm64`, and `i386`. |
| `output` | Destination `.deb` file; defaults to `directory` followed by `.deb`. Parent directories are created during a build. |

Other canonical Debian architectures, such as `riscv64` and `ppc64el`, are
passed through. Use `all` for an architecture-independent package. The
`Architecture` field must match the normalized requested architecture. The
module does not rewrite metadata or cross-compile binaries; supply a payload
already built for the selected CPU.

`validate` checks tools, directory layout, required metadata, and architecture
without creating output. `build` performs these checks, runs `dpkg-deb` with
its own control syntax and permission checks enabled, assigns root ownership
to archive entries using `--root-owner-group`, and verifies the resulting
package's architecture. Existing output files are overwritten by dpkg-deb.

The output path must be outside the package root, including through symlinks.
Paths are literal arguments; shell expansion is not performed. Empty paths,
NULs, and line breaks are rejected. Unknown JSON fields and wrong types are
rejected. Build output is a JSON array of absolute artifact paths:

```json
["/workspace/dist/widget_1.2.0_arm64.deb"]
```

## Compose in PureScript

```purescript
module Main where

import CI.Dpkg as Dpkg
import Effect (Effect)

package :: Effect (Array String)
package = Dpkg.buildWith
  { directory: "package"
  , arch: "arm64"
  , output: "dist/widget.deb"
  }
```

`validateWith` accepts the same configuration and returns `Effect Unit`.
The artifact paths returned by `buildWith` can be passed to
`CI.Gemfury.uploadFiles` in a pipeline that includes both source packages.

## Development

Install Node.js, Spago, the PureScript compiler, and `extism-js`:

```sh
npm ci
npm run build
npm test
```

The build produces `dist/plugin.wasm`. Tests exercise the compiled module
against a stub host. On Linux with the required tools, integration tests also
build and inspect real packages for `amd64`, `arm64`, and `all`. Those tests
are skipped on other hosts.

See the [official dpkg-deb reference](https://manpages.debian.org/trixie/dpkg/dpkg-deb.1.en.html)
for package-root conventions and native validation.

## License

[MIT](./LICENSE).
