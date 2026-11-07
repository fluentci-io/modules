# OpenBao module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), and `timeoutMs` (default `900000`).

## `run`

Execute arbitrary literal CLI arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `strings` | `<arguments>` | Required |

## `version`

Print the CLI version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `status`

Check server initialization and seal status; sealed servers return a failing exit code.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `kv_list`

List key names without reading secret data.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `mount` | `string` | `-mount=<value>` | Omitted |
| `path` | `string` | `<path>` | Required |

## `kv_metadata`

Read KV v2 version metadata without reading secret values.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `mount` | `string` | `-mount=<value>` | Omitted |
| `path` | `string` | `<path>` | Required |

## `kv_put`

Write secret data from a JSON file, reporting metadata only.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `mount` | `string` | `-mount=<value>` | Omitted |
| `path` | `string` | `<path>` | Required |
| `dataFile` | `string` | `@<value>` | Required |

## `kv_delete`

Delete the latest version of a KV secret.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `mount` | `string` | `-mount=<value>` | Omitted |
| `path` | `string` | `<path>` | Required |
