# Wasmer module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` is a comma-separated NAME=PATH string in the public component contract.

## `run`

Execute additional Wasmer CLI commands with literal CSV arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Required |

## `version`

Print the installed Wasmer version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `deploy`

Deploy an application to Wasmer Edge without interactive prompts.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `directory` | `string` | `--dir <value>` | Omitted |
| `path` | `string` | `--path <value>` | Omitted |
| `envFile` | `string` | `--env-file <value>` | Omitted |
| `owner` | `string` | `--owner=<value>` | Omitted |
| `name` | `string` | `--name=<value>` | Omitted |
| `publishPackage` | `boolean` | `--publish-package` | Omitted |
| `buildRemote` | `boolean` | `--build-remote` | Omitted |
| `noWait` | `boolean` | `--no-wait` | Omitted |
| `noDefault` | `boolean` | `--no-default` | Omitted |
| `noPersistId` | `boolean` | `--no-persist-id` | Omitted |
| `format` | `string (json, yaml, table)` | `--format=<value>` | `"json"` |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `publish`

Publish a local package to the Wasmer registry without prompts.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `directory` | `string` | `<directory>` | Omitted |
| `namespace` | `string` | `--namespace=<value>` | Omitted |
| `name` | `string` | `--name=<value>` | Omitted |
| `packageVersion` | `string` | `--version=<value>` | Omitted |
| `dryRun` | `boolean` | `--dry-run` | Omitted |
| `wait` | `string (none, container, native-executables, bindings, all)` | `--wait=<value>` | Omitted |
| `queryTimeout` | `string` | `--timeout=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `validate`

Validate a local WebAssembly file before publishing.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `file` | `string` | `<file>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `app_list`

List accessible Wasmer Edge applications.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `namespace` | `string` | `--namespace=<value>` | Omitted |
| `all` | `boolean` | `--all` | Omitted |
| `max` | `integer` | `--max=<value>` | Omitted |
| `format` | `string (json, yaml, table)` | `--format=<value>` | `"json"` |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `app_get`

Inspect a Wasmer Edge application.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `app` | `string` | `<app>` | Omitted |
| `format` | `string (json, yaml, table)` | `--format=<value>` | `"json"` |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `app_logs`

Retrieve logs without continuous watching by default.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `app` | `string` | `<app>` | Omitted |
| `from` | `string` | `--from=<value>` | Omitted |
| `until` | `string` | `--until=<value>` | Omitted |
| `max` | `integer` | `--max=<value>` | Omitted |
| `watch` | `boolean` | `--watch` | Omitted |
| `streams` | `string (CSV)` | `--streams=<value>` | Omitted |
| `format` | `string (json, yaml, table)` | `--format=<value>` | `"json"` |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `app_delete`

Delete the explicitly identified application; destructive native operation.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `app` | `string` | `<app>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `deployments_list`

Inspect deployment history for an application.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `app` | `string` | `<app>` | Omitted |
| `offset` | `integer` | `--offset=<value>` | Omitted |
| `limit` | `integer` | `--limit=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `version_activate`

Activate a selected unique version ID for rollback or promotion.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `versionId` | `string` | `<versionId>` | Required |
| `format` | `string (json, yaml, table)` | `--format=<value>` | `"json"` |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |
