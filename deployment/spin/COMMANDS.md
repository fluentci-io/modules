# Spin pipeline command coverage

Reviewed against Spin v4.3.0 and the Fermyon cloud plugin using the [official reference](https://spinframework.dev/v4/cli-reference).

| Function | Native command | Pipeline purpose |
| --- | --- | --- |
| `run` | `spin ` | Execute additional Spin or plugin commands with literal CSV arguments. |
| `version` | `spin --version` | Print the installed Spin version. |
| `build` | `spin build` | Build application components with the project toolchains. |
| `registry-push` | `spin registry push` | Push an application as an OCI artifact using native registry credentials. |
| `registry-pull` | `spin registry pull` | Pull an application from an OCI registry. |
| `deploy` | `spin deploy` | Deploy through the plugin named by SPIN_DEPLOY_PLUGIN; arguments are plugin-specific. |
| `cloud-deploy` | `spin cloud deploy` | Deploy through the explicitly installed Fermyon cloud plugin. |
| `cloud-login` | `spin cloud login --auth-method=token` | Authenticate the cloud plugin using inherited SPIN_AUTH_TOKEN without browser login. |
| `plugins-install` | `spin plugins install` | Install a selected deployment/runtime plugin explicitly. |
| `plugins-list` | `spin plugins list` | Inspect installed Spin plugins. |
| `up` | `spin up` | Run an application in the foreground; use a scoped lifecycle and bounded timeout. |

CSV `arguments` supports additional upstream operations without invoking a shell.
