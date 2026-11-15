# Garden

Build, deploy and test Garden projects in CI/CD using a PureScript typed Wasm component for FluentCI v0.17.3+.

```sh
fluentci run setup-garden setup --version 0.14.20
fluentci run garden build --project . --run-dir /tmp/garden-build-1 --environment pr-123.ci --names api,worker
fluentci run garden deploy --project . --run-dir /tmp/garden-deploy-1 --environment pr-123.ci --variables imageTag=abc123 --disable-port-forwards
fluentci run garden test --project . --run-dir /tmp/garden-tests-1 --environment pr-123.ci --names '*integration*' --force
fluentci run garden workflow --project . --run-dir /tmp/garden-workflow-1 --environment ci --name release
fluentci run garden status --project . --run-dir /tmp/garden-status-1 --environment pr-123.ci --output json
fluentci run garden cleanup-deploy --project . --run-dir /tmp/garden-cleanup-1 --environment pr-123.ci --names api,worker
```

Functions cover `build`, `deploy`, `test`, `run-actions`, `workflow`, `status`, `outputs`, `graph`, `config`, `publish`, `logs`, `cleanup-deploy`, `cleanup-namespace`, `version`, and `run`. The named contract targets Garden Cedar 0.14. Use `run --arguments get,actions,--output=json` or a named function's optional `--arguments` for additional native features. See [COMPONENT.md](./COMPONENT.md) for argument descriptions and typed returns, and [OPTIONS.md](./OPTIONS.md) for native flag mappings.

All public list arguments accept comma-separated strings. `--names api,worker` becomes two literal positional tokens; wildcards are passed to Garden without shell expansion. `--skip api,worker` and `--modules backend,frontend` repeat the native option. Variable overrides use `--variables imageTag=abc123,replicas=2`; entries must be KEY=VALUE, with alphanumeric, underscore, dash or dot keys. Optional blank lists preserve Garden's default selection. Empty entries between commas, malformed CSV, NUL characters, malformed assignments and positional option injection are rejected before host commands. CSV double quotes can enclose entries containing commas, but Garden's own list parsing still applies; use project configuration for complex structured values.

The module declares [setup-garden](../../setup/garden/README.md) as a typed dependency. It installs a missing CLI automatically, preserving an existing CLI. Set an explicit `--executable` to use a custom installation and bypass setup, or run setup first to pin the version. Published components compose the dependency; consumers do not need the repository's relative paths. See [module dependencies](../../docs/MODULE_DEPENDENCIES.md).

Run from a checkout containing a Garden project with its environments and providers configured. The CLI installation does not provision a Kubernetes cluster, Docker daemon, registry credentials or provider infrastructure. Supply the prerequisites required by the project's providers. Set `GARDEN_AUTH_TOKEN` for Garden Cloud-connected projects and use native credential files/environment variables for Kubernetes and cloud providers; tokens are not module arguments. Explicit variable arguments appear in execution reports, so keep secrets in environment-backed project configuration. Native logs and resolved outputs may contain sensitive data.

Environment selection uses Garden's `NAMESPACE.ENVIRONMENT` syntax. `--yes` is opt-in and approves protected production operations. `--force` and `--force-build` are also opt-in. Tests reuse Garden's cache unless forced. Cleanup without names targets all eligible deployments; namespace cleanup affects the whole selected project environment. `--skip-dependencies` assumes dependencies are already prepared. Logs do not follow unless requested; bound long-running operations with `--timeout-ms` and use a scoped service lifecycle when needed.

Each invocation requires a fresh `--run-dir`. Native failures, including failed builds and tests, fail the module call. A successful call returns typed `outcome`, `run-dir`, `report-path`, `stdout-path` and `stderr-path`. `--output json` writes Garden's structured result into the returned stdout file; it does not change the module's return type. Collect generated outputs with comma-separated `--artifacts NAME=PATH` declarations.

[Official CLI reference](https://docs.garden.io/reference/commands) · [MIT wrapper license](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add garden --path /path/to/fluentci-modules/deployment/garden
```

For a published module, use `fluentci add @fluentci.io/garden@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

These examples append `build` and a native Git check to one pipeline.
Replace sample paths and identifiers with your own. Optional arguments use the
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
import FluentCI.Modules.Garden as Dependency

run :: Effect String
run =
  Flow.pipeline "ci"
    # Flow.workdir "."
    # Dependency.build (Dependency.buildArgs)
    # Flow.exec [ "git", "diff", "--exit-code" ]
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/garden as dependency

pub fn run() -> String {
  flow.pipeline("ci")
  |> flow.workdir(".")
  |> dependency.build(dependency.build_args())
  |> flow.exec("git", ["diff", "--exit-code"])
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
  alias FluentCI.Modules.Garden, as: Dependency

  defplugin run do
    Flow.pipeline("ci")
    |> Flow.workdir(".")
    |> Dependency.build(%{})
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
            [fluentci-modules.garden :as dependency]))

(defn run []
  (-> (flow/pipeline "ci")
      (flow/workdir ".")
      (dependency/build {})
      (flow/exec ["git" "diff" "--exit-code"])
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("ci")
  ->Flow.workdir(".")
  ->FluentciModulesGarden.build(FluentciModulesGarden.buildArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import garden as dependency


def run() -> str:
    return (
        pipeline("ci")
        .workdir(".")
        .pipe(dependency.build, {})
        .exec("git", "diff", "--exit-code")
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/garden/index";

export function run(): string {
  return flow.pipeline("ci")
    .workdir(".")
    .pipe(dependency.build, {})
    .exec(["git", "diff", "--exit-code"])
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
| `run` | Execute arbitrary Garden commands with literal CSV arguments. |
| `version` | Print the installed Garden version. |
| `build` | Build selected actions and their build dependencies. |
| `deploy` | Deploy selected actions using the Garden dependency graph. |
| `test` | Run selected Test actions, including required build and runtime dependencies. |
| `run_actions` | Execute named Run actions and dependencies for migrations, seed jobs or integration tasks. |
| `workflow` | Execute a project-defined workflow in the selected environment. |
| `status` | Inspect provider and action status for the selected environment. |
| `outputs` | Resolve project outputs, including configured runtime output references. |
| `graph` | Inspect the project dependency graph. |
| `config` | Inspect resolved project configuration. |
| `publish` | Build and publish selected artifacts to configured registries. |
| `logs` | Collect deployment logs without following by default. |
| `cleanup_deploy` | Remove selected deployments; omitted names targets all eligible deployments in this project environment. |
| `cleanup_namespace` | Clean the project environment namespace; explicitly select the intended environment. |
<!-- /generated:language-examples -->
