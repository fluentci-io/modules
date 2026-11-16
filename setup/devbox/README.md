# Setup Devbox

Install and verify Devbox, then optionally install versioned packages for a
CI/CD pipeline. Implemented as a typed PureScript Wasm component for FluentCI
v0.17.2+.

```sh
fluentci run setup-devbox setup --version latest \
  --packages nodejs@22.14.0,python3@3.12.9 --project .
fluentci run setup-devbox setup --help
```

`version` selects the **Devbox release**. `packages` is an optional comma-separated string of
native package selectors, each carrying its own version. Omitting it or passing
a blank value installs only the manager and preserves the existing behavior.
Whitespace around selectors is trimmed; empty entries between commas are rejected.
Package/version availability depends on the manager’s registry and platform;
missing versions and failed installs fail the setup call.

`packages` accepts Devbox selectors such as `nodejs@22` or
`python3@3.12.9`. Nix must already be installed and available on PATH; use
`setup-nix` first. Setup fails before installing the CLI if Nix is missing and
packages were requested. It never starts an interactive Nix installer.

`project` selects an existing project directory (default `.`). Setup initializes
`devbox.json` if missing, adds the requested packages, and installs the resulting
environment. This updates the project’s manifest and lockfile; existing packages
are retained. Commit `devbox.lock` for reproducibility. The activated executable
PATH is exported for later host tasks. Use `devbox run --config PROJECT -- CMD`
when commands also need the full native environment and hooks.

Package environments support Linux/macOS. CLI-only BSD setup still uses native
repositories when available; supplying `packages` on BSD fails before mutation.

The return type remains `tool`, `version`, `bin-dir`, and `environment` (a list
of `{name, value}` records). `bin-dir` identifies the manager; use the returned
**environment PATH** to include requested package executables. Updates apply to
later tasks in the same host session. Separate processes must propagate the
returned environment. No successful environment is published if installation or
environment discovery fails; already installed files or project updates may remain.

For upstream archive installations, `install-dir` selects an absolute per-user
manager prefix. Native packages use the system prefix; omit `install-dir`, use
`package-name` for a native manager package selector, and `sudo` when needed.
These manager installation options do not change package versions in `packages`.

See [COMPONENT.md](./COMPONENT.md) for every typed argument and return,
[upstream package syntax](https://github.com/jetify-com/devbox/blob/main/internal/boxcli/add.go), and [MIT License](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-devbox --path /path/to/fluentci-modules/setup/devbox
```

For a published module, use `fluentci add @fluentci.io/setup-devbox@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision devbox before the build steps that require it. The setup result reports the installed version and executable directory.

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
import FluentCI.Modules.SetupDevbox as SetupDevbox

run :: Effect String
run =
  Flow.pipeline "setup-devbox-setup"
    # Flow.workdir "."
    # SetupDevbox.setup (SetupDevbox.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_devbox

pub fn run() -> String {
  flow.pipeline("setup-devbox-setup")
  |> flow.workdir(".")
  |> setup_devbox.setup(setup_devbox.setup_args())
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
  alias FluentCI.Modules.SetupDevbox

  defplugin run do
    Flow.pipeline("setup-devbox-setup")
    |> Flow.workdir(".")
    |> SetupDevbox.setup(%{})
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
            [fluentci-modules.setup-devbox :as setup_devbox]))

(defn run []
  (-> (flow/pipeline "setup-devbox-setup")
      (flow/workdir ".")
      (setup_devbox/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-devbox-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupDevbox.setup(FluentciModulesSetupDevbox.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_devbox


def run() -> str:
    return (
        pipeline("setup-devbox-setup")
        .workdir(".")
        .pipe(setup_devbox.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_devbox from "./fluentci_modules/setup-devbox/index";

export function run(): string {
  return flow.pipeline("setup-devbox-setup")
    .workdir(".")
    .pipe(setup_devbox.setup, {})
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
| `setup` | Install and verify devbox, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
