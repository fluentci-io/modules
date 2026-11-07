# Pkl

Set up Pkl from FluentCI using PureScript compiled to WebAssembly.

## Platforms

Linux, macOS, FreeBSD, OpenBSD, and NetBSD. Linux/macOS use upstream downloads; BSD uses the native repository and requires an available package for your OS and architecture.

Pkl release binaries for Linux x86_64/aarch64 and macOS aarch64. Linux x86_64
uses the Alpine static executable when musl is detected or `libc="musl"`.
macOS x86_64 and musl Linux aarch64 use the upstream `jpkl` Java executable
installed as `pkl`; these paths require Java 17 or newer on PATH. Run the
Java setup module first if needed. `libc` accepts `auto` (default), `gnu`, or
`musl`. BSD uses native packages and fails clearly if the selected repository
does not provide Pkl.

## Usage

```sh
fluentci run pkl setup 0.33.0
```

Omit the version to use the default. The `setup` export also accepts a JSON
object as plugin input:

```json
{
  "version": "0.33.0"
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
import CI.Setup.Pkl as Runtime
import Effect (Effect)

bootstrap :: Effect Unit
bootstrap = void (Runtime.setupWith (Runtime.defaultConfig { version = "0.33.0" }))
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
