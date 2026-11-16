# Codacy

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.3+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run codacy help --project . --run-dir .fluentci/runs/codacy-001
```

```sh
fluentci run codacy --help
fluentci run codacy help --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Install the Codacy Coverage Reporter binary as codacy-coverage-reporter (or override executable). Supply CODACY_PROJECT_TOKEN or CODACY_API_TOKEN through the host environment. This module uploads existing coverage reports; it does not run tests or analyze source code. coverageFile supports the reporter's native glob matching. Uploads contact the configured Codacy service.

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

This module declares `setup-codacy` as typed native component dependencies.
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
fluentci add codacy --path /path/to/fluentci-modules/code-quality/codacy
```

For a published module, use `fluentci add @fluentci.io/codacy@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Upload an existing coverage report to Codacy.

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
import FluentCI.Modules.Codacy as Codacy

run :: Effect String
run =
  Flow.pipeline "codacy-upload"
    # Flow.workdir "."
    # Codacy.upload (Codacy.uploadArgs { "coverageFile": "coverage/lcov.info" })
    # Flow.map (\result -> result.reportPath)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/codacy

pub fn run() -> String {
  flow.pipeline("codacy-upload")
  |> flow.workdir(".")
  |> codacy.upload(codacy.upload_args("coverage/lcov.info"))
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
  alias FluentCI.Modules.Codacy

  defplugin run do
    Flow.pipeline("codacy-upload")
    |> Flow.workdir(".")
    |> Codacy.upload(%{"coverage_file" => "coverage/lcov.info"})
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
            [fluentci-modules.codacy :as codacy]))

(defn run []
  (-> (flow/pipeline "codacy-upload")
      (flow/workdir ".")
      (codacy/upload {:coverageFile "coverage/lcov.info"})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("codacy-upload")
  ->Flow.workdir(".")
  ->FluentciModulesCodacy.upload(FluentciModulesCodacy.uploadArgs(~coverageFile="coverage/lcov.info"))
  ->Flow.map(result => result.reportPath)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import codacy


def run() -> str:
    return (
        pipeline("codacy-upload")
        .workdir(".")
        .pipe(codacy.upload, {"coverage_file": "coverage/lcov.info"})
        .map(lambda result: result.report_path)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as codacy from "./fluentci_modules/codacy/index";

export function run(): string {
  return flow.pipeline("codacy-upload")
    .workdir(".")
    .pipe(codacy.upload, {"coverageFile":"coverage/lcov.info"})
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
| `help` | help |
| `upload` | Upload an existing coverage report to Codacy. |
<!-- /generated:language-examples -->
