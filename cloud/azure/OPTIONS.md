# Azure module arguments

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

## `account_show`

account show

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `group_deploy`

Deploy an ARM or Bicep template to a resource group.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resourceGroup` | `string` | `--resource-group=<value>` | Required |
| `templateFile` | `string` | `--template-file=<value>` | Required |
| `name` | `string` | `--name=<value>` | Omitted |
| `parameters` | `strings` | `--parameters <values...>` | Omitted |

## `webapp_deploy`

webapp deploy

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resourceGroup` | `string` | `--resource-group=<value>` | Required |
| `name` | `string` | `--name=<value>` | Required |
| `srcPath` | `string` | `--src-path=<value>` | Required |
| `type` | `string (zip, war, jar, ear, static, startup, script, lib)` | `--type=<value>` | Omitted |
