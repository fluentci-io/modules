# Composing module functions

FluentCI 0.17.5 introduces generated pipeline bindings. Add a component dependency
from the caller's directory with `fluentci add`, then import its generated named
functions. The dependency's implementation language does not determine the
caller's SDK. These bindings are generated from the compiled WIT contract.

The initial implementation is released, but full cross-SDK compilation and
end-to-end verification remain pending. The examples in module READMEs describe
this API; they are not evidence that every SDK combination has passed CI.

## Named functions and native operations

For a PureScript caller with `setup-cmake` and `cmake` dependencies:

```sh
fluentci add setup-cmake --path /path/to/fluentci-modules/setup/cmake
fluentci add cmake --path /path/to/fluentci-modules/build/cmake
```

Generated imports live under `FluentCI.Modules`, alongside `FluentCI.Flow`.
Each module function takes named arguments and a pipeline, returning a pipeline
carrying its typed result. `#` is ordinary PureScript application; Gleam and
Elixir use `|>`, ReScript uses `->`, and ClojureScript uses thread-first `->`.
Python and TypeScript use named calls.

Use the generated argument builder to supply required fields and initialize
optional fields. For example, `SetupCmake.setupArgs` initializes all optional
setup fields. Public list fields remain CSV strings, not JSON arrays. Do not
confuse a module's public CSV field with native `Flow.exec`'s literal argv list.

`Flow.pipeline`, `workdir`, `env`, and `exec` compose with generated module
operations. Adding a step constructs a deferred sequence. `run` executes it in
order and stops on failure. Elixir uses its plugin DSL's `stdout` terminal.
The older `FluentCI.Plugin.Pipeline` and the new `FluentCI.Flow.Pipeline` are
distinct types; their operations are not interchangeable.

## Passing results forward

- PureScript: `Dependency.functionWith` takes a callback from the previous result
  to the next function's argument record.
- Gleam: `dependency.function_with` takes the pipeline first, then that callback.
- ReScript: `Dependency.functionWith` takes the pipeline and callback.
- TypeScript and Python: the named operation accepts either its argument object
  or a callback producing that object from the preceding result.
- ClojureScript: the named operation accepts a map or callback returning a map;
  callback results are keywordized maps, without caller-managed JSON parsing.
- Rust: `Pipeline.then` appends a generated operation; `then_with` derives one
  from the preceding value.
- Elixir's initial Flow DSL supports sequential module/native operations, but
  does not yet provide equivalent typed result callbacks.

A primitive `exec` replaces the carried result with stdout. Consume a module's
result before appending an unrelated command when that result is needed later.

## Working directories and cleanup

A module argument named `project` inherits the pipeline workdir when omitted;
an explicit value wins. Missing `runDir` values receive fresh execution-report
directories in the SDKs that support that default. Other argument defaults belong
to the callee. Setup modules may publish environment changes through the host;
full isolation of those side effects between pipelines is not guaranteed.

Register cleanup with `ensuring` in the JavaScript-backed SDKs or Python before
running a service pipeline. The runtime registers cleanup before execution,
runs it after success or failure, and preserves the original failure when cleanup
also fails. Use the same service project/name for start and stop. Appending an
ordinary stop step alone is insufficient: earlier failure skips later steps.
Elixir and Rust Flow do not yet expose equivalent cleanup combinators.

## Compatibility and verification

The published module's direct WIT/CLI contract remains unchanged. Generated
bindings are caller-side source, not a new required public module argument.
The initial generators expect a named argument record for most SDKs. Rust
positional dependency support was fixed after the first 0.17.5 release build;
ensure the installed artifact includes that fix if importing positional APIs.
Resource, variant, and flags contracts still need additional generator support.
Do not assume automatic DAG caching or parallel scheduling for opaque module calls.

CI needs to verify each supported caller SDK against real components, including:

1. Calls to two functions from one module and a second module.
2. Native operations before, between, and after module calls.
3. Typed output-to-input callbacks and optional/list conversions.
4. Failure propagation and cleanup without masking original errors.
5. Working directory overrides and distinct report directories.
6. Unchanged direct dependency imports and CLI contracts.

No examples should require handwritten FFI, generic dispatch helpers, or a shell
invocation of FluentCI to call another component.
