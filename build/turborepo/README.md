# Turborepo

Execute cached workspace tasks, select affected packages, inspect task plans, and prune workspaces for container builds. PureScript typed Wasm component for FluentCI v0.17.3+.

```sh
fluentci run setup-turborepo setup --version 2.11.11
fluentci run turborepo run-tasks --project . --run-dir /tmp/turbo-build-1 --tasks build,test,lint --filters web...,!docs --concurrency 4 --summarize
fluentci run turborepo affected --project . --run-dir /tmp/turbo-affected-1 --tasks build,test
fluentci run turborepo dry-run --project . --run-dir /tmp/turbo-plan-1 --tasks build,test
fluentci run turborepo prune --project . --run-dir /tmp/turbo-prune-1 --package web --docker --out-dir out
fluentci run turborepo run-tasks --run-dir /tmp/turbo-cache-1 --tasks build --cache local:rw,remote:r
```

Functions: `run`, `version`, `run-tasks`, `affected`, `dry-run`, `prune`, `list-packages`, `info`. See [COMPONENT.md](./COMPONENT.md) for named arguments and typed returns, [OPTIONS.md](./OPTIONS.md) for native flag mappings, and [COMMANDS.md](./COMMANDS.md) for coverage.

The component declares [setup-turborepo](../../setup/turborepo/README.md) as a typed dependency. Missing CLIs are installed automatically; existing CLIs are reused. Run setup first to select an exact version or pass `--executable ./node_modules/.bin/turbo` to use a project-local binary and bypass setup. Published dependencies are composed into the component, so consumers do not need repository-relative paths. See [module dependencies](../../docs/MODULE_DEPENDENCIES.md).

Install workspace dependencies from the project's lockfile before invoking task functions. Setup installs the CLI, not workspace packages, executors, plugins, compilers or task prerequisites. The global CLI can delegate to the workspace-local CLI; pin the workspace dependency as well to control the version that executes tasks. Run from the workspace root with `--project`.

The module is named **turborepo**; the native executable is **turbo**. It reuses the existing **setup-turborepo**, without a separate setup-turbo module. Named flags follow Turbo 2.x and were reviewed against 2.11.11. `run-tasks` requires explicit task names; `affected` adds native `--affected`; `dry-run` prints `--dry=json` output without running tasks. Cache source policies are validated as CSV and emitted as one native `--cache=local:rw,remote:r` argument; filters become repeated `--filter` arguments. Strict environment filtering remains native default unless `--env-mode` overrides it. `--force` bypasses cached results only when explicitly selected. `prune` writes a partial workspace and lockfile; it does not install or build that workspace. `--summarize` creates native summaries under `.turbo/runs`.

For affected detection provide complete Git history for the comparison. Set `TURBO_SCM_BASE` and `TURBO_SCM_HEAD` in the runner environment to override Turbo's default comparison. A shallow checkout can cause all packages to be considered changed. Remote cache credentials belong in `TURBO_TOKEN` and `TURBO_TEAM` or the native configuration.

All public lists are comma-separated strings. Whitespace around entries is trimmed, malformed CSV, empty entries, NUL characters and positional options disguised as task names are rejected before host commands. Blank optional lists preserve native defaults. Use CSV double quotes to preserve commas inside a single raw token or Turbo filter. Native selector parsing still applies to values after CSV decoding. Optional `--arguments` appends literal tokens without shell expansion. To forward flags to underlying scripts include `--` as its own CSV entry, for example `--arguments=--,--runInBand` on task functions; `run --arguments=--help` exposes other upstream commands.

Each invocation requires a fresh `--run-dir`. Failed tasks or native command errors fail the module. Cache hits retain native behavior. Successful calls return typed `outcome`, `run-dir`, `report-path`, `stdout-path` and `stderr-path`; structured native output is read from stdout or requested output files. Use comma-separated `--artifacts NAME=PATH` to collect files, and archive output directories before collecting them. The task environment sets `CI=true`. Credentials stay inherited rather than being copied into command arguments; protect logs and reports containing task output.

[Official CLI reference](https://turborepo.dev/docs/reference/run) · [MIT wrapper license](./LICENSE).
