# Docker Buildx

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.3+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run buildx setup --version latest
fluentci run buildx build --project /path/to/project --run-dir /tmp/buildx-build-001 --context . --file Dockerfile --tag example/app:latest --platform linux/amd64,linux/arm64 --push
```

```sh
fluentci run buildx --help
fluentci run buildx build --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use comma-separated strings; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Every operation checks Docker and Buildx first and installs missing prerequisites
through setup-docker and setup-buildx. Existing usable tools skip installation,
even when a custom Docker executable is selected. Explicit `setup` accepts version,
install-dir, package-name and sudo options for the Buildx plugin. Requested versions
are verified; a mismatching installation is replaced in the managed prefix.
A reachable daemon is required for daemon-backed operations. Returns a typed
execution result containing the report/log paths. All Docker options remain named
and typed; the component CLI reserves `--help` for its own contract documentation.
The Docker `type_` argument is now the native named flag `--type`.

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

This module declares `setup-docker` and `setup-buildx` as typed native component dependencies.
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
fluentci add buildx --path /path/to/fluentci-modules/containers/buildx
```

For a published module, use `fluentci add @fluentci.io/buildx@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

These examples append `setup` and a native Git check to one pipeline.
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
import FluentCI.Modules.Buildx as Dependency

run :: Effect String
run =
  Flow.pipeline "ci"
    # Flow.workdir "."
    # Dependency.setup (Dependency.setupArgs)
    # Flow.exec [ "git", "diff", "--exit-code" ]
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/buildx as dependency

pub fn run() -> String {
  flow.pipeline("ci")
  |> flow.workdir(".")
  |> dependency.setup(dependency.setup_args())
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
  alias FluentCI.Modules.Buildx, as: Dependency

  defplugin run do
    Flow.pipeline("ci")
    |> Flow.workdir(".")
    |> Dependency.setup(%{})
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
            [fluentci-modules.buildx :as dependency]))

(defn run []
  (-> (flow/pipeline "ci")
      (flow/workdir ".")
      (dependency/setup {})
      (flow/exec ["git" "diff" "--exit-code"])
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("ci")
  ->Flow.workdir(".")
  ->FluentciModulesBuildx.setup(FluentciModulesBuildx.setupArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import buildx as dependency


def run() -> str:
    prepared = dependency.setup(
        pipeline("ci").workdir("."), {}
    )
    return prepared.exec("git", "diff", "--exit-code").run()
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/buildx/index";

export function run(): string {
  const prepared = dependency.setup(
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
| `setup` | Ensure buildx is installed and verified, reusing an available matching version, and publish its environment. |
| `buildx` | Run Docker Buildx buildx and return execution report paths. |
| `dap` | Run Docker Buildx dap and return execution report paths. |
| `debug` | Run Docker Buildx debug and return execution report paths. |
| `history` | Run Docker Buildx history and return execution report paths. |
| `imagetools` | Run Docker Buildx imagetools and return execution report paths. |
| `policy` | Run Docker Buildx policy and return execution report paths. |
| `bake` | Run Docker Buildx bake and return execution report paths. |
| `build` | Run Docker Buildx build and return execution report paths. |
| `create` | Run Docker Buildx create and return execution report paths. |
| `dial_stdio` | Run Docker Buildx dial stdio and return execution report paths. |
| `du` | Run Docker Buildx du and return execution report paths. |
| `inspect` | Run Docker Buildx inspect and return execution report paths. |
| `ls` | Run Docker Buildx ls and return execution report paths. |
| `prune` | Run Docker Buildx prune and return execution report paths. |
| `rm` | Run Docker Buildx rm and return execution report paths. |
| `stop` | Run Docker Buildx stop and return execution report paths. |
| `use` | Run Docker Buildx use and return execution report paths. |
| `version` | Run Docker Buildx version and return execution report paths. |
| `dap_build` | Run Docker Buildx dap build and return execution report paths. |
| `debug_build` | Run Docker Buildx debug build and return execution report paths. |
| `history_inspect` | Run Docker Buildx history inspect and return execution report paths. |
| `history_export` | Run Docker Buildx history export and return execution report paths. |
| `history_import` | Run Docker Buildx history import and return execution report paths. |
| `history_logs` | Run Docker Buildx history logs and return execution report paths. |
| `history_ls` | Run Docker Buildx history ls and return execution report paths. |
| `history_open` | Run Docker Buildx history open and return execution report paths. |
| `history_rm` | Run Docker Buildx history rm and return execution report paths. |
| `history_trace` | Run Docker Buildx history trace and return execution report paths. |
| `imagetools_create` | Run Docker Buildx imagetools create and return execution report paths. |
| `imagetools_inspect` | Run Docker Buildx imagetools inspect and return execution report paths. |
| `policy_eval` | Run Docker Buildx policy eval and return execution report paths. |
| `policy_test` | Run Docker Buildx policy test and return execution report paths. |
| `history_inspect_attachment` | Run Docker Buildx history inspect attachment and return execution report paths. |
<!-- /generated:language-examples -->
