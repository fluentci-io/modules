# Bun

Set up Bun from FluentCI using PureScript compiled to WebAssembly.

## Platforms

Linux, macOS, FreeBSD, OpenBSD, and NetBSD. Linux/macOS use upstream downloads; BSD uses the native repository and requires an available package for your OS and architecture.

Official Bun ZIP archives. `baseline: true` selects the x86_64 baseline build; `libc` accepts `auto`, `gnu`, or `musl` on Linux. Auto detects Alpine; use `musl` explicitly for other musl-based systems. Baseline is rejected on aarch64.

## Usage

```sh
fluentci run bun setup 1.2.3
```

Omit the version to use the default. The `setup` export also accepts a JSON
object as plugin input:

```json
{
  "version": "1.2.3"
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
import CI.Setup.Bun as Runtime
import Effect (Effect)

bootstrap :: Effect Unit
bootstrap = void (Runtime.setupWith (Runtime.defaultConfig { version = "1.2.3" }))
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
