# TigerBeetle service

Run a single development replica using FluentCI's native **host** service backend
on Linux or macOS. Requires FluentCI v0.17.4+. The `setup-tigerbeetle` component
installs a verified official prebuilt binary; no Docker image or source build is
needed. Other operating systems fail explicitly before setup.

```sh
fluentci run tigerbeetle start --version 0.17.9 --state-dir /tmp/my-tigerbeetle --port 3000
fluentci run tigerbeetle status
fluentci run tigerbeetle logs --follow true --tail 50
fluentci run tigerbeetle restart
fluentci run tigerbeetle stop
```

`--state-dir` is a required absolute caller-owned directory. The module formats
`0_0.tigerbeetle` only when absent, as cluster 0, replica 0, replica count 1, with
`--development`. Existing data is preserved. Stop never deletes it. Startup uses
a format guard to refuse concurrent initializers; inspect an interrupted format
before manually removing its guard. Development mode is for disposable testing.

`--version` selects the binary release (default `0.17.9`, or `latest`).
`--cache-grid` defaults to `256MiB`; `--extra-args` accepts comma-separated native
option tokens. Empty CSV entries, invalid versions, paths, ports and deadlines
are rejected before host commands. Arguments stay literal, without a shell.
The typed port and cache options cannot be overridden through extra arguments.

Start waits for a loopback TCP probe and returns the ready host endpoint and
binding. Repeating unchanged start reuses the active process; stop before changing
configuration. `--project` and `--name module-tigerbeetle-YOUR-TEST` scope lifecycle
calls. Ownership metadata prevents controlling an unrelated process or container.
Stop is idempotent; followed logs can be interrupted without stopping the server.
Always call stop in pipeline cleanup. Restart uses the saved native definition.

[Typed arguments and returns](./COMPONENT.md) ·
[Official quick start](https://docs.tigerbeetle.com/quick-start/)

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add tigerbeetle --path /path/to/fluentci-modules/services/tigerbeetle
```

For a published module, use `fluentci add @fluentci.io/tigerbeetle@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Start tigerbeetle for integration tests using the prebuilt native binary. Return the allocated endpoint to the caller; use it when configuring your test client.

Replace the sample organization, paths and identifiers with your own. Configure
credentials through your CI secret provider before running authenticated operations. Optional arguments use the
callee's defaults, and public list fields use comma-separated strings. See
[COMPONENT.md](./COMPONENT.md) for argument descriptions and return types.

These examples use the generated composition API and builder chaining in
FluentCI 0.17.6; full cross-SDK compilation and execution coverage is still pending.
See [composition support and limitations](../../docs/COMPOSITION.md).

For services, register `stop` with the same project/name in failure-safe cleanup before running tests. A later ordinary `stop` step will be skipped when a preceding step fails. This short example starts the service using its default scoped name; it is not a complete service lifecycle. Elixir Flow does not yet offer failure-safe cleanup.

### PureScript

```purescript
module Main where

import Prelude
import Effect (Effect)
import FluentCI.Flow as Flow
import FluentCI.Modules.Tigerbeetle as Tigerbeetle

run :: Effect String
run =
  Flow.pipeline "tigerbeetle-start"
    # Flow.workdir "."
    # Tigerbeetle.start (Tigerbeetle.startArgs { "stateDir": "/tmp/ci-tigerbeetle" })
    # Flow.map (\result -> result.endpoint)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/tigerbeetle

pub fn run() -> String {
  flow.pipeline("tigerbeetle-start")
  |> flow.workdir(".")
  |> tigerbeetle.start(tigerbeetle.start_args("/tmp/ci-tigerbeetle"))
  |> flow.map(fn(result) { result.endpoint })
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
  alias FluentCI.Modules.Tigerbeetle

  defplugin run do
    Flow.pipeline("tigerbeetle-start")
    |> Flow.workdir(".")
    |> Tigerbeetle.start(%{"state_dir" => "/tmp/ci-tigerbeetle"})
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
            [fluentci-modules.tigerbeetle :as tigerbeetle]))

(defn run []
  (-> (flow/pipeline "tigerbeetle-start")
      (flow/workdir ".")
      (tigerbeetle/start {:stateDir "/tmp/ci-tigerbeetle"})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("tigerbeetle-start")
  ->Flow.workdir(".")
  ->FluentciModulesTigerbeetle.start(FluentciModulesTigerbeetle.startArgs(~stateDir="/tmp/ci-tigerbeetle"))
  ->Flow.map(result => result.endpoint)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import tigerbeetle


def run() -> str:
    return (
        pipeline("tigerbeetle-start")
        .workdir(".")
        .pipe(tigerbeetle.start, {"state_dir": "/tmp/ci-tigerbeetle"})
        .map(lambda result: result.endpoint)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as tigerbeetle from "./fluentci_modules/tigerbeetle/index";

export function run(): string {
  return flow.pipeline("tigerbeetle-start")
    .workdir(".")
    .pipe(tigerbeetle.start, {"stateDir":"/tmp/ci-tigerbeetle"})
    .map(result => result.endpoint)
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
| `start` | Install a verified prebuilt TigerBeetle release, format a development data file if needed, and start it with FluentCI’s native host service manager. |
| `stop` | Stop only this named service through the native manager; preserve explicitly mounted data. Native dependents are stopped too. |
| `restart` | Restart the existing native service definition and wait for readiness. |
| `status` | Return the service’s native lifecycle state and actual loopback port bindings. |
| `logs` | Read native service logs; optionally follow new output until interrupted, without starting or stopping a service. |
<!-- /generated:language-examples -->
