# pgroll

Run PostgreSQL schema migrations through typed PureScript Wasm functions in
CI/CD pipelines. Requires FluentCI v0.17.2+ and an installed `pgroll` CLI.
Use [setup-pgroll](../../setup/pgroll/README.md) to install it.

```sh
fluentci run setup-pgroll setup --version 0.16.3
# Set PGROLL_PG_URL from the runner's secret environment first.
fluentci run pgroll init --run-dir /tmp/pgroll-init
fluentci run pgroll validate --file migrations/001.yaml --run-dir /tmp/pgroll-validate
fluentci run pgroll start --file migrations/001.yaml --run-dir /tmp/pgroll-start
# Deploy and verify the application before completing the active migration.
fluentci run pgroll complete --run-dir /tmp/pgroll-complete
```

For directory-based workflows, `migrate --directory migrations` applies outstanding
migrations. The final migration stays active by default; pass `--complete` to
complete it, or `--expect-one` to reject more than one pending migration. `rollback`
reverts an active migration under pgroll's native limitations. A completed
migration cannot be treated as an arbitrary reversible deployment history.

Functions also cover `status`, `analyze`, `pull`, `baseline`, `convert`, `update`,
`create`, and `latest-migration`, `latest-schema`, and `latest-url`. `create`
requires `--name` and always supplies `--empty` to avoid interactive operation
selection. `baseline --baseline-version NAME --directory DIR` always supplies
`--yes`: invoking it resets migration history and creates a placeholder file.
`update` rewrites migration files in place. Review generated files before use.

`init` and `complete` do not require files despite upstream's historical help
synopsis. Existing migration/SQL files and input directories are checked before
execution. `pull` and `baseline` let pgroll create their destination directories.
Migration validation uses PostgreSQL; it is not an offline syntax checker.

## Configuration and complete CLI access

Use inherited `PGROLL_PG_URL` for the database connection, with TLS and permissions
appropriate to the migration. Native configuration also supports `PGROLL_SCHEMA`,
`PGROLL_STATE_SCHEMA`, `PGROLL_LOCK_TIMEOUT`, `PGROLL_ROLE`,
`PGROLL_USE_VERSION_SCHEMA`, and `PGROLL_VERBOSE`. Named functions expose the
matching optional arguments, including `--lock-timeout`, `--schema`,
`--state-schema`, and `--use-version-schema=false`. Omitted options retain native
defaults. Explicit `--postgres-url` is available, but embeds the URL in the plan;
secret environment variables remain inherited and are not serialized by the module.

All public lists are comma-separated strings. Each operation accepts additional
literal tokens through `--arguments`; `run` accesses every native command, flag,
or future feature. `latest` and `completion` expose their native subcommands.

```sh
fluentci run pgroll latest-schema --local migrations --run-dir /tmp/pgroll-schema
fluentci run pgroll create --name migrations/002_accounts --json --run-dir /tmp/pgroll-create
fluentci run pgroll run --arguments status,--verbose --run-dir /tmp/pgroll-native
```

Double-quote CSV entries containing commas and double embedded quotes. Shell-quote
the whole CSV value when calling from a shell. Tokens are passed literally without
shell expansion. Blank optional lists add no tokens; malformed or empty entries
fail before host commands. Interactive native commands remain available through
`run` and require a suitable runner lifecycle.

## Results and prerequisites

Each invocation requires a fresh `--run-dir`. `--project` selects the working
directory; `--timeout-ms` defaults to 900000. Functions return typed execution
outcome, report, stdout, and stderr paths. Nonzero exits, timeouts, transport
errors, and cancellations fail the call. Use `--artifacts migration=migrations/002_accounts.json`
to collect a generated file and its size/hash. `latest-url` can emit database
credentials; control retention of its output and reports.

The adapter accepts Linux, macOS, FreeBSD, NetBSD, and OpenBSD when a compatible
CLI is available. Database connectivity, PostgreSQL compatibility, permissions,
and pgroll installation remain runner prerequisites. Setup does not install or
start PostgreSQL. pgroll controls migration/backfill behavior; the wrapper does
not independently guarantee a lock-free or zero-downtime rollout.

See [COMPONENT.md](./COMPONENT.md) for typed arguments and results,
[OPTIONS.md](./OPTIONS.md) for native mappings, and
[COMMANDS.md](./COMMANDS.md) for reviewed command coverage.
[Upstream pgroll](https://github.com/xataio/pgroll) · [MIT wrapper license](./LICENSE).
