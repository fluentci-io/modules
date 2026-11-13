# sonarqube component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `run`

Execute any sonar command with literal comma-separated arguments.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `arguments` | `string` | yes | Required comma-separated literal native argument tokens; CSV quoting preserves embedded commas. |

Returns `Contract.ExecutionResult`.

## `version`

Print the SonarQube CLI version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `help`

Show SonarQube CLI commands and options.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `auth-login`

Authenticate via browser or an existing token and save credentials in the system keychain. For CI and automation, use environment variables instead: https://docs.sonarsource.com/sonarqube-cli/using-sonarqube-cli/environment-variables

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `server` | `string` | no | SonarQube Server URL, SonarQube Cloud EU (https://sonarcloud.io), or SonarQube Cloud US (https://sonarqube.us). Defaults to SonarQube Cloud EU. |
| `org` | `string` | no | SonarQube Cloud organization key (required for SonarQube Cloud) |
| `with-token` | `boolean` | no | Read an existing token from standard input |

Returns `Contract.ExecutionResult`.

## `auth-org`

Switch the active SonarQube Cloud organization without logging in again Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `org` | `string` | no | SonarQube Cloud organization key |

Returns `Contract.ExecutionResult`.

## `auth-logout`

Remove the active connection, or all saved connections for a hostname with --server

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `server` | `string` | no | Select a saved server URL and clear all saved connections and the shared token for its hostname |

Returns `Contract.ExecutionResult`.

## `auth-status`

Show active authentication connection with token verification

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `format` | `string` | no | Output format |

Returns `Contract.ExecutionResult`.

## `list-issues`

Search for issues in SonarQube Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `project-key` | `string` | no | Project key |
| `statuses` | `string` | no | Filter by status (comma-separated list of: OPEN, CONFIRMED, FALSE_POSITIVE, ACCEPTED, FIXED). Defaults to OPEN, CONFIRMED. Comma-separated values; whitespace is trimmed and entries are passed literally. |
| `severities` | `string` | no | Filter by severity. Valid values depend on server mode — Multi-Quality Rule (MQR) mode: INFO, LOW, MEDIUM, HIGH, BLOCKER; Standard Experience mode: INFO, MINOR, MAJOR, CRITICAL, BLOCKER. Comma-separated values; whitespace is trimmed and entries are passed literally. |
| `format` | `string` | no | Output format |
| `branch` | `string` | no | Branch name. Cannot be combined with --pull-request. |
| `pull-request` | `string` | no | Pull request ID. Cannot be combined with --branch. |
| `file` | `string` | no | Limit results to one file, or to a directory's own files (not its subdirectories): a full path from the project root, or just a name if it matches only one |
| `new-code` | `boolean` | no | Only show issues on new code (the leak period) |
| `page-size` | `integer` | no | Page size (1-500) |
| `page` | `integer` | no | Page number |

Returns `Contract.ExecutionResult`.

## `list-projects`

Search for projects in SonarQube Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `query` | `string` | no | Search query to filter projects by name or key |
| `format` | `string` | no | Output format |
| `page` | `integer` | no | Page number |
| `page-size` | `integer` | no | Page size (1-500) |

Returns `Contract.ExecutionResult`.

## `list-orgs`

List organizations you have access to (SonarQube Cloud only) Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `format` | `string` | no | Output format |
| `page` | `integer` | no | Page number |
| `page-size` | `integer` | no | Page size (1-500) |

Returns `Contract.ExecutionResult`.

## `quality-gate-status`

Show the quality gate verdict for a project Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `project-key` | `string` | no | Project key |
| `format` | `string` | no | Output format |
| `branch` | `string` | no | Branch name. Cannot be combined with --pull-request. |
| `pull-request` | `string` | no | Pull request ID. Cannot be combined with --branch. |
| `all` | `boolean` | no | Also show passing conditions. By default only failing conditions are shown. |
| `category` | `string` | no | Only show the breakdown for one category of failing conditions |
| `top` | `integer` | no | Number of entries to include in the breakdown, per condition |
| `path` | `string` | no | File or directory path to show conditions for, instead of the whole project |

Returns `Contract.ExecutionResult`.

## `import-repositories`

Import repositories from a connected DevOps platform into SonarQube Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `repo` | `string` | no | DevOps platform repository slug (e.g. my-org/my-repo). Repeatable and/or comma-separated to import multiple repositories. Cannot be combined with --all or --regex. Comma-separated values; whitespace is trimmed and entries are passed literally. |
| `all` | `boolean` | no | Import every eligible repository in the organization (not already imported, and allowed by its project visibility settings). Cannot be combined with --repo or --regex. |
| `regex` | `string` | no | Import only eligible repositories whose DevOps platform name (not slug) matches this regular expression. Case-sensitive by default; wrap as /pattern/flags to add flags like case-insensitive matching. Cannot be combined with --repo or --all. Examples: --regex "^test-" --regex "/^archived-/i" |
| `dop-setting` | `string` | no | SonarQube Server only: key of the DevOps platform setting to import from. Required when several are configured and prompts are off. |
| `non-interactive` | `boolean` | no | Skip all prompts; require explicit flags Default: true. |

Returns `Contract.ExecutionResult`.

## `api`

Make authenticated API requests to SonarQube Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `data` | `string` | no | JSON string for request body. The tool will automatically format as either form data or JSON body. |
| `verbose` | `boolean` | no | Print request and response details for debugging. |
| `method` | `string` | yes | HTTP method (get, post, patch, put, delete) Allowed values: get, post, patch, put, delete. |
| `endpoint` | `string` | yes | API endpoint path. Must start with "/", and can contain query parameters. |

Returns `Contract.ExecutionResult`.

## `integrate-git`

Install a Git pre-commit hook that scans staged files for secrets and dependency risks before each commit, or a Git pre-push hook that scans committed files for secrets before each push. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `hook` | `string` | no | Hook to install: pre-commit (scan staged files) or pre-push (scan files in unpushed commits) |
| `force` | `boolean` | no | Overwrite existing hook if it is not from sonar integrate git |
| `non-interactive` | `boolean` | no | Non-interactive mode (no prompts) Default: true. |
| `local` | `boolean` | no | Install the hook for this repository only, instead of globally (workaround for setups where a global hook does not fit, e.g. Husky) |
| `global` | `boolean` | no | Backwards compatibility; the hook is installed globally by default |

Returns `Contract.ExecutionResult`.

## `integrate-claude`

Setup SonarQube integration for Claude Code. This will install secrets scanning hooks, configure Vortex analysis and MCP Server. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `non-interactive` | `boolean` | no | Non-interactive mode (no prompts) Default: true. |
| `global` | `boolean` | no | Backwards compatibility; integrations are installed globally by default |

Returns `Contract.ExecutionResult`.

## `integrate-copilot`

Setup SonarQube integration for GitHub Copilot CLI. This will install secrets scanning hooks, configure Vortex analysis and MCP Server. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `non-interactive` | `boolean` | no | Non-interactive mode (no prompts) Default: true. |
| `global` | `boolean` | no | Backwards compatibility; integrations are installed globally by default |

Returns `Contract.ExecutionResult`.

## `integrate-codex`

Setup SonarQube integration for Codex. This will install secrets scanning hooks, configure Vortex analysis and MCP Server. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `non-interactive` | `boolean` | no | Non-interactive mode (no prompts) Default: true. |
| `global` | `boolean` | no | Backwards compatibility; integrations are installed globally by default |

Returns `Contract.ExecutionResult`.

## `integrate-antigravity`

Setup SonarQube integration for Antigravity. Installs secrets scanning hooks, prompt-secrets instructions, and Vortex Context. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `non-interactive` | `boolean` | no | Non-interactive mode (no prompts) Default: true. |
| `global` | `boolean` | no | Backwards compatibility; integrations are installed globally by default |

Returns `Contract.ExecutionResult`.

## `integrate-cursor`

Setup SonarQube integration for Cursor. This will configure the SonarQube MCP Server, install secrets scanning hooks, and configure Vortex analysis. Note: Cursor's cloud/background agents only pick up project-level hooks, not global ones. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `non-interactive` | `boolean` | no | Non-interactive mode (no prompts) Default: true. |
| `global` | `boolean` | no | Backwards compatibility; integrations are installed globally by default |

Returns `Contract.ExecutionResult`.

## `integrate-opencode`

Setup SonarQube integration for OpenCode. This will install secrets scanning hooks, configure Vortex analysis and MCP Server. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `non-interactive` | `boolean` | no | Non-interactive mode (no prompts) Default: true. |
| `global` | `boolean` | no | Backwards compatibility; integrations are installed globally by default |

Returns `Contract.ExecutionResult`.

## `integrate-devin`

Setup SonarQube integration for Devin. This will install secrets scanning hooks, configure Vortex analysis and MCP Server. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `non-interactive` | `boolean` | no | Non-interactive mode (no prompts) Default: true. |
| `global` | `boolean` | no | Backwards compatibility; integrations are installed globally by default |

Returns `Contract.ExecutionResult`.

## `integrate-pi`

Setup SonarQube integration for Pi. This will install secrets scanning hooks, configure Vortex analysis and the SonarQube MCP Server. Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `non-interactive` | `boolean` | no | Non-interactive mode (no prompts) Default: true. |
| `global` | `boolean` | no | Backwards compatibility; integrations are installed globally by default |

Returns `Contract.ExecutionResult`.

## `context`

Augment AI agents with context from your codebase

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `action` | `string` | yes | Action forwarded to sonar-context-augmentation |
| `context-arguments` | `string` | no | Additional arguments forwarded to sonar-context-augmentation Comma-separated literal tokens. |

Returns `Contract.ExecutionResult`.

## `analyze`

Analyze code for quality and security issues Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `files` | `string` | no | Analyze specific file(s) instead of the git change set (repeatable) Comma-separated values; whitespace is trimmed and entries are passed literally. |
| `staged` | `boolean` | no | Analyze staged files only (git diff --cached) |
| `base` | `string` | no | Analyze files changed vs a branch or ref (e.g. main) |
| `project-key` | `string` | no | SonarQube project key (overrides auto-detected project) |
| `force` | `boolean` | no | Skip the large change set confirmation prompt |
| `depth` | `string` | no | Analysis depth: STANDARD (fast) or DEEP (cross-file). Default: STANDARD for one --file; DEEP otherwise. Allowed values: STANDARD, DEEP. |
| `format` | `string` | no | Output format |

Returns `Contract.ExecutionResult`.

## `analyze-secrets`

Scan files or stdin for hardcoded secrets Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `stdin` | `boolean` | no | Read from standard input instead of paths |
| `exclude` | `string` | no | File or directory to skip (repeatable; exact path or directory prefix, no wildcards). Overrides the secrets.exclude config key Comma-separated values; whitespace is trimmed and entries are passed literally. |
| `paths` | `string` | no | File or directory paths to scan for secrets Comma-separated literal tokens. |

Returns `Contract.ExecutionResult`.

## `analyze-dependency-risks`

Analyze project dependencies for security and license risks Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `project-key` | `string` | no | Project key (auto-detected when omitted) |
| `format` | `string` | no | Output format |
| `statuses` | `string` | no | Filter issues by status Raw: new \| open \| confirm \| accept \| safe \| fixed Presets: active \| to_fix \| all active: new, open, confirm to_fix: new, open, confirm, accept all: new, open, confirm, accept, safe, fixed Presets and raw statuses can be combined; the resulting set is the union. Examples: --statuses active --statuses new,confirm --statuses active,safe Comma-separated values; whitespace is trimmed and entries are passed literally. |
| `min-severity` | `string` | no | Minimum severity level to include. Allowed values: BLOCKER, HIGH, MEDIUM, LOW, INFO (default: all severities) |

Returns `Contract.ExecutionResult`.

## `analyze-agentic`

Run server-side Vortex analysis. Limitations apply Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `files` | `string` | no | Analyze specific file(s) instead of the git change set (repeatable) Comma-separated values; whitespace is trimmed and entries are passed literally. |
| `staged` | `boolean` | no | Analyze staged files only (git diff --cached) |
| `base` | `string` | no | Analyze files changed vs a branch or ref (e.g. main) |
| `project-key` | `string` | no | SonarQube project key (overrides auto-detected project) |
| `force` | `boolean` | no | Skip the large change set confirmation prompt |
| `depth` | `string` | no | Analysis depth: STANDARD (fast) or DEEP (cross-file). Default: STANDARD for one --file; DEEP otherwise. Allowed values: STANDARD, DEEP. |
| `format` | `string` | no | Output format |
| `branch` | `string` | no | Branch name for analysis context |

Returns `Contract.ExecutionResult`.

## `remediate`

Trigger AI agent remediation for eligible issues (SonarQube Cloud only) Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `project-key` | `string` | no | SonarQube Cloud project key (overrides auto-detected project) |
| `issues` | `string` | no | Comma-separated issue keys to remediate non-interactively (max 20). Required when stdin is not a TTY. Comma-separated values; whitespace is trimmed and entries are passed literally. |

Returns `Contract.ExecutionResult`.

## `link`

Link a project to the active connection in .sonar-config.json Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `path` | `string` | no | Path to the project root, relative to the repository root |
| `monorepo` | `boolean` | no | Add or update this directory in the projects array instead of replacing the single link |
| `project-key` | `string` | yes | SonarQube project key (omit to pick one: a verified suggestion, or a search) |

Returns `Contract.ExecutionResult`.

## `link-list`

List linked projects at, under or enclosing a path as JSON, nearest first Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `path` | `string` | no | File or directory to list projects for (default: current directory) |
| `pattern` | `string` | no | Only list projects whose key or directory matches this regex |
| `page` | `integer` | no | Page number |
| `page-size` | `integer` | no | Page size (1-100) |

Returns `Contract.ExecutionResult`.

## `config-get`

Print a stored sonar config value

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `format` | `string` | no | Output format |
| `key` | `string` | yes | Config key to read |

Returns `Contract.ExecutionResult`.

## `config-list`

Print every sonar config key with its current value

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `format` | `string` | no | Output format |
| `only-set` | `boolean` | no | Only show keys that currently have a value |

Returns `Contract.ExecutionResult`.

## `config-set`

Store a sonar config value

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `key` | `string` | yes | Config key to set |
| `value` | `string` | yes | Value to store; omit to enter it interactively without echoing |

Returns `Contract.ExecutionResult`.

## `config-unset`

Remove a stored sonar config value

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `key` | `string` | yes | Config key to unset |

Returns `Contract.ExecutionResult`.

## `architecture-current-get`

Current architecture, at most 150 nodes, 20 dependencies and 5 feedback pairs across languages; drill down with --component and --depth Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `project-key` | `string` | no | Project key |
| `component` | `string` | no | Node key to start below, from a previous current get |
| `depth` | `integer` | no | Levels below the start node (default 1) |
| `from` | `string` | no | Dependency source key, including descendants; requires --to |
| `to` | `string` | no | Dependency destination key, including descendants; requires --from |
| `page` | `integer` | no | Dependency page (default 1; requires --from/--to) |
| `page-size` | `integer` | no | Dependencies per page (default/maximum 20) |
| `language` | `string` | no | Only this language (default: all) |
| `format` | `string` | no | Output format (default: text on a terminal, toon otherwise) |

Returns `Contract.ExecutionResult`.

## `architecture-intended-get`

Intended architecture; full JSON can be saved with intended set, --component/--depth give partial views, --language exports are CLI-only and cannot be passed to MCP architecture_set Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `project-key` | `string` | no | Project key |
| `component` | `string` | no | Group key to start below, e.g. Domain/Billing |
| `depth` | `integer` | no | Levels of groups below the start group (default: all) |
| `language` | `string` | no | Only this language (default: all) |
| `format` | `string` | no | Output format (default: text on a terminal, toon otherwise) |

Returns `Contract.ExecutionResult`.

## `architecture-intended-set`

Replace the intended architecture with a file shaped like the output of intended get --format json Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `file` | `string` | yes | Intended architecture JSON file |
| `dry-run` | `boolean` | no | Validate and show the changes, removals first, without writing |
| `project-key` | `string` | no | Project key |

Returns `Contract.ExecutionResult`.

## `architecture-directives-get`

Read a directive by id or list a page of visible project directives Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `id` | `string` | no | Directive UUID; cannot be combined with pagination |
| `project-key` | `string` | no | Project key |
| `format` | `string` | no | Output format (default: text on a terminal, toon otherwise) |
| `page` | `integer` | no | Page number (default 1) |
| `page-size` | `integer` | no | Items per page (default 50, maximum 1000) |

Returns `Contract.ExecutionResult`.

## `architecture-directives-set`

Create, update or delete explicit project directives Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `file` | `string` | yes | JSON object with create, update and delete arrays |
| `dry-run` | `boolean` | no | Preview changes without writing |
| `project-key` | `string` | no | Project key |

Returns `Contract.ExecutionResult`.

## `architecture-findings-get`

List findings with their details from the latest main-branch analysis Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `project-key` | `string` | no | Project key |
| `category` | `string` | no | Only this category |
| `type` | `string` | no | Only this finding type |
| `language` | `string` | no | Only this language (default: all) |
| `format` | `string` | no | Output format (default: text on a terminal, toon otherwise) |
| `page` | `integer` | no | Page number (default 1) |
| `page-size` | `integer` | no | Items per page (default 50, 0 counts only, maximum 1000) |

Returns `Contract.ExecutionResult`.

## `architecture-install-skill`

Install the architecture skill for Claude Code and Cursor in this repository Uses native credentials; for CI supply SONARQUBE_CLI_TOKEN and SONARQUBE_CLI_ORG or SONARQUBE_CLI_SERVER.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `global` | `boolean` | no | Install in the home directory instead of the repository |
| `force` | `boolean` | no | Replace a SKILL.md that was not written by this command |

Returns `Contract.ExecutionResult`.

## `system-status`

Show overall system status: authentication, installed binaries, and integrations

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `format` | `string` | no | Output format |
| `json` | `boolean` | no | Output as JSON for machine consumption |

Returns `Contract.ExecutionResult`.

## `system-reset`

Reset the CLI to factory defaults: remove tokens, binaries, integrations, cached files, and local stats data. Pass --all to also remove CLI configuration (sonar config).

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `force` | `boolean` | no | Skip the interactive confirmation prompt (required for non-interactive use) |
| `all` | `boolean` | no | Also remove CLI configuration (sonar config), including network and telemetry configuration |

Returns `Contract.ExecutionResult`.

## `allowlist-secrets-show`

List entries in the sonar-secrets allowlist

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `allowlist-secrets-add`

Add a secret value to the sonar-secrets allowlist (interactive; requires a real terminal, not usable by agents or scripts)

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |

Returns `Contract.ExecutionResult`.

## `allowlist-secrets-remove`

Remove an entry from the sonar-secrets allowlist by key

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `key` | `string` | yes | Unique key of the allowlist entry to remove |

Returns `Contract.ExecutionResult`.

## `allowlist-secrets-clear`

Remove all entries from the sonar-secrets allowlist

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `force` | `boolean` | no | Skip the interactive confirmation prompt (required for non-interactive use) |

Returns `Contract.ExecutionResult`.

## `update`

Update SonarQube CLI to the latest version

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `status` | `boolean` | no | Check for a newer version without installing |
| `force` | `boolean` | no | Install the latest version even if already up to date |

Returns `Contract.ExecutionResult`.

## `update-status`

Check for a newer version without installing

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `string` | no | Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas. |
| `format` | `string` | no | Output format |

Returns `Contract.ExecutionResult`.
