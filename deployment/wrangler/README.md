# Cloudflare Wrangler

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.3+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run wrangler deploy --run-dir .fluentci/run-001
```

```sh
fluentci run wrangler --help
fluentci run wrangler deploy --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Install setup-wrangler or provide Wrangler on PATH. Supply CLOUDFLARE_API_TOKEN and CLOUDFLARE_ACCOUNT_ID through the CI environment. dry_run bundles locally; deploy and pages_deploy publish immediately. versions_upload creates a version without switching traffic. Pages deployment requires an existing Pages project.

The return value is a typed record containing `outcome`, `run-dir`, `report-path`,
`stdout-path`, and `stderr-path`. Each invocation needs a fresh run directory.
Native command failures, cancellation, and timeouts fail the component call.
Use `--artifacts '["package=dist/package.zip"]'` to declare output files for the
execution report. Authentication stays in native configuration or host environment.

## Development

From this module directory, with Node.js, Bun, PureScript, and Spago installed:

```sh
bun install --cwd ../../lib/component --frozen-lockfile
npm ci
npm run build
npm test
```

`dist/plugin.wasm` is the native component; `dist/fluentci.metadata.json` is its
checksummed contract sidecar. The CJS bundles and `legacy-entry.mjs` exist only for
private regression tests and are not the published module interface.

See the [component migration guide](../../docs/COMPONENTS.md) and
[MIT License](./LICENSE).

## Setup component dependency

This module declares `setup-wrangler` as typed native component dependencies.
FluentCI v0.17.3+ resolves their source references while building and composes
them into the published Wasm. Consumers need no relative source paths.
Available tools are reused; missing prerequisites invoke setup with default
arguments. Explicit executable overrides remain caller-managed. Configure pinned
versions or privileged/custom installations in an earlier setup step.
See [dependency behavior and publishing](../../docs/MODULE_DEPENDENCIES.md) for
command-specific prerequisites, validation, credential skips, and CI coverage.

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add wrangler --path /path/to/fluentci-modules/deployment/wrangler
```

For a published module, use `fluentci add @fluentci.io/wrangler@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Deploy a Worker using existing Cloudflare credentials.

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
import FluentCI.Modules.Wrangler as Wrangler

run :: Effect String
run =
  Flow.pipeline "wrangler-deploy"
    # Flow.workdir "."
    # Wrangler.deploy (Wrangler.deployArgs)
    # Flow.map (\result -> result.reportPath)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/wrangler

pub fn run() -> String {
  flow.pipeline("wrangler-deploy")
  |> flow.workdir(".")
  |> wrangler.deploy(wrangler.deploy_args())
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
  alias FluentCI.Modules.Wrangler

  defplugin run do
    Flow.pipeline("wrangler-deploy")
    |> Flow.workdir(".")
    |> Wrangler.deploy(%{})
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
            [fluentci-modules.wrangler :as wrangler]))

(defn run []
  (-> (flow/pipeline "wrangler-deploy")
      (flow/workdir ".")
      (wrangler/deploy {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("wrangler-deploy")
  ->Flow.workdir(".")
  ->FluentciModulesWrangler.deploy(FluentciModulesWrangler.deployArgs)
  ->Flow.map(result => result.reportPath)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import wrangler


def run() -> str:
    return (
        pipeline("wrangler-deploy")
        .workdir(".")
        .pipe(wrangler.deploy, {})
        .map(lambda result: result.report_path)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as wrangler from "./fluentci_modules/wrangler/index";

export function run(): string {
  return flow.pipeline("wrangler-deploy")
    .workdir(".")
    .pipe(wrangler.deploy, {})
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
| `run` | Run a Wrangler operation with literal arguments. |
| `version` | Report the installed Wrangler version. |
| `deploy` | Deploy a Worker using existing Cloudflare credentials. |
| `dry_run` | Bundle a Worker locally without deploying it. |
| `versions_upload` | Upload a Worker version without deploying it to traffic. |
| `pages_deploy` | Deploy a built site to an existing Cloudflare Pages project. |
| `pages_projects` | List Cloudflare Pages projects available to the authenticated account. |
<!-- /generated:language-examples -->
