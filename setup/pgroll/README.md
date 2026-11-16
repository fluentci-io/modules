# Setup pgroll

Install a selected pgroll release, verify its version, and configure PATH for
CI/CD pipelines. Implemented in PureScript as a typed Wasm component for
FluentCI v0.17.2+.

```sh
fluentci run setup-pgroll setup --version 0.16.3
fluentci run setup-pgroll setup --help
```

The default version is `latest`; exact releases may include `v`. Linux and macOS
on x86_64 or aarch64 use official `xataio/pgroll` standalone release binaries.
A GitHub release SHA-256 digest is verified when provided, and `pgroll --version`
checks the installed release. Missing platform assets, checksum failures, and
version mismatches fail setup.

Per-user installations use `$HOME/.local/share/fluentci/pgroll/VERSION` or an
absolute `--install-dir`. A verified existing installation is reused. No Go,
Node.js, PostgreSQL server, authentication, or database provisioning is required
for setup itself.

FreeBSD, NetBSD, and OpenBSD use native `pgroll` packages when available; upstream
provides no BSD binary. Package availability depends on the runner's repositories.
For native packages omit `--install-dir`, optionally set `--package-name`, and use
`--sudo` for noninteractive elevation if needed. Unavailable packages fail clearly.

Returns typed `tool`, `version`, `bin-dir`, and `environment` values. Environment
updates apply to subsequent host tasks; separate processes must propagate the
returned variables. See [COMPONENT.md](./COMPONENT.md) for all arguments and returns.

Use [the pgroll database module](../../databases/pgroll/README.md) for migrations.
[Official releases](https://github.com/xataio/pgroll/releases) · [MIT wrapper license](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-pgroll --path /path/to/fluentci-modules/setup/pgroll
```

For a published module, use `fluentci add @fluentci.io/setup-pgroll@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision pgroll before the build steps that require it. The setup result reports the installed version and executable directory.

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
import FluentCI.Modules.SetupPgroll as SetupPgroll

run :: Effect String
run =
  Flow.pipeline "setup-pgroll-setup"
    # Flow.workdir "."
    # SetupPgroll.setup (SetupPgroll.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_pgroll

pub fn run() -> String {
  flow.pipeline("setup-pgroll-setup")
  |> flow.workdir(".")
  |> setup_pgroll.setup(setup_pgroll.setup_args())
  |> flow.map(fn(result) { result.version })
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
  alias FluentCI.Modules.SetupPgroll

  defplugin run do
    Flow.pipeline("setup-pgroll-setup")
    |> Flow.workdir(".")
    |> SetupPgroll.setup(%{})
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
            [fluentci-modules.setup-pgroll :as setup_pgroll]))

(defn run []
  (-> (flow/pipeline "setup-pgroll-setup")
      (flow/workdir ".")
      (setup_pgroll/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-pgroll-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupPgroll.setup(FluentciModulesSetupPgroll.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_pgroll


def run() -> str:
    return (
        pipeline("setup-pgroll-setup")
        .workdir(".")
        .pipe(setup_pgroll.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_pgroll from "./fluentci_modules/setup-pgroll/index";

export function run(): string {
  return flow.pipeline("setup-pgroll-setup")
    .workdir(".")
    .pipe(setup_pgroll.setup, {})
    .map(result => result.version)
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
| `setup` | Install and verify pgroll, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
