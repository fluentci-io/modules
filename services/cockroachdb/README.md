# CockroachDB service

Run CockroachDB as a background test dependency using FluentCI's native workspace
service manager. Typed PureScript Wasm component; requires FluentCI **v0.17.4+**.

```sh
fluentci run cockroachdb start --version v25.4.0
fluentci run cockroachdb status
fluentci run cockroachdb logs --tail 50 --follow true
fluentci run cockroachdb restart
fluentci run cockroachdb stop
```

## Default profile

- Image: `cockroachdb/cockroach:v25.4.0`; override with `--version` or `--image`, including a digest.
- Primary container port: `26257`; all exposed container ports: `26257, 8080`.
- Readiness: TCP connection on the published primary port; deadline `180000` milliseconds.
- Service name: `module-cockroachdb-default`; use `--name module-cockroachdb-my-test` for an isolated instance.

Single insecure test node. Connect as root without a password; use defaultdb or create a test database.

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

[Upstream configuration](https://www.cockroachlabs.com/docs/stable/start-a-local-cluster-in-docker) · [Shared service behavior](../README.md)

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add cockroachdb --path /path/to/fluentci-modules/services/cockroachdb
```

For a published module, use `fluentci add @fluentci.io/cockroachdb@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Start cockroachdb for integration tests using cockroachdb/cockroach:v25.4.0. Return the allocated endpoint to the caller; use it when configuring your test client.

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
import FluentCI.Modules.Cockroachdb as Cockroachdb

run :: Effect String
run =
  Flow.pipeline "cockroachdb-start"
    # Flow.workdir "."
    # Cockroachdb.start (Cockroachdb.startArgs)
    # Flow.map (\result -> result.endpoint)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/cockroachdb

pub fn run() -> String {
  flow.pipeline("cockroachdb-start")
  |> flow.workdir(".")
  |> cockroachdb.start(cockroachdb.start_args())
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
  alias FluentCI.Modules.Cockroachdb

  defplugin run do
    Flow.pipeline("cockroachdb-start")
    |> Flow.workdir(".")
    |> Cockroachdb.start(%{})
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
            [fluentci-modules.cockroachdb :as cockroachdb]))

(defn run []
  (-> (flow/pipeline "cockroachdb-start")
      (flow/workdir ".")
      (cockroachdb/start {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("cockroachdb-start")
  ->Flow.workdir(".")
  ->FluentciModulesCockroachdb.start(FluentciModulesCockroachdb.startArgs)
  ->Flow.map(result => result.endpoint)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import cockroachdb


def run() -> str:
    return (
        pipeline("cockroachdb-start")
        .workdir(".")
        .pipe(cockroachdb.start, {})
        .map(lambda result: result.endpoint)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as cockroachdb from "./fluentci_modules/cockroachdb/index";

export function run(): string {
  return flow.pipeline("cockroachdb-start")
    .workdir(".")
    .pipe(cockroachdb.start, {})
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
