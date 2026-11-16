# Setup MacPorts Rust CLI

Install and verify MacPorts Rust CLI, select its version, and publish PATH for CI/CD tasks.
Requires FluentCI v0.17.2+; implemented as a typed PureScript Wasm component.

```sh
fluentci run setup-macports-rs setup --version 0.1.4 --packages git,cmake,ninja --sudo
fluentci run setup-macports-rs setup --help
```

macOS only, Intel (x86_64) and Apple Silicon (aarch64). Other operating systems fail before installation.

The default is `latest`; exact versions may include `v`. Archive installations
use `$HOME/.local/share/fluentci/macports-rs/VERSION` or an absolute `--install-dir`.
Existing installations are verified before reuse. Downloads verify SHA-256 when
provided by the GitHub release API; macports-rs requires a digest or published checksum sidecar.
Version mismatches and unavailable release assets fail the operation.

Uses [tsirysndr/macports-rs](https://github.com/tsirysndr/macports-rs), a standalone Rust implementation of the MacPorts CLI. Installs `port` and a `portindex` alias without installing native MacPorts or a Tcl runtime. The selected `port` depends on PATH order if native MacPorts is also present. Package installation is optional; build prerequisites depend on the requested ports.

`packages` accepts comma-separated port names such as `git,cmake,ninja,python312`.
Whitespace around names is trimmed. Omitting it or passing a blank value installs
only the CLI. Empty entries and invalid names fail before host commands. Package
versions come from the configured ports tree; arbitrary historical version
selection is not provided by this argument.

After verifying the CLI, setup invokes **its own** `port -N install` with those
names, even if native MacPorts is on PATH. `--sudo` elevates only the package
install with `sudo -n`; the Rust CLI archive always installs as the normal user.
Without `--sudo`, port installation uses the current user's permissions. Omit
`--sudo` for CLI-only setup. Native `--package-name` selectors are not accepted.

Package setup exposes the default package prefix's `/opt/local/bin` and
`/opt/local/sbin` on PATH, while keeping the selected Rust CLI first. The CLI's
`--install-dir` changes where `port` is installed, independently of the package
prefix. Custom prefixes selected through native configuration are not discovered
automatically. Xcode Command Line Tools, configured sources, and suitable
permissions remain prerequisites. A failed install fails setup without publishing
its environment; previously installed files may remain.

Returns `tool`, `version`, `bin-dir`, and `environment`. Environment changes apply
to the host session; separate processes must propagate the returned environment.
See [COMPONENT.md](./COMPONENT.md) for every named argument and return type.

[Upstream releases](https://github.com/tsirysndr/macports-rs/releases) · [MIT License](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-macports-rs --path /path/to/fluentci-modules/setup/macports-rs
```

For a published module, use `fluentci add @fluentci.io/setup-macports-rs@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision macports-rs before the build steps that require it. The setup result reports the installed version and executable directory.

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
import FluentCI.Modules.SetupMacportsRs as SetupMacportsRs

run :: Effect String
run =
  Flow.pipeline "setup-macports-rs-setup"
    # Flow.workdir "."
    # SetupMacportsRs.setup (SetupMacportsRs.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_macports_rs

pub fn run() -> String {
  flow.pipeline("setup-macports-rs-setup")
  |> flow.workdir(".")
  |> setup_macports_rs.setup(setup_macports_rs.setup_args())
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
  alias FluentCI.Modules.SetupMacportsRs

  defplugin run do
    Flow.pipeline("setup-macports-rs-setup")
    |> Flow.workdir(".")
    |> SetupMacportsRs.setup(%{})
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
            [fluentci-modules.setup-macports-rs :as setup_macports_rs]))

(defn run []
  (-> (flow/pipeline "setup-macports-rs-setup")
      (flow/workdir ".")
      (setup_macports_rs/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-macports-rs-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupMacportsRs.setup(FluentciModulesSetupMacportsRs.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_macports_rs


def run() -> str:
    return (
        pipeline("setup-macports-rs-setup")
        .workdir(".")
        .pipe(setup_macports_rs.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_macports_rs from "./fluentci_modules/setup-macports-rs/index";

export function run(): string {
  return flow.pipeline("setup-macports-rs-setup")
    .workdir(".")
    .pipe(setup_macports_rs.setup, {})
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
| `setup` | Install and verify macports-rs, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
