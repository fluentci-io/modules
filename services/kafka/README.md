# Apache Kafka service

Run Apache Kafka as a background test dependency using FluentCI's native workspace
service manager. Typed PureScript Wasm component; requires FluentCI **v0.17.4+**.

```sh
fluentci run kafka start --version 4.1.0
fluentci run kafka status
fluentci run kafka logs --tail 50 --follow true
fluentci run kafka restart
fluentci run kafka stop
```

## Default profile

- Image: `apache/kafka:4.1.0`; override with `--version` or `--image`, including a digest.
- Primary container port: `9092`; all exposed container ports: `9092`.
- Readiness: TCP connection on the published primary port; deadline `180000` milliseconds.
- Service name: `module-kafka-default`; use `--name module-kafka-my-test` for an isolated instance.

Single-node KRaft test broker. The primary host port defaults to 9092 and is advertised to clients; use --port to select another explicit host port.

## Test configuration

- `KAFKA_NODE_ID=1`.
- `KAFKA_PROCESS_ROLES=broker,controller`.
- `KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093`.
- `KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT`.
- `KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER`.
- `KAFKA_CONTROLLER_QUORUM_VOTERS=1@127.0.0.1:9093`.
- `KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1`.
- `KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1`.
- `KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1`.
- `KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0`.
- `KAFKA_HEAP_OPTS=-Xms256m -Xmx512m`.
- `CLUSTER_ID=MkU3OEVBNTcwNTJENDM2Qk`.

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

[Upstream configuration](https://github.com/apache/kafka/blob/trunk/docs/getting-started/docker.md) · [Shared service behavior](../README.md)

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add kafka --path /path/to/fluentci-modules/services/kafka
```

For a published module, use `fluentci add @fluentci.io/kafka@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Start kafka for integration tests using apache/kafka:4.1.0. Return the allocated endpoint to the caller; use it when configuring your test client.

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
import FluentCI.Modules.Kafka as Kafka

run :: Effect String
run =
  Flow.pipeline "kafka-start"
    # Flow.workdir "."
    # Kafka.start (Kafka.startArgs)
    # Flow.map (\result -> result.endpoint)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/kafka

pub fn run() -> String {
  flow.pipeline("kafka-start")
  |> flow.workdir(".")
  |> kafka.start(kafka.start_args())
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
  alias FluentCI.Modules.Kafka

  defplugin run do
    Flow.pipeline("kafka-start")
    |> Flow.workdir(".")
    |> Kafka.start(%{})
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
            [fluentci-modules.kafka :as kafka]))

(defn run []
  (-> (flow/pipeline "kafka-start")
      (flow/workdir ".")
      (kafka/start {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("kafka-start")
  ->Flow.workdir(".")
  ->FluentciModulesKafka.start(FluentciModulesKafka.startArgs)
  ->Flow.map(result => result.endpoint)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import kafka


def run() -> str:
    return (
        pipeline("kafka-start")
        .workdir(".")
        .pipe(kafka.start, {})
        .map(lambda result: result.endpoint)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as kafka from "./fluentci_modules/kafka/index";

export function run(): string {
  return flow.pipeline("kafka-start")
    .workdir(".")
    .pipe(kafka.start, {})
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
