# Setup curl

Install or verify curl with a typed PureScript Wasm component. Requires FluentCI
v0.17.3+. Supports Linux, macOS, FreeBSD, OpenBSD and NetBSD native repositories.

```sh
fluentci run setup-curl setup
fluentci run setup-curl setup --version 8.17.0
fluentci run setup-curl setup --sudo
fluentci run setup-curl setup --help
```

A matching executable already on PATH is verified and reused. Otherwise the
module selects apt/dnf/yum/apk/pacman/zypper, Homebrew/MacPorts, pkg, pkg_add or
pkgin as appropriate. Version pins and `packageName` selectors must be available
in the configured native repository. `sudo` enables noninteractive elevation;
Homebrew runs as the current user. Native packages do not accept `installDir`.

Returns `tool`, `version`, `binDir`, and `environment` (name/value records), and
publishes PATH to later tasks in the same host session. Failures never report a
successful installation. Notification modules require curl >= 8.3.0; an older
system curl must be upgraded to an available compatible version before sending.

See [COMPONENT.md](./COMPONENT.md), the [curl manual](https://curl.se/docs/manpage.html),
and [MIT License](./LICENSE). Runtime build and regression verification run in CI.

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-curl --path /path/to/fluentci-modules/setup/curl
```

For a published module, use `fluentci add @fluentci.io/setup-curl@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision curl before the build steps that require it. The setup result reports the installed version and executable directory.

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
import FluentCI.Modules.SetupCurl as SetupCurl

run :: Effect String
run =
  Flow.pipeline "setup-curl-setup"
    # Flow.workdir "."
    # SetupCurl.setup (SetupCurl.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_curl

pub fn run() -> String {
  flow.pipeline("setup-curl-setup")
  |> flow.workdir(".")
  |> setup_curl.setup(setup_curl.setup_args())
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
  alias FluentCI.Modules.SetupCurl

  defplugin run do
    Flow.pipeline("setup-curl-setup")
    |> Flow.workdir(".")
    |> SetupCurl.setup(%{})
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
            [fluentci-modules.setup-curl :as setup_curl]))

(defn run []
  (-> (flow/pipeline "setup-curl-setup")
      (flow/workdir ".")
      (setup_curl/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-curl-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupCurl.setup(FluentciModulesSetupCurl.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_curl


def run() -> str:
    return (
        pipeline("setup-curl-setup")
        .workdir(".")
        .pipe(setup_curl.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_curl from "./fluentci_modules/setup-curl/index";

export function run(): string {
  return flow.pipeline("setup-curl-setup")
    .workdir(".")
    .pipe(setup_curl.setup, {})
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
| `setup` | Install and verify curl, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
