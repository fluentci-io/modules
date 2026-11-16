<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add {{module}} --path /path/to/fluentci-modules/{{path}}
```

For a published module, use `fluentci add @fluentci.io/{{module}}@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

{{scenario}}

Replace the sample organization, paths and identifiers with your own. Configure
credentials through your CI secret provider before running authenticated operations. Optional arguments use the
callee's defaults, and public list fields use comma-separated strings. See
[COMPONENT.md](./COMPONENT.md) for argument descriptions and return types.

These examples use the generated composition API and builder chaining in
FluentCI 0.17.6; full cross-SDK compilation and execution coverage is still pending.
See [composition support and limitations](../../docs/COMPOSITION.md).

{{lifecycle}}

### PureScript

```purescript
module Main where

import Prelude
{{purs_extra_imports}}import Effect (Effect)
import FluentCI.Flow as Flow
import FluentCI.Modules.{{module_pascal}} as {{module_pascal}}

run :: Effect String
run =
  Flow.pipeline "{{pipeline_name}}"
    # Flow.workdir "."
    # {{module_pascal}}.{{js_function}} ({{purs_arguments}})
    # Flow.map (\result -> {{purs_projection}})
    # Flow.run
```

### Gleam

```gleam
{{gleam_extra_imports}}import fluentci/flow
import fluentci_modules/{{python_alias}}

pub fn run() -> String {
  flow.pipeline("{{pipeline_name}}")
  |> flow.workdir(".")
  |> {{python_alias}}.{{python_function}}({{python_alias}}.{{python_function}}_args({{gleam_required}}))
  |> flow.map(fn(result) { {{gleam_projection}} })
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
  alias FluentCI.Modules.{{module_pascal}}

  defplugin run do
    Flow.pipeline("{{pipeline_name}}")
    |> Flow.workdir(".")
    |> {{module_pascal}}.{{python_function}}({{elixir_arguments}})
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
            [fluentci-modules.{{module}} :as {{python_alias}}]))

(defn run []
  (-> (flow/pipeline "{{pipeline_name}}")
      (flow/workdir ".")
      ({{python_alias}}/{{function_kebab}} {{cljs_arguments}})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("{{pipeline_name}}")
  ->Flow.workdir(".")
  ->FluentciModules{{module_pascal}}.{{js_function}}({{rescript_arguments}})
  ->Flow.map(result => {{rescript_projection}})
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import {{python_alias}}


def run() -> str:
    return (
        pipeline("{{pipeline_name}}")
        .workdir(".")
        .pipe({{python_alias}}.{{python_function}}, {{python_arguments}})
        .map(lambda result: {{python_projection}})
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as {{python_alias}} from "./fluentci_modules/{{module}}/index";

export function run(): string {
  return flow.pipeline("{{pipeline_name}}")
    .workdir(".")
    .pipe({{python_alias}}.{{js_function}}, {{js_object}})
    .map(result => {{js_projection}})
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
{{function_rows}}
<!-- /generated:language-examples -->
