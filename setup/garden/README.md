# Setup Garden

Install and verify the Garden CLI for CI/CD pipelines. Implemented in PureScript as a typed Wasm component.

```sh
fluentci run setup-garden setup --version 0.14.20
fluentci run setup-garden setup --help
```

Default version: **0.14.20**, the reviewed Garden Cedar release. An exact version or `latest` can be selected with `--version`. Official release tags do not have a `v` prefix.

Linux and macOS on x86_64/aarch64 use official `garden-io/garden` release archives. Alpine Linux selects the separate `alpine-amd64` archive; unavailable platform/architecture assets fail clearly. Setup requires a valid SHA-256 digest from GitHub release metadata or the release's adjacent `.sha256` file and verifies the downloaded archive before extraction. The full archive layout is preserved, including supporting files next to `garden`. No Node.js or Bun installation is required.

The per-user prefix defaults to `$HOME/.local/share/fluentci/garden/VERSION`; an absolute `--install-dir` overrides it. The resolved release version is used for `latest`. Existing managed installations are verified and reused. Download, checksum, extraction and version failures do not publish a successful setup; newly created failed installations are cleaned up.

FreeBSD, OpenBSD and NetBSD use native package repositories when `garden-cli` is available; there are no official BSD release archives. Package availability is repository-dependent. For native installations omit `--install-dir`, optionally select `--package-name`, and use `--sudo` for noninteractive elevation if needed. An unavailable package fails explicitly.

Returns typed `tool`, `version`, `bin-dir` and `environment`. PATH applies to subsequent host tasks; separate processes must propagate returned environment variables. See [COMPONENT.md](./COMPONENT.md) for all arguments and return descriptions.

Setup installs the CLI only. The [Garden deployment module](../../deployment/garden/README.md) runs project builds, deployments, tests and cleanup. Configure provider credentials, project environments and any required Docker/Kubernetes infrastructure separately.

[Official installation guide](https://docs.garden.io/guides/installation) · [Official releases](https://github.com/garden-io/garden/releases) · [MIT wrapper license](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-garden --path /path/to/fluentci-modules/setup/garden
```

For a published module, use `fluentci add @fluentci.io/setup-garden@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

These examples append `setup` and a native Git check to one pipeline.
Replace sample paths and identifiers with your own. Optional arguments use the
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
import FluentCI.Modules.SetupGarden as Dependency

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
import fluentci_modules/setup_garden as dependency

pub fn run() -> String {
  flow.pipeline("ci")
  |> flow.workdir(".")
  |> dependency.setup(dependency.setup_args())
  |> flow.exec("git", ["diff", "--exit-code"])
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
  alias FluentCI.Modules.SetupGarden, as: Dependency

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
            [fluentci-modules.setup-garden :as dependency]))

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
  ->FluentciModulesSetupGarden.setup(FluentciModulesSetupGarden.setupArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_garden as dependency


def run() -> str:
    return (
        pipeline("ci")
        .workdir(".")
        .pipe(dependency.setup, {})
        .exec("git", "diff", "--exit-code")
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/setup-garden/index";

export function run(): string {
  return flow.pipeline("ci")
    .workdir(".")
    .pipe(dependency.setup, {})
    .exec(["git", "diff", "--exit-code"])
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
| `setup` | Install and verify garden, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
