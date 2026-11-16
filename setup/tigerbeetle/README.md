# Setup TigerBeetle

Install a verified official prebuilt TigerBeetle binary for Linux or macOS,
select its version, and return the installed version, binary directory and
updated environment. PureScript typed Wasm component.

```sh
fluentci run setup-tigerbeetle setup --version 0.17.9
fluentci run setup-tigerbeetle setup --version latest
```

Linux supports x86_64 and aarch64; macOS uses the official universal archive.
Downloads must have a SHA-256 digest in GitHub release metadata. Missing assets,
missing digests, checksum failures, and version mismatches fail setup. A verified
existing per-user installation is reused. No source compilation is performed.
FreeBSD, NetBSD, OpenBSD and other operating systems are explicitly unsupported.

The default is `0.17.9`. An absolute `--install-dir` overrides the managed prefix.
Use the returned environment in later tasks; a separate process must propagate it.
This installer does not format data files or start a database. Use the
[tigerbeetle service](../../services/tigerbeetle/README.md) for those operations.

[Typed arguments and returns](./COMPONENT.md) ·
[Official installation guide](https://docs.tigerbeetle.com/operating/installing/)

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-tigerbeetle --path /path/to/fluentci-modules/setup/tigerbeetle
```

For a published module, use `fluentci add @fluentci.io/setup-tigerbeetle@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision tigerbeetle before the build steps that require it. The setup result reports the installed version and executable directory.

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
import FluentCI.Modules.SetupTigerbeetle as SetupTigerbeetle

run :: Effect String
run =
  Flow.pipeline "setup-tigerbeetle-setup"
    # Flow.workdir "."
    # SetupTigerbeetle.setup (SetupTigerbeetle.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_tigerbeetle

pub fn run() -> String {
  flow.pipeline("setup-tigerbeetle-setup")
  |> flow.workdir(".")
  |> setup_tigerbeetle.setup(setup_tigerbeetle.setup_args())
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
  alias FluentCI.Modules.SetupTigerbeetle

  defplugin run do
    Flow.pipeline("setup-tigerbeetle-setup")
    |> Flow.workdir(".")
    |> SetupTigerbeetle.setup(%{})
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
            [fluentci-modules.setup-tigerbeetle :as setup_tigerbeetle]))

(defn run []
  (-> (flow/pipeline "setup-tigerbeetle-setup")
      (flow/workdir ".")
      (setup_tigerbeetle/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-tigerbeetle-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupTigerbeetle.setup(FluentciModulesSetupTigerbeetle.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_tigerbeetle


def run() -> str:
    return (
        pipeline("setup-tigerbeetle-setup")
        .workdir(".")
        .pipe(setup_tigerbeetle.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_tigerbeetle from "./fluentci_modules/setup-tigerbeetle/index";

export function run(): string {
  return flow.pipeline("setup-tigerbeetle-setup")
    .workdir(".")
    .pipe(setup_tigerbeetle.setup, {})
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
| `setup` | Install and verify tigerbeetle, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
