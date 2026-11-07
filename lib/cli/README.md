# Shared CLI modules

`fluentci-cli-common` validates JSON inputs and builds single-task FluentCI
execution plans for the tool modules in this repository. Module entry points,
JSON schemas, and `OPTIONS.md` files are generated from [catalog.json](./catalog.json).

```sh
python3 scripts/generate_cli_modules.py
python3 scripts/generate_cli_modules.py --check
```

Run these commands from the repository root. Edit the catalog, regenerate, then
build and test every CLI module after changing the common engine. Each module
has its own pinned SDK, Spago lockfile, and npm dependencies. The relative
`../../lib/cli` package must accompany its source when vendoring a module.

## Execution

Every export accepts a JSON object. `runDir` is required and must identify a
fresh execution directory. `project` defaults to `.` and selects the local
working directory. `executable` overrides the native CLI program; an absolute
path avoids ambiguity when using wrappers. `timeoutMs` is a positive integer,
with a default of 900000. The optional `artifacts` object maps output names to paths for size/SHA-256
metadata in the host execution report. File inputs marked in the catalog are
checked before the command starts. Artifact collection is separate from remote
upload and retention in the CI provider.

Command-specific fields are listed in the module's
`OPTIONS.md` and schema.

The runtime checks the host OS, project directory, and required executable,
then submits the plan through the FluentCI host's `execute_plan` API. The host
creates the fresh run directory and persists its report and task logs. A failed,
cancelled, malformed, or missing successful outcome raises a plugin error.
Success returns the contents of `runDir/result.json` as the plugin's JSON string
output. The host must implement the plan-execution API from the pinned SDK.

Ordinary commands never invoke a shell. Spaces, quotes, Unicode, and shell
metacharacters stay inside literal argv elements. File globs are only expanded
when supported by the native tool itself. Positional values starting with `-`
are rejected; prefix such filenames with `./`. The generic `run` export accepts
literal `arguments`, including option tokens, for advanced CLI operations.
Interactive stdin and prompts are not supported; configure tools for unattended
execution before invoking them.

This library accepts Linux, macOS, FreeBSD, OpenBSD, and NetBSD. Actual tool and
feature availability depends on upstream support and the host installation.
Container tools need a reachable service where applicable; cloud and deployment
tools need the CLI's normal account, project, and cluster configuration.

Host environment variables are inherited by the task. Credentials should remain
in native configuration or inherited environment variables, not JSON arguments:
plans and task logs persist. Tool output can itself contain sensitive data, so
protect execution directories and avoid commands that print credentials.
Ubicloud additionally requires a nonempty `UBI_TOKEN`; its value is never placed
in the plan. Vercel requires an existing login or an executable wrapper that
reads its authentication token from the environment at execution time.

## Tests

The suites in [test/cli](../../test/cli) exercise every generated export and its
typed fields against compiled PureScript, check host failures, and execute a
local fixture program through the plan interface. Cloud operations use controlled
host responses, with no real deployments or account changes. Optional native
CLI tests exercise installed formatters and linters against temporary files,
uv against an offline Python project, and Cypress/Playwright against temporary
browser fixtures. The browser modules use Bun to install test dependencies.
Betterleaks, Gitleaks, and Syft native tests use synthetic markers and temporary package
metadata; they never scan this repository or verify credentials remotely. Secrets modules use native token
configuration, environment injection into child processes, or JSON file paths;
the module never reads or serializes credential values.

Licensed under the [MIT License](./LICENSE).
