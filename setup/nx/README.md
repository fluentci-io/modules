# Setup Nx

Install a selected Nx CLI release, verify its version, and publish PATH for CI/CD tasks. Implemented in PureScript as a typed Wasm component.

```sh
fluentci run setup-nx setup --version 24.0.6
fluentci run setup-nx setup --help
```

Default version: **24.0.6**. Use `--version` for another exact compatible npm release, or explicitly request `latest`. Linux and macOS install `nx@VERSION` with Bun, ensuring Node.js and Bun are available. Configure a compatible Node.js version with setup-node first when the runner already has an older Node.js installation. Bun's default trusted dependency list permits Nx's native postinstall script.

The per-user prefix is `$HOME/.local/share/fluentci/nx/VERSION`; an absolute `--install-dir` overrides it. Verified installations are reused. The version check reads the installed global Nx version when the CLI reports both local and global versions, avoiding a false mismatch from the current workspace. Failed installation or version checks never publish successful setup; failed newly created prefixes are cleaned up.

FreeBSD, OpenBSD and NetBSD use native `nx` packages when available in the configured repositories. Availability and compatible native dependencies are repository-dependent; missing packages fail explicitly. For native installations omit `--install-dir`, optionally set `--package-name`, and use `--sudo` for noninteractive elevation if required.

Setup does not initialize a workspace or install its plugins, executor packages or task dependencies. Install workspace dependencies using the project lockfile. Nx may delegate subsequent commands to the workspace-local version; pin that version alongside the setup version.

Returns typed `tool`, `version`, `bin-dir` and `environment`. Environment updates apply to subsequent host tasks; separate processes must propagate the returned PATH. See [COMPONENT.md](./COMPONENT.md) for all options and return descriptions, and [the Nx build module](../../build/nx/README.md) for task orchestration.

[Official installation guide](https://nx.dev/docs/getting-started/installation) · [MIT wrapper license](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-nx --path /path/to/fluentci-modules/setup/nx
```

For a published module, use `fluentci add @fluentci.io/setup-nx@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision nx before the build steps that require it. The setup result reports the installed version and executable directory.

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
import FluentCI.Modules.SetupNx as SetupNx

run :: Effect String
run =
  Flow.pipeline "setup-nx-setup"
    # Flow.workdir "."
    # SetupNx.setup (SetupNx.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_nx

pub fn run() -> String {
  flow.pipeline("setup-nx-setup")
  |> flow.workdir(".")
  |> setup_nx.setup(setup_nx.setup_args())
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
  alias FluentCI.Modules.SetupNx

  defplugin run do
    Flow.pipeline("setup-nx-setup")
    |> Flow.workdir(".")
    |> SetupNx.setup(%{})
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
            [fluentci-modules.setup-nx :as setup_nx]))

(defn run []
  (-> (flow/pipeline "setup-nx-setup")
      (flow/workdir ".")
      (setup_nx/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-nx-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupNx.setup(FluentciModulesSetupNx.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_nx


def run() -> str:
    return (
        pipeline("setup-nx-setup")
        .workdir(".")
        .pipe(setup_nx.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_nx from "./fluentci_modules/setup-nx/index";

export function run(): string {
  return flow.pipeline("setup-nx-setup")
    .workdir(".")
    .pipe(setup_nx.setup, {})
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
| `setup` | Install and verify nx, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
