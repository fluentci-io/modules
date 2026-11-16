# Cachix

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.3+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run cachix setup --cache example
```

```sh
fluentci run cachix --help
fluentci run cachix setup --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Requires Nix and CACHIX_AUTH_TOKEN for the named cache. `setup` configures cache
use; `push` uploads ./result. Returns `enabled` and `cache`, making a skipped
operation visible when the token is absent. Tool installation is `setup-cachix`.

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

This module declares `setup-nix` and `setup-cachix` as typed native component dependencies.
FluentCI v0.17.3+ resolves their source references while building and composes
them into the published Wasm. Consumers need no relative source paths.
Available tools are reused; missing prerequisites invoke setup with default
arguments. Explicit executable overrides remain caller-managed. Configure pinned
versions or privileged/custom installations in an earlier setup step.
See [dependency behavior and publishing](../../docs/MODULE_DEPENDENCIES.md) for
command-specific prerequisites, validation, credential skips, and CI coverage.

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add cachix --path /path/to/fluentci-modules/caching/cachix
```

For a published module, use `fluentci add @fluentci.io/cachix@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Push the result closure to a Cachix cache using host credentials.

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
import FluentCI.Modules.Cachix as Cachix

run :: Effect String
run =
  Flow.pipeline "cachix-push"
    # Flow.workdir "."
    # Cachix.push (Cachix.pushArgs { "cache": "acme-builds" })
    # Flow.map (\result -> result.cache)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/cachix

pub fn run() -> String {
  flow.pipeline("cachix-push")
  |> flow.workdir(".")
  |> cachix.push(cachix.push_args("acme-builds"))
  |> flow.map(fn(result) { result.cache })
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
  alias FluentCI.Modules.Cachix

  defplugin run do
    Flow.pipeline("cachix-push")
    |> Flow.workdir(".")
    |> Cachix.push(%{"cache" => "acme-builds"})
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
            [fluentci-modules.cachix :as cachix]))

(defn run []
  (-> (flow/pipeline "cachix-push")
      (flow/workdir ".")
      (cachix/push {:cache "acme-builds"})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("cachix-push")
  ->Flow.workdir(".")
  ->FluentciModulesCachix.push(FluentciModulesCachix.pushArgs(~cache="acme-builds"))
  ->Flow.map(result => result.cache)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import cachix


def run() -> str:
    return (
        pipeline("cachix-push")
        .workdir(".")
        .pipe(cachix.push, {"cache": "acme-builds"})
        .map(lambda result: result.cache)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as cachix from "./fluentci_modules/cachix/index";

export function run(): string {
  return flow.pipeline("cachix-push")
    .workdir(".")
    .pipe(cachix.push, {"cache":"acme-builds"})
    .map(result => result.cache)
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
| `setup` | Configure a Cachix cache using host credentials. |
| `push` | Push the result closure to a Cachix cache using host credentials. |
<!-- /generated:language-examples -->
