# Nx

Run project targets across a workspace, select affected projects, inspect graphs, and validate formatting and sync state. PureScript typed Wasm component for FluentCI v0.17.3+.

```sh
fluentci run setup-nx setup --version 24.0.6
fluentci run nx run-many --project . --run-dir /tmp/nx-build-1 --targets build,test,lint --projects app,shared-* --parallel 4
fluentci run nx affected --project . --run-dir /tmp/nx-affected-1 --targets build,test --base origin/main --head HEAD
fluentci run nx run-target --project . --run-dir /tmp/nx-target-1 --target app:build:production
fluentci run nx show-projects --project . --run-dir /tmp/nx-projects-1 --affected --base origin/main --head HEAD
fluentci run nx graph --project . --run-dir /tmp/nx-graph-1 --file graph.json --artifacts graph=graph.json
```

Functions: `run`, `version`, `run-target`, `run-many`, `affected`, `show-projects`, `show-project`, `graph`, `format-check`, `sync-check`, `report`. See [COMPONENT.md](./COMPONENT.md) for named arguments and typed returns, [OPTIONS.md](./OPTIONS.md) for native flag mappings, and [COMMANDS.md](./COMMANDS.md) for coverage.

The component declares [setup-nx](../../setup/nx/README.md) as a typed dependency. Missing CLIs are installed automatically; existing CLIs are reused. Run setup first to select an exact version or pass `--executable ./node_modules/.bin/nx` to use a project-local binary and bypass setup. Published dependencies are composed into the component, so consumers do not need repository-relative paths. See [module dependencies](../../docs/MODULE_DEPENDENCIES.md).

Install workspace dependencies from the project's lockfile before invoking task functions. Setup installs the CLI, not workspace packages, executors, plugins, compilers or task prerequisites. The global CLI can delegate to the workspace-local CLI; pin the workspace dependency as well to control the version that executes tasks. Run from the workspace root with `--project`.

Named flags target Nx 24.x. `run-target` takes a single `PROJECT:TARGET[:CONFIGURATION]` selector. `run-many` and `affected` require explicit target lists. Omitted or blank `projects` on `run-many` targets all eligible projects. Targets, projects, exclusions, changed files and target filters are validated as CSV and emitted as single comma-delimited native flag values. Changed paths may refer to deleted files and are not checked for existence. Native Nx validates conflicting change-selection options. `graph` writes its output file and disables opening a browser. `show-projects` and `show-project` print JSON. `format-check` and `sync-check` fail when the workspace needs changes; they do not automatically fix them. Task logs default to static output. The task environment sets `NX_DAEMON=false` to avoid a background Nx daemon.

For affected detection check out the base/head history, and pass `--base` and `--head`, or set `NX_BASE` and `NX_HEAD`. Alternatively pass a CSV `--files` list. Configure Nx Cloud or another remote-cache provider in the workspace, with credentials such as `NX_CLOUD_ACCESS_TOKEN` in the runner environment. Cache bypass and remote-cache disable flags are opt-in.

All public lists are comma-separated strings. Whitespace around entries is trimmed, malformed CSV, empty entries, NUL characters and positional options disguised as task names are rejected before host commands. Blank optional lists preserve native defaults. Use CSV double quotes to preserve commas inside a single raw token or Turbo filter. Native selector parsing still applies to values after CSV decoding. Optional `--arguments` appends literal tokens without shell expansion. To forward flags to underlying scripts include `--` as its own CSV entry, for example `--arguments=--,--runInBand` on task functions; `run --arguments=--help` exposes other upstream commands.

Each invocation requires a fresh `--run-dir`. Failed tasks or native command errors fail the module. Cache hits retain native behavior. Successful calls return typed `outcome`, `run-dir`, `report-path`, `stdout-path` and `stderr-path`; structured native output is read from stdout or requested output files. Use comma-separated `--artifacts NAME=PATH` to collect files, and archive output directories before collecting them. The task environment sets `CI=true`. Credentials stay inherited rather than being copied into command arguments; protect logs and reports containing task output.

[Official CLI reference](https://nx.dev/docs/reference/nx-commands) · [MIT wrapper license](./LICENSE).
