# Setup Cachix

Install and verify Cachix, then optionally configure a named binary cache with
`cachix use`. A typed PureScript Wasm component for FluentCI v0.17.2+.

```sh
fluentci run setup-cachix setup --cache fluentci
fluentci run setup-cachix setup --version latest
fluentci run setup-cachix setup --help
```

`cache` is the **cache name**, such as `fluentci`, rather than a signing key or
access token. After verifying the installed CLI, setup runs that executable’s
`cachix use CACHE` to configure Nix’s substituter and trusted public key. The
name must be a lowercase DNS label of 1–63 letters, digits, or hyphens, without
leading or trailing hyphens. Invalid names fail before installation starts.
Omitting `cache` retains CLI-only setup.

Public caches need no authentication. For a private cache, supply
`CACHIX_AUTH_TOKEN` through the runner’s secret environment before setup. The
module does not put that token in command arguments or the returned environment.
Setup configures cache reads; it does not upload build outputs or install an
automatic upload hook. Use native `cachix push CACHE PATH` for uploads.

On Linux/macOS, setup installs **`nixpkgs#cachix`** into a private Nix profile
under the per-user installation prefix. It requires an existing Nix installation
with flakes support. It does not build Cachix from its upstream GitHub flake.

`version` is checked against the Cachix version provided by the selected nixpkgs
registry entry; `latest` accepts that package’s version. An explicit version
fails if nixpkgs provides a different release. Pin the `nixpkgs` registry entry
to a suitable revision for reproducible installs of a particular package version.
The cache name is independent of the CLI version.
BSD CLI installation uses native packages when available. Configuring a cache
also requires Nix on PATH and permission to update the applicable Nix
configuration; `cachix use` determines the native configuration location. Native
package or configuration failures propagate, and no successful setup environment
is published when cache configuration fails.

Returns `tool`, `version`, `bin-dir`, and `environment`. Environment updates apply
to later tasks in the same host session; separate processes must propagate the
returned PATH. Cachix’s Nix configuration changes persist on the runner.
See [COMPONENT.md](./COMPONENT.md) for all typed arguments and returns.

[Cachix cache configuration](https://docs.cachix.org/getting-started) ·
[MIT License](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-cachix --path /path/to/fluentci-modules/setup/cachix
```

For a published module, use `fluentci add @fluentci.io/setup-cachix@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision cachix before the build steps that require it. The setup result reports the installed version and executable directory.

Replace the sample organization, paths and identifiers with your own. Configure
credentials through your CI secret provider before running authenticated operations. Optional arguments use the
callee's defaults, and public list fields use comma-separated strings. See
[COMPONENT.md](./COMPONENT.md) for argument descriptions and return types.

These examples use the generated composition API and builder chaining in
FluentCI 0.17.6; full cross-SDK compilation and execution coverage is still pending.
See [composition support and limitations](../../docs/COMPOSITION.md).



### PureScript

```purescript
module Main where

import Prelude
import Effect (Effect)
import FluentCI.Flow as Flow
import FluentCI.Modules.SetupCachix as SetupCachix

run :: Effect String
run =
  Flow.pipeline "setup-cachix-setup"
    # Flow.workdir "."
    # SetupCachix.setup (SetupCachix.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_cachix

pub fn run() -> String {
  flow.pipeline("setup-cachix-setup")
  |> flow.workdir(".")
  |> setup_cachix.setup(setup_cachix.setup_args())
  |> flow.map(fn(result) { result.version })
  |> flow.run
}
```

Use Gleam's JavaScript target for the Wasm guest. BEAM escripts used for repository
automation are separate from component guests.

### Elixir

```elixir
defmodule Main do
  use FluentCI.Plugin
  alias FluentCI.Flow
  alias FluentCI.Modules.SetupCachix

  defplugin run do
    Flow.pipeline("setup-cachix-setup")
    |> Flow.workdir(".")
    |> SetupCachix.setup(%{})
    |> Flow.stdout()
  end
end
```

Elixir compiles this sequence to Rust/Wasm. Its initial Flow API does not yet
provide the typed result callbacks or cleanup combinators of the other examples.

### ClojureScript

```clojure
(ns main.plugin
  (:require [fluentci.flow :as flow]
            [fluentci-modules.setup-cachix :as setup_cachix]))

(defn run []
  (-> (flow/pipeline "setup-cachix-setup")
      (flow/workdir ".")
      (setup_cachix/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-cachix-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupCachix.setup(FluentciModulesSetupCachix.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_cachix


def run() -> str:
    return (
        pipeline("setup-cachix-setup")
        .workdir(".")
        .pipe(setup_cachix.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_cachix from "./fluentci_modules/setup-cachix/index";

export function run(): string {
  return flow.pipeline("setup-cachix-setup")
    .workdir(".")
    .pipe(setup_cachix.setup, {})
    .map(result => result.version)
    .run();
}
```

Python and TypeScript use FluentCI builder chains: `.pipe(module.function, args)`
composes generated module functions with `.workdir`, `.env`, and `.exec`.
Functions return a pipeline carrying their typed result. Use a generated result
callback (`With`/`_with`, or a callback argument in TypeScript/Python) when a later
module needs a preceding result; use Flow's map operation to select a result field.
Execution begins at `run` (or the Elixir plugin terminal), in declared order.

### Exported functions

| Function | Purpose |
| --- | --- |
| `setup` | Install and verify cachix, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
