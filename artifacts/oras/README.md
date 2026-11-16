# ORAS

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.3+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run oras push --project . --run-dir .fluentci/runs/oras-001 --reference registry.example/project/artifact:v1 --files '["dist/app.zip:application/zip"]'
```

```sh
fluentci run oras --help
fluentci run oras push --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Install ORAS or use setup-oras. Authenticate with the native registry credential store before invocation. files use ORAS path:mediaType notation. References may use immutable digests for reproducible downstream downloads. OCI registries must support the selected artifact/referrer features.

The return value is a typed record containing `outcome`, `run-dir`, `report-path`,
`stdout-path`, and `stderr-path`. Each invocation needs a fresh run directory.
Native command failures, cancellation, and timeouts fail the component call.
Use `--artifacts '["package=dist/package.zip"]'` to declare output files for the
execution report. Authentication stays in native configuration or host environment.

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

## Setup component dependency

This module declares `setup-oras` as typed native component dependencies.
FluentCI v0.17.3+ resolves their source references while building and composes
them into the published Wasm. Consumers need no relative source paths.
Available tools are reused; missing prerequisites invoke setup with default
arguments. Explicit executable overrides remain caller-managed. Configure pinned
versions or privileged/custom installations in an earlier setup step.
See [dependency behavior and publishing](../../docs/MODULE_DEPENDENCIES.md) for
command-specific prerequisites, validation, credential skips, and CI coverage.

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add oras --path /path/to/fluentci-modules/artifacts/oras
```

For a published module, use `fluentci add @fluentci.io/oras@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Discover attestations and other OCI artifacts attached to the released api image.

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
import FluentCI.Modules.Oras as Oras

run :: Effect String
run =
  Flow.pipeline "oras-discover"
    # Flow.workdir "."
    # Oras.discover (Oras.discoverArgs { "reference": "ghcr.io/acme/api:1.0.0" })
    # Flow.map (\result -> result.reportPath)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/oras

pub fn run() -> String {
  flow.pipeline("oras-discover")
  |> flow.workdir(".")
  |> oras.discover(oras.discover_args("ghcr.io/acme/api:1.0.0"))
  |> flow.map(fn(result) { result.report_path })
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
  alias FluentCI.Modules.Oras

  defplugin run do
    Flow.pipeline("oras-discover")
    |> Flow.workdir(".")
    |> Oras.discover(%{"reference" => "ghcr.io/acme/api:1.0.0"})
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
            [fluentci-modules.oras :as oras]))

(defn run []
  (-> (flow/pipeline "oras-discover")
      (flow/workdir ".")
      (oras/discover {:reference "ghcr.io/acme/api:1.0.0"})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("oras-discover")
  ->Flow.workdir(".")
  ->FluentciModulesOras.discover(FluentciModulesOras.discoverArgs(~reference="ghcr.io/acme/api:1.0.0"))
  ->Flow.map(result => result.reportPath)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import oras


def run() -> str:
    return (
        pipeline("oras-discover")
        .workdir(".")
        .pipe(oras.discover, {"reference": "ghcr.io/acme/api:1.0.0"})
        .map(lambda result: result.report_path)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as oras from "./fluentci_modules/oras/index";

export function run(): string {
  return flow.pipeline("oras-discover")
    .workdir(".")
    .pipe(oras.discover, {"reference":"ghcr.io/acme/api:1.0.0"})
    .map(result => result.reportPath)
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
| `run` | Execute arbitrary literal CLI arguments. |
| `version` | Print the CLI version. |
| `push` | Publish typed artifacts to an OCI registry. |
| `pull` | pull |
| `copy` | copy |
| `discover` | discover |
<!-- /generated:language-examples -->
