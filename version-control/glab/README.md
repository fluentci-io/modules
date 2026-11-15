# GitLab CLI

Manage merge requests, releases and GitLab CI jobs and pipelines through typed GitLab CLI functions.
Native PureScript WebAssembly component; requires FluentCI v0.17.3+.

```sh
fluentci run glab setup --version latest
fluentci run glab mr-create --project source --run-dir /tmp/glab-mr-001 --repo group/app --source-branch automation/update --target-branch main --title 'Update dependencies' --description 'Validated dependency update' --labels dependencies,automation
fluentci run glab ci-run --run-dir /tmp/glab-run-001 --repo group/app --branch main --variables DEPLOY_ENV:staging,VERSION:1.2.3
fluentci run glab ci-get --run-dir /tmp/glab-get-001 --repo group/app --pipeline-id 123456
fluentci run glab ci-retry --run-dir /tmp/glab-retry-001 --repo group/app --pipeline-id 123456 --job lint
fluentci run glab ci-cancel --run-dir /tmp/glab-cancel-001 --repo group/app --pipeline-id 123456
fluentci run glab release-upload --run-dir /tmp/glab-upload-001 --repo group/app --tag v1.2.3 --files dist/app.deb,dist/app.rpm
```

## Setup and platforms

Every named operation, including calls with an executable override, performs setup
preflight after input validation and before running its command. Usable installed
tools skip installation. Missing tools use typed setup dependencies and must pass
the availability check again. Git is also checked and installed through setup-git when missing.

The exported setup function accepts version, install-dir, package-name and sudo,
then returns tool, version, bin-dir and environment. A matching installed release
is reused; an exact requested version is verified. GitLab CLI uses SHA-256 checked official GitLab release archives on Linux/macOS and native glab packages on BSD.
Linux, macOS, FreeBSD, OpenBSD and NetBSD are supported. Native package availability,
permissions and repository versions determine installation success on BSD.
Unsupported OS values fail before installation.

For native packages, omit install-dir; package-name selects a repository-specific
versioned package and sudo requests noninteractive elevation. Official archive
installs are per-user and require package-name/sudo to be omitted. A custom
install-dir selects a managed archive prefix instead of PATH reuse. Separate shell
processes must apply the returned environment themselves.

## Pipeline behavior

Exports cover authentication status, repository inspection, merge request
creation/listing/checkout/comments/merging, release creation and asset transfer,
pipeline dispatch/status/details/cancellation, explicitly selected job retry,
configuration linting and authenticated API calls. `ci-retry` retries a job,
not an entire pipeline. `ci-cancel` uses the native `ci cancel pipeline` command.
Merge request creation and merging use confirmation bypass only when those named
operations are explicitly invoked. Source branch deletion remains opt-in. Release
creation uses no-update by default to protect an existing release.

Authentication remains in `GITLAB_TOKEN`, `GLAB_TOKEN` or native credential storage;
GitLab CI job tokens can use native `GLAB_ENABLE_CI_AUTOLOGIN` configuration. Use
`GITLAB_HOST`/hostname for self-managed GitLab. Setup never opens an interactive
login. Pipeline variables use comma-separated KEY:VALUE entries. Native typed
pipeline inputs use KEY:VALUE or KEY:type(value); CSV-quote entries containing
commas. API fields use comma-separated KEY=VALUE strings, or an existing
input-file for a request body. Tokens and sensitive request values should remain
in credential configuration rather than recorded argument fields.

Every operation requires a fresh run-dir and returns typed outcome, run-dir,
report-path, stdout-path and stderr-path fields. Read the captured stdout for
native results. Nonzero native exits, timeout, setup failures and transport errors
propagate without returning success. Polling operations remain bounded by timeout-ms.
Commands that create comments, releases, requests, commits or tags mutate remote or
local state only when explicitly invoked.

All public lists use comma-separated strings; whitespace is trimmed, blank optional
lists keep native defaults, and empty entries/malformed CSV are rejected before
setup. CSV double quotes preserve literal commas within a token. Arguments remain
literal argv, with no shell expansion. Filenames are literal; shell globs are not
expanded by the module. Release uploads and body-file inputs are checked before
setup can install anything.

```sh
fluentci run glab run --run-dir /tmp/glab-native-001 --arguments=--help
```

The run escape hatch exposes every remaining native CLI feature. No CLI argument
requires a JSON object or array. See [COMPONENT.md](./COMPONENT.md) for all typed
arguments, return fields and descriptions, [OPTIONS.md](./OPTIONS.md) for native
flag mappings, and the [upstream CLI reference](https://docs.gitlab.com/cli/). Source descriptions
are embedded in the compiled component.

## Development

CI builds the component and runs contract, installer, dependency, and literal-argument
regression suites. License: MIT.

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add glab --path /path/to/fluentci-modules/version-control/glab
```

For a published module, use `fluentci add @fluentci.io/glab@VERSION` with an
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
import FluentCI.Modules.Glab as Dependency

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
import fluentci_modules/glab as dependency

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
  alias FluentCI.Modules.Glab, as: Dependency

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
            [fluentci-modules.glab :as dependency]))

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
  ->FluentciModulesGlab.setup(FluentciModulesGlab.setupArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import glab as dependency


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
import * as dependency from "./fluentci_modules/glab/index";

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
| `setup` | Ensure glab is installed and verified, reusing an available matching version, and publish its environment. |
| `run` | Run any native glab command with literal argv. |
| `version` | Report the installed glab CLI version. |
| `auth_status` | Check inherited GitLab authentication without interactive login. |
| `repo_view` | Inspect GitLab repository metadata without opening a browser. |
| `mr_create` | Create a noninteractive merge request with explicit title and description. |
| `mr_view` | Read a merge request and its state. |
| `mr_list` | List merge requests in a machine-readable format. |
| `mr_checkout` | Check out a merge request locally. |
| `mr_note` | Publish a pipeline comment on a merge request. |
| `mr_merge` | Merge a selected merge request; source branch deletion remains opt-in. |
| `release_create` | Create a GitLab release and attach optional assets; existing releases are protected by default. |
| `release_upload` | Upload files to an existing GitLab release. |
| `release_download` | Download selected GitLab release assets. |
| `ci_run` | Create a GitLab pipeline with named variables or inputs. |
| `ci_status` | Inspect or watch a GitLab pipeline status. |
| `ci_get` | Read detailed pipeline information. |
| `ci_retry` | Retry one explicitly selected GitLab CI job, optionally within a selected pipeline. |
| `ci_cancel` | Cancel one explicitly selected pipeline using glab ci cancel pipeline. |
| `ci_lint` | Validate GitLab CI configuration using the native server lint API. |
| `api` | Call the authenticated GitLab API with scalar fields or a body file. |
<!-- /generated:language-examples -->
