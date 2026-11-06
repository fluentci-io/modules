# Rpmbuild for FluentCI

Build RPM packages from a project-owned RPM directory tree using PureScript.
Your spec defines the package metadata, payload, dependencies, and build steps.

## Requirements

Execution is Linux-only. Both `validate` and `build` check the host OS first,
then verify that `rpmbuild`, `rpmspec`, `rpm`, and GNU `realpath` can run.
Standard tools `test` and `mkdir` must also be available. On Debian/Ubuntu,
install `rpm` and `coreutils`; on Fedora/RHEL, install `rpm-build` and
`coreutils`. Missing tools cause a clear failure; the module does not install
system packages. Any compilers or tools used by your spec must also be installed.

## Directory layout

Prepare the standard RPM tree with the chosen spec in `SPECS/` and source
files or a staged payload in `SOURCES/`:

```text
rpm-tree/
├── SPECS/
│   └── widget.spec
└── SOURCES/
    └── root/
        └── usr/
            └── share/
                └── widget/
                    └── message.txt
```

A spec that packages this staged payload can contain:

```spec
Name: widget
Version: 1.2.0
Release: 1
Summary: My application
License: MIT

%description
My application's files.

%prep
%build
%install
mkdir -p "%{buildroot}"
cp -a "%{_sourcedir}/root/." "%{buildroot}/"

%files
/usr/share/widget/message.txt
```

Source archives and full compilation recipes are also supported. Specs are
executable build recipes; parsing them can evaluate macros. Use trusted specs.

## Usage

The module is registered as `rpmbuild` in the repository's `fluentci.toml`.
Invoke its `validate` or `build` WebAssembly export with JSON plugin input:

```json
{
  "directory": "rpm-tree",
  "spec": "widget.spec",
  "arch": "aarch64",
  "output": "dist/rpm"
}
```

| Argument | Meaning |
| --- | --- |
| `directory` | Required RPM top directory containing `SPECS/` and `SOURCES/`. |
| `spec` | Required `.spec` filename inside `SPECS/`, without directory components. |
| `arch` | Required RPM architecture; `amd64`, `arm64`, and `i386` are aliases for `x86_64`, `aarch64`, and `i686`. |
| `output` | RPM output directory; defaults to `directory/RPMS`. |

Other RPM architectures, such as `ppc64le`, `s390x`, and `riscv64`, are passed
through. Use `noarch` for architecture-independent packages. Every package in
the spec must match the normalized requested architecture, including
subpackages. For CPU-specific packages, omit `BuildArch` to let `--target`
select it. Use `BuildArch: noarch` with `arch: "noarch"` for portable payloads.
An explicit conflicting `BuildArch` fails validation; RPM can also reject a
fixed `BuildArch` incompatible with the build host. Architecture selection uses `--target`; it does not provide
a cross-compiler or verify machine code inside your payload.

`validate` checks tools, required directories, a readable nonempty spec,
spec parsing, predicted filenames, and package architectures. It does not
create directories or run the build stages. `rpmbuild` performs native checks
for source availability, dependencies, recipes, and `%files` during `build`.

`build` validates first, creates working and output directories, runs
`rpmbuild -bb`, and verifies each predicted artifact's architecture. It fixes
the filename format to `ARCH/NAME-VERSION-RELEASE.ARCH.rpm`. Existing artifacts
with the same names may be replaced. Standard build directories remain in
the RPM tree for inspection.

To keep RPM path macros literal when recipes expand them, canonical directory
and output paths allow only letters, digits, `/`, `_`, `-`, `.`, and `+`.
An output directory inside the RPM tree must be `RPMS` or a directory beneath
it. Unknown JSON fields and wrong types are rejected. Build output is a JSON
array of absolute artifact paths:

```json
["/workspace/dist/rpm/aarch64/widget-1.2.0-1.aarch64.rpm"]
```

## Compose in PureScript

```purescript
module Main where

import CI.Rpmbuild as Rpmbuild
import Effect (Effect)

package :: Effect (Array String)
package = Rpmbuild.buildWith
  { directory: "rpm-tree"
  , spec: "widget.spec"
  , arch: "aarch64"
  , output: "dist/rpm"
  }
```

`validateWith` accepts the same configuration and returns `Effect Unit`.
`buildWith` returns all binary package paths, including subpackages, for later
publishing with tools such as `CI.Gemfury.uploadFiles`.

## Development

Install Node.js, Spago, the PureScript compiler, and `extism-js`:

```sh
npm ci
npm run build
npm test
```

The build produces `dist/plugin.wasm`. Tests exercise the compiled module
against a stub host. On Linux with the required tools, integration tests also
build and inspect real packages for `x86_64`, `aarch64`, and `noarch`. Those
tests are skipped on other hosts.

See the official [rpmbuild](https://rpm.org/docs/4.20.x/man/rpmbuild.8) and
[rpmspec](https://rpm.org/docs/4.20.x/man/rpmspec.8) references for build and
spec query behavior.

## License

[MIT](./LICENSE).
