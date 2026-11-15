# GitHub CLI

Manage pull requests, releases and GitHub Actions runs through typed GitHub CLI functions.
Native PureScript WebAssembly component; requires FluentCI v0.17.3+.

```sh
fluentci run gh setup --version latest
fluentci run gh pr-create --project source --run-dir /tmp/gh-pr-001 --repo acme/app --head automation/update --base main --title 'Update dependencies' --body 'Validated dependency update' --labels dependencies,automation
fluentci run gh pr-checks --run-dir /tmp/gh-checks-001 --repo acme/app --number 42 --watch --required
fluentci run gh workflow-run --run-dir /tmp/gh-dispatch-001 --repo acme/app --workflow release.yml --ref main --inputs version=1.2.3,environment=staging
fluentci run gh run-watch --run-dir /tmp/gh-watch-001 --repo acme/app --run-id 123456
fluentci run gh release-upload --run-dir /tmp/gh-upload-001 --repo acme/app --tag v1.2.3 --files dist/app.deb,dist/app.rpm
```

## Setup and platforms

Every named operation, including calls with an executable override, performs setup
preflight after input validation and before running its command. Usable installed
tools skip installation. Missing tools use typed setup dependencies and must pass
the availability check again. Git is also checked and installed through setup-git when missing.

The exported setup function accepts version, install-dir, package-name and sudo,
then returns tool, version, bin-dir and environment. A matching installed release
is reused; an exact requested version is verified. GitHub CLI uses the existing setup-gh companion.
Linux, macOS, FreeBSD, OpenBSD and NetBSD are supported. Native package availability,
permissions and repository versions determine installation success on BSD.
Unsupported OS values fail before installation.

For native packages, omit install-dir; package-name selects a repository-specific
versioned package and sudo requests noninteractive elevation. Official archive
installs are per-user and require package-name/sudo to be omitted. A custom
install-dir selects a managed archive prefix instead of PATH reuse. Separate shell
processes must apply the returned environment themselves.

## Pipeline behavior

Exports cover authentication status, repository inspection, pull request
creation/listing/checkout/checks/comments/merging, release creation/asset transfer,
workflow dispatch and run listing/inspection/watching/rerunning/cancellation, and
authenticated API calls. PR merging requires an explicit `method` (squash, merge,
or rebase). Run-watch and run-view enable exit-status by default so failed runs
fail the calling pipeline. Release creation requires an existing tag by default;
pass `--verify-tag=false` to allow native tag creation. Asset replacement and
branch deletion are opt-in.

Authentication remains in `GH_TOKEN`, `GH_ENTERPRISE_TOKEN` or native gh credential
storage. Set `GH_HOST`/hostname for enterprise instances. `GH_PROMPT_DISABLED=1`
and `GIT_TERMINAL_PROMPT=0` keep named operations noninteractive; insufficient
inputs or credentials fail clearly. Setup never runs an interactive login. API
fields and workflow inputs use comma-separated KEY=VALUE strings; API request
bodies may also come from an existing input-file. Do not pass tokens through
recorded arguments.

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
fluentci run gh run --run-dir /tmp/gh-native-001 --arguments=--help
```

The run escape hatch exposes every remaining native CLI feature. No CLI argument
requires a JSON object or array. See [COMPONENT.md](./COMPONENT.md) for all typed
arguments, return fields and descriptions, [OPTIONS.md](./OPTIONS.md) for native
flag mappings, and the [upstream CLI reference](https://cli.github.com/manual/). Source descriptions
are embedded in the compiled component.

## Development

CI builds the component and runs contract, installer, dependency, and literal-argument
regression suites. License: MIT.

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.5 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add gh --path /path/to/fluentci-modules/version-control/gh
```

For a published module, use `fluentci add @fluentci.io/gh@VERSION` with an
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
import FluentCI.Modules.Gh as Dependency

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
import fluentci_modules/gh as dependency

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
  alias FluentCI.Modules.Gh, as: Dependency

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
            [fluentci-modules.gh :as dependency]))

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
  ->FluentciModulesGh.setup(FluentciModulesGh.setupArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import gh as dependency


def run() -> str:
    prepared = dependency.setup(
        pipeline("ci").workdir("."), {}
    )
    return prepared.exec("git", "diff", "--exit-code").run()
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/gh/index";

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
| `setup` | Ensure gh is installed and verified, reusing an available matching version, and publish its environment. |
| `run` | Run any native gh command with literal argv. |
| `version` | Report the installed gh CLI version. |
| `auth_status` | Check existing GitHub authentication without interactive login. |
| `repo_view` | Inspect repository metadata. |
| `pr_create` | Create a pull request with explicit noninteractive title and description. |
| `pr_view` | Read a pull request and its review state. |
| `pr_list` | List pull requests for automated review or release workflows. |
| `pr_checkout` | Check out a pull request into the working tree. |
| `pr_checks` | Inspect or wait for pull request checks; native failing and pending statuses propagate. |
| `pr_comment` | Publish a pipeline comment to a pull request. |
| `pr_merge` | Merge a reviewed pull request using an explicitly selected strategy; branch deletion is opt-in. |
| `release_create` | Create a GitHub release and optionally attach release assets. |
| `release_upload` | Upload assets to an existing release; replacement is opt-in. |
| `release_download` | Download selected release assets. |
| `workflow_run` | Dispatch a GitHub Actions workflow with named scalar inputs. |
| `run_list` | List workflow runs for pipeline orchestration. |
| `run_view` | Inspect a workflow run and propagate its failure status. |
| `run_watch` | Wait for a workflow run and propagate failure to the pipeline. |
| `run_rerun` | Rerun a selected workflow run or its failed jobs. |
| `run_cancel` | Cancel a selected workflow run. |
| `api` | Call the authenticated GitHub API using scalar fields or a request file. |
<!-- /generated:language-examples -->
