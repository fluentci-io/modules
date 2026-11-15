# Rpmbuild

Native WebAssembly component written in PureScript. Requires **FluentCI v0.17.3+**.
Function signatures and argument descriptions come from the compiled PureScript
source and are embedded in the component; no raw JSON plugin input is required.

## Usage

```sh
fluentci run rpmbuild build --directory rpm-tree --spec widget.spec --arch aarch64 --output dist/rpm
```

```sh
fluentci run rpmbuild --help
fluentci run rpmbuild build --help
```

See [COMPONENT.md](./COMPONENT.md) for every named argument, description,
required flag, and return type. The [schema](./schema.json) describes the same
contract. Optional values retain the native module defaults. Lists use JSON array
syntax; boolean arguments accept switches. Native function/flag names use kebab-case.

## Requirements and behavior

Linux-only; requires rpmbuild, rpm, and GNU coreutils.
`validate` returns a boolean after validating the tree and CPU architecture.
`build` returns a native list of generated package paths. Selecting an architecture
does not cross-compile the payload.

## Directory layout

Prepare the standard RPM tree with the chosen spec in `SPECS/` and source
files or a staged payload in `SOURCES/`:

```text
rpm-tree/
├── SPECS/
│   └── widget.spec
└── SOURCES/
    └── root/
        └── usr/
            └── share/
                └── widget/
                    └── message.txt
```

A spec that packages this staged payload can contain:

```spec
Name: widget
Version: 1.2.0
Release: 1
Summary: My application
License: MIT

%description
My application's files.

%prep
%build
%install
mkdir -p "%{buildroot}"
cp -a "%{_sourcedir}/root/." "%{buildroot}/"

%files
/usr/share/widget/message.txt
```

Source archives and full compilation recipes are also supported. Specs are
executable build recipes; parsing them can evaluate macros. Use trusted specs.

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

This module declares `setup-rpmbuild` as typed native component dependencies.
FluentCI v0.17.3+ resolves their source references while building and composes
them into the published Wasm. Consumers need no relative source paths.
Available tools are reused; missing prerequisites invoke setup with default
arguments. Explicit executable overrides remain caller-managed. Configure pinned
versions or privileged/custom installations in an earlier setup step.
See [dependency behavior and publishing](../../docs/MODULE_DEPENDENCIES.md) for
command-specific prerequisites, validation, credential skips, and CI coverage.

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.5 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add rpmbuild --path /path/to/fluentci-modules/packaging/rpmbuild
```

For a published module, use `fluentci add @fluentci.io/rpmbuild@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

These examples append `build` and a native Git check to one pipeline.
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
import FluentCI.Modules.Rpmbuild as Dependency

run :: Effect String
run =
  Flow.pipeline "ci"
    # Flow.workdir "."
    # Dependency.build (Dependency.buildArgs { "directory": ".", "arch": "x86_64", "spec": "example-spec" })
    # Flow.exec [ "git", "diff", "--exit-code" ]
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/rpmbuild as dependency

pub fn run() -> String {
  flow.pipeline("ci")
  |> flow.workdir(".")
  |> dependency.build(dependency.build_args(".", "x86_64", "example-spec"))
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
  alias FluentCI.Modules.Rpmbuild, as: Dependency

  defplugin run do
    Flow.pipeline("ci")
    |> Flow.workdir(".")
    |> Dependency.build(%{"directory" => ".", "arch" => "x86_64", "spec" => "example-spec"})
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
            [fluentci-modules.rpmbuild :as dependency]))

(defn run []
  (-> (flow/pipeline "ci")
      (flow/workdir ".")
      (dependency/build {:directory ".", :arch "x86_64", :spec "example-spec"})
      (flow/exec ["git" "diff" "--exit-code"])
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("ci")
  ->Flow.workdir(".")
  ->FluentciModulesRpmbuild.build(FluentciModulesRpmbuild.buildArgs(~directory=".", ~arch="x86_64", ~spec="example-spec"))
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import rpmbuild as dependency


def run() -> str:
    prepared = dependency.build(
        pipeline("ci").workdir("."), {"directory": ".", "arch": "x86_64", "spec": "example-spec"}
    )
    return prepared.exec("git", "diff", "--exit-code").run()
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/rpmbuild/index";

export function run(): string {
  const prepared = dependency.build(
    flow.workdir(flow.pipeline("ci"), "."), {"directory":".","arch":"x86_64","spec":"example-spec"}
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
| `build` | Build packages from a Linux rpmbuild package tree and target architecture. |
| `validate` | Validate a Linux rpmbuild package tree and target architecture. |
<!-- /generated:language-examples -->
