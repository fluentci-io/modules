# Determinate Nix

Set up Determinate Nix from FluentCI using PureScript compiled to WebAssembly.

## Platforms

Linux and macOS only. BSD hosts are rejected before executing commands.

Official Determinate Nix installer. `version` pins the **installer** release, which chooses its associated Determinate Nix release; it is not an arbitrary Nix package version. Use `latest` for the current installer. On Linux, set `init: "none"` for a container without systemd. Uses system-managed Nix paths rather than `installDir`.

## Usage

```sh
fluentci run determinate-nix setup 3.24.2
```

Omit the version to use the default. The `setup` export also accepts a JSON
object as plugin input:

```json
{
  "version": "3.24.2"
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
import CI.Setup.DeterminateNix as Runtime
import Effect (Effect)

bootstrap :: Effect Unit
bootstrap = void (Runtime.setupWith (Runtime.defaultConfig { version = "3.24.2" }))
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
