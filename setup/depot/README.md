# Setup Depot

Install or reuse a verified Depot CLI and publish its environment for CI/CD tasks.
Native Wasm component written in PureScript; requires FluentCI v0.17.3+.

```sh
fluentci run setup-depot setup --version latest
fluentci run setup-depot setup --version 2.103.12
```

Supports Linux/macOS on x86_64/aarch64 only. Unsupported hosts fail explicitly.
An existing CLI on PATH with a matching requested version skips downloads; latest
accepts the installed version. Otherwise the official depot/cli GitHub release archive
is SHA-256 checked, extracted into a versioned per-user prefix, and version-verified.
Missing checksums or a wrong version fail without publishing success.
An explicit install-dir selects a managed installation instead of reusing PATH.
Native package-name and sudo options are not used for official per-user archives.

Returns tool, version, bin-dir, and environment entries. Later tasks in the same
host session inherit PATH. Credentials remain inherited through DEPOT_TOKEN or
native CI OIDC. Installation does not authenticate or start a build.

See [COMPONENT.md](./COMPONENT.md) for all named arguments and their descriptions.
The [Depot operation module](../../containers/depot/README.md) exposes setup and
runs its preflight before every command. License: MIT.

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-depot --path /path/to/fluentci-modules/setup/depot
```

For a published module, use `fluentci add @fluentci.io/setup-depot@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision depot before the build steps that require it. The setup result reports the installed version and executable directory.

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
import FluentCI.Modules.SetupDepot as SetupDepot

run :: Effect String
run =
  Flow.pipeline "setup-depot-setup"
    # Flow.workdir "."
    # SetupDepot.setup (SetupDepot.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_depot

pub fn run() -> String {
  flow.pipeline("setup-depot-setup")
  |> flow.workdir(".")
  |> setup_depot.setup(setup_depot.setup_args())
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
  alias FluentCI.Modules.SetupDepot

  defplugin run do
    Flow.pipeline("setup-depot-setup")
    |> Flow.workdir(".")
    |> SetupDepot.setup(%{})
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
            [fluentci-modules.setup-depot :as setup_depot]))

(defn run []
  (-> (flow/pipeline "setup-depot-setup")
      (flow/workdir ".")
      (setup_depot/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-depot-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupDepot.setup(FluentciModulesSetupDepot.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_depot


def run() -> str:
    return (
        pipeline("setup-depot-setup")
        .workdir(".")
        .pipe(setup_depot.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_depot from "./fluentci_modules/setup-depot/index";

export function run(): string {
  return flow.pipeline("setup-depot-setup")
    .workdir(".")
    .pipe(setup_depot.setup, {})
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
| `setup` | Install and verify depot, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
