# Nx command coverage

Reviewed against [the official CLI reference](https://nx.dev/docs/reference/nx-commands).

| Function | Native command | Pipeline purpose |
| --- | --- | --- |
| `run` | `nx ` | Run arbitrary literal Nx CLI arguments. |
| `version` | `nx --version` | Print the Nx CLI versions. |
| `run-target` | `nx run` | Execute one project target, such as app:build:production. |
| `run-many` | `nx run-many` | Execute targets across selected projects; omitted projects selects all eligible projects. |
| `affected` | `nx affected` | Execute targets only for projects affected by the selected changes. |
| `show-projects` | `nx show projects --json` | Print matching project names as JSON without running targets. |
| `show-project` | `nx show project --json` | Print the resolved configuration of a project. |
| `graph` | `nx graph --open=false` | Write a project graph without opening a browser. |
| `format-check` | `nx format:check` | Fail when selected workspace files are not formatted. |
| `sync-check` | `nx sync:check` | Fail when workspace sync generators would change files. |
| `report` | `nx report` | Print Nx workspace and plugin version diagnostics. |

`run` and optional CSV `arguments` expose additional native features. Setup does not run workspace tasks.
