# AWS module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` (an object mapping output names to file paths).

## `run`

Execute arbitrary literal CLI arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `strings` | `<arguments>` | Required |

## `version`

Print the CLI version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `identity`

Inspect the authenticated AWS principal.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `region` | `string` | `--region=<value>` (global) | Omitted |
| `profile` | `string` | `--profile=<value>` (global) | Omitted |
| `endpointUrl` | `string` | `--endpoint-url=<value>` (global) | Omitted |
| `output` | `string (json, text, table, yaml, yaml-stream)` | `--output=<value>` | Omitted |

## `s3_cp`

Copy files to, from, or between S3 locations.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `region` | `string` | `--region=<value>` (global) | Omitted |
| `profile` | `string` | `--profile=<value>` (global) | Omitted |
| `endpointUrl` | `string` | `--endpoint-url=<value>` (global) | Omitted |
| `recursive` | `boolean` | `--recursive` | Omitted |
| `exclude` | `strings` | `--exclude=<value>` | Omitted |
| `include` | `strings` | `--include=<value>` | Omitted |
| `source` | `string` | `<source>` | Required |
| `destination` | `string` | `<destination>` | Required |

## `s3_sync`

Synchronize a directory or S3 prefix.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `region` | `string` | `--region=<value>` (global) | Omitted |
| `profile` | `string` | `--profile=<value>` (global) | Omitted |
| `endpointUrl` | `string` | `--endpoint-url=<value>` (global) | Omitted |
| `delete` | `boolean` | `--delete` | Omitted |
| `dryrun` | `boolean` | `--dryrun` | Omitted |
| `exclude` | `strings` | `--exclude=<value>` | Omitted |
| `include` | `strings` | `--include=<value>` | Omitted |
| `source` | `string` | `<source>` | Required |
| `destination` | `string` | `<destination>` | Required |

## `cloudformation_deploy`

Deploy a CloudFormation template.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `region` | `string` | `--region=<value>` (global) | Omitted |
| `profile` | `string` | `--profile=<value>` (global) | Omitted |
| `endpointUrl` | `string` | `--endpoint-url=<value>` (global) | Omitted |
| `templateFile` | `string` | `--template-file=<value>` | Required |
| `stackName` | `string` | `--stack-name=<value>` | Required |
| `capabilities` | `strings` | `--capabilities <values...>` | Omitted |
| `parameterOverrides` | `strings` | `--parameter-overrides <values...>` | Omitted |
| `noFailOnEmptyChangeset` | `boolean` | `--no-fail-on-empty-changeset` | Omitted |
