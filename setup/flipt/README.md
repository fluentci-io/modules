# Setup Flipt

Install or reuse a verified Flipt CLI and publish its environment for CI/CD tasks.
Typed PureScript Wasm component; requires FluentCI v0.17.3+.

```sh
fluentci run setup-flipt setup --version latest
fluentci run setup-flipt setup --version 2.14.1
```

Supports Linux/macOS on x86_64/aarch64. Unsupported hosts fail explicitly before
installation. An existing PATH executable matching the requested version skips
downloads; latest accepts an installed release. Otherwise setup uses official
[flipt-io/flipt releases](https://github.com/flipt-io/flipt/releases), verifies SHA-256
from the exact asset digest or checksums.txt entry, and verifies its installed version.
Missing checksums, invalid archives and version mismatches fail without successful setup.
An explicit install-dir selects a managed prefix instead of PATH reuse. Omit
package-name and sudo for official per-user archives.

Returns tool, version, bin-dir and environment entries. PATH is published to later
tasks in the same host session. Setup installs the CLI without starting a server,
running database migrations or opening configuration wizards.

The [Flipt operation module](../../deployment/flipt/README.md) exports setup and runs
its preflight before every operation. Named operations target v2; explicit older
versions can use the literal run escape hatch. See [COMPONENT.md](./COMPONENT.md)
for typed arguments, descriptions and return fields. License: MIT.

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-flipt --path /path/to/fluentci-modules/setup/flipt
```

For a published module, use `fluentci add @fluentci.io/setup-flipt@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision flipt before the build steps that require it. The setup result reports the installed version and executable directory.

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
import FluentCI.Modules.SetupFlipt as SetupFlipt

run :: Effect String
run =
  Flow.pipeline "setup-flipt-setup"
    # Flow.workdir "."
    # SetupFlipt.setup (SetupFlipt.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_flipt

pub fn run() -> String {
  flow.pipeline("setup-flipt-setup")
  |> flow.workdir(".")
  |> setup_flipt.setup(setup_flipt.setup_args())
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
  alias FluentCI.Modules.SetupFlipt

  defplugin run do
    Flow.pipeline("setup-flipt-setup")
    |> Flow.workdir(".")
    |> SetupFlipt.setup(%{})
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
            [fluentci-modules.setup-flipt :as setup_flipt]))

(defn run []
  (-> (flow/pipeline "setup-flipt-setup")
      (flow/workdir ".")
      (setup_flipt/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-flipt-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupFlipt.setup(FluentciModulesSetupFlipt.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_flipt


def run() -> str:
    return (
        pipeline("setup-flipt-setup")
        .workdir(".")
        .pipe(setup_flipt.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_flipt from "./fluentci_modules/setup-flipt/index";

export function run(): string {
  return flow.pipeline("setup-flipt-setup")
    .workdir(".")
    .pipe(setup_flipt.setup, {})
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
| `setup` | Install and verify flipt, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
