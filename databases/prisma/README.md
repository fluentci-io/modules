# Prisma

Validate schemas, generate clients, inspect migration state, and deploy committed Prisma ORM migrations. PureScript typed Wasm component for FluentCI v0.17.3+.

```sh
fluentci run prisma validate --project . --run-dir /tmp/prisma-validate-1 --config prisma.config.ts
fluentci run prisma generate --project . --run-dir /tmp/prisma-generate-1 --generators client,reporting
fluentci run prisma migrate-deploy --project . --run-dir /tmp/prisma-deploy-1 --config prisma.config.ts
fluentci run prisma run --run-dir /tmp/prisma-help-1 --arguments migrate,deploy,--help
```

Functions: `run`, `version`, `init`, `generate`, `validate`, `format`, `db-pull`, `db-push`, `db-seed`, `db-execute`, `migrate-deploy`, `migrate-status`, `migrate-dev`, `migrate-reset`, `migrate-resolve`, `migrate-diff`, `debug`, `studio`. All named arguments and typed return values are described in [COMPONENT.md](./COMPONENT.md); native flag mappings are in [OPTIONS.md](./OPTIONS.md).

The component depends on [setup-prisma](../../setup/prisma/README.md). If `prisma` is missing, it invokes setup automatically and verifies that the executable is available. An existing CLI is reused. To select an exact version, run setup first; to use the project-local CLI, pass `--executable ./node_modules/.bin/prisma`. Explicit executable overrides skip automatic setup. Publishing composes the dependency; the relative source path is not required on consumers' machines. See [module dependencies](../../docs/MODULE_DEPENDENCIES.md).

Install project dependencies with the project lockfile before running these functions. Setup installs the CLI only, not the project's ORM/client, adapters, drivers or generated code. Run from the project directory using `--project`. A supplied `--config` must exist before setup or database operations start. Omitted config uses native discovery.

Named functions target Prisma ORM **7.x**, with setup default **7.8.0**. The npm `latest` tag currently points to a v8 release candidate with a different command surface. Pin compatible versions of Prisma CLI and your project client. Use `prisma.config.ts` for datasource and migrations configuration; Prisma 7 requires explicit environment loading in this config (for example `import "dotenv/config"`). `migrate-diff` delegates source exclusivity checks to Prisma. With `--exit-code`, drift exits 2 and fails the module call. `migrate-dev` and `migrate-reset` are for disposable development databases. Production jobs should use `migrate-deploy`. `studio` is a foreground service bounded by `timeout-ms`.

Credentials such as `DATABASE_URL` belong in the runner environment and project configuration. The wrapper inherits this environment without copying credentials into argument reports. Native CLI output can still contain connection details; protect the execution logs.

No destructive approval is enabled by default. Explicit force/data-loss/reset arguments retain upstream behavior. Each call requires a fresh `--run-dir`; failures propagate as module errors. Successful calls return typed `outcome`, `run-dir`, `report-path`, `stdout-path` and `stderr-path`, rather than claiming to return rows or SQL. Read generated SQL from stdout or a configured output file. Collect outputs using comma-separated `--artifacts NAME=PATH` entries.

Optional `--arguments` appends literal tokens for flags beyond the named contract. Lists use comma-separated strings; whitespace is trimmed and empty entries are rejected. For a token containing a comma, use CSV double quotes inside the argument string. No shell evaluation occurs.

[Official CLI documentation](https://www.prisma.io/docs/orm/v7/reference/prisma-cli-reference) · [MIT license](./LICENSE).
