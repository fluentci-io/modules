# Dpkg

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.2+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run dpkg build --directory package --arch arm64 --output dist/widget_1.2.0_arm64.deb
```

```sh
fluentci run dpkg --help
fluentci run dpkg build --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Linux-only; requires dpkg, dpkg-deb, and GNU coreutils.
`validate` returns a boolean after validating the tree and CPU architecture.
`build` returns a native list of generated package paths. Selecting an architecture
does not cross-compile the payload.

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
