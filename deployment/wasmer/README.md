# Wasmer

Publish WebAssembly packages, deploy Wasmer Edge applications, inspect deployments and logs, and promote application versions through typed PureScript CI/CD functions. Requires FluentCI v0.17.3+.

```sh
fluentci run setup-wasmer setup --version 7.5.0
fluentci run wasmer validate --run-dir /tmp/wasmer-validate-1 --file dist/app.wasm
fluentci run wasmer publish --run-dir /tmp/wasmer-publish-1 --directory package --namespace example --name app --package-version 1.0.0 --wait container
fluentci run wasmer deploy --run-dir /tmp/wasmer-deploy-1 --path app.yaml --owner example --name ci-app --publish-package
fluentci run wasmer app-get --run-dir /tmp/wasmer-app-1 --app example/ci-app --format json
fluentci run wasmer app-logs --run-dir /tmp/wasmer-logs-1 --app example/ci-app --streams stdout,stderr --max 100
fluentci run wasmer version-activate --run-dir /tmp/wasmer-promote-1 --version-id dav_unique_version_id
```

Set `WASMER_TOKEN` from the CI secret store for registry and Edge operations, or provision native Wasmer credentials before invoking them. Credentials remain inherited and are not public token arguments. Build Wasm and prepare `wasmer.toml`/`app.yaml` using the project's toolchains before publishing/deploying. Setup installs the CLI only. Named flags target Wasmer 7.5.0; [COMMANDS.md](./COMMANDS.md), [COMPONENT.md](./COMPONENT.md) and [OPTIONS.md](./OPTIONS.md) describe coverage, typed contracts and flag mappings.

`publish` and `deploy` pass `--non-interactive`. They fail when required owner/app configuration is missing instead of starting a login or configuration prompt. File and directory inputs marked in the contract are checked before setup or execution. Native Wasmer rejects conflicting `--dir`/`--path` selections. `--no-default` can stage a version without activating it, while `version-activate` requires a unique version ID rather than a human-readable version name. `--no-wait` returns before reachability checks finish. `app-delete` requires an explicit app reference and is destructive; native Wasmer deletes without an interactive confirmation in a headless environment.

The component declares [setup-wasmer](../../setup/wasmer/README.md) as a typed dependency. Missing CLIs are installed automatically; available tools are reused. To pin a version run setup first. An explicit `--executable` bypasses automatic setup. Publishing composes dependencies so consumers need no repository-relative source paths.

Public lists use comma-separated strings; `--streams stdout,stderr` repeats the native stream option. Whitespace is trimmed and malformed CSV, empty entries and NUL characters are rejected before host commands. `run --arguments=app,list` and optional `--arguments` on named functions expose additional native features without shell expansion. Native server validation still applies.

Every call requires a fresh `--run-dir`. Failures and timeouts propagate as module errors. Success returns typed `outcome`, `run-dir`, `report-path`, `stdout-path` and `stderr-path`; native JSON or tables are read from the stdout file. Collect files with CSV `--artifacts NAME=PATH`. Logs do not watch unless requested; use a bounded `--timeout-ms` for streaming. Protect logs and reports containing application environment or secret data.

[Official Edge CLI reference](https://docs.wasmer.io/edge/cli/) · [Registry publishing](https://docs.wasmer.io/registry/cli/) · [MIT wrapper license](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add wasmer --path /path/to/fluentci-modules/deployment/wasmer
```

For a published module, use `fluentci add @fluentci.io/wasmer@VERSION` with an
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
import FluentCI.Modules.Wasmer as Dependency

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
import fluentci_modules/wasmer as dependency

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
  alias FluentCI.Modules.Wasmer, as: Dependency

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
            [fluentci-modules.wasmer :as dependency]))

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
  ->FluentciModulesWasmer.version(FluentciModulesWasmer.versionArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import wasmer as dependency


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
import * as dependency from "./fluentci_modules/wasmer/index";

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
| `run` | Execute additional Wasmer CLI commands with literal CSV arguments. |
| `version` | Print the installed Wasmer version. |
| `deploy` | Deploy an application to Wasmer Edge without interactive prompts. |
| `publish` | Publish a local package to the Wasmer registry without prompts. |
| `validate` | Validate a local WebAssembly file before publishing. |
| `app_list` | List accessible Wasmer Edge applications. |
| `app_get` | Inspect a Wasmer Edge application. |
| `app_logs` | Retrieve logs without continuous watching by default. |
| `app_delete` | Delete the explicitly identified application; destructive native operation. |
| `deployments_list` | Inspect deployment history for an application. |
| `version_activate` | Activate a selected unique version ID for rollback or promotion. |
<!-- /generated:language-examples -->
