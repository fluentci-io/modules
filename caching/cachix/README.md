# Cachix for FluentCI

Configure a Cachix binary cache and upload Nix build outputs from FluentCI.
The module is written in PureScript and compiled to WebAssembly.

## Usage

Run from a Nix flake workspace with FluentCI installed and Nix's `flakes` and
`nix-command` features enabled. Supply `CACHIX_AUTH_TOKEN` through your shell or
CI secret store, then replace `my-cache` with your Cachix cache name:

```sh
fluentci run cachix setup my-cache
nix build
fluentci run cachix push my-cache
```

The module runs Cachix through
`nix run --no-write-lock-file --inputs-from . nixpkgs#cachix -- ...`, so a
separate Cachix installation is unnecessary. Your workspace must provide the
Nix inputs needed to resolve `nixpkgs#cachix`.

## Functions

| CLI function | Behavior |
| --- | --- |
| `setup CACHE_NAME` | Runs `cachix use CACHE_NAME` to configure the binary cache. |
| `push CACHE_NAME` | Uploads the `./result` output closure, including an already-built result. |

Both functions fall back to `CACHIX_CACHE` when no cache name is passed:

```sh
export CACHIX_CACHE=my-cache
fluentci run cachix setup
nix build
fluentci run cachix push
```

Cache names must contain 1–63 lowercase letters, digits, or hyphens, with no
leading or trailing hyphen. `setup` only configures the cache; call `push` after
a successful build that creates `./result`.

## Authentication

If `CACHIX_AUTH_TOKEN` is missing, empty, or whitespace-only, `setup` and `push`
print a skip message and succeed. With a token present, setup and upload errors
propagate to FluentCI. Cachix reads the token from the host environment; the
module does not include it in command arguments or print it.

## Compose in PureScript

The source API also exposes helpers for use in other PureScript modules:

```purescript
module Main where

import Prelude
import CI.Cachix as Cachix
import Effect (Effect)

build :: Effect Unit
build = do
  Cachix.setupWith "my-cache"
  Cachix.runWithCache "my-cache" [ "nix", "build" ]
  Cachix.pushResultWith "my-cache"
```

- `setupWith :: String -> Effect Unit` configures the named cache.
- `runWithCache :: String -> Array String -> Effect Unit` runs a command through
  `cachix watch-exec`, uploading newly produced store paths, including build-time
  dependencies. Without a token, it runs the command normally. Command failures
  propagate in either case.
- `pushResultWith :: String -> Effect Unit` uploads the `./result` closure.

An explicit final push also covers builds that produce no new store paths.
Only `setup` and `push` are exported as WebAssembly entry points.

## Development

Install Node.js, Spago, the PureScript compiler, and the `extism-js` compiler.
The workspace configuration also requires the `fluentci-ci-common` package at
`../common`, relative to this module.

```sh
npm ci
npm run build
npm test
```

The build compiles PureScript, bundles the entry points, and produces
`dist/plugin.wasm`. Tests run the compiled PureScript against a stub FluentCI
host without launching Nix or Cachix or reading real credentials.

## License

[MIT](./LICENSE).
