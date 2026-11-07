# PureScript

Install a complete PureScript toolchain: Node.js, Bun, npm, the `purs` compiler,
and Spago. Each version can be selected independently.

## Usage

```sh
fluentci run setup-purescript setup 0.15.16
```

The `setup` WebAssembly export also accepts JSON plugin input:

```json
{
  "version": "0.15.16",
  "nodeVersion": "22.14.0",
  "bunVersion": "1.2.3",
  "spagoVersion": "1.0.5",
  "npmVersion": "10.9.2",
  "installDir": "/home/runner/tools/purescript"
}
```

Defaults are the latest PureScript, Bun, and Spago releases, Node LTS, and npm
10.9.2. `npmVersion` must be an exact numeric release. Select versions that
are compatible with one another; for example, Spago 1.x requires Node 22.5
or newer. Version mismatches fail instead of reporting success.

On Linux/macOS, npm installs the compiler and Spago in an isolated prefix.
`installDir` controls that prefix and defaults to
`$HOME/.local/share/fluentci/purescript/VERSION`. Node and Bun use their normal
[setup module](../README.md) installation locations. Portable npm is bootstrapped
from its official registry archive and retained in the toolchain prefix.

On FreeBSD, OpenBSD, and NetBSD, Node, Bun, and PureScript come from the native
package repository; npm and Spago are installed as JavaScript packages. All
three native packages must be available. On BSD, `installDir` still controls
the per-user npm/Spago prefix; native packages use their system prefixes.
Use `nodePackageName`, `bunPackageName`,
and `packageName` to choose repository-specific versions, and `sudo: true`
for passwordless native package installation. FreeBSD defaults to the
`hs-purescript` compiler package. Other BSD defaults use `purescript`.

Setup verifies the compiler, Node, Bun, npm, and Spago, updates the FluentCI
engine's PATH, and returns their versions in JSON. Shell startup files are
not changed.

## Compose in PureScript

```purescript
module Main where

import Prelude
import CI.Setup.PureScript as PureScript
import Effect (Effect)

bootstrap :: Effect Unit
bootstrap = void (PureScript.setupWith (PureScript.defaultConfig
  { version = "0.15.16", nodeVersion = "22.14.0", spagoVersion = "1.0.5" }))
```

## Development

```sh
npm ci
npm run build
npm test
```

The module uses the checked-in `lib/setup` library and shared test fixtures.
`FLUENTCI_SETUP_LIVE=1 npm test` enables a real temporary toolchain install on
Linux/macOS. Native BSD package availability requires a BSD runner to verify.

## License

[MIT](./LICENSE).
