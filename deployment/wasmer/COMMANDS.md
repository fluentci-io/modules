# Wasmer pipeline command coverage

Reviewed against Wasmer v7.5.0 using the [official reference](https://docs.wasmer.io/edge/cli/).

| Function | Native command | Pipeline purpose |
| --- | --- | --- |
| `run` | `wasmer ` | Execute additional Wasmer CLI commands with literal CSV arguments. |
| `version` | `wasmer --version` | Print the installed Wasmer version. |
| `deploy` | `wasmer deploy --non-interactive` | Deploy an application to Wasmer Edge without interactive prompts. |
| `publish` | `wasmer publish --non-interactive` | Publish a local package to the Wasmer registry without prompts. |
| `validate` | `wasmer validate` | Validate a local WebAssembly file before publishing. |
| `app-list` | `wasmer app list` | List accessible Wasmer Edge applications. |
| `app-get` | `wasmer app get` | Inspect a Wasmer Edge application. |
| `app-logs` | `wasmer app logs` | Retrieve logs without continuous watching by default. |
| `app-delete` | `wasmer app delete` | Delete the explicitly identified application; destructive native operation. |
| `deployments-list` | `wasmer app deployments list` | Inspect deployment history for an application. |
| `version-activate` | `wasmer app version activate` | Activate a selected unique version ID for rollback or promotion. |

CSV `arguments` supports additional upstream operations without invoking a shell.
