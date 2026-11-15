# Setup Drizzle Kit

Install a versioned `drizzle-kit` CLI, verify its version, and publish PATH for subsequent pipeline tasks. Implemented in PureScript as a typed Wasm component.

```sh
fluentci run setup-drizzlekit setup --version 0.31.11
fluentci run setup-drizzlekit setup --help
```

Default version: **0.31.11**. Override it with an exact compatible npm release using `--version`.

Linux and macOS use the npm CLI installed with Bun. BSD hosts use native repository packages when available; no BSD npm installation is attempted and unavailable packages fail explicitly.

On Linux/macOS the shared installer ensures Node.js and Bun are available, installs `drizzle-kit@VERSION` with Bun into `$HOME/.local/share/fluentci/drizzlekit/VERSION`, and links the CLI into that prefix's `bin` directory. Use an absolute `--install-dir` to choose a different prefix. Verified existing installations are reused; version mismatches and failed installations do not publish success. Supply a Node version compatible with the selected CLI.

Setup does not create or migrate a database and does not install the project's ORM/client or database drivers. Install those using the project's package manager and lockfile. Keep CLI and project dependency versions compatible. Project configuration imports must resolve from that project's own dependencies.

Returns typed `tool`, `version`, `bin-dir` and `environment`; separate processes must propagate the returned environment. See [COMPONENT.md](./COMPONENT.md) for all options and return descriptions, and [the database module](../../databases/drizzlekit/README.md) for pipeline operations.

[Official CLI documentation](https://orm.drizzle.team/docs/kit-overview) · [MIT license](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.5 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-drizzlekit --path /path/to/fluentci-modules/setup/drizzlekit
```

For a published module, use `fluentci add @fluentci.io/setup-drizzlekit@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

These examples append `setup` and a native Git check to one pipeline.
Replace sample paths and identifiers with your own. Optional arguments use the
callee's defaults, and public list fields use comma-separated strings. See
[COMPONENT.md](./COMPONENT.md) for argument descriptions and return types.

The 0.17.5 composition API is an initial foundation. These examples follow its
generated API; full cross-SDK compilation and execution coverage is still pending.
See [composition support and limitations](../../docs/COMPOSITION.md).



### PureScript

```purescript
module Main where

import Prelude
import Effect (Effect)
import FluentCI.Flow as Flow
import FluentCI.Modules.SetupDrizzlekit as Dependency

run :: Effect String
run =
  Flow.pipeline "ci"
    # Flow.workdir "."
    # Dependency.setup (Dependency.setupArgs)
    # Flow.exec [ "git", "diff", "--exit-code" ]
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_drizzlekit as dependency

pub fn run() -> String {
  flow.pipeline("ci")
  |> flow.workdir(".")
  |> dependency.setup(dependency.setup_args())
  |> flow.exec(["git", "diff", "--exit-code"])
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
  alias FluentCI.Modules.SetupDrizzlekit, as: Dependency

  defplugin run do
    Flow.pipeline("ci")
    |> Flow.workdir(".")
    |> Dependency.setup(%{})
    |> Flow.exec(["git", "diff", "--exit-code"])
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
            [fluentci-modules.setup-drizzlekit :as dependency]))

(defn run []
  (-> (flow/pipeline "ci")
      (flow/workdir ".")
      (dependency/setup {})
      (flow/exec ["git" "diff" "--exit-code"])
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("ci")
  ->Flow.workdir(".")
  ->FluentciModulesSetupDrizzlekit.setup(FluentciModulesSetupDrizzlekit.setupArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_drizzlekit as dependency


def run() -> str:
    prepared = dependency.setup(
        pipeline("ci").workdir("."), {}
    )
    return prepared.exec("git", "diff", "--exit-code").run()
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/setup-drizzlekit/index";

export function run(): string {
  const prepared = dependency.setup(
    flow.workdir(flow.pipeline("ci"), "."), {}
  );
  return flow.run(flow.exec(prepared, ["git", "diff", "--exit-code"]));
}
```

Python and TypeScript use named calls rather than inventing a pipe operator.
Functions return a pipeline carrying their typed result. Use a generated result
callback (`With`/`_with`, or a callback argument in TypeScript/Python) when a later
module needs a preceding result; use Flow's map operation to select a result field.
Execution begins at `run` (or the Elixir plugin terminal), in declared order.

### Exported functions

| Function | Purpose |
| --- | --- |
| `setup` | Install and verify drizzlekit, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
