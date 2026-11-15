# Setup MacPorts

Install the official signed MacPorts system package for the current macOS
release and verify `/opt/local/bin/port`. This typed PureScript Wasm component
requires FluentCI v0.17.2+.

```sh
fluentci run setup-macports setup --version 2.12.7 --packages git,cmake,ninja --sudo
fluentci run setup-macports setup --help
```

macOS only, on Intel and Apple Silicon. Setup selects the release `.pkg` matching
`sw_vers -productVersion`, verifies the upstream SHA-256 and package signature,
then invokes Apple's `installer`. A missing matching package or digest fails
before installation. Linux and BSD hosts fail before mutation.

The default is `latest`; exact versions may include `v`. A new system install
requires root or explicit `--sudo` (noninteractive `sudo -n`). The official
installer fixes the prefix at `/opt/local`; `--install-dir` and `--package-name`
are rejected. Existing installations are reused only if they match the selected
release; a mismatch fails without replacing the installation. The native package
may initialize its ports tree as part of its upstream post-install procedure.

`packages` optionally installs a comma-separated list of port names, such as
`git,cmake,ninja,python312`, after the CLI is verified. Whitespace around names is
trimmed; omitted or blank values retain CLI-only setup. Empty entries and invalid
names fail before any host command. Package versions come from the configured
ports tree; this argument does not fetch arbitrary historical versions.

Setup invokes `/opt/local/bin/port -N install` with the requested names. Use
`--sudo` for noninteractive privilege elevation; otherwise the command runs with
the current user's permissions. A failed package install fails setup without
publishing a successful environment. Already installed files may remain.

Xcode Command Line Tools, accepted licenses, configured sources, and permissions
for port installation remain runner prerequisites. This module always verifies
and invokes native MacPorts at its fixed path, even if the Rust `port`
implementation is earlier on PATH.

Returns `tool`, `version`, `bin-dir`, and `environment`; publishes `/opt/local/bin`
for subsequent host tasks, plus `/opt/local/sbin` when packages are requested. Separate CLI processes must propagate the returned
environment. See [COMPONENT.md](./COMPONENT.md) for typed arguments and returns.

[MacPorts installation guide](https://guide.macports.org/#installing.macports) ·
[Upstream releases](https://github.com/macports/macports-base/releases) ·
[MIT module license](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.5 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-macports --path /path/to/fluentci-modules/setup/macports
```

For a published module, use `fluentci add @fluentci.io/setup-macports@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

These examples append `setup` and a native Git check to one pipeline.
Replace sample paths and identifiers with your own. Optional arguments use the
callee's defaults, and public list fields use comma-separated strings. See
[COMPONENT.md](./COMPONENT.md) for argument descriptions and return types.

The 0.17.5 composition API is an initial foundation. These examples follow its
generated API; full cross-SDK compilation and execution coverage is still pending.
See [composition support and limitations](../../docs/COMPOSITION.md).



### PureScript

```purescript
module Main where

import Prelude
import Effect (Effect)
import FluentCI.Flow as Flow
import FluentCI.Modules.SetupMacports as Dependency

run :: Effect String
run =
  Flow.pipeline "ci"
    # Flow.workdir "."
    # Dependency.setup (Dependency.setupArgs)
    # Flow.exec [ "git", "diff", "--exit-code" ]
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_macports as dependency

pub fn run() -> String {
  flow.pipeline("ci")
  |> flow.workdir(".")
  |> dependency.setup(dependency.setup_args())
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
  alias FluentCI.Modules.SetupMacports, as: Dependency

  defplugin run do
    Flow.pipeline("ci")
    |> Flow.workdir(".")
    |> Dependency.setup(%{})
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
            [fluentci-modules.setup-macports :as dependency]))

(defn run []
  (-> (flow/pipeline "ci")
      (flow/workdir ".")
      (dependency/setup {})
      (flow/exec ["git" "diff" "--exit-code"])
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("ci")
  ->Flow.workdir(".")
  ->FluentciModulesSetupMacports.setup(FluentciModulesSetupMacports.setupArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_macports as dependency


def run() -> str:
    prepared = dependency.setup(
        pipeline("ci").workdir("."), {}
    )
    return prepared.exec("git", "diff", "--exit-code").run()
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/setup-macports/index";

export function run(): string {
  const prepared = dependency.setup(
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
| `setup` | Install and verify macports, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
