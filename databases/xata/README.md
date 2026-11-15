# Xata

Manage preview database branches and schema migrations from CI/CD pipelines.
This PureScript Wasm component requires FluentCI v0.17.3+ and the current Xata
Postgres platform CLI. Install it with [setup-xata](../../setup/xata/README.md).

```sh
fluentci run setup-xata setup --version 1.18.2
fluentci run xata branch-create --run-dir /tmp/xata-create \
  --organization-id ORG --project-id PROJECT --name pr-123 --parent-branch main
fluentci run xata branch-wait-ready --run-dir /tmp/xata-ready \
  --organization-id ORG --project-id PROJECT --branch pr-123
fluentci run xata migration-start --run-dir /tmp/xata-migration \
  --organization-id ORG --project-id PROJECT --branch pr-123 --migration-file migrations/001.json
fluentci run xata migration-complete --run-dir /tmp/xata-complete \
  --organization-id ORG --project-id PROJECT --branch pr-123
fluentci run xata branch-delete --run-dir /tmp/xata-cleanup \
  --organization-id ORG --project-id PROJECT --branch pr-123 --yes
```

Set `XATA_API_KEY` through the runner’s secret environment, or supply an existing
native authentication profile using `--profile`. Organization/project/branch
context can come from native configuration; pass identifiers explicitly for
predictable CI runs. `--project` selects the local working directory, while
`--project-id` selects a Xata project. Setup does not authenticate or provision a
server. The module sets `CI=true`; native commands requiring unspecified prompt
answers fail or remain subject to the configured task timeout.

## Complete CLI access

Every upstream top-level command has a function, including `auth`, `organization`,
`project`, `branch`, `keys`, `roll`, `clone`, `stream`, `skill`, `console`,
`checkout`, `init`, `scratch`, `onboard`, `status`, `licenses`, `upgrade`,
`completions`, and `version`. Each accepts its entire native subcommand and flag
surface through comma-separated `--arguments`. The `run` function accepts any
root command, alias, or future feature. These calls use literal argv tokens;
shell expansion and shell quoting are not applied.

```sh
fluentci run xata branch --run-dir /tmp/xata-list \
  --arguments list,--organization,ORG,--project,PROJECT,--json
fluentci run xata run --run-dir /tmp/xata-any --arguments status,--json
```

For values containing commas, double-quote the CSV entry and double any embedded
quotes. Shell-quote the complete CSV string when calling from a shell. Both
`arguments` and `artifacts` use CSV strings; JSON array brackets are not required.
A missing or blank optional list adds no arguments; malformed/empty CSV entries
fail before host commands. Native flags and behavior remain those of the
installed CLI version. See [COMMANDS.md](./COMMANDS.md) for the complete command
mapping and the reviewed upstream source revision.

## Pipeline functions and results

Named functions cover branch create/list/describe/delete/URL/readiness, project
creation, and pgroll init/start/complete/rollback/status/migrate/pull/baseline.
The `arguments` field on each helper provides additional native options.
Migration input files are checked before execution. Branch creation and deletion
execute immediately; place them in the appropriate workflow stages. Cloning,
replication, logs, metrics, query insights, backups, IP filters, key management,
and all other native features are available through their command-group function.
Native interactive shells and long-running streams still require an appropriate
runner lifecycle; setup does not create background services.

Each function needs a fresh `--run-dir`; `--timeout-ms` defaults to 900000.
Returns a typed execution result with outcome, report, stdout, and stderr paths.
Nonzero exits, transport failures, cancellations, and timeouts fail the call.
Use `--artifacts schema=out/schema.sql` to collect output files and their hashes.
Connection-string and credential commands write sensitive values to stdout;
choose how those report files are consumed and retained in your pipeline.
Credentials are inherited and are not injected into the execution plan by the
module. This adapter accepts Linux/macOS/BSD with an available compatible CLI;
setup availability and native database-client requirements still apply.

[COMPONENT.md](./COMPONENT.md) lists every named argument and return type;
[OPTIONS.md](./OPTIONS.md) records native flag mappings.
[Xata CLI](https://github.com/xataio/cli) · [MIT wrapper license](./LICENSE).

## Setup component dependency

This module declares `setup-xata` as typed native component dependencies.
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
fluentci add xata --path /path/to/fluentci-modules/databases/xata
```

For a published module, use `fluentci add @fluentci.io/xata@VERSION` with an
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
import FluentCI.Modules.Xata as Dependency

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
import fluentci_modules/xata as dependency

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
  alias FluentCI.Modules.Xata, as: Dependency

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
            [fluentci-modules.xata :as dependency]))

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
  ->FluentciModulesXata.version(FluentciModulesXata.versionArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import xata as dependency


def run() -> str:
    prepared = dependency.version(
        pipeline("ci").workdir("."), {}
    )
    return prepared.exec("git", "diff", "--exit-code").run()
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/xata/index";

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
| `run` | Execute any Xata CLI feature with literal CSV arguments. |
| `version` | Print the installed Xata CLI version. |
| `skill` | Run the complete xata skill command surface, including every nested subcommand and native flag. |
| `init` | Run the complete xata init command surface, including every nested subcommand and native flag. |
| `onboard` | Run the complete xata onboard command surface, including every nested subcommand and native flag. |
| `auth` | Run the complete xata auth command surface, including every nested subcommand and native flag. |
| `organization` | Run the complete xata organization command surface, including every nested subcommand and native flag. |
| `project` | Run the complete xata project command surface, including every nested subcommand and native flag. |
| `branch` | Run the complete xata branch command surface, including every nested subcommand and native flag. |
| `keys` | Run the complete xata keys command surface, including every nested subcommand and native flag. |
| `roll` | Run the complete xata roll command surface, including every nested subcommand and native flag. |
| `clone` | Run the complete xata clone command surface, including every nested subcommand and native flag. |
| `stream` | Run the complete xata stream command surface, including every nested subcommand and native flag. |
| `status` | Run the complete xata status command surface, including every nested subcommand and native flag. |
| `licenses` | Run the complete xata licenses command surface, including every nested subcommand and native flag. |
| `checkout` | Run the complete xata checkout command surface, including every nested subcommand and native flag. |
| `scratch` | Run the complete xata scratch command surface, including every nested subcommand and native flag. |
| `console` | Run the complete xata console command surface, including every nested subcommand and native flag. |
| `upgrade` | Run the complete xata upgrade command surface, including every nested subcommand and native flag. |
| `completions` | Run the complete xata completions command surface, including every nested subcommand and native flag. |
| `branch_create` | Create a preview database branch; use branch-wait-ready before running tests. |
| `branch_delete` | Delete a database branch during pipeline cleanup. |
| `branch_list` | List database branches for the selected project. |
| `branch_describe` | Inspect a database branch and its current state. |
| `branch_wait_ready` | Block the pipeline until a branch is healthy; task timeoutMs bounds the wait. |
| `branch_url` | Write the selected branch connection string to the task stdout file. |
| `project_create` | Create a Xata project and its initial branch using explicit CI configuration. |
| `migration_init` | Run pgroll init for the selected database branch and propagate migration failures. |
| `migration_start` | Run pgroll start for the selected database branch and propagate migration failures. |
| `migration_complete` | Run pgroll complete for the selected database branch and propagate migration failures. |
| `migration_rollback` | Run pgroll rollback for the selected database branch and propagate migration failures. |
| `migration_status` | Run pgroll status for the selected database branch and propagate migration failures. |
| `migration_migrate` | Run pgroll migrate for the selected database branch and propagate migration failures. |
| `migration_pull` | Run pgroll pull for the selected database branch and propagate migration failures. |
| `migration_baseline` | Run pgroll baseline for the selected database branch and propagate migration failures. |
<!-- /generated:language-examples -->
