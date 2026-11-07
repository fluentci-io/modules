# Nix

Set up Nix from FluentCI using PureScript compiled to WebAssembly.

## Platforms

Linux and macOS only. BSD hosts are rejected before executing commands.

Official upstream Nix installer. Select a Nix release or `latest`. Defaults to daemon mode; `daemon: false` is supported only on Linux. Uses system-managed Nix paths rather than `installDir`.

## Usage

```sh
fluentci run nix setup 2.26.0
```

Omit the version to use the default. The `setup` export also accepts a JSON
object as plugin input:

```json
{
  "version": "2.26.0"
}
```

See the [shared setup guide](../README.md) for configuration, prerequisites,
installation paths, native BSD package selectors, privileges, and output format.
After installation, setup verifies the runtime version and updates PATH in the
FluentCI engine for later steps.

## Compose in PureScript

```purescript
module Main where

import Prelude
import CI.Setup.Nix as Runtime
import Effect (Effect)

bootstrap :: Effect Unit
bootstrap = void (Runtime.setupWith (Runtime.defaultConfig { version = "2.26.0" }))
```

## Development

Keep the checked-in `lib/setup` library and `test/setup` fixtures available,
then run from this directory:

```sh
npm ci
npm run build
npm test
```

The build produces `dist/plugin.wasm`. See the shared guide for optional live
upstream smoke tests and the limits of stub-host BSD verification.

## License

[MIT](./LICENSE).
