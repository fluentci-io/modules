# Prisma

Validate schemas, generate clients, inspect migration state, and deploy committed Prisma ORM migrations. PureScript typed Wasm component for FluentCI v0.17.3+.

```sh
fluentci run prisma validate --project . --run-dir /tmp/prisma-validate-1 --config prisma.config.ts
fluentci run prisma generate --project . --run-dir /tmp/prisma-generate-1 --generators client,reporting
fluentci run prisma migrate-deploy --project . --run-dir /tmp/prisma-deploy-1 --config prisma.config.ts
fluentci run prisma run --run-dir /tmp/prisma-help-1 --arguments migrate,deploy,--help
```

Functions: `run`, `version`, `init`, `generate`, `validate`, `format`, `db-pull`, `db-push`, `db-seed`, `db-execute`, `migrate-deploy`, `migrate-status`, `migrate-dev`, `migrate-reset`, `migrate-resolve`, `migrate-diff`, `debug`, `studio`. All named arguments and typed return values are described in [COMPONENT.md](./COMPONENT.md); native flag mappings are in [OPTIONS.md](./OPTIONS.md).

The component depends on [setup-prisma](../../setup/prisma/README.md). If `prisma` is missing, it invokes setup automatically and verifies that the executable is available. An existing CLI is reused. To select an exact version, run setup first; to use the project-local CLI, pass `--executable ./node_modules/.bin/prisma`. Explicit executable overrides skip automatic setup. Publishing composes the dependency; the relative source path is not required on consumers' machines. See [module dependencies](../../docs/MODULE_DEPENDENCIES.md).

Install project dependencies with the project lockfile before running these functions. Setup installs the CLI only, not the project's ORM/client, adapters, drivers or generated code. Run from the project directory using `--project`. A supplied `--config` must exist before setup or database operations start. Omitted config uses native discovery.

Named functions target Prisma ORM **7.x**, with setup default **7.8.0**. The npm `latest` tag currently points to a v8 release candidate with a different command surface. Pin compatible versions of Prisma CLI and your project client. Use `prisma.config.ts` for datasource and migrations configuration; Prisma 7 requires explicit environment loading in this config (for example `import "dotenv/config"`). `migrate-diff` delegates source exclusivity checks to Prisma. With `--exit-code`, drift exits 2 and fails the module call. `migrate-dev` and `migrate-reset` are for disposable development databases. Production jobs should use `migrate-deploy`. `studio` is a foreground service bounded by `timeout-ms`.

Credentials such as `DATABASE_URL` belong in the runner environment and project configuration. The wrapper inherits this environment without copying credentials into argument reports. Native CLI output can still contain connection details; protect the execution logs.

No destructive approval is enabled by default. Explicit force/data-loss/reset arguments retain upstream behavior. Each call requires a fresh `--run-dir`; failures propagate as module errors. Successful calls return typed `outcome`, `run-dir`, `report-path`, `stdout-path` and `stderr-path`, rather than claiming to return rows or SQL. Read generated SQL from stdout or a configured output file. Collect outputs using comma-separated `--artifacts NAME=PATH` entries.

Optional `--arguments` appends literal tokens for flags beyond the named contract. Lists use comma-separated strings; whitespace is trimmed and empty entries are rejected. For a token containing a comma, use CSV double quotes inside the argument string. No shell evaluation occurs.

[Official CLI documentation](https://www.prisma.io/docs/orm/v7/reference/prisma-cli-reference) · [MIT license](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add prisma --path /path/to/fluentci-modules/databases/prisma
```

For a published module, use `fluentci add @fluentci.io/prisma@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

These examples append `version` and a native Git check to one pipeline.
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
import FluentCI.Modules.Prisma as Dependency

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
import fluentci_modules/prisma as dependency

pub fn run() -> String {
  flow.pipeline("ci")
  |> flow.workdir(".")
  |> dependency.version(dependency.version_args())
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
  alias FluentCI.Modules.Prisma, as: Dependency

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
            [fluentci-modules.prisma :as dependency]))

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
  ->FluentciModulesPrisma.version(FluentciModulesPrisma.versionArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import prisma as dependency


def run() -> str:
    return (
        pipeline("ci")
        .workdir(".")
        .pipe(dependency.version, {})
        .exec("git", "diff", "--exit-code")
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/prisma/index";

export function run(): string {
  return flow.pipeline("ci")
    .workdir(".")
    .pipe(dependency.version, {})
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
| `run` | Execute literal Prisma CLI arguments, including version-specific features. |
| `version` | Print the Prisma CLI and engine versions. |
| `init` | Initialize a Prisma project; configure the datasource explicitly for unattended jobs. |
| `generate` | Generate project clients from the Prisma schema without applying migrations. |
| `validate` | Validate the project Prisma schema. |
| `format` | Format schemas or fail a formatting check without writing changes. |
| `db_pull` | Introspect the database; print avoids rewriting the project schema. |
| `db_push` | Synchronize schema without migrations; data loss and reset flags are explicit. |
| `db_seed` | Run the project seed command configured in Prisma config. |
| `db_execute` | Execute an existing SQL script using the configured datasource. |
| `migrate_deploy` | Apply pending committed migrations noninteractively in deployment pipelines. |
| `migrate_status` | Report migration status; propagate divergence and pending-migration failures. |
| `migrate_dev` | Create and apply development migrations; use migrate-deploy for production. |
| `migrate_reset` | Reset a disposable development database; destructive confirmation is explicit. |
| `migrate_resolve` | Record a migration as applied or rolled back; choose exactly one in Prisma. |
| `migrate_diff` | Compare schema sources; native Prisma requires exactly one from and one to source. |
| `debug` | Print Prisma diagnostic information for troubleshooting. |
| `studio` | Run the long-lived Studio server within a scoped service lifecycle. |
<!-- /generated:language-examples -->
