# Nix publishing

Publish a checked-out Nix flake to **FlakeHub** or **Flakestry** from a CI release
job. This PureScript module is a native Wasm component for FluentCI v0.17.3+.
It generalizes the pipeline in FluentCI's `.fluentci/nix` without hardcoding a
repository name. Every function has named typed arguments and returns an
execution result with report and log paths.

## Usage

Check out the intended release tag/commit before publishing. `version` names
that release; Flakestry's `ref` must identify the same checked-out commit.
Each invocation requires a fresh `run-dir`.

```sh
fluentci run nix-publish check --run-dir .fluentci/nix-check
fluentci run nix-publish metadata --run-dir .fluentci/nix-metadata
fluentci run nix-publish outputs --run-dir .fluentci/nix-outputs

fluentci run nix-publish flakehub --run-dir .fluentci/flakehub \
  --name example/project --version v1.2.3 --visibility public

fluentci run nix-publish flakestry --run-dir .fluentci/flakestry \
  --version v1.2.3 --ref "$(git rev-parse HEAD)"
```

Use `--project PATH` for another checkout directory. Nix checks, metadata, and
output inspection enable `nix-command flakes` and use `--no-write-lock-file`.
They do not rewrite `flake.lock`. `check` may build derivations and access the
network. Flakestry evaluates metadata and outputs for all systems before making
publication requests; evaluation failures cancel publication.

FlakeHub accepts `public`, `unlisted`, or `private` visibility. Its publisher
inherits `FLAKEHUB_PUSH_REV` when provided; set it to the release commit when
pinning the revision explicitly. The native publisher controls its upload and
release validation behavior.

Flakestry accepts an optional repository-relative `--readme` filename (default
`README.md`), an HTTPS registry origin via `--url`, and `--ignore-conflicts` to
treat an existing release (HTTP 409) as success. Other HTTP failures still fail.
The registry origin becomes the GitHub OIDC audience. The default is
`https://flakestry.dev`; `readme` is the filename expected by the registry API.

See [COMPONENT.md](./COMPONENT.md) for every argument and return type, or run:

```sh
fluentci run nix-publish flakehub --help
fluentci run nix-publish flakestry --help
```

## Prerequisites and authentication

Linux and macOS are supported. Install Nix using [setup-nix](../../setup/nix/README.md)
or [setup-determinate-nix](../../setup/determinate-nix/README.md).
FlakeHub additionally needs [setup-flakehub-push](../../setup/flakehub-push/README.md);
Flakestry needs [setup-bun](../../setup/bun/README.md). Flakestry uses Bun's HTTP
and JSON support, so `curl`, `jq`, and `jo` are not required for publication.
Setup calls publish PATH within a host session; separate CLI processes must add
the returned `bin-dir` to PATH explicitly.

Publishing currently uses the GitHub Actions OIDC flow from the reference
pipeline. Configure `permissions: {contents: read, id-token: write}`. Both
publishers require `ACTIONS_ID_TOKEN_REQUEST_TOKEN` and
`ACTIONS_ID_TOKEN_REQUEST_URL` in the inherited environment. Additionally:

| Registry | Required GitHub token |
| --- | --- |
| FlakeHub | `FLAKEHUB_PUSH_GITHUB_TOKEN` |
| Flakestry | `GH_TOKEN` |

These variables must be nonempty. Tokens are never function arguments or embedded
in execution plans. Generic `GITHUB_TOKEN` does not replace either explicit
variable. For Jenkins or Tekton, an equivalent supported identity flow is needed;
a generic GitHub token alone does not provide GitHub Actions OIDC.

For an existing runner with FluentCI, Nix, Bun, and `flakehub-push` on PATH:

```yaml
permissions:
  contents: read
  id-token: write
steps:
  - uses: actions/checkout@v6
    with:
      ref: ${{ github.ref_name }}
      fetch-depth: 0
  - name: Validate and publish the release
    env:
      RELEASE_VERSION: ${{ github.ref_name }}
      GH_TOKEN: ${{ github.token }}
      FLAKEHUB_PUSH_GITHUB_TOKEN: ${{ github.token }}
      FLAKEHUB_PUSH_REV: ${{ github.sha }}
    run: |
      fluentci run nix-publish check --run-dir .fluentci/check
      fluentci run nix-publish flakehub --run-dir .fluentci/flakehub --name example/project --version "$RELEASE_VERSION"
      fluentci run nix-publish flakestry --run-dir .fluentci/flakestry --version "$RELEASE_VERSION" --ref "$(git rev-parse HEAD)"
```

The example belongs in a tag-triggered workflow. Each publisher is a separate
operation: an earlier successful publication remains published if a later one
fails. There is no automatic checkout, release creation, rollback, or combined
cross-registry transaction.

## Results and failures

Functions return `outcome`, `run-dir`, `report-path`, `stdout-path`, and
`stderr-path`. Missing credentials and unsupported hosts fail before host
commands. Missing tools, Nix evaluation errors, HTTP failures, cancellation,
and timeouts fail the component call. Flakestry's successful JSON receipt is in
its stdout log; an ignored conflict reports `alreadyExists: true`.

## Development

```sh
bun install --cwd ../../lib/component --frozen-lockfile
npm ci
npm run build
npm test
```

Tests execute compiled PureScript and exercise the Flakestry payload using a local
Nix fixture and mocked HTTP/OIDC responses. They never publish to either registry.
The native component is `dist/plugin.wasm`; its typed contract sidecar is
`dist/fluentci.metadata.json`. Private CJS/legacy entries only support regression
testing. See the [component guide](../../docs/COMPONENTS.md) and [MIT License](./LICENSE).

Protocol references: [Flakestry's publishing action](https://github.com/flakestry/flakestry-publish/blob/main/action.yaml)
and [FlakeHub publishing](https://docs.determinate.systems/flakehub/publishing/).

## Setup component dependency

This module declares `setup-nix`, `setup-bun`, and `setup-flakehub-push` as typed native component dependencies.
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
fluentci add nix-publish --path /path/to/fluentci-modules/publishing/nix-publish
```

For a published module, use `fluentci add @fluentci.io/nix-publish@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Evaluate and build flake checks without modifying flake.lock.

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
import FluentCI.Modules.NixPublish as NixPublish

run :: Effect String
run =
  Flow.pipeline "nix-publish-check"
    # Flow.workdir "."
    # NixPublish.check (NixPublish.checkArgs)
    # Flow.map (\result -> result.reportPath)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/nix_publish

pub fn run() -> String {
  flow.pipeline("nix-publish-check")
  |> flow.workdir(".")
  |> nix_publish.check(nix_publish.check_args())
  |> flow.map(fn(result) { result.report_path })
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
  alias FluentCI.Modules.NixPublish

  defplugin run do
    Flow.pipeline("nix-publish-check")
    |> Flow.workdir(".")
    |> NixPublish.check(%{})
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
            [fluentci-modules.nix-publish :as nix_publish]))

(defn run []
  (-> (flow/pipeline "nix-publish-check")
      (flow/workdir ".")
      (nix_publish/check {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("nix-publish-check")
  ->Flow.workdir(".")
  ->FluentciModulesNixPublish.check(FluentciModulesNixPublish.checkArgs)
  ->Flow.map(result => result.reportPath)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import nix_publish


def run() -> str:
    return (
        pipeline("nix-publish-check")
        .workdir(".")
        .pipe(nix_publish.check, {})
        .map(lambda result: result.report_path)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as nix_publish from "./fluentci_modules/nix-publish/index";

export function run(): string {
  return flow.pipeline("nix-publish-check")
    .workdir(".")
    .pipe(nix_publish.check, {})
    .map(result => result.reportPath)
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
| `check` | Evaluate and build flake checks without modifying flake.lock. |
| `metadata` | Inspect locked flake metadata as JSON without modifying flake.lock. |
| `outputs` | Inspect flake outputs for every supported system as JSON. |
| `flakehub` | Publish the checked-out flake release to FlakeHub using GitHub OIDC. |
| `flakestry` | Publish locked flake metadata and outputs to Flakestry using GitHub OIDC. |
<!-- /generated:language-examples -->
