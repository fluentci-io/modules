# Setup PlanetScale

Install and verify the PlanetScale CLI and publish PATH for CI/CD pipelines.
Implemented in PureScript as a typed Wasm component for FluentCI v0.17.2+.

```sh
fluentci run setup-planetscale setup --version 0.350.0
fluentci run setup-planetscale setup --help
```

Official PlanetScale release archives for Linux and macOS, on x86_64 or aarch64.

Installs the `pscale` executable from versioned `planetscale/cli` releases. A release API SHA-256 digest is verified when provided, then `pscale version` verifies the selected CLI release.

The default is `latest`; exact releases may include `v`. Per-user installations
use `$HOME/.local/share/fluentci/planetscale/VERSION` or an absolute `--install-dir`.
Existing installations are verified before reuse. Version mismatches, checksum
failures, and missing platform assets fail setup. No authentication, database
creation, or database server installation occurs during setup.

FreeBSD, NetBSD, and OpenBSD attempt the native `pscale` package when available;
upstream provides no BSD binary. Repository availability determines whether this
works. Native packages use their system prefix; omit `--install-dir`, optionally
select an available package using `--package-name`, and use `--sudo` for
noninteractive elevation when needed. Unavailable packages fail clearly.

Returns `tool`, `version`, `bin-dir`, and `environment`. Environment changes apply
to subsequent host tasks; separate processes must propagate the returned
variables. See [COMPONENT.md](./COMPONENT.md) for all typed arguments and returns.

Use [the database module](../../databases/planetscale/README.md) for pipeline operations.
SQL clients required by native shell/connect commands remain runner prerequisites.

[Upstream CLI](https://github.com/planetscale/cli) · [MIT wrapper license](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-planetscale --path /path/to/fluentci-modules/setup/planetscale
```

For a published module, use `fluentci add @fluentci.io/setup-planetscale@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision planetscale before the build steps that require it. The setup result reports the installed version and executable directory.

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
import FluentCI.Modules.SetupPlanetscale as SetupPlanetscale

run :: Effect String
run =
  Flow.pipeline "setup-planetscale-setup"
    # Flow.workdir "."
    # SetupPlanetscale.setup (SetupPlanetscale.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_planetscale

pub fn run() -> String {
  flow.pipeline("setup-planetscale-setup")
  |> flow.workdir(".")
  |> setup_planetscale.setup(setup_planetscale.setup_args())
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
  alias FluentCI.Modules.SetupPlanetscale

  defplugin run do
    Flow.pipeline("setup-planetscale-setup")
    |> Flow.workdir(".")
    |> SetupPlanetscale.setup(%{})
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
            [fluentci-modules.setup-planetscale :as setup_planetscale]))

(defn run []
  (-> (flow/pipeline "setup-planetscale-setup")
      (flow/workdir ".")
      (setup_planetscale/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-planetscale-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupPlanetscale.setup(FluentciModulesSetupPlanetscale.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_planetscale


def run() -> str:
    return (
        pipeline("setup-planetscale-setup")
        .workdir(".")
        .pipe(setup_planetscale.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_planetscale from "./fluentci_modules/setup-planetscale/index";

export function run(): string {
  return flow.pipeline("setup-planetscale-setup")
    .workdir(".")
    .pipe(setup_planetscale.setup, {})
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
| `setup` | Install and verify planetscale, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
