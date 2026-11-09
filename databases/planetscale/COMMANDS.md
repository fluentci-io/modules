# PlanetScale CLI command coverage

Reviewed upstream source: [internal/cmd/root.go](https://github.com/planetscale/cli/blob/a10fddb3b74da8d1f9ef3689cc6a9faf8ff382cd/internal/cmd/root.go).

Each group function forwards every nested command and native flag through its CSV `arguments` string.
`run` provides root-level access to aliases, global flags, and features added by newer CLI versions.

| Native root command | Component function |
| --- | --- |
| `agents` | `agents` |
| `login` | `login` |
| `logout` | `logout` |
| `agent-guide` | `agent-guide` |
| `api` | `api` |
| `audit-log` | `audit-log` |
| `auth` | `auth` |
| `billing` | `billing` |
| `completion` | `completion` |
| `org` | `org` |
| `ping` | `ping` |
| `region` | `region` |
| `signup` | `signup` |
| `size` | `size` |
| `service-token` | `service-token` |
| `version` | `version` |
| `backup` | `backup` |
| `branch` | `branch` |
| `database` | `database` |
| `insights` | `insights` |
| `inspect` | `inspect` |
| `logs` | `logs` |
| `metrics` | `metrics` |
| `webhook` | `webhook` |
| `connect` | `connect` |
| `deploy-request` | `deploy-request` |
| `keyspace` | `keyspace` |
| `maintenance` | `maintenance` |
| `password` | `password` |
| `shell` | `shell` |
| `import` | `import-command` |
| `sql` | `sql` |
| `workflow` | `workflow` |
| `role` | `role-command` |
| `pgbouncer` | `pgbouncer` |
| `dedicated-read-replica` | `dedicated-read-replica` |
| `read-only-replica` | `read-only-replica` |
| `traffic-control` | `traffic-control` |

Named pipeline helpers are listed in [COMPONENT.md](./COMPONENT.md).
