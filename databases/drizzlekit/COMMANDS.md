# Drizzle Kit command coverage

Reviewed against https://orm.drizzle.team/docs/kit-overview.

| Function | Native command | CI/CD purpose |
| --- | --- | --- |
| `run` | `drizzle-kit ` | Execute literal Drizzle Kit arguments for additional upstream features. |
| `version` | `drizzle-kit --version` | Print the Drizzle Kit version. |
| `generate` | `drizzle-kit generate` | Generate SQL migrations; custom creates an empty migration for handwritten SQL. |
| `migrate` | `drizzle-kit migrate` | Apply committed SQL migrations using the project database configuration. |
| `push` | `drizzle-kit push` | Apply schema changes directly; destructive approval is opt-in through force. |
| `pull` | `drizzle-kit pull` | Introspect the configured database into Drizzle schema files. |
| `check` | `drizzle-kit check` | Check generated migrations for collisions before merging. |
| `up` | `drizzle-kit up` | Upgrade existing migration snapshots to the installed Kit format. |
| `export-sql` | `drizzle-kit export` | Print SQL DDL from the configured TypeScript schema. |
| `studio` | `drizzle-kit studio` | Start the long-running Studio server; use a bounded timeout and scoped service lifecycle. |

Additional upstream flags and future commands remain accessible through CSV `arguments` on `run`. No database command executes during setup.
