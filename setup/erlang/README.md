# Setup Erlang/OTP

Install Erlang/OTP for Linux, macOS, FreeBSD, NetBSD, or OpenBSD using a typed
PureScript Wasm component. Requires FluentCI v0.17.2+.

```sh
fluentci run setup-erlang setup --version 28.3.2
fluentci run setup-erlang setup --version 28
fluentci run setup-erlang setup --help
```

`version` accepts an exact release, numeric branch, `OTP-`/`v` prefix, or `latest`.
Archive selection prefers an exact available release; otherwise it selects the
newest matching stable numeric version. Release candidates and development
branches are excluded. Omitting the version selects the latest stable build.

## Platforms

| OS | Installation |
| --- | --- |
| Linux, Ubuntu 22.04/24.04/26.04 | Hex OTP archive for the detected distribution and CPU, followed by `Install -minimal`. |
| Other Linux distributions | Native packages using apt, dnf/yum, apk, pacman, or zypper. |
| macOS | Matching `erlef/otp_builds` archive, verified against the SHA-256 in its build index. |
| FreeBSD | Native `pkg` Erlang package. |
| NetBSD | Native `pkgin` Erlang package. |
| OpenBSD | Native `pkg_add` Erlang package. |

The Linux/macOS archive approach follows [erlef/setup-beam](https://github.com/erlef/setup-beam).
x86_64 and aarch64 are supported, including amd64/arm64 aliases. Linux is detected
from `/etc/os-release`; incompatible Ubuntu archives are not used on another
distribution. Native packages depend on the repository, OS release, CPU, and
available versions. Missing packages and mismatched versions fail explicitly.

Archive installation needs curl, tar, and the runtime libraries expected by its
build platform, including compatible OpenSSL/ncurses libraries. Ubuntu archives
rely on upstream HTTPS; macOS archives additionally use the published SHA-256.
No Linux binaries are downloaded on BSD hosts.

## Configuration and verification

Archives install beneath `$HOME/.local/share/fluentci/erlang/VERSION` or an
absolute `--install-dir`. A verified matching prefix is reused. Failed new
installations are removed; existing directories are preserved.

`--package-name` explicitly selects a native package on any OS. `--sudo` selects
native installation with noninteractive sudo. Native installation requires a
configured package manager/repository and appropriate privileges; it does not
accept `--install-dir`. Pinned native package versions must exist in the selected
repository. Homebrew versioned formulas are resolved through their own prefix:

```sh
fluentci run setup-erlang setup --version 28 --package-name erlang@28
```

Verification checks `erl`, `erlc`, and `escript`, starts Erlang without a shell,
loads the compiler, and reads the installed `OTP_VERSION` file. This verifies
the OTP patch version rather than confusing the ERTS version with the OTP release.

The result contains `tool`, `version`, `bin-dir`, and `environment`. PATH updates
apply within the host session. Separate shell invocations must explicitly add
the returned `bin-dir` to PATH. See [COMPONENT.md](./COMPONENT.md) for named arguments
and return types.

## Development

```sh
bun install --cwd ../../lib/component --frozen-lockfile
npm ci
npm run build
npm test
```

Tests cover archive selection, both CPU families, native package-manager commands,
version verification, failure cleanup, and preservation of existing prefixes.
BSD package-manager tests use host fixtures; availability on a particular BSD
release still needs a real runner. The smoke workflow installs the real archive
on Linux/macOS through this component.

[MIT License](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-erlang --path /path/to/fluentci-modules/setup/erlang
```

For a published module, use `fluentci add @fluentci.io/setup-erlang@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

These examples append `setup` and a native Git check to one pipeline.
Replace sample paths and identifiers with your own. Optional arguments use the
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
import FluentCI.Modules.SetupErlang as Dependency

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
import fluentci_modules/setup_erlang as dependency

pub fn run() -> String {
  flow.pipeline("ci")
  |> flow.workdir(".")
  |> dependency.setup(dependency.setup_args())
  |> flow.exec("git", ["diff", "--exit-code"])
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
  alias FluentCI.Modules.SetupErlang, as: Dependency

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
            [fluentci-modules.setup-erlang :as dependency]))

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
  ->FluentciModulesSetupErlang.setup(FluentciModulesSetupErlang.setupArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_erlang as dependency


def run() -> str:
    return (
        pipeline("ci")
        .workdir(".")
        .pipe(dependency.setup, {})
        .exec("git", "diff", "--exit-code")
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/setup-erlang/index";

export function run(): string {
  return flow.pipeline("ci")
    .workdir(".")
    .pipe(dependency.setup, {})
    .exec(["git", "diff", "--exit-code"])
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
| `setup` | Install and verify erlang, select its version, and publish its environment for subsequent tasks. |
<!-- /generated:language-examples -->
