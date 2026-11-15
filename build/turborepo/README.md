# Turborepo

Execute cached workspace tasks, select affected packages, inspect task plans, and prune workspaces for container builds. PureScript typed Wasm component for FluentCI v0.17.3+.

```sh
fluentci run setup-turborepo setup --version 2.11.11
fluentci run turborepo run-tasks --project . --run-dir /tmp/turbo-build-1 --tasks build,test,lint --filters web...,!docs --concurrency 4 --summarize
fluentci run turborepo affected --project . --run-dir /tmp/turbo-affected-1 --tasks build,test
fluentci run turborepo dry-run --project . --run-dir /tmp/turbo-plan-1 --tasks build,test
fluentci run turborepo prune --project . --run-dir /tmp/turbo-prune-1 --package web --docker --out-dir out
fluentci run turborepo run-tasks --run-dir /tmp/turbo-cache-1 --tasks build --cache local:rw,remote:r
```

Functions: `run`, `version`, `run-tasks`, `affected`, `dry-run`, `prune`, `list-packages`, `info`. See [COMPONENT.md](./COMPONENT.md) for named arguments and typed returns, [OPTIONS.md](./OPTIONS.md) for native flag mappings, and [COMMANDS.md](./COMMANDS.md) for coverage.

The component declares [setup-turborepo](../../setup/turborepo/README.md) as a typed dependency. Missing CLIs are installed automatically; existing CLIs are reused. Run setup first to select an exact version or pass `--executable ./node_modules/.bin/turbo` to use a project-local binary and bypass setup. Published dependencies are composed into the component, so consumers do not need repository-relative paths. See [module dependencies](../../docs/MODULE_DEPENDENCIES.md).

Install workspace dependencies from the project's lockfile before invoking task functions. Setup installs the CLI, not workspace packages, executors, plugins, compilers or task prerequisites. The global CLI can delegate to the workspace-local CLI; pin the workspace dependency as well to control the version that executes tasks. Run from the workspace root with `--project`.

The module is named **turborepo**; the native executable is **turbo**. It reuses the existing **setup-turborepo**, without a separate setup-turbo module. Named flags follow Turbo 2.x and were reviewed against 2.11.11. `run-tasks` requires explicit task names; `affected` adds native `--affected`; `dry-run` prints `--dry=json` output without running tasks. Cache source policies are validated as CSV and emitted as one native `--cache=local:rw,remote:r` argument; filters become repeated `--filter` arguments. Strict environment filtering remains native default unless `--env-mode` overrides it. `--force` bypasses cached results only when explicitly selected. `prune` writes a partial workspace and lockfile; it does not install or build that workspace. `--summarize` creates native summaries under `.turbo/runs`.

For affected detection provide complete Git history for the comparison. Set `TURBO_SCM_BASE` and `TURBO_SCM_HEAD` in the runner environment to override Turbo's default comparison. A shallow checkout can cause all packages to be considered changed. Remote cache credentials belong in `TURBO_TOKEN` and `TURBO_TEAM` or the native configuration.

All public lists are comma-separated strings. Whitespace around entries is trimmed, malformed CSV, empty entries, NUL characters and positional options disguised as task names are rejected before host commands. Blank optional lists preserve native defaults. Use CSV double quotes to preserve commas inside a single raw token or Turbo filter. Native selector parsing still applies to values after CSV decoding. Optional `--arguments` appends literal tokens without shell expansion. To forward flags to underlying scripts include `--` as its own CSV entry, for example `--arguments=--,--runInBand` on task functions; `run --arguments=--help` exposes other upstream commands.

Each invocation requires a fresh `--run-dir`. Failed tasks or native command errors fail the module. Cache hits retain native behavior. Successful calls return typed `outcome`, `run-dir`, `report-path`, `stdout-path` and `stderr-path`; structured native output is read from stdout or requested output files. Use comma-separated `--artifacts NAME=PATH` to collect files, and archive output directories before collecting them. The task environment sets `CI=true`. Credentials stay inherited rather than being copied into command arguments; protect logs and reports containing task output.

[Official CLI reference](https://turborepo.dev/docs/reference/run) · [MIT wrapper license](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.5 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add turborepo --path /path/to/fluentci-modules/build/turborepo
```

For a published module, use `fluentci add @fluentci.io/turborepo@VERSION` with an
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
import FluentCI.Modules.Turborepo as Dependency

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
import fluentci_modules/turborepo as dependency

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
  alias FluentCI.Modules.Turborepo, as: Dependency

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
            [fluentci-modules.turborepo :as dependency]))

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
  ->FluentciModulesTurborepo.version(FluentciModulesTurborepo.versionArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import turborepo as dependency


def run() -> str:
    prepared = dependency.version(
        pipeline("ci").workdir("."), {}
    )
    return prepared.exec("git", "diff", "--exit-code").run()
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/turborepo/index";

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
| `run` | Run arbitrary literal Turbo CLI arguments. |
| `version` | Print the Turbo CLI version. |
| `run_tasks` | Run selected workspace tasks with native dependency ordering and caching. |
| `affected` | Run tasks only in affected packages; requires the Git comparison history. |
| `dry_run` | Print a JSON task plan without executing workspace tasks. |
| `prune` | Generate a partial workspace and pruned lockfile for a package. |
| `list_packages` | Inspect packages, dependencies and tasks without executing tasks. |
| `info` | Print Turbo environment diagnostics. |
<!-- /generated:language-examples -->
