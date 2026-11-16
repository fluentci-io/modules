# Setup uv

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.2+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run setup-uv setup --version latest \
  --python-version 3.13 --tools ruff==0.12.0,httpie
```

```sh
fluentci run setup-uv --help
fluentci run setup-uv setup --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. List arguments use comma-separated strings; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Installs and verifies `uv`, then returns `tool`, `version`, `bin-dir`, and
`environment` (a list of `{name, value}` records). Environment updates are visible
to later tasks in the same host session. Separate shell invocations must add the
returned installation directory to PATH explicitly.


## Optional Python and tools

`--python-version` requests a Python release or interpreter selector, such as
`3.13`, `3.13.5`, or `cpython-3.13.5`. Linux/macOS install the managed interpreter
through `uv python install`, then verify its executable and expose `python` and
`python3` shims on PATH. `UV_PYTHON` selects that interpreter for later uv commands.
`--version` continues to select the uv release, not Python.

`--tools` accepts a comma-separated list of Python CLI packages, optionally with
a single native version constraint: `ruff==0.12.0,httpie>=3`. Tools are installed
using `uv tool install` into isolated environments. Bare names, single extras
such as `mypy[faster-cache]`, and single comparison constraints are accepted;
compound constraints containing commas and direct URLs are not supported by this
list input. Tool requests are passed as literal arguments without shell expansion.
The requested Python is used for all tools when supplied; otherwise uv resolves
an interpreter using its normal rules. Repeated setup replaces the requested tool
installations in the module's own tool store using `--force`.

Both options are optional. Omitted or blank tools install no tools; omitted or
empty Python version does not explicitly install/select Python. Supplying neither
retains uv-only setup. Entries are trimmed; malformed lists and empty entries are
rejected before any host command. Tool or interpreter failures fail setup before
publishing environment changes. Successful downloads can remain for retry.

Managed environments are stored under
`$HOME/.local/share/fluentci/uv-environments/UV_VERSION/PYTHON_SELECTOR`, separate
from application environments. Returned environment values include the uv and
requested executable directories on PATH, plus uv's managed Python/tool storage
variables. Propagate the full returned environment between separate processes.

Linux/macOS retain the existing per-user uv installer, which requires a bootstrap
`python3` with virtual-environment support. The optional managed Python is installed
after uv itself. FreeBSD, OpenBSD, and NetBSD use
native uv packages; missing packages/versions fail clearly. On BSD, a requested
Python must already be installed and discoverable by uv; automatic Python
downloads are disabled for both interpreter discovery and tool installation.
Unavailable or incompatible interpreters/tools fail clearly. Setup does not
change shell startup files or project dependency manifests.

See uv's [Python guide](https://docs.astral.sh/uv/guides/install-python/) and
[tool guide](https://docs.astral.sh/uv/guides/tools/) for native behavior.

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

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-uv --path /path/to/fluentci-modules/setup/uv
```

For a published module, use `fluentci add @fluentci.io/setup-uv@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Provision uv before the build steps that require it. The setup result reports the installed version and executable directory.

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
import FluentCI.Modules.SetupUv as SetupUv

run :: Effect String
run =
  Flow.pipeline "setup-uv-setup"
    # Flow.workdir "."
    # SetupUv.setup (SetupUv.setupArgs)
    # Flow.map (\result -> result.version)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_uv

pub fn run() -> String {
  flow.pipeline("setup-uv-setup")
  |> flow.workdir(".")
  |> setup_uv.setup(setup_uv.setup_args())
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
  alias FluentCI.Modules.SetupUv

  defplugin run do
    Flow.pipeline("setup-uv-setup")
    |> Flow.workdir(".")
    |> SetupUv.setup(%{})
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
            [fluentci-modules.setup-uv :as setup_uv]))

(defn run []
  (-> (flow/pipeline "setup-uv-setup")
      (flow/workdir ".")
      (setup_uv/setup {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("setup-uv-setup")
  ->Flow.workdir(".")
  ->FluentciModulesSetupUv.setup(FluentciModulesSetupUv.setupArgs)
  ->Flow.map(result => result.version)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_uv


def run() -> str:
    return (
        pipeline("setup-uv-setup")
        .workdir(".")
        .pipe(setup_uv.setup, {})
        .map(lambda result: result.version)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as setup_uv from "./fluentci_modules/setup-uv/index";

export function run(): string {
  return flow.pipeline("setup-uv-setup")
    .workdir(".")
    .pipe(setup_uv.setup, {})
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
| `setup` | Install and verify uv, optionally configure a Python version and isolated tools, and publish their environment. |
<!-- /generated:language-examples -->
