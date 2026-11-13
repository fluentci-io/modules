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
