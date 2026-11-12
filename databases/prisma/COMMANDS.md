# Prisma command coverage

Reviewed against https://www.prisma.io/docs/orm/v7/reference/prisma-cli-reference.

| Function | Native command | CI/CD purpose |
| --- | --- | --- |
| `run` | `prisma ` | Execute literal Prisma CLI arguments, including version-specific features. |
| `version` | `prisma --version` | Print the Prisma CLI and engine versions. |
| `init` | `prisma init` | Initialize a Prisma project; configure the datasource explicitly for unattended jobs. |
| `generate` | `prisma generate` | Generate project clients from the Prisma schema without applying migrations. |
| `validate` | `prisma validate` | Validate the project Prisma schema. |
| `format` | `prisma format` | Format schemas or fail a formatting check without writing changes. |
| `db-pull` | `prisma db pull` | Introspect the database; print avoids rewriting the project schema. |
| `db-push` | `prisma db push` | Synchronize schema without migrations; data loss and reset flags are explicit. |
| `db-seed` | `prisma db seed` | Run the project seed command configured in Prisma config. |
| `db-execute` | `prisma db execute` | Execute an existing SQL script using the configured datasource. |
| `migrate-deploy` | `prisma migrate deploy` | Apply pending committed migrations noninteractively in deployment pipelines. |
| `migrate-status` | `prisma migrate status` | Report migration status; propagate divergence and pending-migration failures. |
| `migrate-dev` | `prisma migrate dev` | Create and apply development migrations; use migrate-deploy for production. |
| `migrate-reset` | `prisma migrate reset` | Reset a disposable development database; destructive confirmation is explicit. |
| `migrate-resolve` | `prisma migrate resolve` | Record a migration as applied or rolled back; choose exactly one in Prisma. |
| `migrate-diff` | `prisma migrate diff` | Compare schema sources; native Prisma requires exactly one from and one to source. |
| `debug` | `prisma debug` | Print Prisma diagnostic information for troubleshooting. |
| `studio` | `prisma studio` | Run the long-lived Studio server within a scoped service lifecycle. |

Additional upstream flags and future commands remain accessible through CSV `arguments` on `run`. No database command executes during setup.
