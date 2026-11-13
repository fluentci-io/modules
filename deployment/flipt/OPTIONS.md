# Flipt module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` is a comma-separated NAME=PATH string in the public component contract.

## `run`

Run any Flipt CLI command as literal native arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Required |

## `version`

Report the installed Flipt version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `validate`

Validate flag-state YAML and fail the pipeline on validation issues.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `files` | `string (CSV)` | `<files>` | Omitted |
| `workDir` | `string` | `--work-dir=<value>` | Omitted |
| `extraSchema` | `string` | `--extra-schema=<value>` | Omitted |
| `format` | `string (json, text)` | `--format=<value>` | `"json"` |
| `issueExitCode` | `integer` | `--issue-exit-code=<value>` | `1` |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `migrate`

Run pending Flipt v2 analytics database migrations with the selected server configuration.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `license_check`

Check the configured Flipt Pro license status with the native licensing service.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `evaluate`

Evaluate a feature flag once without watch mode; upstream evaluation failures propagate.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `flagKey` | `string` | `<flagKey>` | Required |
| `address` | `string` | `--address=<value>` | Omitted |
| `environment` | `string` | `--environment=<value>` | Omitted |
| `namespace` | `string` | `--namespace=<value>` | Omitted |
| `entityId` | `string` | `--entity-id=<value>` | Omitted |
| `requestId` | `string` | `--request-id=<value>` | Omitted |
| `context` | `string (CSV)` | `--context=<value>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |
