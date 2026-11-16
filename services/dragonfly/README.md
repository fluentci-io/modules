# Dragonfly service

Run a background Dragonfly test service through FluentCI's native workspace
service manager and Docker backend. Typed PureScript Wasm component; requires
FluentCI **v0.17.4+**, with the native services apply/status lifecycle API.

```sh
fluentci run dragonfly start --version v2.0.2
fluentci run dragonfly status
fluentci run dragonfly logs --tail 50
fluentci run dragonfly logs --tail 50 --follow true
fluentci run dragonfly restart
fluentci run dragonfly stop
```

For live logs, use `logs --follow true`. Press Ctrl-C to stop following; the
background service keeps running. The native shorthand is
`fluentci logs module-dragonfly-default -f` in the same project workspace.

## Default profile

- Image: `ghcr.io/dragonflydb/dragonfly:v2.0.2`.
- Primary port: `6379`; exposed ports: `6379`.
- Readiness: tcp /; deadline 60000 ms.

Single-node Redis-compatible test cache without authentication. Uses epoll instead of io_uring for standard Docker sandbox compatibility, one I/O thread and a 256 MiB memory limit. Readiness checks the allocated loopback binding; full E2E also requires a Redis PONG. Mount /data for snapshots; explicit named or bind-mounted data survives stop. These settings target disposable CI workloads.

[Upstream configuration](https://github.com/dragonflydb/dragonfly/blob/v2.0.2/README.md).

## Typed configuration and lifecycle

--version selects the image tag. --image accepts a complete image/digest reference;
do not combine them. Start waits for readiness and returns name, state, backend,
host, primary port, endpoint and every container/host port binding. Dynamic ports
are returned as allocated; do not assume the host port equals the container port.
Restart uses the saved native definition. Reconfiguration requires stop first.
Repeated unchanged start reuses the service, and repeated stop is safe. Stop also
affects native dependents, while explicit bind/named volume data is preserved.

Use project to select the same workspace across calls. Docker must be installed
and its daemon and loopback port bindings accessible to the caller. Readiness,
Docker/image, manager and health failures propagate without successful startup.
Use cleanup/finally to stop manually started services after tests.

Public list inputs are comma-separated strings. env uses KEY=VALUE entries;
ports use CONTAINER or HOST:CONTAINER; volumes use /CONTAINER or
SOURCE:/CONTAINER[:ro|rw]. Optional blank lists retain defaults. Empty entries,
invalid selectors and duplicate mappings are rejected before installation.
CSV double quotes preserve commas within a literal token. command and
readiness-command remain foreground literal argv, without shell expansion.



See [COMPONENT.md](./COMPONENT.md) for every named argument, description and native
return, [the shared service guide](../README.md) for platform/data/lifecycle
semantics, and the [upstream reference](https://github.com/dragonflydb/dragonfly/blob/v2.0.2/README.md).

## Development

Mocked unit/contract tests run in normal module CI. The dedicated Services E2E
workflow builds every real component, starts/reuses/restarts/stops it through the
native manager, and checks real protocol connectivity sequentially on one runner.
No services or images are run by the source generators. License: MIT.

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add dragonfly --path /path/to/fluentci-modules/services/dragonfly
```

For a published module, use `fluentci add @fluentci.io/dragonfly@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Start Dragonfly for Redis-compatible integration tests using ghcr.io/dragonflydb/dragonfly:v2.0.2. Return the allocated endpoint to the caller; use it when configuring your Redis client.

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
import FluentCI.Modules.Dragonfly as Dragonfly

run :: Effect String
run =
  Flow.pipeline "dragonfly-start"
    # Flow.workdir "."
    # Dragonfly.start (Dragonfly.startArgs)
    # Flow.map (\result -> result.endpoint)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/dragonfly

pub fn run() -> String {
  flow.pipeline("dragonfly-start")
  |> flow.workdir(".")
  |> dragonfly.start(dragonfly.start_args())
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
  alias FluentCI.Modules.Dragonfly

  defplugin run do
    Flow.pipeline("dragonfly-start")
    |> Flow.workdir(".")
    |> Dragonfly.start(%{})
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
            [fluentci-modules.dragonfly :as dragonfly]))

(defn run []
  (-> (flow/pipeline "dragonfly-start")
      (flow/workdir ".")
      (dragonfly/start {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("dragonfly-start")
  ->Flow.workdir(".")
  ->FluentciModulesDragonfly.start(FluentciModulesDragonfly.startArgs)
  ->Flow.map(result => result.endpoint)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import dragonfly


def run() -> str:
    return (
        pipeline("dragonfly-start")
        .workdir(".")
        .pipe(dragonfly.start, {})
        .map(lambda result: result.endpoint)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dragonfly from "./fluentci_modules/dragonfly/index";

export function run(): string {
  return flow.pipeline("dragonfly-start")
    .workdir(".")
    .pipe(dragonfly.start, {})
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
