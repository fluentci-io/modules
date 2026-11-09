# PlanetScale module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` is a comma-separated NAME=PATH string in the public component contract.

## `run`

Execute any PlanetScale CLI feature with literal CSV arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Required |

## `version`

Print the installed pscale CLI version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `agents`

Run the complete pscale agents command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `login`

Run the complete pscale login command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `logout`

Run the complete pscale logout command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `agent_guide`

Run the complete pscale agent-guide command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `api`

Run the complete pscale api command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `audit_log`

Run the complete pscale audit-log command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `auth`

Run the complete pscale auth command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `billing`

Run the complete pscale billing command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `completion`

Run the complete pscale completion command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `org`

Run the complete pscale org command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `ping`

Run the complete pscale ping command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `region`

Run the complete pscale region command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `signup`

Run the complete pscale signup command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `size`

Run the complete pscale size command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `service_token`

Run the complete pscale service-token command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `backup`

Run the complete pscale backup command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `branch`

Run the complete pscale branch command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `database`

Run the complete pscale database command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `insights`

Run the complete pscale insights command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `inspect`

Run the complete pscale inspect command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `logs`

Run the complete pscale logs command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `metrics`

Run the complete pscale metrics command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `webhook`

Run the complete pscale webhook command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `connect`

Run the complete pscale connect command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `deploy_request`

Run the complete pscale deploy-request command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `keyspace`

Run the complete pscale keyspace command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `maintenance`

Run the complete pscale maintenance command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `password`

Run the complete pscale password command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `shell`

Run the complete pscale shell command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `import_command`

Run the complete pscale import command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `sql`

Run the complete pscale sql command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `workflow`

Run the complete pscale workflow command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `role_command`

Run the complete pscale role command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pgbouncer`

Run the complete pscale pgbouncer command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `dedicated_read_replica`

Run the complete pscale dedicated-read-replica command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `read_only_replica`

Run the complete pscale read-only-replica command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `traffic_control`

Run the complete pscale traffic-control command surface, including every nested subcommand and native flag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `branch_create`

Create a preview branch and wait for readiness by default.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `database` | `string` | `<database>` | Required |
| `branch` | `string` | `<branch>` | Required |
| `organization` | `string` | `--org=<value>` | Omitted |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `fromBranch` | `string` | `--from=<value>` | Omitted |
| `region` | `string` | `--region=<value>` | Omitted |
| `clusterSize` | `string` | `--cluster-size=<value>` | Omitted |
| `wait` | `boolean` | `--wait` | `true` |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `branch_list`

List database branches for preview environment discovery.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `database` | `string` | `<database>` | Required |
| `organization` | `string` | `--org=<value>` | Omitted |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `branch_show`

Inspect a database branch and its readiness information.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `database` | `string` | `<database>` | Required |
| `branch` | `string` | `<branch>` | Required |
| `organization` | `string` | `--org=<value>` | Omitted |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `branch_delete`

Delete a preview branch during pipeline cleanup.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `database` | `string` | `<database>` | Required |
| `branch` | `string` | `<branch>` | Required |
| `organization` | `string` | `--org=<value>` | Omitted |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `deleteDescendants` | `boolean` | `--delete-descendants` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `branch_schema`

Retrieve a branch schema for inspection or artifact collection.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `database` | `string` | `<database>` | Required |
| `branch` | `string` | `<branch>` | Required |
| `organization` | `string` | `--org=<value>` | Omitted |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `database_list`

List databases visible to the pipeline credentials.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `organization` | `string` | `--org=<value>` | Omitted |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `deploy_request_create`

Open a schema deploy request from a branch.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `database` | `string` | `<database>` | Required |
| `branch` | `string` | `<branch>` | Required |
| `organization` | `string` | `--org=<value>` | Omitted |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `into` | `string` | `--into=<value>` | Omitted |
| `notes` | `string` | `--notes=<value>` | Omitted |
| `autoDeleteBranch` | `boolean` | `--auto-delete-branch` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `deploy_request_show`

Inspect a deploy request before applying schema changes.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `database` | `string` | `<database>` | Required |
| `request` | `string` | `<request>` | Required |
| `organization` | `string` | `--org=<value>` | Omitted |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `deploy_request_diff`

Inspect schema changes in a deploy request.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `database` | `string` | `<database>` | Required |
| `requestNumber` | `integer` | `<requestNumber>` | Required |
| `organization` | `string` | `--org=<value>` | Omitted |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `deploy_request_deploy`

Deploy a schema request and wait for completion by default.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `database` | `string` | `<database>` | Required |
| `request` | `string` | `<request>` | Required |
| `organization` | `string` | `--org=<value>` | Omitted |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `wait` | `boolean` | `--wait` | `true` |
| `strategy` | `string (serial, parallel)` | `--strategy=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `sql_query`

Execute a noninteractive SQL query and propagate query failures.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `database` | `string` | `<database>` | Required |
| `branch` | `string` | `<branch>` | Required |
| `organization` | `string` | `--org=<value>` | Omitted |
| `outputFormat` | `string (human, json, csv)` | `--format=<value>` | Omitted |
| `query` | `string` | `--query=<value>` | Required |
| `role` | `string` | `--role=<value>` | Omitted |
| `dbname` | `string` | `--dbname=<value>` | Omitted |
| `keyspace` | `string` | `--keyspace=<value>` | Omitted |
| `replica` | `boolean` | `--replica` | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |
