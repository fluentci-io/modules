# Flipt

Typed PureScript WebAssembly component for Flipt v2 feature-flag pipeline operations.
Requires FluentCI v0.17.3+.

```sh
fluentci run flipt setup --version latest
fluentci run flipt validate --run-dir /tmp/flipt-validate-001 --work-dir flags --files features.yaml --format json
fluentci run flipt evaluate --run-dir /tmp/flipt-evaluate-001 --flag-key checkout --address http://localhost:8080 --entity-id ci --context tier=enterprise,region=eu
fluentci run flipt migrate --run-dir /tmp/flipt-migrate-001 --config flipt.yml
fluentci run flipt license-check --run-dir /tmp/flipt-license-001 --config flipt.yml
fluentci run flipt run --run-dir /tmp/flipt-help-001 --arguments server,--help
```

Every operation checks setup first, including explicit executable overrides. Usable
installed tools skip installation; missing tools use the typed
[setup-flipt](../../setup/flipt/README.md) dependency and are checked again before execution.
The exported setup function forwards version/install-dir/package-name/sudo options,
returns tool, version, bin-dir and environment, and verifies explicit versions.
Official per-user installs use version/install-dir; omit package-name and sudo.
Linux/macOS x86_64/aarch64 are supported; other hosts fail before installation.

Validation fails on findings by default and accepts only positive issue-exit-code
values. Evaluation runs once, never implicitly entering watch mode. A successfully
returned flag value is an evaluation result, not an assertion that the flag is enabled;
inspect the execution stdout when making a deployment decision. Migrate runs v2
analytics database migrations and can change its configured database.
Server configuration and inherited environment supply the native server settings.
The evaluate CLI's authenticated mode requires its native token option; it is
available through extra-args/run, whose argument values are recorded in reports.
Do not put sensitive credentials in these recorded argument fields.

All lists use comma-separated strings, with whitespace trimmed and empty entries
rejected before setup. CSV double quotes preserve commas inside one token.
No public argument requires a JSON object or array. Tokens are passed literally,
without shell expansion. Blank optional lists retain the native defaults.

The typed exports target the [current v2 CLI](https://docs.flipt.io/v2/cli/overview).
Flipt v1-only import/export and bundle commands remain available through run when
an explicit v1 release is installed. Interactive configuration/license wizards
and foreground server lifecycle commands are intentionally available through run,
rather than being silently invoked during setup.

Each invocation needs a fresh run-dir. The return contains outcome, run-dir and
report/log paths. Native failures, setup errors, timeout and transport failures
propagate. See [COMPONENT.md](./COMPONENT.md) for every typed argument and return and
[OPTIONS.md](./OPTIONS.md) for native flag mappings. Function and argument descriptions
are derived from the PureScript source and embedded in the Wasm component.

CI runs the mocked installer, typed argument, setup dependency, and command-plan
regression suites. License: MIT.

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.5 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add flipt --path /path/to/fluentci-modules/deployment/flipt
```

For a published module, use `fluentci add @fluentci.io/flipt@VERSION` with an
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
import FluentCI.Modules.Flipt as Dependency

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
import fluentci_modules/flipt as dependency

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
  alias FluentCI.Modules.Flipt, as: Dependency

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
            [fluentci-modules.flipt :as dependency]))

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
  ->FluentciModulesFlipt.setup(FluentciModulesFlipt.setupArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import flipt as dependency


def run() -> str:
    prepared = dependency.setup(
        pipeline("ci").workdir("."), {}
    )
    return prepared.exec("git", "diff", "--exit-code").run()
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/flipt/index";

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
| `setup` | Ensure flipt is installed and verified, reusing an available matching version, and publish its environment. |
| `run` | Run any Flipt CLI command as literal native arguments. |
| `version` | Report the installed Flipt version. |
| `validate` | Validate flag-state YAML and fail the pipeline on validation issues. |
| `migrate` | Run pending Flipt v2 analytics database migrations with the selected server configuration. |
| `license_check` | Check the configured Flipt Pro license status with the native licensing service. |
| `evaluate` | Evaluate a feature flag once without watch mode; upstream evaluation failures propagate. |
<!-- /generated:language-examples -->
