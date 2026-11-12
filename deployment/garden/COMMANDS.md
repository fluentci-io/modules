# Garden command coverage

Reviewed against the [Cedar 0.14.20 reference](https://github.com/garden-io/garden/blob/0.14.20/docs/reference/commands.md).

| Function | Native command | Pipeline purpose |
| --- | --- | --- |
| `run` | `garden ` | Execute arbitrary Garden commands with literal CSV arguments. |
| `version` | `garden --version` | Print the installed Garden version. |
| `build` | `garden build` | Build selected actions and their build dependencies. |
| `deploy` | `garden deploy` | Deploy selected actions using the Garden dependency graph. |
| `test` | `garden test` | Run selected Test actions, including required build and runtime dependencies. |
| `run-actions` | `garden run` | Execute named Run actions and dependencies for migrations, seed jobs or integration tasks. |
| `workflow` | `garden workflow` | Execute a project-defined workflow in the selected environment. |
| `status` | `garden get status` | Inspect provider and action status for the selected environment. |
| `outputs` | `garden get outputs` | Resolve project outputs, including configured runtime output references. |
| `graph` | `garden get graph` | Inspect the project dependency graph. |
| `config` | `garden get config` | Inspect resolved project configuration. |
| `publish` | `garden publish` | Build and publish selected artifacts to configured registries. |
| `logs` | `garden logs` | Collect deployment logs without following by default. |
| `cleanup-deploy` | `garden cleanup deploy` | Remove selected deployments; omitted names targets all eligible deployments in this project environment. |
| `cleanup-namespace` | `garden cleanup namespace` | Clean the project environment namespace; explicitly select the intended environment. |

Additional flags and commands remain available through literal CSV `arguments`. The wrapper never adds confirmation or force flags implicitly.
