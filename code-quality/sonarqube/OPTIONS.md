# SonarQube module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` is a comma-separated NAME=PATH string in the public component contract.

## `run`

Execute any sonar command with literal comma-separated arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Required |

## `version`

Print the SonarQube CLI version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `help`

Show SonarQube CLI commands and options.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `auth_login`

Authenticate via browser or an existing token and save credentials in the system keychain. For CI and automation, use environment variables instead: https://docs.sonarsource.com/sonarqube-cli/using-sonarqube-cli/environment-variables

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `server` | `string` | `--server=<value>` | Omitted |
| `org` | `string` | `--org=<value>` | Omitted |
| `withToken` | `boolean` | `--with-token` | Omitted |

## `auth_org`

Switch the active SonarQube Cloud organization without logging in again Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `org` | `string` | `<org>` | Omitted |

## `auth_logout`

Remove the active connection, or all saved connections for a hostname with --server

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `server` | `string` | `--server=<value>` | Omitted |

## `auth_status`

Show active authentication connection with token verification

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `format` | `string` | `--format=<value>` | Omitted |

## `list_issues`

Search for issues in SonarQube Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `projectKey` | `string` | `--project=<value>` | Omitted |
| `statuses` | `string (CSV)` | `--statuses=<comma-separated values>` | Omitted |
| `severities` | `string (CSV)` | `--severities=<comma-separated values>` | Omitted |
| `format` | `string` | `--format=<value>` | Omitted |
| `branch` | `string` | `--branch=<value>` | Omitted |
| `pullRequest` | `string` | `--pull-request=<value>` | Omitted |
| `file` | `string` | `--file=<value>` | Omitted |
| `newCode` | `boolean` | `--new-code` | Omitted |
| `pageSize` | `integer` | `--page-size=<value>` | Omitted |
| `page` | `integer` | `--page=<value>` | Omitted |

## `list_projects`

Search for projects in SonarQube Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `query` | `string` | `--query=<value>` | Omitted |
| `format` | `string` | `--format=<value>` | Omitted |
| `page` | `integer` | `--page=<value>` | Omitted |
| `pageSize` | `integer` | `--page-size=<value>` | Omitted |

## `list_orgs`

List organizations you have access to (SonarQube Cloud only) Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `format` | `string` | `--format=<value>` | Omitted |
| `page` | `integer` | `--page=<value>` | Omitted |
| `pageSize` | `integer` | `--page-size=<value>` | Omitted |

## `quality_gate_status`

Show the quality gate verdict for a project Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `projectKey` | `string` | `--project=<value>` | Omitted |
| `format` | `string` | `--format=<value>` | Omitted |
| `branch` | `string` | `--branch=<value>` | Omitted |
| `pullRequest` | `string` | `--pull-request=<value>` | Omitted |
| `all` | `boolean` | `--all` | Omitted |
| `category` | `string` | `--category=<value>` | Omitted |
| `top` | `integer` | `--top=<value>` | Omitted |
| `path` | `string` | `<path>` | Omitted |

## `import_repositories`

Import repositories from a connected DevOps platform into SonarQube Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `repo` | `string (CSV)` | `--repo=<value>` | Omitted |
| `all` | `boolean` | `--all` | Omitted |
| `regex` | `string` | `--regex=<value>` | Omitted |
| `dopSetting` | `string` | `--dop-setting=<value>` | Omitted |
| `nonInteractive` | `boolean` | `--non-interactive` | `true` |

## `api`

Make authenticated API requests to SonarQube Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `data` | `string` | `--data=<value>` | Omitted |
| `verbose` | `boolean` | `--verbose` | Omitted |
| `method` | `string (get, post, patch, put, delete)` | `<method>` | Required |
| `endpoint` | `string` | `<endpoint>` | Required |

## `integrate_git`

Install a Git pre-commit hook that scans staged files for secrets and dependency risks before each commit, or a Git pre-push hook that scans committed files for secrets before each push. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `hook` | `string` | `--hook=<value>` | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `nonInteractive` | `boolean` | `--non-interactive` | `true` |
| `local` | `boolean` | `--local` | Omitted |
| `global` | `boolean` | `--global` | Omitted |

## `integrate_claude`

Setup SonarQube integration for Claude Code. This will install secrets scanning hooks, configure Vortex analysis and MCP Server. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `nonInteractive` | `boolean` | `--non-interactive` | `true` |
| `global` | `boolean` | `--global` | Omitted |

## `integrate_copilot`

Setup SonarQube integration for GitHub Copilot CLI. This will install secrets scanning hooks, configure Vortex analysis and MCP Server. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `nonInteractive` | `boolean` | `--non-interactive` | `true` |
| `global` | `boolean` | `--global` | Omitted |

## `integrate_codex`

Setup SonarQube integration for Codex. This will install secrets scanning hooks, configure Vortex analysis and MCP Server. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `nonInteractive` | `boolean` | `--non-interactive` | `true` |
| `global` | `boolean` | `--global` | Omitted |

## `integrate_antigravity`

Setup SonarQube integration for Antigravity. Installs secrets scanning hooks, prompt-secrets instructions, and Vortex Context. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `nonInteractive` | `boolean` | `--non-interactive` | `true` |
| `global` | `boolean` | `--global` | Omitted |

## `integrate_cursor`

Setup SonarQube integration for Cursor. This will configure the SonarQube MCP Server, install secrets scanning hooks, and configure Vortex analysis. Note: Cursor's cloud/background agents only pick up project-level hooks, not global ones. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `nonInteractive` | `boolean` | `--non-interactive` | `true` |
| `global` | `boolean` | `--global` | Omitted |

## `integrate_opencode`

Setup SonarQube integration for OpenCode. This will install secrets scanning hooks, configure Vortex analysis and MCP Server. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `nonInteractive` | `boolean` | `--non-interactive` | `true` |
| `global` | `boolean` | `--global` | Omitted |

## `integrate_devin`

Setup SonarQube integration for Devin. This will install secrets scanning hooks, configure Vortex analysis and MCP Server. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `nonInteractive` | `boolean` | `--non-interactive` | `true` |
| `global` | `boolean` | `--global` | Omitted |

## `integrate_pi`

Setup SonarQube integration for Pi. This will install secrets scanning hooks, configure Vortex analysis and the SonarQube MCP Server. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `nonInteractive` | `boolean` | `--non-interactive` | `true` |
| `global` | `boolean` | `--global` | Omitted |

## `context`

Augment AI agents with context from your codebase

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `action` | `string` | `<action>` | Required |
| `contextArguments` | `string (CSV)` | `<contextArguments>` | Omitted |

## `analyze`

Analyze code for quality and security issues Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `files` | `string (CSV)` | `--file=<value>` | Omitted |
| `staged` | `boolean` | `--staged` | Omitted |
| `base` | `string` | `--base=<value>` | Omitted |
| `projectKey` | `string` | `--project=<value>` | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `depth` | `string (STANDARD, DEEP)` | `--depth=<value>` | Omitted |
| `format` | `string` | `--format=<value>` | Omitted |

## `analyze_secrets`

Scan files or stdin for hardcoded secrets Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `stdin` | `boolean` | `--stdin` | Omitted |
| `exclude` | `string (CSV)` | `--exclude=<value>` | Omitted |
| `paths` | `string (CSV)` | `<paths>` | Omitted |

## `analyze_dependency_risks`

Analyze project dependencies for security and license risks Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `projectKey` | `string` | `--project=<value>` | Omitted |
| `format` | `string` | `--format=<value>` | Omitted |
| `statuses` | `string (CSV)` | `--statuses=<comma-separated values>` | Omitted |
| `minSeverity` | `string` | `--min-severity=<value>` | Omitted |

## `analyze_agentic`

Run server-side Vortex analysis. Limitations apply Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `files` | `string (CSV)` | `--file=<value>` | Omitted |
| `staged` | `boolean` | `--staged` | Omitted |
| `base` | `string` | `--base=<value>` | Omitted |
| `projectKey` | `string` | `--project=<value>` | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `depth` | `string (STANDARD, DEEP)` | `--depth=<value>` | Omitted |
| `format` | `string` | `--format=<value>` | Omitted |
| `branch` | `string` | `--branch=<value>` | Omitted |

## `remediate`

Trigger AI agent remediation for eligible issues (SonarQube Cloud only) Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `projectKey` | `string` | `--project=<value>` | Omitted |
| `issues` | `string (CSV)` | `--issues=<comma-separated values>` | Omitted |

## `link`

Link a project to the active connection in .sonar-config.json Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `path` | `string` | `--path=<value>` | Omitted |
| `monorepo` | `boolean` | `--monorepo` | Omitted |
| `projectKey` | `string` | `<projectKey>` | Required |

## `link_list`

List linked projects at, under or enclosing a path as JSON, nearest first Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `path` | `string` | `--path=<value>` | Omitted |
| `pattern` | `string` | `--pattern=<value>` | Omitted |
| `page` | `integer` | `--page=<value>` | Omitted |
| `pageSize` | `integer` | `--page-size=<value>` | Omitted |

## `config_get`

Print a stored sonar config value

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `format` | `string` | `--format=<value>` | Omitted |
| `key` | `string` | `<key>` | Required |

## `config_list`

Print every sonar config key with its current value

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `format` | `string` | `--format=<value>` | Omitted |
| `onlySet` | `boolean` | `--only-set` | Omitted |

## `config_set`

Store a sonar config value

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `key` | `string` | `<key>` | Required |
| `value` | `string` | `<value>` | Required |

## `config_unset`

Remove a stored sonar config value

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `key` | `string` | `<key>` | Required |

## `architecture_current_get`

Current architecture, at most 150 nodes, 20 dependencies and 5 feedback pairs across languages; drill down with --component and --depth Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `projectKey` | `string` | `--project=<value>` | Omitted |
| `component` | `string` | `--component=<value>` | Omitted |
| `depth` | `integer` | `--depth=<value>` | Omitted |
| `from` | `string` | `--from=<value>` | Omitted |
| `to` | `string` | `--to=<value>` | Omitted |
| `page` | `integer` | `--page=<value>` | Omitted |
| `pageSize` | `integer` | `--page-size=<value>` | Omitted |
| `language` | `string` | `--language=<value>` | Omitted |
| `format` | `string` | `--format=<value>` | Omitted |

## `architecture_intended_get`

Intended architecture; full JSON can be saved with intended set, --component/--depth give partial views, --language exports are CLI-only and cannot be passed to MCP architecture_set Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `projectKey` | `string` | `--project=<value>` | Omitted |
| `component` | `string` | `--component=<value>` | Omitted |
| `depth` | `integer` | `--depth=<value>` | Omitted |
| `language` | `string` | `--language=<value>` | Omitted |
| `format` | `string` | `--format=<value>` | Omitted |

## `architecture_intended_set`

Replace the intended architecture with a file shaped like the output of intended get --format json Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `file` | `string` | `--file=<value>` | Required |
| `dryRun` | `boolean` | `--dry-run` | Omitted |
| `projectKey` | `string` | `--project=<value>` | Omitted |

## `architecture_directives_get`

Read a directive by id or list a page of visible project directives Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `id` | `string` | `--id=<value>` | Omitted |
| `projectKey` | `string` | `--project=<value>` | Omitted |
| `format` | `string` | `--format=<value>` | Omitted |
| `page` | `integer` | `--page=<value>` | Omitted |
| `pageSize` | `integer` | `--page-size=<value>` | Omitted |

## `architecture_directives_set`

Create, update or delete explicit project directives Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `file` | `string` | `--file=<value>` | Required |
| `dryRun` | `boolean` | `--dry-run` | Omitted |
| `projectKey` | `string` | `--project=<value>` | Omitted |

## `architecture_findings_get`

List findings with their details from the latest main-branch analysis Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `projectKey` | `string` | `--project=<value>` | Omitted |
| `category` | `string` | `--category=<value>` | Omitted |
| `type` | `string` | `--type=<value>` | Omitted |
| `language` | `string` | `--language=<value>` | Omitted |
| `format` | `string` | `--format=<value>` | Omitted |
| `page` | `integer` | `--page=<value>` | Omitted |
| `pageSize` | `integer` | `--page-size=<value>` | Omitted |

## `architecture_install_skill`

Install the architecture skill for Claude Code and Cursor in this repository Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `global` | `boolean` | `--global` | Omitted |
| `force` | `boolean` | `--force` | Omitted |

## `system_status`

Show overall system status: authentication, installed binaries, and integrations

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `format` | `string` | `--format=<value>` | Omitted |
| `json` | `boolean` | `--json` | Omitted |

## `system_reset`

Reset the CLI to factory defaults: remove tokens, binaries, integrations, cached files, and local stats data. Pass --all to also remove CLI configuration (sonar config).

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `force` | `boolean` | `--force` | Omitted |
| `all` | `boolean` | `--all` | Omitted |

## `allowlist_secrets_show`

List entries in the sonar-secrets allowlist

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `allowlist_secrets_add`

Add a secret value to the sonar-secrets allowlist (interactive; requires a real terminal, not usable by agents or scripts)

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `allowlist_secrets_remove`

Remove an entry from the sonar-secrets allowlist by key

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `key` | `string` | `<key>` | Required |

## `allowlist_secrets_clear`

Remove all entries from the sonar-secrets allowlist

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `force` | `boolean` | `--force` | Omitted |

## `update`

Update SonarQube CLI to the latest version

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `status` | `boolean` | `--status` | Omitted |
| `force` | `boolean` | `--force` | Omitted |

## `update_status`

Check for a newer version without installing

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `format` | `string` | `--format=<value>` | Omitted |
