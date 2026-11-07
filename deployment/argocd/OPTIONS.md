# Argo CD module arguments

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

## `app_get`

app get

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `server` | `string` | `--server=<value>` (global) | Omitted |
| `grpcWeb` | `boolean` | `--grpc-web` (global) | Omitted |
| `output` | `string (json, yaml, wide)` | `--output=<value>` | Omitted |
| `application` | `string` | `<application>` | Required |

## `app_sync`

app sync

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `server` | `string` | `--server=<value>` (global) | Omitted |
| `grpcWeb` | `boolean` | `--grpc-web` (global) | Omitted |
| `revision` | `string` | `--revision=<value>` | Omitted |
| `prune` | `boolean` | `--prune` | Omitted |
| `application` | `string` | `<application>` | Required |

## `app_wait`

app wait

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `server` | `string` | `--server=<value>` (global) | Omitted |
| `grpcWeb` | `boolean` | `--grpc-web` (global) | Omitted |
| `timeout` | `integer` | `--timeout=<value>` | Omitted |
| `application` | `string` | `<application>` | Required |
