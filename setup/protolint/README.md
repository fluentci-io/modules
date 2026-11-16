# Setup Protolint

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.2+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run setup-protolint setup --version latest
```

```sh
fluentci run setup-protolint --help
fluentci run setup-protolint setup --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Installs and verifies `protolint`, then returns `tool`, `version`, `bin-dir`, and
`environment` (a list of `{name, value}` records). Environment updates are visible
to later tasks in the same host session. Separate shell invocations must add the
returned installation directory to PATH explicitly.

Installs the official versioned CLI release for the current host OS and CPU.

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
fluentci add setup-protolint --path /path/to/fluentci-modules/setup/protolint
```

For a published module, use `fluentci add @fluentci.io/setup-protolint@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision protolint before the build steps that require it. The setup result reports the installed version and executable directory.

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
import FluentCI.Modules.SetupProtolint as SetupProtolint

run :: Effect String
run =
  Flow.pipeline "setup-protolint-setup"
    # Flow.workdir "."
    # SetupProtolint.setup (SetupProtolint.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_protolint

pub fn run() -> String {
  flow.pipeline("setup-protolint-setup")
  |> flow.workdir(".")
  |> setup_protolint.setup(setup_protolint.setup_args())
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
  alias FluentCI.Modules.SetupProtolint

  defplugin run do
    Flow.pipeline("setup-protolint-setup")
    |> Flow.workdir(".")
    |> SetupProtolint.setup(%{})
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
            [fluentci-modules.setup-protolint :as setup_protolint]))

(defn run []
  (-> (flow/pipeline "setup-protolint-setup")
      (flow/workdir ".")
      (setup_protolint/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-protolint-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupProtolint.setup(FluentciModulesSetupProtolint.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_protolint


def run() -> str:
    return (
        pipeline("setup-protolint-setup")
        .workdir(".")
        .pipe(setup_protolint.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_protolint from "./fluentci_modules/setup-protolint/index";

export function run(): string {
  return flow.pipeline("setup-protolint-setup")
    .workdir(".")
    .pipe(setup_protolint.setup, {})
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
| `setup` | Install and verify protolint, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
