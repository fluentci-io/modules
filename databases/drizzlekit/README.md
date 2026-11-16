# Drizzle Kit

Generate and check SQL migrations, introspect schemas, export DDL, and apply committed migrations. PureScript typed Wasm component for FluentCI v0.17.3+.

```sh
fluentci run drizzlekit generate --project . --run-dir /tmp/drizzle-generate-1 --config drizzle.config.ts
fluentci run drizzlekit check --project . --run-dir /tmp/drizzle-check-1 --config drizzle.config.ts
fluentci run drizzlekit migrate --project . --run-dir /tmp/drizzle-deploy-1 --config drizzle.config.ts
fluentci run drizzlekit run --run-dir /tmp/drizzle-help-1 --arguments generate,--help
```

Functions: `run`, `version`, `generate`, `migrate`, `push`, `pull`, `check`, `up`, `export-sql`, `studio`. All named arguments and typed return values are described in [COMPONENT.md](./COMPONENT.md); native flag mappings are in [OPTIONS.md](./OPTIONS.md).

The component depends on [setup-drizzlekit](../../setup/drizzlekit/README.md). If `drizzle-kit` is missing, it invokes setup automatically and verifies that the executable is available. An existing CLI is reused. To select an exact version, run setup first; to use the project-local CLI, pass `--executable ./node_modules/.bin/drizzle-kit`. Explicit executable overrides skip automatic setup. Publishing composes the dependency; the relative source path is not required on consumers' machines. See [module dependencies](../../docs/MODULE_DEPENDENCIES.md).

Install project dependencies with the project lockfile before running these functions. Setup installs the CLI only, not the project's ORM/client, adapters, drivers or generated code. Run from the project directory using `--project`. A supplied `--config` must exist before setup or database operations start. Omitted config uses native discovery.

The default Kit version is 0.31.11. Use `drizzle.config.ts` for dialect, schema paths, output directories, filters and database credentials. Kit rejects combinations of a config file and conflicting configuration flags; the wrapper passes native errors through. `generate` may ask about renames: review generated migrations before deployment. `check` checks migration collisions, not database drift. `export-sql` writes SQL to the returned stdout log. `studio` is a foreground service bounded by `timeout-ms`.

Credentials such as `DATABASE_URL` belong in the runner environment and project configuration. The wrapper inherits this environment without copying credentials into argument reports. Native CLI output can still contain connection details; protect the execution logs.

No destructive approval is enabled by default. Explicit force/data-loss/reset arguments retain upstream behavior. Each call requires a fresh `--run-dir`; failures propagate as module errors. Successful calls return typed `outcome`, `run-dir`, `report-path`, `stdout-path` and `stderr-path`, rather than claiming to return rows or SQL. Read generated SQL from stdout or a configured output file. Collect outputs using comma-separated `--artifacts NAME=PATH` entries.

Optional `--arguments` appends literal tokens for flags beyond the named contract. Lists use comma-separated strings; whitespace is trimmed and empty entries are rejected. For a token containing a comma, use CSV double quotes inside the argument string. No shell evaluation occurs.

[Official CLI documentation](https://orm.drizzle.team/docs/kit-overview) · [MIT license](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add drizzlekit --path /path/to/fluentci-modules/databases/drizzlekit
```

For a published module, use `fluentci add @fluentci.io/drizzlekit@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Check generated migrations for collisions before merging.

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
import FluentCI.Modules.Drizzlekit as Drizzlekit

run :: Effect String
run =
  Flow.pipeline "drizzlekit-check"
    # Flow.workdir "."
    # Drizzlekit.check (Drizzlekit.checkArgs)
    # Flow.map (\result -> result.reportPath)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/drizzlekit

pub fn run() -> String {
  flow.pipeline("drizzlekit-check")
  |> flow.workdir(".")
  |> drizzlekit.check(drizzlekit.check_args())
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
  alias FluentCI.Modules.Drizzlekit

  defplugin run do
    Flow.pipeline("drizzlekit-check")
    |> Flow.workdir(".")
    |> Drizzlekit.check(%{})
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
            [fluentci-modules.drizzlekit :as drizzlekit]))

(defn run []
  (-> (flow/pipeline "drizzlekit-check")
      (flow/workdir ".")
      (drizzlekit/check {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("drizzlekit-check")
  ->Flow.workdir(".")
  ->FluentciModulesDrizzlekit.check(FluentciModulesDrizzlekit.checkArgs)
  ->Flow.map(result => result.reportPath)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import drizzlekit


def run() -> str:
    return (
        pipeline("drizzlekit-check")
        .workdir(".")
        .pipe(drizzlekit.check, {})
        .map(lambda result: result.report_path)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as drizzlekit from "./fluentci_modules/drizzlekit/index";

export function run(): string {
  return flow.pipeline("drizzlekit-check")
    .workdir(".")
    .pipe(drizzlekit.check, {})
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
| `run` | Execute literal Drizzle Kit arguments for additional upstream features. |
| `version` | Print the Drizzle Kit version. |
| `generate` | Generate SQL migrations; custom creates an empty migration for handwritten SQL. |
| `migrate` | Apply committed SQL migrations using the project database configuration. |
| `push` | Apply schema changes directly; destructive approval is opt-in through force. |
| `pull` | Introspect the configured database into Drizzle schema files. |
| `check` | Check generated migrations for collisions before merging. |
| `up` | Upgrade existing migration snapshots to the installed Kit format. |
| `export_sql` | Print SQL DDL from the configured TypeScript schema. |
| `studio` | Start the long-running Studio server; use a bounded timeout and scoped service lifecycle. |
<!-- /generated:language-examples -->
