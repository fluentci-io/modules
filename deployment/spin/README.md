# Spin

Build WebAssembly applications, publish/pull OCI artifacts, install deployment plugins, and deploy through Spin's plugin interface with typed PureScript CI/CD functions. Requires FluentCI v0.17.3+.

```sh
fluentci run setup-spin setup --version 4.3.0
fluentci run spin build --run-dir /tmp/spin-build-1 --from spin.toml --components api,worker
fluentci run spin registry-push --run-dir /tmp/spin-push-1 --reference ghcr.io/example/app:1.0.0 --from spin.toml --annotations org.opencontainers.image.revision=abc123
fluentci run spin registry-pull --run-dir /tmp/spin-pull-1 --reference ghcr.io/example/app:1.0.0 --prepare prepared-app
fluentci run spin plugins-install --run-dir /tmp/spin-plugin-1 --name cloud --yes
fluentci run spin cloud-login --run-dir /tmp/spin-login-1
fluentci run spin cloud-deploy --run-dir /tmp/spin-deploy-1 --from spin.toml --variables stage=ci --readiness-timeout 60
```

Named core flags target Spin 4.3.0. `build` uses the toolchains configured by `spin.toml`, which must be installed separately. Registry operations use the runner's native OCI credentials; authenticate the registry before pushing/pulling. The wrapper does not expose a plaintext registry password argument or claim to supply stdin to `spin registry login`. Prepare authentication in a prior runner step using the native CLI's password-stdin support when needed. See [COMMANDS.md](./COMMANDS.md), [COMPONENT.md](./COMPONENT.md) and [OPTIONS.md](./OPTIONS.md).

Spin 4's `deploy` alias requires `SPIN_DEPLOY_PLUGIN` to identify the installed plugin. This module's generic `deploy` forwards only CSV `arguments`, so it does not invent a universal plugin contract. Use `cloud-deploy` for the explicitly supported Fermyon cloud plugin. Install it with `plugins-install --name cloud --yes`; pin with `--plugin-version` when needed. The approval flag is explicit, and setup does not silently install deployment plugins. `plugins-list` checks installations. Missing/incompatible plugins fail the native operation and the module call.

For Fermyon Cloud set `SPIN_AUTH_TOKEN` from the CI secret store and call `cloud-login`, which selects token authentication without a browser flow, then `cloud-deploy`. Use native saved environments or `--environment-name` to select an instance. `--variables`, `--key-values` and `--links` customize deployment. Variable/key-value arguments can appear in task reports; prefer the provider's secret configuration for sensitive data.

All list arguments are comma-separated strings. Components, OCI annotations, component environment values and cloud variables become repeated literal flags. KEY=VALUE list entries are validated before host commands; malformed CSV, empty entries and NUL characters fail early. Optional blank lists keep native defaults. CSV double quotes preserve embedded commas. `run --arguments=registry,push,--help` exposes further native features. `--compose false` is represented correctly as the single native token `--compose=false` through `--compose=false` on this module as well. TLS verification is enabled unless `--insecure` is explicitly requested.

The component depends on [setup-spin](../../setup/spin/README.md), installs a missing CLI and reuses available tools. To pin a CLI run setup first; explicit `--executable` overrides skip automatic setup. Published components compose dependencies and require no repository-relative source paths. CLI setup does not initialize a project or cloud account.

Each invocation requires a fresh `--run-dir`. Native build, plugin, push/pull and deployment failures propagate as module errors. Success returns typed `outcome`, `run-dir`, `report-path`, `stdout-path` and `stderr-path`; it does not fabricate a provider-independent deployment response. Use CSV `--artifacts NAME=PATH` to collect output files, archiving directories first. `up` runs in the foreground: use a scoped service lifecycle and bounded `--timeout-ms`; it does not deploy to a remote platform.

[Spin CLI reference](https://spinframework.dev/v4/cli-reference) · [Fermyon plugin reference](https://developer.fermyon.com/cloud/cloud-command-reference) · [MIT wrapper license](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add spin --path /path/to/fluentci-modules/deployment/spin
```

For a published module, use `fluentci add @fluentci.io/spin@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

These examples append `build` and a native Git check to one pipeline.
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
import FluentCI.Modules.Spin as Dependency

run :: Effect String
run =
  Flow.pipeline "ci"
    # Flow.workdir "."
    # Dependency.build (Dependency.buildArgs)
    # Flow.exec [ "git", "diff", "--exit-code" ]
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/spin as dependency

pub fn run() -> String {
  flow.pipeline("ci")
  |> flow.workdir(".")
  |> dependency.build(dependency.build_args())
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
  alias FluentCI.Modules.Spin, as: Dependency

  defplugin run do
    Flow.pipeline("ci")
    |> Flow.workdir(".")
    |> Dependency.build(%{})
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
            [fluentci-modules.spin :as dependency]))

(defn run []
  (-> (flow/pipeline "ci")
      (flow/workdir ".")
      (dependency/build {})
      (flow/exec ["git" "diff" "--exit-code"])
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("ci")
  ->Flow.workdir(".")
  ->FluentciModulesSpin.build(FluentciModulesSpin.buildArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import spin as dependency


def run() -> str:
    return (
        pipeline("ci")
        .workdir(".")
        .pipe(dependency.build, {})
        .exec("git", "diff", "--exit-code")
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/spin/index";

export function run(): string {
  return flow.pipeline("ci")
    .workdir(".")
    .pipe(dependency.build, {})
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
| `run` | Execute additional Spin or plugin commands with literal CSV arguments. |
| `version` | Print the installed Spin version. |
| `build` | Build application components with the project toolchains. |
| `registry_push` | Push an application as an OCI artifact using native registry credentials. |
| `registry_pull` | Pull an application from an OCI registry. |
| `deploy` | Deploy through the plugin named by SPIN_DEPLOY_PLUGIN; arguments are plugin-specific. |
| `cloud_deploy` | Deploy through the explicitly installed Fermyon cloud plugin. |
| `cloud_login` | Authenticate the cloud plugin using inherited SPIN_AUTH_TOKEN without browser login. |
| `plugins_install` | Install a selected deployment/runtime plugin explicitly. |
| `plugins_list` | Inspect installed Spin plugins. |
| `up` | Run an application in the foreground; use a scoped lifecycle and bounded timeout. |
<!-- /generated:language-examples -->
