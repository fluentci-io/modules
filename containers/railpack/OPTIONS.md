# Railpack module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` (an object mapping output names to file paths).

## `run`

Run a native command with literal arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `strings` | `<arguments>` | Required |

## `version`

Print the installed tool version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `prepare`

Generate a build plan and metadata, failing when the project cannot be prepared.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `envNames` | `strings` | `--env=<value>` | Omitted |
| `configFile` | `string` | `--config-file=<value>` | Omitted |
| `buildCmd` | `string` | `--build-cmd=<value>` | Omitted |
| `startCmd` | `string` | `--start-cmd=<value>` | Omitted |
| `previous` | `strings` | `--previous=<value>` | Omitted |
| `directory` | `string` | `<directory>` | `"."` |
| `planOut` | `string` | `--plan-out=<value>` | `"railpack-plan.json"` |
| `infoOut` | `string` | `--info-out=<value>` | `"railpack-info.json"` |

## `build`

Build a project into an image through a configured BuildKit daemon.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `envNames` | `strings` | `--env=<value>` | Omitted |
| `configFile` | `string` | `--config-file=<value>` | Omitted |
| `buildCmd` | `string` | `--build-cmd=<value>` | Omitted |
| `startCmd` | `string` | `--start-cmd=<value>` | Omitted |
| `previous` | `strings` | `--previous=<value>` | Omitted |
| `directory` | `string` | `<directory>` | `"."` |
| `name` | `string` | `--name=<value>` | Required |
| `platform` | `string` | `--platform=<value>` | Omitted |
| `progress` | `string` | `--progress=<value>` | `"plain"` |
| `output` | `string` | `--output=<value>` | Omitted |
| `cacheFrom` | `strings` | `--cache-from=<value>` | Omitted |
| `cacheTo` | `strings` | `--cache-to=<value>` | Omitted |
| `noCache` | `boolean` | `--no-cache` | Omitted |

## `info`

Inspect detected runtimes, dependencies, and build requirements.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `format` | `string` | `--format=<value>` | `"json"` |
| `out` | `string` | `--out=<value>` | Omitted |
| `directory` | `string` | `<directory>` | `"."` |

## `schema`

Print the Railpack configuration JSON schema.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
