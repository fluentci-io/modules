# SonarQube CLI

Run the **`sonar` CLI** through a native Wasm component written in PureScript.
Requires FluentCI v0.17.3+. Missing tools invoke the typed `setup-sonarqube`
dependency; an explicit `--executable` stays caller-managed.

For full-project SonarScanner analysis and `-Dsonar.*` properties, use the separate
[sonarqube-scanner](../sonarqube-scanner/README.md) module.

## Usage

Configure credentials through your CI secret store:

- SonarQube Cloud: `SONARQUBE_CLI_TOKEN` and `SONARQUBE_CLI_ORG`.
- SonarQube Server: `SONARQUBE_CLI_TOKEN` and `SONARQUBE_CLI_SERVER`.

A token alone can fall back to keychain credentials; set the organization or server
as well. Credentials remain inherited by the native process and are not copied
into task arguments or reports. `SONAR_TOKEN` is the separate Scanner setting.

```sh
fluentci run sonarqube analyze --project . --project-key org_app \
  --files src/app.ts,src/lib.ts --run-dir .fluentci/runs/analyze-001
fluentci run sonarqube analyze-secrets --paths src/app.ts,src/lib.ts \
  --exclude vendor,generated --run-dir .fluentci/runs/secrets-001
fluentci run sonarqube analyze-dependency-risks --project-key org_app \
  --statuses active,safe --run-dir .fluentci/runs/dependencies-001
fluentci run sonarqube quality-gate-status --project-key org_app \
  --branch main --format json --run-dir .fluentci/runs/gate-001
fluentci run sonarqube list-issues --project-key org_app \
  --statuses OPEN,CONFIRMED --severities HIGH,BLOCKER \
  --run-dir .fluentci/runs/issues-001
fluentci run sonarqube --help
fluentci run sonarqube analyze --help
```

`project` selects the local working directory; `projectKey` (`--project-key`)
selects the remote SonarQube project. Lists are comma-separated strings. Trimmed
entries become literal native arguments; CSV quotes preserve embedded commas.
Malformed lists fail before setup or host commands.

## Operations

The [reviewed v1.12.0 command inventory](./upstream-commands.json) comes from the
[official command reference](https://www.sonarsource.com/sonarqube/cli/commands.html).
The module exposes 49 typed functions:

- `analyze`, `analyze_secrets`, `analyze_dependency_risks`, `analyze_agentic`, and `remediate`.
- `list_issues`, `list_projects`, `list_orgs`, `quality_gate_status`, and authenticated `api`.
- `link`, `link_list`, and `import_repositories`.
- `architecture_current_get`, `architecture_intended_get/set`,
  `architecture_directives_get/set`, `architecture_findings_get`, and `architecture_install_skill`.
- `integrate_git` and the Claude, Copilot, Codex, Antigravity, Cursor, OpenCode,
  Devin, and Pi integration functions.
- Authentication, configuration, system, secret allowlist, and update commands,
  plus `context`, `run`, `version`, and `help`.

Function names use kebab-case in the CLI. [COMPONENT.md](./COMPONENT.md) lists every
named argument, description, optional default, and return type;
[OPTIONS.md](./OPTIONS.md) maps fields to native tokens. Use `run --arguments ...`
for native features outside the reviewed contract.

Analysis can contact SonarQube or use cloud-only services. Native licenses and
feature availability still apply. Fetching a quality gate status is separate
from submitting a full project analysis with Scanner. Integration and config
commands change local settings; remediation can invoke an AI agent. Forces and
self-updates are explicit. Noninteractive flags default to true where the native
command supports them. `link` requires a project key, `context` requires an action,
and `config_set` requires a value to avoid interactive selection in those calls.

Browser/keychain login, token-from-stdin login, secret scanning from stdin, and
interactive allowlist creation require native terminal/input facilities; these
wrappers do not collect interactive input. Use environment authentication for CI.
Values explicitly supplied to commands such as `api` or `config_set` appear in
native task reports; pass credentials through the documented environment variables.

## Results and prerequisites

Every function returns `outcome`, `runDir`, `reportPath`, `stdoutPath`, and
`stderrPath`. Each call needs a fresh run directory. Native failures, cancellation,
and timeouts fail the component call. Stdout contains the CLI's selected output
format. Declare report artifacts with `--artifacts analysis=report.json`.

The setup dependency supports Linux x86-64/ARM64 and macOS ARM64. Other platforms
need a compatible caller-managed executable; the default installer fails explicitly.
Input files marked in the typed contract are checked before installing prerequisites.

## Migration and development

Earlier `sonarqube scan` releases wrapped `sonar-scanner`. Use
`sonarqube-scanner scan` for that API, or `sonarqube analyze` for the new CLI.

CI builds and tests this component through the repository's grouped module jobs.
See the [component guide](../../docs/COMPONENTS.md),
[dependency behavior](../../docs/MODULE_DEPENDENCIES.md), and [MIT License](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add sonarqube --path /path/to/fluentci-modules/code-quality/sonarqube
```

For a published module, use `fluentci add @fluentci.io/sonarqube@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

These examples append `analyze` and a native Git check to one pipeline.
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
import FluentCI.Modules.Sonarqube as Dependency

run :: Effect String
run =
  Flow.pipeline "ci"
    # Flow.workdir "."
    # Dependency.analyze (Dependency.analyzeArgs)
    # Flow.exec [ "git", "diff", "--exit-code" ]
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/sonarqube as dependency

pub fn run() -> String {
  flow.pipeline("ci")
  |> flow.workdir(".")
  |> dependency.analyze(dependency.analyze_args())
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
  alias FluentCI.Modules.Sonarqube, as: Dependency

  defplugin run do
    Flow.pipeline("ci")
    |> Flow.workdir(".")
    |> Dependency.analyze(%{})
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
            [fluentci-modules.sonarqube :as dependency]))

(defn run []
  (-> (flow/pipeline "ci")
      (flow/workdir ".")
      (dependency/analyze {})
      (flow/exec ["git" "diff" "--exit-code"])
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("ci")
  ->Flow.workdir(".")
  ->FluentciModulesSonarqube.analyze(FluentciModulesSonarqube.analyzeArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import sonarqube as dependency


def run() -> str:
    return (
        pipeline("ci")
        .workdir(".")
        .pipe(dependency.analyze, {})
        .exec("git", "diff", "--exit-code")
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/sonarqube/index";

export function run(): string {
  return flow.pipeline("ci")
    .workdir(".")
    .pipe(dependency.analyze, {})
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
| `run` | Execute any sonar command with literal comma-separated arguments. |
| `version` | Print the SonarQube CLI version. |
| `help` | Show SonarQube CLI commands and options. |
| `auth_login` | Authenticate via browser or an existing token and save credentials in the system keychain. For CI and automation, use environment variables instead: https://docs.sonarsource.com/sonarqube-cli/using-sonarqube-cli/environment-variables |
| `auth_org` | Switch the active SonarQube Cloud organization without logging in again Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `auth_logout` | Remove the active connection, or all saved connections for a hostname with --server |
| `auth_status` | Show active authentication connection with token verification |
| `list_issues` | Search for issues in SonarQube Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `list_projects` | Search for projects in SonarQube Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `list_orgs` | List organizations you have access to (SonarQube Cloud only) Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `quality_gate_status` | Show the quality gate verdict for a project Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `import_repositories` | Import repositories from a connected DevOps platform into SonarQube Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `api` | Make authenticated API requests to SonarQube Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `integrate_git` | Install a Git pre-commit hook that scans staged files for secrets and dependency risks before each commit, or a Git pre-push hook that scans committed files for secrets before each push. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `integrate_claude` | Setup SonarQube integration for Claude Code. This will install secrets scanning hooks, configure Vortex analysis and MCP Server. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `integrate_copilot` | Setup SonarQube integration for GitHub Copilot CLI. This will install secrets scanning hooks, configure Vortex analysis and MCP Server. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `integrate_codex` | Setup SonarQube integration for Codex. This will install secrets scanning hooks, configure Vortex analysis and MCP Server. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `integrate_antigravity` | Setup SonarQube integration for Antigravity. Installs secrets scanning hooks, prompt-secrets instructions, and Vortex Context. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `integrate_cursor` | Setup SonarQube integration for Cursor. This will configure the SonarQube MCP Server, install secrets scanning hooks, and configure Vortex analysis. Note: Cursor's cloud/background agents only pick up project-level hooks, not global ones. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `integrate_opencode` | Setup SonarQube integration for OpenCode. This will install secrets scanning hooks, configure Vortex analysis and MCP Server. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `integrate_devin` | Setup SonarQube integration for Devin. This will install secrets scanning hooks, configure Vortex analysis and MCP Server. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `integrate_pi` | Setup SonarQube integration for Pi. This will install secrets scanning hooks, configure Vortex analysis and the SonarQube MCP Server. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `context` | Augment AI agents with context from your codebase |
| `analyze` | Analyze code for quality and security issues Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `analyze_secrets` | Scan files or stdin for hardcoded secrets Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `analyze_dependency_risks` | Analyze project dependencies for security and license risks Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `analyze_agentic` | Run server-side Vortex analysis. Limitations apply Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `remediate` | Trigger AI agent remediation for eligible issues (SonarQube Cloud only) Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `link` | Link a project to the active connection in .sonar-config.json Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `link_list` | List linked projects at, under or enclosing a path as JSON, nearest first Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `config_get` | Print a stored sonar config value |
| `config_list` | Print every sonar config key with its current value |
| `config_set` | Store a sonar config value |
| `config_unset` | Remove a stored sonar config value |
| `architecture_current_get` | Current architecture, at most 150 nodes, 20 dependencies and 5 feedback pairs across languages; drill down with --component and --depth Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `architecture_intended_get` | Intended architecture; full JSON can be saved with intended set, --component/--depth give partial views, --language exports are CLI-only and cannot be passed to MCP architecture_set Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `architecture_intended_set` | Replace the intended architecture with a file shaped like the output of intended get --format json Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `architecture_directives_get` | Read a directive by id or list a page of visible project directives Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `architecture_directives_set` | Create, update or delete explicit project directives Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `architecture_findings_get` | List findings with their details from the latest main-branch analysis Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `architecture_install_skill` | Install the architecture skill for Claude Code and Cursor in this repository Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER. |
| `system_status` | Show overall system status: authentication, installed binaries, and integrations |
| `system_reset` | Reset the CLI to factory defaults: remove tokens, binaries, integrations, cached files, and local stats data. Pass --all to also remove CLI configuration (sonar config). |
| `allowlist_secrets_show` | List entries in the sonar-secrets allowlist |
| `allowlist_secrets_add` | Add a secret value to the sonar-secrets allowlist (interactive; requires a real terminal, not usable by agents or scripts) |
| `allowlist_secrets_remove` | Remove an entry from the sonar-secrets allowlist by key |
| `allowlist_secrets_clear` | Remove all entries from the sonar-secrets allowlist |
| `update` | Update SonarQube CLI to the latest version |
| `update_status` | Check for a newer version without installing |
<!-- /generated:language-examples -->
