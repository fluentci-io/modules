# Setup GitHub CLI

Install a selected GitHub CLI release and configure PATH for CI/CD pipelines.
This PureScript Wasm component requires FluentCI v0.17.2+.

```sh
fluentci run setup-gh setup --version 2.103.3
fluentci run setup-gh setup --help
```

## Platforms

| OS | Installation |
| --- | --- |
| Linux | Official GitHub CLI tar.gz release for amd64 or arm64. |
| macOS | Official GitHub CLI ZIP release for amd64 or arm64. |
| FreeBSD | Native `gh` package using `pkg`. |
| NetBSD | Native `gh` package using `pkgin`. |
| OpenBSD | Native `gh` package using `pkg_add`. |

Linux/macOS support x86_64/aarch64 CPU aliases. The default version is `latest`;
exact releases may include the `v` prefix. Archive downloads verify an upstream
SHA-256 digest when the GitHub release API provides one, then execute `gh --version`
to verify the selected release.

BSD support uses native packages, never Linux binaries. Package/version
availability depends on the configured repository and OS/CPU. Use `--package-name`
for an explicit native package selector and `--sudo` for noninteractive privilege
elevation when needed. Missing packages or version mismatches fail the call.
BSD command selection is tested with fixtures; a particular package repository
still needs verification on a real BSD runner.

Archive installs preserve adjacent resources under
`$HOME/.local/share/fluentci/gh/VERSION`, or an absolute `--install-dir`. Existing
matching installations are verified and reused. Native packages use the system
prefix and do not accept a custom installation directory.

No login or authenticated GitHub operation is performed during setup. Supply
`GH_TOKEN` or native GitHub CLI authentication separately for later pipeline
commands.

The result contains `tool`, `version`, `bin-dir`, and `environment` records.
Environment updates apply within the host session. Separate CLI processes must
add the returned installation directory to PATH explicitly. See
[COMPONENT.md](./COMPONENT.md) for all typed arguments and returns.

## Development

```sh
bun install --cwd ../../lib/component --frozen-lockfile
npm ci
npm run build
npm test
```

[GitHub CLI releases](https://github.com/cli/cli/releases) · [MIT License](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-gh --path /path/to/fluentci-modules/setup/gh
```

For a published module, use `fluentci add @fluentci.io/setup-gh@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision gh before the build steps that require it. The setup result reports the installed version and executable directory.

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
import FluentCI.Modules.SetupGh as SetupGh

run :: Effect String
run =
  Flow.pipeline "setup-gh-setup"
    # Flow.workdir "."
    # SetupGh.setup (SetupGh.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_gh

pub fn run() -> String {
  flow.pipeline("setup-gh-setup")
  |> flow.workdir(".")
  |> setup_gh.setup(setup_gh.setup_args())
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
  alias FluentCI.Modules.SetupGh

  defplugin run do
    Flow.pipeline("setup-gh-setup")
    |> Flow.workdir(".")
    |> SetupGh.setup(%{})
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
            [fluentci-modules.setup-gh :as setup_gh]))

(defn run []
  (-> (flow/pipeline "setup-gh-setup")
      (flow/workdir ".")
      (setup_gh/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-gh-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupGh.setup(FluentciModulesSetupGh.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_gh


def run() -> str:
    return (
        pipeline("setup-gh-setup")
        .workdir(".")
        .pipe(setup_gh.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_gh from "./fluentci_modules/setup-gh/index";

export function run(): string {
  return flow.pipeline("setup-gh-setup")
    .workdir(".")
    .pipe(setup_gh.setup, {})
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
| `setup` | Install and verify gh, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
