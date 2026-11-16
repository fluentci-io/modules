# Rust

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.2+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run setup-rust setup --toolchain stable --components rustfmt,clippy --targets wasm32-wasip2,wasm32-unknown-unknown --profile minimal
```

```sh
fluentci run setup-rust --help
fluentci run setup-rust setup --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. List arguments use
comma-separated text; boolean arguments accept switches. Native function/flag
names use kebab-case.

`--toolchain` selects a channel, dated nightly, or exact release. `--version`
remains an alias; both must agree when supplied together. `--components` and
`--targets` accept comma-separated strings installed for that toolchain, with
duplicates removed and whitespace around entries trimmed. Omitted or blank
values add no components or targets. Empty entries between commas, JSON arrays,
and invalid names are rejected before host commands. Profiles are `minimal` (default), `default`, and `complete`. Explicit
rustup options fail on BSD, which uses native packages. Failed installation
never publishes a successful setup result or activates the installed bin directory.

## Requirements and behavior

Installs and verifies `rust`, then returns `tool`, `version`, `bin-dir`, and
`environment` (a list of `{name, value}` records). Environment updates are visible
to later tasks in the same host session. Separate shell invocations must add the
returned installation directory to PATH explicitly.



Linux/macOS use the configured upstream or ecosystem installer. JavaScript tools
are installed through Bun, bootstrapping Node.js/Bun when missing. Python, Go,
Ruby, and Java prerequisites depend on the selected tool. BSD uses native pkg,
pkg_add, or pkgin repositories; missing packages/versions fail clearly. Nix and
Determinate Nix support Linux/macOS only; dpkg/rpmbuild installers are Linux-only.

## Development

From this module directory, with Node.js, Bun, PureScript, and Spago installed:

```sh
bun install --cwd ../../lib/component --frozen-lockfile
npm ci
npm run build
npm test
```

`dist/plugin.wasm` is the native component; `dist/fluentci.metadata.json` is its
checksummed contract sidecar. The CJS bundles and `legacy-entry.mjs` exist only for
private regression tests and are not the published module interface.

See the [component migration guide](../../docs/COMPONENTS.md) and
[MIT License](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-rust --path /path/to/fluentci-modules/setup/rust
```

For a published module, use `fluentci add @fluentci.io/setup-rust@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision rust before the build steps that require it. The setup result reports the installed version and executable directory.

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
import FluentCI.Modules.SetupRust as SetupRust

run :: Effect String
run =
  Flow.pipeline "setup-rust-setup"
    # Flow.workdir "."
    # SetupRust.setup (SetupRust.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_rust

pub fn run() -> String {
  flow.pipeline("setup-rust-setup")
  |> flow.workdir(".")
  |> setup_rust.setup(setup_rust.setup_args())
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
  alias FluentCI.Modules.SetupRust

  defplugin run do
    Flow.pipeline("setup-rust-setup")
    |> Flow.workdir(".")
    |> SetupRust.setup(%{})
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
            [fluentci-modules.setup-rust :as setup_rust]))

(defn run []
  (-> (flow/pipeline "setup-rust-setup")
      (flow/workdir ".")
      (setup_rust/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-rust-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupRust.setup(FluentciModulesSetupRust.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_rust


def run() -> str:
    return (
        pipeline("setup-rust-setup")
        .workdir(".")
        .pipe(setup_rust.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_rust from "./fluentci_modules/setup-rust/index";

export function run(): string {
  return flow.pipeline("setup-rust-setup")
    .workdir(".")
    .pipe(setup_rust.setup, {})
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
| `setup` | Install and verify rust, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
