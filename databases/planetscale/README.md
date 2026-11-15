# PlanetScale

Create preview branches, run SQL, and deploy schema changes in CI/CD pipelines.
This PureScript Wasm component requires FluentCI v0.17.3+ and the PlanetScale
`pscale` CLI. Install it with [setup-planetscale](../../setup/planetscale/README.md).

```sh
fluentci run setup-planetscale setup --version 0.350.0
fluentci run planetscale branch-create --run-dir /tmp/pscale-create \
  --database app --branch pr-123 --organization team
fluentci run planetscale sql-query --run-dir /tmp/pscale-query \
  --database app --branch pr-123 --organization team --query 'SELECT 1' --output-format json
fluentci run planetscale deploy-request-create --run-dir /tmp/pscale-request \
  --database app --branch pr-123 --organization team --into main
fluentci run planetscale deploy-request-deploy --run-dir /tmp/pscale-deploy \
  --database app --request 123 --organization team
fluentci run planetscale branch-delete --run-dir /tmp/pscale-cleanup \
  --database app --branch pr-123 --organization team --force
```

Supply `PLANETSCALE_SERVICE_TOKEN_ID` and `PLANETSCALE_SERVICE_TOKEN` through the
runner’s secret environment, or use existing native authentication. Organization
context is exposed as `--organization` on named helpers; native group calls use
`--org`. No login, provisioning, or database server startup occurs during setup.
The module sets `CI=true`. Native engine-specific constraints still apply:
deploy requests are a Vitess schema workflow; PostgreSQL and other database
engines expose their own branch, role, parameter, replica, and migration features.

## Complete CLI access

Every upstream root command has a function covering its complete subcommand and
flag surface. This includes databases, branches, backups, deploy requests,
passwords, roles, keyspaces, imports, SQL, query insights, inspection, logs,
metrics, webhooks, workflows, maintenance, dedicated replicas, PgBouncer,
traffic controls, organizations, billing, authentication, and service tokens.
`run` also accepts arbitrary root commands, aliases, global flags, and newly
introduced features. See [COMMANDS.md](./COMMANDS.md) for the complete mapping.

```sh
fluentci run planetscale branch --run-dir /tmp/pscale-native \
  --arguments create,app,pr-456,--org,team,--wait
fluentci run planetscale run --run-dir /tmp/pscale-any \
  --arguments 'sql,app,pr-123,--org,team,--query,"SELECT a,b FROM example"'
```

`arguments` and `artifacts` accept comma-separated strings. CSV double quotes
preserve commas within a value; doubled quotes represent literal quotes.
Arguments are passed literally without shell expansion. Malformed CSV fails
before host commands. Native flags retain their installed CLI semantics.

## Pipeline functions and results

Named functions cover branch create/list/show/schema/delete, database discovery,
deploy-request create/show/diff/deploy, and noninteractive SQL. Branch creation
and deploy-request deployment wait for completion by default; pass `--wait=false`
to retain asynchronous native behavior. Mutations run when invoked. SQL text is
passed as one literal argument; native destructive-query guards remain enabled
unless the caller explicitly supplies `--force`. Additional native flags are
available through each helper’s `arguments` string.

Every invocation requires a fresh `--run-dir`; optional `--project` selects the
checkout directory and `--timeout-ms` defaults to 900000. Returns typed outcome,
report, stdout, and stderr paths. Nonzero exits, transport errors, timeouts,
and cancellations fail the call. Declare generated files using
`--artifacts schema=out/schema.sql` for artifact size/SHA-256 reporting.
Credentials remain inherited; the module does not serialize them into plans.
Connection/password commands can write secrets to stdout, so control the
retention of those report files. Native shell/connect commands need the relevant
PostgreSQL/MySQL client and a suitable runner lifecycle; task timeouts bound
long-running commands. Linux/macOS/BSD adapters require an installed compatible
CLI; setup package availability is documented separately.

[COMPONENT.md](./COMPONENT.md) documents every typed argument and return;
[OPTIONS.md](./OPTIONS.md) records native flag mappings.
[PlanetScale CLI](https://github.com/planetscale/cli) · [MIT wrapper license](./LICENSE).

## Setup component dependency

This module declares `setup-planetscale` as typed native component dependencies.
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
fluentci add planetscale --path /path/to/fluentci-modules/databases/planetscale
```

For a published module, use `fluentci add @fluentci.io/planetscale@VERSION` with an
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
import FluentCI.Modules.Planetscale as Dependency

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
import fluentci_modules/planetscale as dependency

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
  alias FluentCI.Modules.Planetscale, as: Dependency

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
            [fluentci-modules.planetscale :as dependency]))

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
  ->FluentciModulesPlanetscale.version(FluentciModulesPlanetscale.versionArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import planetscale as dependency


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
import * as dependency from "./fluentci_modules/planetscale/index";

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
| `run` | Execute any PlanetScale CLI feature with literal CSV arguments. |
| `version` | Print the installed pscale CLI version. |
| `agents` | Run the complete pscale agents command surface, including every nested subcommand and native flag. |
| `login` | Run the complete pscale login command surface, including every nested subcommand and native flag. |
| `logout` | Run the complete pscale logout command surface, including every nested subcommand and native flag. |
| `agent_guide` | Run the complete pscale agent-guide command surface, including every nested subcommand and native flag. |
| `api` | Run the complete pscale api command surface, including every nested subcommand and native flag. |
| `audit_log` | Run the complete pscale audit-log command surface, including every nested subcommand and native flag. |
| `auth` | Run the complete pscale auth command surface, including every nested subcommand and native flag. |
| `billing` | Run the complete pscale billing command surface, including every nested subcommand and native flag. |
| `completion` | Run the complete pscale completion command surface, including every nested subcommand and native flag. |
| `org` | Run the complete pscale org command surface, including every nested subcommand and native flag. |
| `ping` | Run the complete pscale ping command surface, including every nested subcommand and native flag. |
| `region` | Run the complete pscale region command surface, including every nested subcommand and native flag. |
| `signup` | Run the complete pscale signup command surface, including every nested subcommand and native flag. |
| `size` | Run the complete pscale size command surface, including every nested subcommand and native flag. |
| `service_token` | Run the complete pscale service-token command surface, including every nested subcommand and native flag. |
| `backup` | Run the complete pscale backup command surface, including every nested subcommand and native flag. |
| `branch` | Run the complete pscale branch command surface, including every nested subcommand and native flag. |
| `database` | Run the complete pscale database command surface, including every nested subcommand and native flag. |
| `insights` | Run the complete pscale insights command surface, including every nested subcommand and native flag. |
| `inspect` | Run the complete pscale inspect command surface, including every nested subcommand and native flag. |
| `logs` | Run the complete pscale logs command surface, including every nested subcommand and native flag. |
| `metrics` | Run the complete pscale metrics command surface, including every nested subcommand and native flag. |
| `webhook` | Run the complete pscale webhook command surface, including every nested subcommand and native flag. |
| `connect` | Run the complete pscale connect command surface, including every nested subcommand and native flag. |
| `deploy_request` | Run the complete pscale deploy-request command surface, including every nested subcommand and native flag. |
| `keyspace` | Run the complete pscale keyspace command surface, including every nested subcommand and native flag. |
| `maintenance` | Run the complete pscale maintenance command surface, including every nested subcommand and native flag. |
| `password` | Run the complete pscale password command surface, including every nested subcommand and native flag. |
| `shell` | Run the complete pscale shell command surface, including every nested subcommand and native flag. |
| `import_command` | Run the complete pscale import command surface, including every nested subcommand and native flag. |
| `sql` | Run the complete pscale sql command surface, including every nested subcommand and native flag. |
| `workflow` | Run the complete pscale workflow command surface, including every nested subcommand and native flag. |
| `role_command` | Run the complete pscale role command surface, including every nested subcommand and native flag. |
| `pgbouncer` | Run the complete pscale pgbouncer command surface, including every nested subcommand and native flag. |
| `dedicated_read_replica` | Run the complete pscale dedicated-read-replica command surface, including every nested subcommand and native flag. |
| `read_only_replica` | Run the complete pscale read-only-replica command surface, including every nested subcommand and native flag. |
| `traffic_control` | Run the complete pscale traffic-control command surface, including every nested subcommand and native flag. |
| `branch_create` | Create a preview branch and wait for readiness by default. |
| `branch_list` | List database branches for preview environment discovery. |
| `branch_show` | Inspect a database branch and its readiness information. |
| `branch_delete` | Delete a preview branch during pipeline cleanup. |
| `branch_schema` | Retrieve a branch schema for inspection or artifact collection. |
| `database_list` | List databases visible to the pipeline credentials. |
| `deploy_request_create` | Open a schema deploy request from a branch. |
| `deploy_request_show` | Inspect a deploy request before applying schema changes. |
| `deploy_request_diff` | Inspect schema changes in a deploy request. |
| `deploy_request_deploy` | Deploy a schema request and wait for completion by default. |
| `sql_query` | Execute a noninteractive SQL query and propagate query failures. |
<!-- /generated:language-examples -->
