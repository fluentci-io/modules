# Drizzle Kit

Generate and check SQL migrations, introspect schemas, export DDL, and apply committed migrations. PureScript typed Wasm component for FluentCI v0.17.3+.

```sh
fluentci run drizzlekit generate --project . --run-dir /tmp/drizzle-generate-1 --config drizzle.config.ts
fluentci run drizzlekit check --project . --run-dir /tmp/drizzle-check-1 --config drizzle.config.ts
fluentci run drizzlekit migrate --project . --run-dir /tmp/drizzle-deploy-1 --config drizzle.config.ts
fluentci run drizzlekit run --run-dir /tmp/drizzle-help-1 --arguments generate,--help
```

Functions: `run`, `version`, `generate`, `migrate`, `push`, `pull`, `check`, `up`, `export-sql`, `studio`. All named arguments and typed return values are described in [COMPONENT.md](./COMPONENT.md); native flag mappings are in [OPTIONS.md](./OPTIONS.md).

The component depends on [setup-drizzlekit](../../setup/drizzlekit/README.md). If `drizzle-kit` is missing, it invokes setup automatically and verifies that the executable is available. An existing CLI is reused. To select an exact version, run setup first; to use the project-local CLI, pass `--executable ./node_modules/.bin/drizzle-kit`. Explicit executable overrides skip automatic setup. Publishing composes the dependency; the relative source path is not required on consumers' machines. See [module dependencies](../../docs/MODULE_DEPENDENCIES.md).

Install project dependencies with the project lockfile before running these functions. Setup installs the CLI only, not the project's ORM/client, adapters, drivers or generated code. Run from the project directory using `--project`. A supplied `--config` must exist before setup or database operations start. Omitted config uses native discovery.

The default Kit version is 0.31.11. Use `drizzle.config.ts` for dialect, schema paths, output directories, filters and database credentials. Kit rejects combinations of a config file and conflicting configuration flags; the wrapper passes native errors through. `generate` may ask about renames: review generated migrations before deployment. `check` checks migration collisions, not database drift. `export-sql` writes SQL to the returned stdout log. `studio` is a foreground service bounded by `timeout-ms`.

Credentials such as `DATABASE_URL` belong in the runner environment and project configuration. The wrapper inherits this environment without copying credentials into argument reports. Native CLI output can still contain connection details; protect the execution logs.

No destructive approval is enabled by default. Explicit force/data-loss/reset arguments retain upstream behavior. Each call requires a fresh `--run-dir`; failures propagate as module errors. Successful calls return typed `outcome`, `run-dir`, `report-path`, `stdout-path` and `stderr-path`, rather than claiming to return rows or SQL. Read generated SQL from stdout or a configured output file. Collect outputs using comma-separated `--artifacts NAME=PATH` entries.

Optional `--arguments` appends literal tokens for flags beyond the named contract. Lists use comma-separated strings; whitespace is trimmed and empty entries are rejected. For a token containing a comma, use CSV double quotes inside the argument string. No shell evaluation occurs.

[Official CLI documentation](https://orm.drizzle.team/docs/kit-overview) · [MIT license](./LICENSE).
