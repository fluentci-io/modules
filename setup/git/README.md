# Setup Git

Install or reuse a verified Git CLI and publish its environment for CI/CD.
Native PureScript Wasm component; requires FluentCI v0.17.3+.

```sh
fluentci run setup-git setup --version latest
```

Supports Linux, macOS, FreeBSD, OpenBSD and NetBSD. Unsupported OS values fail before installation. Archive installers support
x86_64/aarch64; BSD architecture availability follows the native repositories. A usable installed CLI matching the requested version
is reused. Native package availability and permissions determine installation
success; missing packages and version mismatches remain failures.

Git uses native repositories on every supported OS. Exact versions must be available in the configured repository; package-name can select a versioned package. Omit install-dir. The executable version is verified after installation.

Use sudo for noninteractive native package elevation when needed; Homebrew must
run as the normal user. This function installs the CLI without logging in or
changing repository contents. Credentials remain in native environment/configuration.
Returns tool, version, bin-dir and environment entries, publishing PATH for later
tasks in the same host session. See [COMPONENT.md](./COMPONENT.md) for named arguments
and return fields and the [git operation module](../../version-control/git/README.md)
for checkout/release/pipeline operations with automatic setup. License: MIT.

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.5 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-git --path /path/to/fluentci-modules/setup/git
```

For a published module, use `fluentci add @fluentci.io/setup-git@VERSION` with an
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
import FluentCI.Modules.SetupGit as Dependency

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
import fluentci_modules/setup_git as dependency

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
  alias FluentCI.Modules.SetupGit, as: Dependency

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
            [fluentci-modules.setup-git :as dependency]))

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
  ->FluentciModulesSetupGit.setup(FluentciModulesSetupGit.setupArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_git as dependency


def run() -> str:
    prepared = dependency.setup(
        pipeline("ci").workdir("."), {}
    )
    return prepared.exec("git", "diff", "--exit-code").run()
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/setup-git/index";

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
| `setup` | Install and verify git, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
