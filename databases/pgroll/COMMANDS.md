# pgroll CLI command coverage

Reviewed against [v0.16.3 CLI definitions](https://github.com/xataio/pgroll/blob/v0.16.3/cli-definition.json)
and the [command implementations](https://github.com/xataio/pgroll/tree/v0.16.3/cmd).

| Native command | Component function |
| --- | --- |
| `--version` | `version` |
| `init` | `init` |
| `validate` | `validate` |
| `start` | `start` |
| `complete` | `complete` |
| `rollback` | `rollback` |
| `migrate` | `migrate` |
| `status` | `status` |
| `analyze` (hidden) | `analyze` |
| `baseline --yes` | `baseline` |
| `pull` | `pull` |
| `convert` | `convert` |
| `update` | `update` |
| `create --empty --name NAME` | `create` |
| `latest` | `latest` |
| `latest migration` | `latest-migration` |
| `latest schema` | `latest-schema` |
| `latest url` | `latest-url` |
| `completion` (Cobra-generated) | `completion` |
| Any native command, alias, or flag | `run` |

Named functions expose applicable command flags and persistent connection/schema
options. All remaining native behavior is accessible through CSV `arguments`.
`create` is deliberately noninteractive; interactive creation remains available
through `run`. `baseline` confirms the history reset as part of its invocation.
