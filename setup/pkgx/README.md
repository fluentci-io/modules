# Setup pkgx

Install and verify pkgx, then optionally install versioned packages for a
CI/CD pipeline. Implemented as a typed PureScript Wasm component for FluentCI
v0.17.2+.

```sh
fluentci run setup-pkgx setup --version latest \
  --packages nodejs.org@22.14.0,python.org=3.12.9
fluentci run setup-pkgx setup --help
```

`version` selects the **pkgx release**. `packages` is an optional comma-separated string of
native package selectors, each carrying its own version. Omitting it or passing
a blank value installs only the manager and preserves the existing behavior.
Whitespace around selectors is trimmed; empty entries between commas are rejected.
Package/version availability depends on the manager’s registry and platform;
missing versions and failed installs fail the setup call.

Use fully qualified pkgx names where possible: `nodejs.org@22` selects the
22.x family; `python.org=3.12.9` requests an exact release. Selectors must not
include the leading `+`; the module adds it when invoking pkgx. Packages and
their dependencies are downloaded to pkgx’s store. Their executable, library,
and package-specific runtime variables are exported for subsequent host tasks.
The module uses pkgx’s JSON metadata and native execution environment; it does
not modify shell startup files or install packages into a system prefix.

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
[upstream package syntax](https://docs.pkgx.sh/pkgx/pkgx), and [MIT License](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-pkgx --path /path/to/fluentci-modules/setup/pkgx
```

For a published module, use `fluentci add @fluentci.io/setup-pkgx@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision pkgx before the build steps that require it. The setup result reports the installed version and executable directory.

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
import FluentCI.Modules.SetupPkgx as SetupPkgx

run :: Effect String
run =
  Flow.pipeline "setup-pkgx-setup"
    # Flow.workdir "."
    # SetupPkgx.setup (SetupPkgx.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_pkgx

pub fn run() -> String {
  flow.pipeline("setup-pkgx-setup")
  |> flow.workdir(".")
  |> setup_pkgx.setup(setup_pkgx.setup_args())
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
  alias FluentCI.Modules.SetupPkgx

  defplugin run do
    Flow.pipeline("setup-pkgx-setup")
    |> Flow.workdir(".")
    |> SetupPkgx.setup(%{})
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
            [fluentci-modules.setup-pkgx :as setup_pkgx]))

(defn run []
  (-> (flow/pipeline "setup-pkgx-setup")
      (flow/workdir ".")
      (setup_pkgx/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-pkgx-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupPkgx.setup(FluentciModulesSetupPkgx.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_pkgx


def run() -> str:
    return (
        pipeline("setup-pkgx-setup")
        .workdir(".")
        .pipe(setup_pkgx.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_pkgx from "./fluentci_modules/setup-pkgx/index";

export function run(): string {
  return flow.pipeline("setup-pkgx-setup")
    .workdir(".")
    .pipe(setup_pkgx.setup, {})
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
| `setup` | Install and verify pkgx, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
