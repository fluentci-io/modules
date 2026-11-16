# Setup Wasmer

Install a versioned Wasmer CLI and publish PATH for subsequent CI/CD tasks. Implemented in PureScript as a typed Wasm component.

```sh
fluentci run setup-wasmer setup --version 7.5.0
fluentci run setup-wasmer setup --help
```

Default release: **7.5.0**. `--version` accepts another exact release (with or without `v`) or `latest`. Setup downloads matching official GitHub release archives, verifies SHA-256 when provided by release metadata, preserves adjacent resources, and checks the installed CLI version. Missing platform assets, extraction errors, checksum mismatches and wrong versions fail setup. New failed prefixes are cleaned up and do not publish success.

Linux and macOS support x86_64 and aarch64 when the selected release provides a matching archive. Wasmer 7.5.0 provides Linux amd64/aarch64 and macOS arm64 assets, but no macOS Intel asset. Select a release providing that asset for an Intel Mac; setup never substitutes a binary for a different CPU.

FreeBSD, OpenBSD and NetBSD use native repositories when an appropriate package is available. The default selector is `wasmer`; use `--package-name` for the name used by your repository. Unavailable packages and versions fail explicitly.  Native installs omit `--install-dir` and can use `--sudo` for noninteractive elevation. No official BSD archive is assumed.

Managed prefixes default to `$HOME/.local/share/fluentci/wasmer/VERSION`; an absolute `--install-dir` overrides the prefix. Verified existing installations are reused. Setup installs the standalone CLI, not project language toolchains, cloud credentials, or deployment plugins.

Returns typed `tool`, `version`, `bin-dir` and `environment`. Environment updates apply to subsequent host tasks; separate processes must propagate the returned PATH. See [COMPONENT.md](./COMPONENT.md) for every argument and return description, and [the deployment module](../../deployment/wasmer/README.md) for CI/CD operations.

[Official releases](https://github.com/wasmerio/wasmer/releases) · [MIT wrapper license](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-wasmer --path /path/to/fluentci-modules/setup/wasmer
```

For a published module, use `fluentci add @fluentci.io/setup-wasmer@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision wasmer before the build steps that require it. The setup result reports the installed version and executable directory.

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
import FluentCI.Modules.SetupWasmer as SetupWasmer

run :: Effect String
run =
  Flow.pipeline "setup-wasmer-setup"
    # Flow.workdir "."
    # SetupWasmer.setup (SetupWasmer.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_wasmer

pub fn run() -> String {
  flow.pipeline("setup-wasmer-setup")
  |> flow.workdir(".")
  |> setup_wasmer.setup(setup_wasmer.setup_args())
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
  alias FluentCI.Modules.SetupWasmer

  defplugin run do
    Flow.pipeline("setup-wasmer-setup")
    |> Flow.workdir(".")
    |> SetupWasmer.setup(%{})
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
            [fluentci-modules.setup-wasmer :as setup_wasmer]))

(defn run []
  (-> (flow/pipeline "setup-wasmer-setup")
      (flow/workdir ".")
      (setup_wasmer/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-wasmer-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupWasmer.setup(FluentciModulesSetupWasmer.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_wasmer


def run() -> str:
    return (
        pipeline("setup-wasmer-setup")
        .workdir(".")
        .pipe(setup_wasmer.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_wasmer from "./fluentci_modules/setup-wasmer/index";

export function run(): string {
  return flow.pipeline("setup-wasmer-setup")
    .workdir(".")
    .pipe(setup_wasmer.setup, {})
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
| `setup` | Install and verify wasmer, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
