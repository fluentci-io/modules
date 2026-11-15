# Cosign

Sign OCI images and release files, then enforce signature verification in CI/CD.
Implemented in PureScript as a typed Wasm component for FluentCI v0.17.3+.
Install the native CLI with [setup-cosign](../../setup/cosign/README.md).
Blob operations target Cosign 3.x Sigstore bundles.

```sh
fluentci run setup-cosign setup --version 3.1.4
fluentci run cosign sign --run-dir /tmp/sign-image --image registry.example/app@sha256:DIGEST
fluentci run cosign verify --run-dir /tmp/verify-image \
  --image registry.example/app@sha256:DIGEST \
  --certificate-identity https://github.com/org/repo/.github/workflows/release.yml@refs/heads/main \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
fluentci run cosign sign-blob --run-dir /tmp/sign-file \
  --file dist/app.tar.gz --bundle dist/app.sigstore.json
fluentci run cosign verify-blob --run-dir /tmp/verify-file \
  --file dist/app.tar.gz --bundle dist/app.sigstore.json \
  --certificate-identity https://github.com/org/repo/.github/workflows/release.yml@refs/heads/main \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
```

`sign` and `sign-blob` use ambient OIDC credentials unless `--key` selects a
local key, an `env://` reference, or supported KMS URI. Signing skips confirmation
prompts and can publish to a transparency log; image signing also writes to its
registry. Configure CI OIDC permissions (for example GitHub `id-token: write`),
registry authentication, and key passwords through the runner environment.
Never place secret key material or tokens in module arguments.

`verify` and `verify-blob` require exact expected certificate identity and issuer.
`verify-key` and `verify-blob-key` instead require `--key` with the public key or
KMS reference. Verification keeps native transparency-log and certificate checks;
errors fail the pipeline. Prefer immutable image digests. `run` accepts literal
arguments for additional Cosign commands; `version` reports the installed CLI.

Every call requires a fresh `--run-dir`; optional `--project` selects its working
directory. Local input files and verification bundles are checked before starting
the command. Output bundle parent directories must exist. Declare output bundles
with `--artifacts NAME=PATH` to collect their sizes and SHA-256 in the report.
Returns a typed execution result with outcome, report, stdout, and stderr paths;
nonzero exits propagate as failures. Credentials remain inherited from the host.

The adapter accepts Linux, macOS, FreeBSD, NetBSD, and OpenBSD hosts with an
installed native Cosign; repository availability still limits BSD installations.
See [COMPONENT.md](./COMPONENT.md) and [OPTIONS.md](./OPTIONS.md) for named
arguments, descriptions, and return types.

[Cosign documentation](https://docs.sigstore.dev/cosign/) · [MIT License](./LICENSE).

## Setup component dependency

This module declares `setup-cosign` as typed native component dependencies.
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
fluentci add cosign --path /path/to/fluentci-modules/security/cosign
```

For a published module, use `fluentci add @fluentci.io/cosign@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

These examples append `version` and a native Git check to one pipeline.
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
import FluentCI.Modules.Cosign as Dependency

run :: Effect String
run =
  Flow.pipeline "ci"
    # Flow.workdir "."
    # Dependency.version (Dependency.versionArgs)
    # Flow.exec [ "git", "diff", "--exit-code" ]
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/cosign as dependency

pub fn run() -> String {
  flow.pipeline("ci")
  |> flow.workdir(".")
  |> dependency.version(dependency.version_args())
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
  alias FluentCI.Modules.Cosign, as: Dependency

  defplugin run do
    Flow.pipeline("ci")
    |> Flow.workdir(".")
    |> Dependency.version(%{})
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
            [fluentci-modules.cosign :as dependency]))

(defn run []
  (-> (flow/pipeline "ci")
      (flow/workdir ".")
      (dependency/version {})
      (flow/exec ["git" "diff" "--exit-code"])
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("ci")
  ->Flow.workdir(".")
  ->FluentciModulesCosign.version(FluentciModulesCosign.versionArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import cosign as dependency


def run() -> str:
    prepared = dependency.version(
        pipeline("ci").workdir("."), {}
    )
    return prepared.exec("git", "diff", "--exit-code").run()
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/cosign/index";

export function run(): string {
  const prepared = dependency.version(
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
| `run` | Run arbitrary Cosign commands with literal arguments. |
| `version` | Report the installed Cosign version. |
| `sign` | Sign an OCI image using a key or ambient CI OIDC credentials; publish the signature to its registry. |
| `sign_blob` | Sign a local release artifact and write its Sigstore verification bundle. |
| `verify` | Verify an OCI image signature against an exact keyless identity and issuer; fail the pipeline on verification errors. |
| `verify_key` | Verify an OCI image signature against an explicit public key or KMS key. |
| `verify_blob` | Verify a release artifact and Sigstore bundle against an exact keyless identity and issuer. |
| `verify_blob_key` | Verify a release artifact and Sigstore bundle against an explicit public key or KMS key. |
<!-- /generated:language-examples -->
