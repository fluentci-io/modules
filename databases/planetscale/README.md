# PlanetScale

Create preview branches, run SQL, and deploy schema changes in CI/CD pipelines.
This PureScript Wasm component requires FluentCI v0.17.2+ and the PlanetScale
`pscale` CLI. Install it with [setup-planetscale](../../setup/planetscale/README.md).

```sh
fluentci run setup-planetscale setup --version 0.350.0
fluentci run planetscale branch-create --run-dir /tmp/pscale-create \
  --database app --branch pr-123 --organization team
fluentci run planetscale sql-query --run-dir /tmp/pscale-query \
  --database app --branch pr-123 --organization team --query 'SELECT 1' --output-format json
fluentci run planetscale deploy-request-create --run-dir /tmp/pscale-request \
  --database app --branch pr-123 --organization team --into main
fluentci run planetscale deploy-request-deploy --run-dir /tmp/pscale-deploy \
  --database app --request 123 --organization team
fluentci run planetscale branch-delete --run-dir /tmp/pscale-cleanup \
  --database app --branch pr-123 --organization team --force
```

Supply `PLANETSCALE_SERVICE_TOKEN_ID` and `PLANETSCALE_SERVICE_TOKEN` through the
runner’s secret environment, or use existing native authentication. Organization
context is exposed as `--organization` on named helpers; native group calls use
`--org`. No login, provisioning, or database server startup occurs during setup.
The module sets `CI=true`. Native engine-specific constraints still apply:
deploy requests are a Vitess schema workflow; PostgreSQL and other database
engines expose their own branch, role, parameter, replica, and migration features.

## Complete CLI access

Every upstream root command has a function covering its complete subcommand and
flag surface. This includes databases, branches, backups, deploy requests,
passwords, roles, keyspaces, imports, SQL, query insights, inspection, logs,
metrics, webhooks, workflows, maintenance, dedicated replicas, PgBouncer,
traffic controls, organizations, billing, authentication, and service tokens.
`run` also accepts arbitrary root commands, aliases, global flags, and newly
introduced features. See [COMMANDS.md](./COMMANDS.md) for the complete mapping.

```sh
fluentci run planetscale branch --run-dir /tmp/pscale-native \
  --arguments create,app,pr-456,--org,team,--wait
fluentci run planetscale run --run-dir /tmp/pscale-any \
  --arguments 'sql,app,pr-123,--org,team,--query,"SELECT a,b FROM example"'
```

`arguments` and `artifacts` accept comma-separated strings. CSV double quotes
preserve commas within a value; doubled quotes represent literal quotes.
Arguments are passed literally without shell expansion. Malformed CSV fails
before host commands. Native flags retain their installed CLI semantics.

## Pipeline functions and results

Named functions cover branch create/list/show/schema/delete, database discovery,
deploy-request create/show/diff/deploy, and noninteractive SQL. Branch creation
and deploy-request deployment wait for completion by default; pass `--wait=false`
to retain asynchronous native behavior. Mutations run when invoked. SQL text is
passed as one literal argument; native destructive-query guards remain enabled
unless the caller explicitly supplies `--force`. Additional native flags are
available through each helper’s `arguments` string.

Every invocation requires a fresh `--run-dir`; optional `--project` selects the
checkout directory and `--timeout-ms` defaults to 900000. Returns typed outcome,
report, stdout, and stderr paths. Nonzero exits, transport errors, timeouts,
and cancellations fail the call. Declare generated files using
`--artifacts schema=out/schema.sql` for artifact size/SHA-256 reporting.
Credentials remain inherited; the module does not serialize them into plans.
Connection/password commands can write secrets to stdout, so control the
retention of those report files. Native shell/connect commands need the relevant
PostgreSQL/MySQL client and a suitable runner lifecycle; task timeouts bound
long-running commands. Linux/macOS/BSD adapters require an installed compatible
CLI; setup package availability is documented separately.

[COMPONENT.md](./COMPONENT.md) documents every typed argument and return;
[OPTIONS.md](./OPTIONS.md) records native flag mappings.
[PlanetScale CLI](https://github.com/planetscale/cli) · [MIT wrapper license](./LICENSE).
