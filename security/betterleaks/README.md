# Betterleaks

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.3+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run betterleaks scan-dir --project . --run-dir .fluentci/runs/betterleaks-001
```

```sh
fluentci run betterleaks --help
fluentci run betterleaks scan-dir --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Install Betterleaks 1.10.x; the named commands target its stable v1 CLI, not the incompatible v2 development CLI. Homebrew's versioned cask uses betterleaks-v1, which can be selected with executable. Named scans force redaction, a nonzero findings exit code, and validation=false, so detected credentials are not checked against provider APIs. Automatic loading of target-local configs is disabled; provide an explicit config when needed. Use run.arguments for other native operations, and protect run reports.

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

This module declares `setup-betterleaks` as typed native component dependencies.
FluentCI v0.17.3+ resolves their source references while building and composes
them into the published Wasm. Consumers need no relative source paths.
Available tools are reused; missing prerequisites invoke setup with default
arguments. Explicit executable overrides remain caller-managed. Configure pinned
versions or privileged/custom installations in an earlier setup step.
See [dependency behavior and publishing](../../docs/MODULE_DEPENDENCIES.md) for
command-specific prerequisites, validation, credential skips, and CI coverage.

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.5 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add betterleaks --path /path/to/fluentci-modules/security/betterleaks
```

For a published module, use `fluentci add @fluentci.io/betterleaks@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

These examples append `version` and a native Git check to one pipeline.
Replace sample paths and identifiers with your own. Optional arguments use the
callee's defaults, and public list fields use comma-separated strings. See
[COMPONENT.md](./COMPONENT.md) for argument descriptions and return types.

The 0.17.5 composition API is an initial foundation. These examples follow its
generated API; full cross-SDK compilation and execution coverage is still pending.
See [composition support and limitations](../../docs/COMPOSITION.md).



### PureScript

```purescript
module Main where

import Prelude
import Effect (Effect)
import FluentCI.Flow as Flow
import FluentCI.Modules.Betterleaks as Dependency

run :: Effect String
run =
  Flow.pipeline "ci"
    # Flow.workdir "."
    # Dependency.version (Dependency.versionArgs)
    # Flow.exec [ "git", "diff", "--exit-code" ]
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/betterleaks as dependency

pub fn run() -> String {
  flow.pipeline("ci")
  |> flow.workdir(".")
  |> dependency.version(dependency.version_args())
  |> flow.exec(["git", "diff", "--exit-code"])
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
  alias FluentCI.Modules.Betterleaks, as: Dependency

  defplugin run do
    Flow.pipeline("ci")
    |> Flow.workdir(".")
    |> Dependency.version(%{})
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
            [fluentci-modules.betterleaks :as dependency]))

(defn run []
  (-> (flow/pipeline "ci")
      (flow/workdir ".")
      (dependency/version {})
      (flow/exec ["git" "diff" "--exit-code"])
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("ci")
  ->Flow.workdir(".")
  ->FluentciModulesBetterleaks.version(FluentciModulesBetterleaks.versionArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import betterleaks as dependency


def run() -> str:
    prepared = dependency.version(
        pipeline("ci").workdir("."), {}
    )
    return prepared.exec("git", "diff", "--exit-code").run()
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/betterleaks/index";

export function run(): string {
  const prepared = dependency.version(
    flow.workdir(flow.pipeline("ci"), "."), {}
  );
  return flow.run(flow.exec(prepared, ["git", "diff", "--exit-code"]));
}
```

Python and TypeScript use named calls rather than inventing a pipe operator.
Functions return a pipeline carrying their typed result. Use a generated result
callback (`With`/`_with`, or a callback argument in TypeScript/Python) when a later
module needs a preceding result; use Flow's map operation to select a result field.
Execution begins at `run` (or the Elixir plugin terminal), in declared order.

### Exported functions

| Function | Purpose |
| --- | --- |
| `run` | Execute arbitrary literal CLI arguments. |
| `version` | Print the CLI version. |
| `scan_dir` | Scan files using Betterleaks 1.x with redaction and credential validation disabled. |
| `scan_git` | Scan Git history with Betterleaks 1.x, failing on detected secrets. |
<!-- /generated:language-examples -->
