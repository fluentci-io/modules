# Xata

Manage preview database branches and schema migrations from CI/CD pipelines.
This PureScript Wasm component requires FluentCI v0.17.2+ and the current Xata
Postgres platform CLI. Install it with [setup-xata](../../setup/xata/README.md).

```sh
fluentci run setup-xata setup --version 1.18.2
fluentci run xata branch-create --run-dir /tmp/xata-create \
  --organization-id ORG --project-id PROJECT --name pr-123 --parent-branch main
fluentci run xata branch-wait-ready --run-dir /tmp/xata-ready \
  --organization-id ORG --project-id PROJECT --branch pr-123
fluentci run xata migration-start --run-dir /tmp/xata-migration \
  --organization-id ORG --project-id PROJECT --branch pr-123 --migration-file migrations/001.json
fluentci run xata migration-complete --run-dir /tmp/xata-complete \
  --organization-id ORG --project-id PROJECT --branch pr-123
fluentci run xata branch-delete --run-dir /tmp/xata-cleanup \
  --organization-id ORG --project-id PROJECT --branch pr-123 --yes
```

Set `XATA_API_KEY` through the runner’s secret environment, or supply an existing
native authentication profile using `--profile`. Organization/project/branch
context can come from native configuration; pass identifiers explicitly for
predictable CI runs. `--project` selects the local working directory, while
`--project-id` selects a Xata project. Setup does not authenticate or provision a
server. The module sets `CI=true`; native commands requiring unspecified prompt
answers fail or remain subject to the configured task timeout.

## Complete CLI access

Every upstream top-level command has a function, including `auth`, `organization`,
`project`, `branch`, `keys`, `roll`, `clone`, `stream`, `skill`, `console`,
`checkout`, `init`, `scratch`, `onboard`, `status`, `licenses`, `upgrade`,
`completions`, and `version`. Each accepts its entire native subcommand and flag
surface through comma-separated `--arguments`. The `run` function accepts any
root command, alias, or future feature. These calls use literal argv tokens;
shell expansion and shell quoting are not applied.

```sh
fluentci run xata branch --run-dir /tmp/xata-list \
  --arguments list,--organization,ORG,--project,PROJECT,--json
fluentci run xata run --run-dir /tmp/xata-any --arguments status,--json
```

For values containing commas, double-quote the CSV entry and double any embedded
quotes. Shell-quote the complete CSV string when calling from a shell. Both
`arguments` and `artifacts` use CSV strings; JSON array brackets are not required.
A missing or blank optional list adds no arguments; malformed/empty CSV entries
fail before host commands. Native flags and behavior remain those of the
installed CLI version. See [COMMANDS.md](./COMMANDS.md) for the complete command
mapping and the reviewed upstream source revision.

## Pipeline functions and results

Named functions cover branch create/list/describe/delete/URL/readiness, project
creation, and pgroll init/start/complete/rollback/status/migrate/pull/baseline.
The `arguments` field on each helper provides additional native options.
Migration input files are checked before execution. Branch creation and deletion
execute immediately; place them in the appropriate workflow stages. Cloning,
replication, logs, metrics, query insights, backups, IP filters, key management,
and all other native features are available through their command-group function.
Native interactive shells and long-running streams still require an appropriate
runner lifecycle; setup does not create background services.

Each function needs a fresh `--run-dir`; `--timeout-ms` defaults to 900000.
Returns a typed execution result with outcome, report, stdout, and stderr paths.
Nonzero exits, transport failures, cancellations, and timeouts fail the call.
Use `--artifacts schema=out/schema.sql` to collect output files and their hashes.
Connection-string and credential commands write sensitive values to stdout;
choose how those report files are consumed and retained in your pipeline.
Credentials are inherited and are not injected into the execution plan by the
module. This adapter accepts Linux/macOS/BSD with an available compatible CLI;
setup availability and native database-client requirements still apply.

[COMPONENT.md](./COMPONENT.md) lists every named argument and return type;
[OPTIONS.md](./OPTIONS.md) records native flag mappings.
[Xata CLI](https://github.com/xataio/cli) · [MIT wrapper license](./LICENSE).
