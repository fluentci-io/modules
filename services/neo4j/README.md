# Neo4j service

Run Neo4j as a background test dependency using FluentCI's native workspace
service manager. Typed PureScript Wasm component; requires FluentCI **v0.17.4+**.

```sh
fluentci run neo4j start --version 5-community
fluentci run neo4j status
fluentci run neo4j logs --tail 50 --follow true
fluentci run neo4j restart
fluentci run neo4j stop
```

## Default profile

- Image: `neo4j:5-community`; override with `--version` or `--image`, including a digest.
- Primary container port: `7474`; all exposed container ports: `7474, 7687`.
- Readiness: HTTP /; deadline `180000` milliseconds.
- Service name: `module-neo4j-default`; use `--name module-neo4j-my-test` for an isolated instance.

HTTP management on 7474; Bolt on 7687. Test credentials neo4j / fluentci-test-password.

## Test configuration

- `NEO4J_AUTH=neo4j/fluentci-test-password`.
- `NEO4J_server_memory_heap_initial__size=256M`.
- `NEO4J_server_memory_heap_max__size=512M`.
- `NEO4J_server_memory_pagecache_size=128M`.

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

[Upstream configuration](https://neo4j.com/docs/operations-manual/current/docker/introduction/) · [Shared service behavior](../README.md)

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.5 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add neo4j --path /path/to/fluentci-modules/services/neo4j
```

For a published module, use `fluentci add @fluentci.io/neo4j@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

These examples append `start` and a native Git check to one pipeline.
Replace sample paths and identifiers with your own. Optional arguments use the
callee's defaults, and public list fields use comma-separated strings. See
[COMPONENT.md](./COMPONENT.md) for argument descriptions and return types.

The 0.17.5 composition API is an initial foundation. These examples follow its
generated API; full cross-SDK compilation and execution coverage is still pending.
See [composition support and limitations](../../docs/COMPOSITION.md).

For services, register `stop` with the same project/name in failure-safe cleanup before running tests. A later ordinary `stop` step will be skipped when a preceding step fails. This short example starts the service using its default scoped name; it is not a complete service lifecycle. Elixir Flow does not yet offer failure-safe cleanup.

### PureScript

```purescript
module Main where

import Prelude
import Effect (Effect)
import FluentCI.Flow as Flow
import FluentCI.Modules.Neo4j as Dependency

run :: Effect String
run =
  Flow.pipeline "ci"
    # Flow.workdir "."
    # Dependency.start (Dependency.startArgs)
    # Flow.exec [ "git", "diff", "--exit-code" ]
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/neo4j as dependency

pub fn run() -> String {
  flow.pipeline("ci")
  |> flow.workdir(".")
  |> dependency.start(dependency.start_args())
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
  alias FluentCI.Modules.Neo4j, as: Dependency

  defplugin run do
    Flow.pipeline("ci")
    |> Flow.workdir(".")
    |> Dependency.start(%{})
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
            [fluentci-modules.neo4j :as dependency]))

(defn run []
  (-> (flow/pipeline "ci")
      (flow/workdir ".")
      (dependency/start {})
      (flow/exec ["git" "diff" "--exit-code"])
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("ci")
  ->Flow.workdir(".")
  ->FluentciModulesNeo4j.start(FluentciModulesNeo4j.startArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import neo4j as dependency


def run() -> str:
    prepared = dependency.start(
        pipeline("ci").workdir("."), {}
    )
    return prepared.exec("git", "diff", "--exit-code").run()
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/neo4j/index";

export function run(): string {
  const prepared = dependency.start(
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
| `start` | Start an idempotent background service through FluentCI’s native workspace service manager and wait for readiness. |
| `stop` | Stop only this named service through the native manager; preserve explicitly mounted data. Native dependents are stopped too. |
| `restart` | Restart the existing native service definition and wait for readiness. |
| `status` | Return the service’s native lifecycle state and actual loopback port bindings. |
| `logs` | Read native service logs; optionally follow new output until interrupted, without starting or stopping a service. |
<!-- /generated:language-examples -->
