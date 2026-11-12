# Turborepo command coverage

Reviewed against [the official CLI reference](https://turborepo.dev/docs/reference/run).

| Function | Native command | Pipeline purpose |
| --- | --- | --- |
| `run` | `turbo ` | Run arbitrary literal Turbo CLI arguments. |
| `version` | `turbo --version` | Print the Turbo CLI version. |
| `run-tasks` | `turbo run` | Run selected workspace tasks with native dependency ordering and caching. |
| `affected` | `turbo run --affected` | Run tasks only in affected packages; requires the Git comparison history. |
| `dry-run` | `turbo run --dry=json` | Print a JSON task plan without executing workspace tasks. |
| `prune` | `turbo prune` | Generate a partial workspace and pruned lockfile for a package. |
| `list-packages` | `turbo ls` | Inspect packages, dependencies and tasks without executing tasks. |
| `info` | `turbo info` | Print Turbo environment diagnostics. |

`run` and optional CSV `arguments` expose additional native features. Setup does not run workspace tasks.
