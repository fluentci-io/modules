# Dpkg

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.3+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run dpkg build --directory package --arch arm64 --output dist/widget_1.2.0_arm64.deb
```

```sh
fluentci run dpkg --help
fluentci run dpkg build --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Linux-only; requires dpkg, dpkg-deb, and GNU coreutils.
`validate` returns a boolean after validating the tree and CPU architecture.
`build` returns a native list of generated package paths. Selecting an architecture
does not cross-compile the payload.

## Directory layout

Prepare a binary package root, with installed paths relative to that root:

```text
package/
├── DEBIAN/
│   └── control
└── usr/
    └── share/
        └── widget/
            └── message.txt
```

For example, `package/DEBIAN/control`:

```debcontrol
Package: widget
Version: 1.2.0
Architecture: arm64
Maintainer: Example <packages@example.org>
Description: My application
```

Use `DEBIAN` in uppercase. A source package's `debian/control` layout is not
accepted. Metadata must contain one binary package paragraph and exactly one
nonempty `Package`, `Version`, `Architecture`, `Maintainer`, and `Description`
field. Package names and versions are validated by `dpkg`. Optional maintainer
scripts belong under `DEBIAN/` and must have the permissions required by dpkg.
Payload paths and dependencies are your choice; metadata-only packages are
also supported.

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

This module declares `setup-dpkg` as typed native component dependencies.
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
fluentci add dpkg --path /path/to/fluentci-modules/packaging/dpkg
```

For a published module, use `fluentci add @fluentci.io/dpkg@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Build packages from a Linux dpkg package tree and target architecture.

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
import Data.Array as Array
import Effect (Effect)
import FluentCI.Flow as Flow
import FluentCI.Modules.Dpkg as Dpkg

run :: Effect String
run =
  Flow.pipeline "dpkg-build"
    # Flow.workdir "."
    # Dpkg.build (Dpkg.buildArgs { "directory": "packaging/debian", "arch": "amd64" })
    # Flow.map (\result -> show (Array.length result))
    # Flow.run
```

### Gleam

```gleam
import gleam/int
import gleam/list
import fluentci/flow
import fluentci_modules/dpkg

pub fn run() -> String {
  flow.pipeline("dpkg-build")
  |> flow.workdir(".")
  |> dpkg.build(dpkg.build_args("packaging/debian", "amd64"))
  |> flow.map(fn(result) { int.to_string(list.length(result)) })
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
  alias FluentCI.Modules.Dpkg

  defplugin run do
    Flow.pipeline("dpkg-build")
    |> Flow.workdir(".")
    |> Dpkg.build(%{"directory" => "packaging/debian", "arch" => "amd64"})
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
            [fluentci-modules.dpkg :as dpkg]))

(defn run []
  (-> (flow/pipeline "dpkg-build")
      (flow/workdir ".")
      (dpkg/build {:directory "packaging/debian", :arch "amd64"})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("dpkg-build")
  ->Flow.workdir(".")
  ->FluentciModulesDpkg.build(FluentciModulesDpkg.buildArgs(~directory="packaging/debian", ~arch="amd64"))
  ->Flow.map(result => Js.Int.toString(Belt.Array.length(result)))
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import dpkg


def run() -> str:
    return (
        pipeline("dpkg-build")
        .workdir(".")
        .pipe(dpkg.build, {"directory": "packaging/debian", "arch": "amd64"})
        .map(lambda result: str(len(result)))
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dpkg from "./fluentci_modules/dpkg/index";

export function run(): string {
  return flow.pipeline("dpkg-build")
    .workdir(".")
    .pipe(dpkg.build, {"directory":"packaging/debian","arch":"amd64"})
    .map(result => String(result.length))
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
| `build` | Build packages from a Linux dpkg package tree and target architecture. |
| `validate` | Validate a Linux dpkg package tree and target architecture. |
<!-- /generated:language-examples -->
