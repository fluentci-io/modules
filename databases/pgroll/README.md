# pgroll

Run PostgreSQL schema migrations through typed PureScript Wasm functions in
CI/CD pipelines. Requires FluentCI v0.17.3+ and an installed `pgroll` CLI.
Use [setup-pgroll](../../setup/pgroll/README.md) to install it.

```sh
fluentci run setup-pgroll setup --version 0.16.3
# Set PGROLL_PG_URL from the runner's secret environment first.
fluentci run pgroll init --run-dir /tmp/pgroll-init
fluentci run pgroll validate --file migrations/001.yaml --run-dir /tmp/pgroll-validate
fluentci run pgroll start --file migrations/001.yaml --run-dir /tmp/pgroll-start
# Deploy and verify the application before completing the active migration.
fluentci run pgroll complete --run-dir /tmp/pgroll-complete
```

For directory-based workflows, `migrate --directory migrations` applies outstanding
migrations. The final migration stays active by default; pass `--complete` to
complete it, or `--expect-one` to reject more than one pending migration. `rollback`
reverts an active migration under pgroll's native limitations. A completed
migration cannot be treated as an arbitrary reversible deployment history.

Functions also cover `status`, `analyze`, `pull`, `baseline`, `convert`, `update`,
`create`, and `latest-migration`, `latest-schema`, and `latest-url`. `create`
requires `--name` and always supplies `--empty` to avoid interactive operation
selection. `baseline --baseline-version NAME --directory DIR` always supplies
`--yes`: invoking it resets migration history and creates a placeholder file.
`update` rewrites migration files in place. Review generated files before use.

`init` and `complete` do not require files despite upstream's historical help
synopsis. Existing migration/SQL files and input directories are checked before
execution. `pull` and `baseline` let pgroll create their destination directories.
Migration validation uses PostgreSQL; it is not an offline syntax checker.

## Configuration and complete CLI access

Use inherited `PGROLL_PG_URL` for the database connection, with TLS and permissions
appropriate to the migration. Native configuration also supports `PGROLL_SCHEMA`,
`PGROLL_STATE_SCHEMA`, `PGROLL_LOCK_TIMEOUT`, `PGROLL_ROLE`,
`PGROLL_USE_VERSION_SCHEMA`, and `PGROLL_VERBOSE`. Named functions expose the
matching optional arguments, including `--lock-timeout`, `--schema`,
`--state-schema`, and `--use-version-schema=false`. Omitted options retain native
defaults. Explicit `--postgres-url` is available, but embeds the URL in the plan;
secret environment variables remain inherited and are not serialized by the module.

All public lists are comma-separated strings. Each operation accepts additional
literal tokens through `--arguments`; `run` accesses every native command, flag,
or future feature. `latest` and `completion` expose their native subcommands.

```sh
fluentci run pgroll latest-schema --local migrations --run-dir /tmp/pgroll-schema
fluentci run pgroll create --name migrations/002_accounts --json --run-dir /tmp/pgroll-create
fluentci run pgroll run --arguments status,--verbose --run-dir /tmp/pgroll-native
```

Double-quote CSV entries containing commas and double embedded quotes. Shell-quote
the whole CSV value when calling from a shell. Tokens are passed literally without
shell expansion. Blank optional lists add no tokens; malformed or empty entries
fail before host commands. Interactive native commands remain available through
`run` and require a suitable runner lifecycle.

## Results and prerequisites

Each invocation requires a fresh `--run-dir`. `--project` selects the working
directory; `--timeout-ms` defaults to 900000. Functions return typed execution
outcome, report, stdout, and stderr paths. Nonzero exits, timeouts, transport
errors, and cancellations fail the call. Use `--artifacts migration=migrations/002_accounts.json`
to collect a generated file and its size/hash. `latest-url` can emit database
credentials; control retention of its output and reports.

The adapter accepts Linux, macOS, FreeBSD, NetBSD, and OpenBSD when a compatible
CLI is available. Database connectivity, PostgreSQL compatibility, permissions,
and pgroll installation remain runner prerequisites. Setup does not install or
start PostgreSQL. pgroll controls migration/backfill behavior; the wrapper does
not independently guarantee a lock-free or zero-downtime rollout.

See [COMPONENT.md](./COMPONENT.md) for typed arguments and results,
[OPTIONS.md](./OPTIONS.md) for native mappings, and
[COMMANDS.md](./COMMANDS.md) for reviewed command coverage.
[Upstream pgroll](https://github.com/xataio/pgroll) · [MIT wrapper license](./LICENSE).

## Setup component dependency

This module declares `setup-pgroll` as typed native component dependencies.
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
fluentci add pgroll --path /path/to/fluentci-modules/databases/pgroll
```

For a published module, use `fluentci add @fluentci.io/pgroll@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

These examples append `start` and a native Git check to one pipeline.
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
import FluentCI.Modules.Pgroll as Dependency

run :: Effect String
run =
  Flow.pipeline "ci"
    # Flow.workdir "."
    # Dependency.start (Dependency.startArgs { "file": "dist/artifact.tar.gz" })
    # Flow.exec [ "git", "diff", "--exit-code" ]
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/pgroll as dependency

pub fn run() -> String {
  flow.pipeline("ci")
  |> flow.workdir(".")
  |> dependency.start(dependency.start_args("dist/artifact.tar.gz"))
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
  alias FluentCI.Modules.Pgroll, as: Dependency

  defplugin run do
    Flow.pipeline("ci")
    |> Flow.workdir(".")
    |> Dependency.start(%{"file" => "dist/artifact.tar.gz"})
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
            [fluentci-modules.pgroll :as dependency]))

(defn run []
  (-> (flow/pipeline "ci")
      (flow/workdir ".")
      (dependency/start {:file "dist/artifact.tar.gz"})
      (flow/exec ["git" "diff" "--exit-code"])
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("ci")
  ->Flow.workdir(".")
  ->FluentciModulesPgroll.start(FluentciModulesPgroll.startArgs(~file="dist/artifact.tar.gz"))
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import pgroll as dependency


def run() -> str:
    return (
        pipeline("ci")
        .workdir(".")
        .pipe(dependency.start, {"file": "dist/artifact.tar.gz"})
        .exec("git", "diff", "--exit-code")
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/pgroll/index";

export function run(): string {
  return flow.pipeline("ci")
    .workdir(".")
    .pipe(dependency.start, {"file":"dist/artifact.tar.gz"})
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
| `run` | Execute any pgroll feature with literal CSV arguments. |
| `version` | Print the installed pgroll version. |
| `init` | Initialize pgroll state in the target database; no migration file is required. |
| `validate` | Validate a migration file against the target database before application. |
| `start` | Start a migration, backfill data, and optionally complete it. |
| `complete` | Complete the currently active migration in the database; no migration file is required. |
| `rollback` | Roll back the currently active migration; completed migrations retain native rollback limitations. |
| `migrate` | Apply outstanding migrations from a directory and propagate native failures. |
| `status` | Report active migration and schema state in the target database. |
| `analyze` | Analyze the target database SQL schema using the native hidden diagnostic command. |
| `baseline` | Reset migration history to a baseline and write its placeholder file without a confirmation prompt. |
| `pull` | Pull missing migration history from the database into local files. |
| `convert` | Convert SQL statements from a file to a pgroll migration using native conversion rules. |
| `update` | Rewrite outdated migration files in place; review changes before committing them. |
| `create` | Create an empty named migration file noninteractively in the working directory. |
| `latest` | Access native latest subcommands through the CSV arguments string. |
| `latest_migration` | Print the latest migration from the target database or local migration directory. |
| `latest_schema` | Print the latest schema from the target database or local migration directory. |
| `latest_url` | Print the latest connection URL with version schema search_path from the target database or local migration directory. |
| `completion` | Generate shell completion scripts through literal native CSV arguments. |
<!-- /generated:language-examples -->
