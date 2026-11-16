# Trino service

Run Trino as a background test dependency using FluentCI's native workspace
service manager. Typed PureScript Wasm component; requires FluentCI **v0.17.4+**.

```sh
fluentci run trino start --version 484
fluentci run trino status
fluentci run trino logs --tail 50 --follow true
fluentci run trino restart
fluentci run trino stop
```

## Default profile

- Image: `trinodb/trino:484`; override the tag with `--version`, or supply `--image` instead.
- Primary port: `8080`; exposed ports: `8080`.
- Readiness: http `/v1/info`; deadline `180000` ms.

Single-node SQL query server; mount catalog files for external connectors. Default client user can be any test username. The generated JVM config bounds the heap to 1 GiB instead of reserving most runner memory; override the /etc/trino/jvm.config mount to tune it.

## Test configuration

No environment overrides are required by default.

These are disposable CI defaults. Supply application-specific configuration with
`--env 'KEY=value,OTHER=value'`; credentials in service definitions are not a secret store.
Use `--ports 'HOST:CONTAINER,CONTAINER'`, `--volumes 'test-data:/data,/host/config:/config:ro'`,
and `--command 'program,arg1,arg2'` for native overrides. Lists are comma-separated,
trimmed, validated, and passed as literal tokens. CSV quotes preserve embedded commas.
No shell expansion or JSON object arguments are used.

Start is idempotent, waits for native readiness, and returns the actual loopback
endpoint plus every container/host port binding. Dynamic host ports may differ
from container ports: use returned bindings when constructing client URLs.
`--project` selects the same workspace for all lifecycle calls. Native recurring
health checks use the readiness probe unless `--health-check false` is supplied.
`--startup-timeout-ms`, `--stop-timeout-ms`, `--restart-policy`, `--max-restarts`,
`--depends-on`, `--readiness-path`, and `--readiness-command` customize lifecycle
behavior; see [COMPONENT.md](./COMPONENT.md) for the complete typed contract.

Interrupting followed logs leaves the service running. Stop targets this named
service and its native dependents, removes its supervised container, and preserves
explicitly mounted data. Always stop services in your pipeline's cleanup step.
Docker must be available, locally or through the caller's Docker context.

[Upstream configuration](https://trino.io/docs/current/installation/containers.html) · [Shared service behavior](../README.md)

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add trino --path /path/to/fluentci-modules/services/trino
```

For a published module, use `fluentci add @fluentci.io/trino@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Start trino for integration tests using trinodb/trino:484. Return the allocated endpoint to the caller; use it when configuring your test client.

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
import FluentCI.Modules.Trino as Trino

run :: Effect String
run =
  Flow.pipeline "trino-start"
    # Flow.workdir "."
    # Trino.start (Trino.startArgs)
    # Flow.map (\result -> result.endpoint)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/trino

pub fn run() -> String {
  flow.pipeline("trino-start")
  |> flow.workdir(".")
  |> trino.start(trino.start_args())
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
  alias FluentCI.Modules.Trino

  defplugin run do
    Flow.pipeline("trino-start")
    |> Flow.workdir(".")
    |> Trino.start(%{})
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
            [fluentci-modules.trino :as trino]))

(defn run []
  (-> (flow/pipeline "trino-start")
      (flow/workdir ".")
      (trino/start {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("trino-start")
  ->Flow.workdir(".")
  ->FluentciModulesTrino.start(FluentciModulesTrino.startArgs)
  ->Flow.map(result => result.endpoint)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import trino


def run() -> str:
    return (
        pipeline("trino-start")
        .workdir(".")
        .pipe(trino.start, {})
        .map(lambda result: result.endpoint)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as trino from "./fluentci_modules/trino/index";

export function run(): string {
  return flow.pipeline("trino-start")
    .workdir(".")
    .pipe(trino.start, {})
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
| `start` | Start an idempotent background service through FluentCI’s native workspace service manager and wait for readiness. |
| `stop` | Stop only this named service through the native manager; preserve explicitly mounted data. Native dependents are stopped too. |
| `restart` | Restart the existing native service definition and wait for readiness. |
| `status` | Return the service’s native lifecycle state and actual loopback port bindings. |
| `logs` | Read native service logs; optionally follow new output until interrupted, without starting or stopping a service. |
<!-- /generated:language-examples -->
