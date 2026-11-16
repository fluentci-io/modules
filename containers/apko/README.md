# Apko

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.3+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run apko build --run-dir .fluentci/run-001 --config apko.yaml --tag registry.example.com/team/app:ci --output dist/app.tar
```

```sh
fluentci run apko --help
fluentci run apko build --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Use setup-apko or provide apko on PATH. apko builds images from APK packages using a trusted YAML configuration and its configured repositories; it does not execute Dockerfile RUN instructions. Supply a lockfile and build date for repeatability, and collect generated image/SBOM files as pipeline artifacts. publish uses the native container credential store. Actual platform/build privileges depend on apko and its selected image format; setup only installs the CLI.

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

This module declares `setup-apko` as typed native component dependencies.
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
fluentci add apko --path /path/to/fluentci-modules/containers/apko
```

For a published module, use `fluentci add @fluentci.io/apko@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Build an OCI image and SBOM from an APK package configuration.

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
import FluentCI.Modules.Apko as Apko

run :: Effect String
run =
  Flow.pipeline "apko-build"
    # Flow.workdir "."
    # Apko.build (Apko.buildArgs { "config": "apko.yaml", "tag": "ghcr.io/acme/api:1.0.0", "output": "dist" })
    # Flow.map (\result -> result.reportPath)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/apko

pub fn run() -> String {
  flow.pipeline("apko-build")
  |> flow.workdir(".")
  |> apko.build(apko.build_args("apko.yaml", "ghcr.io/acme/api:1.0.0", "dist"))
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
  alias FluentCI.Modules.Apko

  defplugin run do
    Flow.pipeline("apko-build")
    |> Flow.workdir(".")
    |> Apko.build(%{"config" => "apko.yaml", "tag" => "ghcr.io/acme/api:1.0.0", "output" => "dist"})
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
            [fluentci-modules.apko :as apko]))

(defn run []
  (-> (flow/pipeline "apko-build")
      (flow/workdir ".")
      (apko/build {:config "apko.yaml", :tag "ghcr.io/acme/api:1.0.0", :output "dist"})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("apko-build")
  ->Flow.workdir(".")
  ->FluentciModulesApko.build(FluentciModulesApko.buildArgs(~config="apko.yaml", ~tag="ghcr.io/acme/api:1.0.0", ~output="dist"))
  ->Flow.map(result => result.reportPath)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import apko


def run() -> str:
    return (
        pipeline("apko-build")
        .workdir(".")
        .pipe(apko.build, {"config": "apko.yaml", "tag": "ghcr.io/acme/api:1.0.0", "output": "dist"})
        .map(lambda result: result.report_path)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as apko from "./fluentci_modules/apko/index";

export function run(): string {
  return flow.pipeline("apko-build")
    .workdir(".")
    .pipe(apko.build, {"config":"apko.yaml","tag":"ghcr.io/acme/api:1.0.0","output":"dist"})
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
| `run` | Run a native command with literal arguments. |
| `version` | Print the installed tool version. |
| `build` | Build an OCI image and SBOM from an APK package configuration. |
| `publish` | Build and publish an OCI image using native registry credentials. |
<!-- /generated:language-examples -->
