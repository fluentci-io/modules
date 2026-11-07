# Elixir

Set up Elixir from FluentCI using PureScript compiled to WebAssembly.

## Platforms

Linux, macOS, FreeBSD, OpenBSD, and NetBSD. Linux/macOS use upstream downloads; BSD uses the native repository and requires an available package for your OS and architecture.

Precompiled Elixir ZIP archives from Hex, matched to the installed Erlang/OTP major. Erlang must already be on PATH on Linux/macOS. `otpVersion` can require a specific installed OTP major; a mismatch fails before downloading.

## Usage

```sh
fluentci run elixir setup 1.18.0
```

Omit the version to use the default. The `setup` export also accepts a JSON
object as plugin input:

```json
{
  "version": "1.18.0"
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
import CI.Setup.Elixir as Runtime
import Effect (Effect)

bootstrap :: Effect Unit
bootstrap = void (Runtime.setupWith (Runtime.defaultConfig { version = "1.18.0" }))
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
