# Depot

Typed PureScript WebAssembly component for Depot remote container builds. Requires FluentCI v0.17.3+.

```sh
fluentci run depot setup --version latest
fluentci run depot build --run-dir /tmp/depot-build-001 --project-id my-project --context . --tags ghcr.io/acme/app:latest --platforms linux/amd64,linux/arm64 --push
fluentci run depot bake --run-dir /tmp/depot-bake-001 --files docker-bake.hcl --targets app,worker --push
fluentci run depot list-builds --run-dir /tmp/depot-list-001 --project-id my-project
fluentci run depot run --run-dir /tmp/depot-native-001 --arguments projects,trust-policy,list,--output,json
```

Every operation runs a setup preflight, including calls with an explicit executable.
A usable installed Depot CLI skips installation; missing tools use the typed
[setup-depot](../../setup/depot/README.md) dependency and are checked again before execution.
Explicit `setup` installs or reuses a verified version, returns tool/version/bin-dir/environment,
and accepts version, install-dir, package-name and sudo. Official archive installs are per-user;
omit package-name and sudo. An explicit install-dir selects a managed prefix.
Only Linux and macOS on x86_64/aarch64 are supported; other hosts fail before installation.

Authentication uses inherited `DEPOT_TOKEN` or Depot's native CI OIDC support.
Configure `DEPOT_PROJECT_ID`, commit depot.json, or pass project-id. Do not pass tokens
in argument lists. Remote builds do not require a local Docker daemon; load and
configure-docker require Docker. Organization-level operations require the appropriate
organization token and permissions. Cache reset and build cancellation mutate remote state;
bulk cancellation requires explicit native flags and is never silently approved.

Lists accept comma-separated strings, never JSON arrays or objects. Whitespace is
trimmed and empty entries are rejected before setup. Use CSV double quotes around an
entry containing commas, for example `--cache-to '"type=registry,ref=ghcr.io/acme/cache,mode=max"'`.
Tokens are literal argv, with no shell expansion. Blank optional lists add no arguments.

Exports cover setup, build, bake, build cancellation, cache reset, machine-readable
build/project listings, project creation/inspection, Docker configuration, version,
and a literal `run` escape hatch for every other upstream command. See
[COMPONENT.md](./COMPONENT.md) for typed arguments and returns and [OPTIONS.md](./OPTIONS.md)
for native flags. Each operation needs a fresh run-dir and returns report and log paths.
Nonzero exit, timeout, setup, and transport failures propagate without successful results.

Installation uses official [Depot CLI releases](https://github.com/depot/cli/releases),
checks SHA-256 from GitHub asset metadata or the exact release checksum entry, verifies
its executable version, and publishes PATH. A failed download never reports setup success.
The reviewed native commands are documented in [Depot's CLI reference](https://depot.dev/docs/cli/reference/container-builds).

## Development

CI builds and runs the mocked contract, installer, dependency, and command-plan regression suites.
The shared catalogs and generators keep source descriptions, schemas, WIT inputs, and docs aligned.
License: MIT.

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add depot --path /path/to/fluentci-modules/containers/depot
```

For a published module, use `fluentci add @fluentci.io/depot@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Build container images on Depot remote builders, optionally pushing, loading, or saving the result.

Replace the sample organization, paths and identifiers with your own. Configure
credentials through your CI secret provider before running authenticated operations. Optional arguments use the
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
import FluentCI.Modules.Depot as Depot

run :: Effect String
run =
  Flow.pipeline "depot-build"
    # Flow.workdir "."
    # Depot.build (Depot.buildArgs)
    # Flow.map (\result -> result.reportPath)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/depot

pub fn run() -> String {
  flow.pipeline("depot-build")
  |> flow.workdir(".")
  |> depot.build(depot.build_args())
  |> flow.map(fn(result) { result.report_path })
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
  alias FluentCI.Modules.Depot

  defplugin run do
    Flow.pipeline("depot-build")
    |> Flow.workdir(".")
    |> Depot.build(%{})
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
            [fluentci-modules.depot :as depot]))

(defn run []
  (-> (flow/pipeline "depot-build")
      (flow/workdir ".")
      (depot/build {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("depot-build")
  ->Flow.workdir(".")
  ->FluentciModulesDepot.build(FluentciModulesDepot.buildArgs)
  ->Flow.map(result => result.reportPath)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import depot


def run() -> str:
    return (
        pipeline("depot-build")
        .workdir(".")
        .pipe(depot.build, {})
        .map(lambda result: result.report_path)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as depot from "./fluentci_modules/depot/index";

export function run(): string {
  return flow.pipeline("depot-build")
    .workdir(".")
    .pipe(depot.build, {})
    .map(result => result.reportPath)
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
| `setup` | Ensure depot is installed and verified, reusing an available matching version, and publish its environment. |
| `run` | Run any Depot CLI command using literal comma-separated tokens. |
| `version` | Report the installed Depot CLI version. |
| `build` | Build container images on Depot remote builders, optionally pushing, loading, or saving the result. |
| `bake` | Build multiple targets from Bake or Compose definitions. |
| `cache_reset` | Reset the selected project build cache. |
| `list_builds` | List recent builds with machine-readable output. |
| `projects_list` | List accessible projects without opening an interactive selector. |
| `projects_get` | Read project configuration using an organization token. |
| `projects_create` | Create a Depot project with explicit organization and build storage settings. |
| `build_cancel` | Cancel selected builds or explicitly preview/bulk-cancel running project builds. Requires an organization API token. |
| `configure_docker` | Configure or remove Depot Docker integration; requires Docker. |
<!-- /generated:language-examples -->
