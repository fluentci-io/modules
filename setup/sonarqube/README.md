# Setup SonarQube CLI

Install the standalone **`sonar` CLI**, verify its version, and publish PATH for
later CI/CD steps. Native Wasm component written in PureScript; requires FluentCI
v0.17.3+. For `sonar-scanner`, use
[setup-sonarqube-scanner](../sonarqube-scanner/README.md).

```sh
fluentci run setup-sonarqube setup --version latest
fluentci run setup-sonarqube setup --version 1.12.0
fluentci run setup-sonarqube setup --version 1.12.0.17622
fluentci run setup-sonarqube setup --help
```

## Platforms and installation

Supports Linux x86-64/ARM64 and macOS ARM64. BSD, Windows, and native Intel macOS
installations fail explicitly. This follows the vendor's standalone binary
platforms; the installer does not silently substitute SonarScanner or enable Rosetta.

`latest` resolves the vendor's `stable.version` to a concrete CDN release ID.
Three-part versions resolve against the latest 100 GitHub releases; for an older
release, pass its full four-part ID. Exact IDs need no release-discovery request.
Downloads come directly from `binaries.sonarsource.com` over HTTPS, using `.bin`
with the vendor's `.exe` fallback for older Linux/macOS builds. The vendor does
not supply a checksum through this installation contract; no checksum is invented.
The installed banner must match the selected semantic version. A banner omits
its CDN build ID, so verification checks the three-part version.

Installations live under `~/.local/share/fluentci/sonarqube/<release-id>` unless
`installDir` is supplied. Existing installations are verified before reuse;
failed new installations are cleaned up and never publish PATH. Java is not
required to install this standalone CLI. `sudo` and `packageName` are unsupported.
The install requires curl and standard filesystem utilities and does not execute
the vendor's shell installer or change shell profiles.

## Returned environment

Returns `tool`, `version`, `binDir`, and `environment` (name/value records).
Environment changes apply to subsequent tasks in the same host session. Separate
shell sessions must apply the returned PATH themselves. Analysis engines or other
native subcommands may download additional resources when first used.

For CI authentication, set `SONARQUBE_CLI_TOKEN` with `SONARQUBE_CLI_ORG` (Cloud)
or `SONARQUBE_CLI_SERVER` (Server). Setup installs the CLI without logging in.

See [COMPONENT.md](./COMPONENT.md), the
[official CLI](https://www.sonarsource.com/sonarqube/cli/), and [MIT License](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-sonarqube --path /path/to/fluentci-modules/setup/sonarqube
```

For a published module, use `fluentci add @fluentci.io/setup-sonarqube@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision sonarqube before the build steps that require it. The setup result reports the installed version and executable directory.

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
import FluentCI.Modules.SetupSonarqube as SetupSonarqube

run :: Effect String
run =
  Flow.pipeline "setup-sonarqube-setup"
    # Flow.workdir "."
    # SetupSonarqube.setup (SetupSonarqube.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_sonarqube

pub fn run() -> String {
  flow.pipeline("setup-sonarqube-setup")
  |> flow.workdir(".")
  |> setup_sonarqube.setup(setup_sonarqube.setup_args())
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
  alias FluentCI.Modules.SetupSonarqube

  defplugin run do
    Flow.pipeline("setup-sonarqube-setup")
    |> Flow.workdir(".")
    |> SetupSonarqube.setup(%{})
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
            [fluentci-modules.setup-sonarqube :as setup_sonarqube]))

(defn run []
  (-> (flow/pipeline "setup-sonarqube-setup")
      (flow/workdir ".")
      (setup_sonarqube/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-sonarqube-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupSonarqube.setup(FluentciModulesSetupSonarqube.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_sonarqube


def run() -> str:
    return (
        pipeline("setup-sonarqube-setup")
        .workdir(".")
        .pipe(setup_sonarqube.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_sonarqube from "./fluentci_modules/setup-sonarqube/index";

export function run(): string {
  return flow.pipeline("setup-sonarqube-setup")
    .workdir(".")
    .pipe(setup_sonarqube.setup, {})
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
| `setup` | Install and verify sonarqube, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
