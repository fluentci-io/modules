# Setup Cosign

Install and verify Cosign, select its version, and publish PATH for CI/CD tasks.
Requires FluentCI v0.17.2+; implemented as a typed PureScript Wasm component.

```sh
fluentci run setup-cosign setup --version 3.1.4
fluentci run setup-cosign setup --help
```

Official Sigstore binaries for Linux/macOS on x86_64 and aarch64. FreeBSD, NetBSD, and OpenBSD use native repositories when a matching package is available.

The default is `latest`; exact versions may include `v`. Archive installations
use `$HOME/.local/share/fluentci/cosign/VERSION` or an absolute `--install-dir`.
Existing installations are verified before reuse. Downloads verify SHA-256 when
provided by the GitHub release API.
Version mismatches and unavailable release assets fail the operation.

The CLI does not generate keys or sign artifacts during setup. Supply registry credentials, signing keys, or ambient CI OIDC permissions for subsequent operations. See [the signing module](../../security/cosign/README.md).

Native BSD installations use the system prefix. Omit `--install-dir`; use
`--package-name` for an available native package selector and `--sudo` when
noninteractive privilege elevation is needed. Repository availability determines
which versions can be installed; unavailable packages fail clearly.


Returns `tool`, `version`, `bin-dir`, and `environment`. Environment changes apply
to the host session; separate processes must propagate the returned environment.
See [COMPONENT.md](./COMPONENT.md) for every named argument and return type.

[Upstream releases](https://github.com/sigstore/cosign/releases) · [MIT License](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-cosign --path /path/to/fluentci-modules/setup/cosign
```

For a published module, use `fluentci add @fluentci.io/setup-cosign@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision cosign before the build steps that require it. The setup result reports the installed version and executable directory.

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
import FluentCI.Modules.SetupCosign as SetupCosign

run :: Effect String
run =
  Flow.pipeline "setup-cosign-setup"
    # Flow.workdir "."
    # SetupCosign.setup (SetupCosign.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_cosign

pub fn run() -> String {
  flow.pipeline("setup-cosign-setup")
  |> flow.workdir(".")
  |> setup_cosign.setup(setup_cosign.setup_args())
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
  alias FluentCI.Modules.SetupCosign

  defplugin run do
    Flow.pipeline("setup-cosign-setup")
    |> Flow.workdir(".")
    |> SetupCosign.setup(%{})
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
            [fluentci-modules.setup-cosign :as setup_cosign]))

(defn run []
  (-> (flow/pipeline "setup-cosign-setup")
      (flow/workdir ".")
      (setup_cosign/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-cosign-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupCosign.setup(FluentciModulesSetupCosign.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_cosign


def run() -> str:
    return (
        pipeline("setup-cosign-setup")
        .workdir(".")
        .pipe(setup_cosign.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_cosign from "./fluentci_modules/setup-cosign/index";

export function run(): string {
  return flow.pipeline("setup-cosign-setup")
    .workdir(".")
    .pipe(setup_cosign.setup, {})
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
| `setup` | Install and verify cosign, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
