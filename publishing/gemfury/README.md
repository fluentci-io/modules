# Gemfury

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.3+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run gemfury upload --files dist/app.deb,dist/app.rpm
```

```sh
fluentci run gemfury --help
fluentci run gemfury upload --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. List arguments use comma-separated strings. CSV double quotes preserve commas within a filename. Native function/flag names use kebab-case.

## Requirements and behavior

Uploads explicit files using FURY_ACCOUNT, FURY_USER, and FURY_TOKEN from the
host environment. Requires curl with --variable/--expand-user support. Returns
`uploaded` and the decoded `files` array. A missing/blank FURY_TOKEN skips uploads and reports `uploaded: false` for a valid file list; with a token present, FURY_USER and FURY_ACCOUNT are required.
All package files are checked before uploading; successful earlier uploads remain
published if a later upload fails. FURY_PACKAGE fallback is replaced by `--files`.

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

This module declares `setup-gemfury` as typed native component dependencies.
FluentCI v0.17.3+ resolves their source references while building and composes
them into the published Wasm. Consumers need no relative source paths.
Available tools are reused; missing prerequisites invoke setup with default
arguments. Explicit executable overrides remain caller-managed. Configure pinned
versions or privileged/custom installations in an earlier setup step.
See [dependency behavior and publishing](../../docs/MODULE_DEPENDENCIES.md) for
command-specific prerequisites, validation, credential skips, and CI coverage.

`files` is a required comma-separated string. Whitespace around unquoted entries is trimmed. Blank lists, empty entries between commas, malformed CSV, NUL characters and line breaks in paths are rejected before host commands or setup. To upload a filename containing a comma, quote that CSV entry, for example `--files '"dist/file,one.deb",dist/second.rpm'`. Paths are passed as literal argv values with curl multipart escaping, without shell expansion. Internal PureScript upload APIs and the returned `files` value continue to use arrays.

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.5 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add gemfury --path /path/to/fluentci-modules/publishing/gemfury
```

For a published module, use `fluentci add @fluentci.io/gemfury@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

These examples append `upload` and a native Git check to one pipeline.
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
import FluentCI.Modules.Gemfury as Dependency

run :: Effect String
run =
  Flow.pipeline "ci"
    # Flow.workdir "."
    # Dependency.upload (Dependency.uploadArgs { "files": "dist/app.deb,dist/app.rpm" })
    # Flow.exec [ "git", "diff", "--exit-code" ]
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/gemfury as dependency

pub fn run() -> String {
  flow.pipeline("ci")
  |> flow.workdir(".")
  |> dependency.upload(dependency.upload_args("dist/app.deb,dist/app.rpm"))
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
  alias FluentCI.Modules.Gemfury, as: Dependency

  defplugin run do
    Flow.pipeline("ci")
    |> Flow.workdir(".")
    |> Dependency.upload(%{"files" => "dist/app.deb,dist/app.rpm"})
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
            [fluentci-modules.gemfury :as dependency]))

(defn run []
  (-> (flow/pipeline "ci")
      (flow/workdir ".")
      (dependency/upload {:files "dist/app.deb,dist/app.rpm"})
      (flow/exec ["git" "diff" "--exit-code"])
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("ci")
  ->Flow.workdir(".")
  ->FluentciModulesGemfury.upload(FluentciModulesGemfury.uploadArgs(~files="dist/app.deb,dist/app.rpm"))
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import gemfury as dependency


def run() -> str:
    prepared = dependency.upload(
        pipeline("ci").workdir("."), {"files": "dist/app.deb,dist/app.rpm"}
    )
    return prepared.exec("git", "diff", "--exit-code").run()
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/gemfury/index";

export function run(): string {
  const prepared = dependency.upload(
    flow.workdir(flow.pipeline("ci"), "."), {"files":"dist/app.deb,dist/app.rpm"}
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
| `upload` | Upload Linux packages to Gemfury using credentials from the host environment. |
<!-- /generated:language-examples -->
