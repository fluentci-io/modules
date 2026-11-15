# Git

Check out source, inspect revisions, create commits and tags, and publish refs with typed Git functions.
Native PureScript WebAssembly component; requires FluentCI v0.17.3+.

```sh
fluentci run git setup
fluentci run git clone --run-dir /tmp/git-clone-001 --url https://github.com/acme/app.git --directory source --depth 1
fluentci run git fetch --project source --run-dir /tmp/git-fetch-001 --tags --prune
fluentci run git checkout --project source --run-dir /tmp/git-checkout-001 --ref main
fluentci run git add --project source --run-dir /tmp/git-add-001 --paths Cargo.toml,Cargo.lock
fluentci run git tag --project source --run-dir /tmp/git-tag-001 --name v1.2.3 --message 'Release 1.2.3'
fluentci run git push --project source --run-dir /tmp/git-push-001 --remote origin --refspecs refs/tags/v1.2.3
```

## Setup and platforms

Every named operation, including calls with an executable override, performs setup
preflight after input validation and before running its command. Usable installed
tools skip installation. Missing tools use typed setup dependencies and must pass
the availability check again.

The exported setup function accepts version, install-dir, package-name and sudo,
then returns tool, version, bin-dir and environment. A matching installed release
is reused; an exact requested version is verified. Git uses native package repositories; exact versions depend on configured repositories and are verified after installation.
Linux, macOS, FreeBSD, OpenBSD and NetBSD are supported. Native package availability,
permissions and repository versions determine installation success on BSD.
Unsupported OS values fail before installation.

For native packages, omit install-dir; package-name selects a repository-specific
versioned package and sudo requests noninteractive elevation. Official archive
installs are per-user and require package-name/sudo to be omitted. A custom
install-dir selects a managed archive prefix instead of PATH reuse. Separate shell
processes must apply the returned environment themselves.

## Pipeline behavior

Exports cover clone/fetch/checkout, status/diff/log/show, rev-parse/describe,
add/commit/tag/push/pull, submodule updates, remote refs/URLs, source archives and
configuration reads. Pull requires fast-forward-only by default. Diff uses
exit-code by default, so changes fail the pipeline; pass `--exit-code=false`
when collecting an informational diff. Commits require a literal message and use
the inherited author/committer identity. There is no implicit add-all, hard reset,
branch deletion, or unguarded force push. `--force-with-lease` and tag publication
must be requested explicitly. Native Git configuration, SSH agents and credential
helpers remain inherited; `GIT_TERMINAL_PROMPT=0` disables password prompts.

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
fluentci run git run --run-dir /tmp/git-native-001 --arguments=--help
```

The run escape hatch exposes every remaining native CLI feature. No CLI argument
requires a JSON object or array. See [COMPONENT.md](./COMPONENT.md) for all typed
arguments, return fields and descriptions, [OPTIONS.md](./OPTIONS.md) for native
flag mappings, and the [upstream CLI reference](https://git-scm.com/docs). Source descriptions
are embedded in the compiled component.

## Development

CI builds the component and runs contract, installer, dependency, and literal-argument
regression suites. License: MIT.

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add git --path /path/to/fluentci-modules/version-control/git
```

For a published module, use `fluentci add @fluentci.io/git@VERSION` with an
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
import FluentCI.Modules.Git as Dependency

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
import fluentci_modules/git as dependency

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
  alias FluentCI.Modules.Git, as: Dependency

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
            [fluentci-modules.git :as dependency]))

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
  ->FluentciModulesGit.setup(FluentciModulesGit.setupArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import git as dependency


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
import * as dependency from "./fluentci_modules/git/index";

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
| `setup` | Ensure git is installed and verified, reusing an available matching version, and publish its environment. |
| `run` | Run any native git command with literal argv. |
| `version` | Report the installed git CLI version. |
| `clone` | Clone a repository with optional shallow, partial and submodule checkout. |
| `fetch` | Fetch selected refs and tags without merging them. |
| `checkout` | Check out a revision while retaining native dirty-worktree safety checks. |
| `status` | Inspect checkout and index state with stable machine-readable output. |
| `diff` | Compare source revisions or the working tree and optionally fail on differences. |
| `log` | Read bounded commit history for release notes or change detection. |
| `show` | Inspect a selected commit, tree or versioned file. |
| `rev_parse` | Resolve an exact commit or object identifier. |
| `describe` | Derive a release identifier from Git tags and commit history. |
| `add` | Stage explicitly selected paths without implicitly staging all files. |
| `commit` | Create a commit from staged changes using the inherited Git author identity. |
| `tag` | Create an explicitly named release tag without forcing replacement. |
| `push` | Push selected refs; force updates and tag publication are opt-in. |
| `pull` | Update the checkout, requiring a fast-forward by default. |
| `submodule_update` | Initialize and update submodules at their committed revisions. |
| `ls_remote` | Inspect remote refs without checking out or modifying repository contents. |
| `archive` | Create a source release archive from a selected Git tree. |
| `config_get` | Read one configured Git value without modifying configuration. |
| `remote_get_url` | Read the configured repository remote URL. |
<!-- /generated:language-examples -->
