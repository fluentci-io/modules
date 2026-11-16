# AWS Emulator service

Run a background AWS Emulator test service through FluentCI's native workspace
service manager and Docker backend. Typed PureScript Wasm component; requires
FluentCI **v0.17.4+**, with the native services apply/status lifecycle API.

```sh
fluentci run aws-emulator start --state-dir /tmp/aws-emulator-material --image fluentci/aws-emulator:ci
fluentci run aws-emulator status
fluentci run aws-emulator logs --tail 50
fluentci run aws-emulator logs --tail 50 --follow true
fluentci run aws-emulator restart
fluentci run aws-emulator stop
```

For live logs, use `logs --follow true`. Press Ctrl-C to stop following; the
background service keeps running. The native shorthand is
`fluentci logs module-aws-emulator-default -f` in the same project workspace.

## Default profile

- Image: `fluentci/aws-emulator:local` (locally built, not a published image).
- Primary container port: `9297`; exposed TCP ports: `9297`.
- Readiness: `exec: HTTPS health verified with the generated CA`; startup deadline: `180000` ms.
- Native recurring health check uses the same probe by default.
- Name: `module-aws-emulator-default`; custom names must start with `module-aws-emulator-`.

Official aws/aws-emulator. Run build first or provide a prebuilt image. stateDir is required; host and container ports match. Generated credentials and TLS material remain in the caller-owned bind directory.

Default environment values are disposable CI fixtures:

- `EMULATOR_TELEMETRY=off`

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


## Official AWS Emulator image and SDK configuration

AWS does not publish a prebuilt Docker image. The build function installs the
[official AWS Emulator RPM](https://docs.aws.amazon.com/emulator/latest/userguide/getting-started-docker.html)
into Amazon Linux 2023, selecting the daemon's x86_64/aarch64 architecture. It uses
JSON-form Dockerfile instructions, not a source build or a shell-script pipeline.
The returned image tag can be passed directly to start. A custom package-url must
include package-sha256; Docker verifies that checksum during ADD. The default RPM
URL follows AWS's latest LTS distribution. Image file ownership matches the caller
so the generated private files are readable through the bind mount.

```sh
fluentci run aws-emulator build --image fluentci/aws-emulator:ci
fluentci run aws-emulator start --image fluentci/aws-emulator:ci --state-dir /tmp/aws-emulator-material --port 9297
```

state-dir is required and must be absolute. The same nonzero port is used inside
and outside the container. A second instance needs both a distinct module name
and a distinct port/material directory. Do not use random port zero for AWS.
Readiness includes checking the generated files and an HTTPS request to the native
/__admin/health endpoint using its CA, without disabling certificate verification.

The generated SDK material lives below STATE_DIR/PORT. Configure test processes
using AWS_ENDPOINT_URL=https://127.0.0.1:PORT, AWS_SHARED_CREDENTIALS_FILE pointing
to emulator_credentials, AWS_CONFIG_FILE pointing to config, and AWS_CA_BUNDLE
pointing to ca.pem. Set AWS_EC2_METADATA_DISABLED=true and
AWS_DISABLE_HOST_PREFIX_INJECTION=true. Clear credential environment variables
that take precedence over the generated files. SDKs with separate trust settings
need their documented CA option. See [AWS SDK configuration](https://docs.aws.amazon.com/emulator/latest/userguide/point-sdk-to-emulator.html).
Stop preserves the caller-owned directory; the emulator itself removes per-run
credential material on shutdown. Telemetry is disabled by this CI profile.


See [COMPONENT.md](./COMPONENT.md) for every named argument, description and native
return, [the shared service guide](../README.md) for platform/data/lifecycle
semantics, and the [upstream reference](https://github.com/aws/aws-emulator).

## Development

Mocked unit/contract tests run in normal module CI. The dedicated Services E2E
workflow builds every real component, starts/reuses/restarts/stops it through the
native manager, and checks real protocol connectivity sequentially on one runner.
No services or images are run by the source generators. License: MIT.

Default readiness and recurring health use curl inside the owned container to
verify HTTPS `/__admin/health` with its generated CA. A published TCP port alone
is insufficient because Docker may accept connections before emulator startup.
The image built by this module installs `curl-minimal`; compatible prebuilt
images must provide curl and use `/home/emulator` for generated SDK material.

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add aws-emulator --path /path/to/fluentci-modules/services/aws-emulator
```

For a published module, use `fluentci add @fluentci.io/aws-emulator@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Start aws-emulator for integration tests using fluentci/aws-emulator:local. Return the allocated endpoint to the caller; use it when configuring your test client.

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
import FluentCI.Modules.AwsEmulator as AwsEmulator

run :: Effect String
run =
  Flow.pipeline "aws-emulator-start"
    # Flow.workdir "."
    # AwsEmulator.start (AwsEmulator.startArgs { "stateDir": "/tmp/ci-aws-emulator" })
    # Flow.map (\result -> result.endpoint)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/aws_emulator

pub fn run() -> String {
  flow.pipeline("aws-emulator-start")
  |> flow.workdir(".")
  |> aws_emulator.start(aws_emulator.start_args("/tmp/ci-aws-emulator"))
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
  alias FluentCI.Modules.AwsEmulator

  defplugin run do
    Flow.pipeline("aws-emulator-start")
    |> Flow.workdir(".")
    |> AwsEmulator.start(%{"state_dir" => "/tmp/ci-aws-emulator"})
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
            [fluentci-modules.aws-emulator :as aws_emulator]))

(defn run []
  (-> (flow/pipeline "aws-emulator-start")
      (flow/workdir ".")
      (aws_emulator/start {:stateDir "/tmp/ci-aws-emulator"})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("aws-emulator-start")
  ->Flow.workdir(".")
  ->FluentciModulesAwsEmulator.start(FluentciModulesAwsEmulator.startArgs(~stateDir="/tmp/ci-aws-emulator"))
  ->Flow.map(result => result.endpoint)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import aws_emulator


def run() -> str:
    return (
        pipeline("aws-emulator-start")
        .workdir(".")
        .pipe(aws_emulator.start, {"state_dir": "/tmp/ci-aws-emulator"})
        .map(lambda result: result.endpoint)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as aws_emulator from "./fluentci_modules/aws-emulator/index";

export function run(): string {
  return flow.pipeline("aws-emulator-start")
    .workdir(".")
    .pipe(aws_emulator.start, {"stateDir":"/tmp/ci-aws-emulator"})
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
| `build` | Build the official AWS Emulator package into a local Docker image without starting it. |
<!-- /generated:language-examples -->
