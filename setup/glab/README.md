# Setup GitLab CLI

Install or reuse a verified GitLab CLI CLI and publish its environment for CI/CD.
Native PureScript Wasm component; requires FluentCI v0.17.3+.

```sh
fluentci run setup-glab setup --version latest
```

Supports Linux, macOS, FreeBSD, OpenBSD and NetBSD. Unsupported OS values fail before installation. Archive installers support
x86_64/aarch64; BSD architecture availability follows the native repositories. A usable installed CLI matching the requested version
is reused. Native package availability and permissions determine installation
success; missing packages and version mismatches remain failures.

Linux/macOS x86_64/aarch64 use official gitlab-org/cli release assets. The exact archive SHA-256 is read from its checksums.txt entry and verified before extraction; the installed version must match. Missing/ambiguous checksums, unavailable assets and insecure URLs fail clearly. An explicit install-dir selects a managed prefix. BSD uses native glab packages, requiring install-dir to be omitted.

Use sudo for noninteractive native package elevation when needed; Homebrew must
run as the normal user. This function installs the CLI without logging in or
changing repository contents. Credentials remain in native environment/configuration.
Returns tool, version, bin-dir and environment entries, publishing PATH for later
tasks in the same host session. See [COMPONENT.md](./COMPONENT.md) for named arguments
and return fields and the [glab operation module](../../version-control/glab/README.md)
for checkout/release/pipeline operations with automatic setup. License: MIT.

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-glab --path /path/to/fluentci-modules/setup/glab
```

For a published module, use `fluentci add @fluentci.io/setup-glab@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision glab before the build steps that require it. The setup result reports the installed version and executable directory.

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
import FluentCI.Modules.SetupGlab as SetupGlab

run :: Effect String
run =
  Flow.pipeline "setup-glab-setup"
    # Flow.workdir "."
    # SetupGlab.setup (SetupGlab.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_glab

pub fn run() -> String {
  flow.pipeline("setup-glab-setup")
  |> flow.workdir(".")
  |> setup_glab.setup(setup_glab.setup_args())
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
  alias FluentCI.Modules.SetupGlab

  defplugin run do
    Flow.pipeline("setup-glab-setup")
    |> Flow.workdir(".")
    |> SetupGlab.setup(%{})
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
            [fluentci-modules.setup-glab :as setup_glab]))

(defn run []
  (-> (flow/pipeline "setup-glab-setup")
      (flow/workdir ".")
      (setup_glab/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-glab-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupGlab.setup(FluentciModulesSetupGlab.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_glab


def run() -> str:
    return (
        pipeline("setup-glab-setup")
        .workdir(".")
        .pipe(setup_glab.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_glab from "./fluentci_modules/setup-glab/index";

export function run(): string {
  return flow.pipeline("setup-glab-setup")
    .workdir(".")
    .pipe(setup_glab.setup, {})
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
| `setup` | Install and verify glab, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
