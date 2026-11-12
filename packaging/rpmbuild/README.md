# Rpmbuild

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.3+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run rpmbuild build --directory rpm-tree --spec widget.spec --arch aarch64 --output dist/rpm
```

```sh
fluentci run rpmbuild --help
fluentci run rpmbuild build --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Linux-only; requires rpmbuild, rpm, and GNU coreutils.
`validate` returns a boolean after validating the tree and CPU architecture.
`build` returns a native list of generated package paths. Selecting an architecture
does not cross-compile the payload.

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

## Development

From this module directory, with Node.js, Bun, PureScript, and Spago installed:

```sh
bun install --cwd ../../lib/component --frozen-lockfile
npm ci
npm run build
npm test
```

`dist/plugin.wasm` is the native component; `dist/fluentci.metadata.json` is its
checksummed contract sidecar. The CJS bundles and `legacy-entry.mjs` exist only for
private regression tests and are not the published module interface.

See the [component migration guide](../../docs/COMPONENTS.md) and
[MIT License](./LICENSE).

## Setup component dependency

This module declares `setup-rpmbuild` as typed native component dependencies.
FluentCI v0.17.3+ resolves their source references while building and composes
them into the published Wasm. Consumers need no relative source paths.
Available tools are reused; missing prerequisites invoke setup with default
arguments. Explicit executable overrides remain caller-managed. Configure pinned
versions or privileged/custom installations in an earlier setup step.
See [dependency behavior and publishing](../../docs/MODULE_DEPENDENCIES.md) for
command-specific prerequisites, validation, credential skips, and CI coverage.
