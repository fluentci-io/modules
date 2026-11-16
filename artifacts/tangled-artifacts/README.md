# Tangled release artifacts

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.3+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run tangled-artifacts upload --project . --run-dir .fluentci/runs/tangled-artifacts-001 --username publisher.example --tag v1.2.3 --repository https://tangled.org/publisher.example/project --files 'dist/app.zip'
```

```sh
fluentci run tangled-artifacts --help
fluentci run tangled-artifacts upload --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use comma-separated strings; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Install tangled-release-asset-uploader or use setup-tangled-artifacts. This purpose-built uploader is separate from aly.codes/tg. The annotated tag must already be pushed to the repository. username must own that repository; provide its app password through TNGL_UPLOADER_APP_PASSWORD. Passwords are never module inputs or task arguments. Files are checked locally before upload. The uploader prints each created AT URI in task stdout; the execution report preserves it for downstream steps.

The return value is a typed record containing `outcome`, `run-dir`, `report-path`,
`stdout-path`, and `stderr-path`. Each invocation needs a fresh run directory.
Native command failures, cancellation, and timeouts fail the component call.
Use `--artifacts 'package=dist/package.zip'` to declare output files for the
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

This module declares `setup-tangled-artifacts` as typed native component dependencies.
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
fluentci add tangled-artifacts --path /path/to/fluentci-modules/artifacts/tangled-artifacts
```

For a published module, use `fluentci add @fluentci.io/tangled-artifacts@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Upload files as assets attached to an existing annotated Tangled tag.

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
import FluentCI.Modules.TangledArtifacts as TangledArtifacts

run :: Effect String
run =
  Flow.pipeline "tangled-artifacts-upload"
    # Flow.workdir "."
    # TangledArtifacts.upload (TangledArtifacts.uploadArgs { "username": "acme", "tag": "v1.0.0", "repository": "api", "files": "dist/api.tar.gz" })
    # Flow.map (\result -> result.reportPath)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/tangled_artifacts

pub fn run() -> String {
  flow.pipeline("tangled-artifacts-upload")
  |> flow.workdir(".")
  |> tangled_artifacts.upload(tangled_artifacts.upload_args("acme", "v1.0.0", "api", "dist/api.tar.gz"))
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
  alias FluentCI.Modules.TangledArtifacts

  defplugin run do
    Flow.pipeline("tangled-artifacts-upload")
    |> Flow.workdir(".")
    |> TangledArtifacts.upload(%{"username" => "acme", "tag" => "v1.0.0", "repository" => "api", "files" => "dist/api.tar.gz"})
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
            [fluentci-modules.tangled-artifacts :as tangled_artifacts]))

(defn run []
  (-> (flow/pipeline "tangled-artifacts-upload")
      (flow/workdir ".")
      (tangled_artifacts/upload {:username "acme", :tag "v1.0.0", :repository "api", :files "dist/api.tar.gz"})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("tangled-artifacts-upload")
  ->Flow.workdir(".")
  ->FluentciModulesTangledArtifacts.upload(FluentciModulesTangledArtifacts.uploadArgs(~username="acme", ~tag="v1.0.0", ~repository="api", ~files="dist/api.tar.gz"))
  ->Flow.map(result => result.reportPath)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import tangled_artifacts


def run() -> str:
    return (
        pipeline("tangled-artifacts-upload")
        .workdir(".")
        .pipe(tangled_artifacts.upload, {"username": "acme", "tag": "v1.0.0", "repository": "api", "files": "dist/api.tar.gz"})
        .map(lambda result: result.report_path)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as tangled_artifacts from "./fluentci_modules/tangled-artifacts/index";

export function run(): string {
  return flow.pipeline("tangled-artifacts-upload")
    .workdir(".")
    .pipe(tangled_artifacts.upload, {"username":"acme","tag":"v1.0.0","repository":"api","files":"dist/api.tar.gz"})
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
| `upload` | Upload files as assets attached to an existing annotated Tangled tag. |
<!-- /generated:language-examples -->
