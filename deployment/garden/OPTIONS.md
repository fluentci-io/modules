# Garden module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` is a comma-separated NAME=PATH string in the public component contract.

## `run`

Execute arbitrary Garden commands with literal CSV arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Required |

## `version`

Print the installed Garden version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `build`

Build selected actions and their build dependencies.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `environment` | `string` | `--env=<value>` (global) | Omitted |
| `variables` | `string (CSV)` | `--var=<value>` (global) | Omitted |
| `output` | `string (json, yaml)` | `--output=<value>` (global) | Omitted |
| `logLevel` | `string (error, warn, info, verbose, debug, silly)` | `--log-level=<value>` (global) | Omitted |
| `yes` | `boolean` | `--yes` | Omitted |
| `names` | `string (CSV)` | `<names>` | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `withDependants` | `boolean` | `--with-dependants` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `deploy`

Deploy selected actions using the Garden dependency graph.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `environment` | `string` | `--env=<value>` (global) | Omitted |
| `variables` | `string (CSV)` | `--var=<value>` (global) | Omitted |
| `output` | `string (json, yaml)` | `--output=<value>` (global) | Omitted |
| `logLevel` | `string (error, warn, info, verbose, debug, silly)` | `--log-level=<value>` (global) | Omitted |
| `yes` | `boolean` | `--yes` | Omitted |
| `names` | `string (CSV)` | `<names>` | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `forceBuild` | `boolean` | `--force-build` | Omitted |
| `plan` | `boolean` | `--plan` | Omitted |
| `skip` | `string (CSV)` | `--skip=<value>` | Omitted |
| `skipDependencies` | `boolean` | `--skip-dependencies` | Omitted |
| `withDependants` | `boolean` | `--with-dependants` | Omitted |
| `disablePortForwards` | `boolean` | `--disable-port-forwards` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `test`

Run selected Test actions, including required build and runtime dependencies.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `environment` | `string` | `--env=<value>` (global) | Omitted |
| `variables` | `string (CSV)` | `--var=<value>` (global) | Omitted |
| `output` | `string (json, yaml)` | `--output=<value>` (global) | Omitted |
| `logLevel` | `string (error, warn, info, verbose, debug, silly)` | `--log-level=<value>` (global) | Omitted |
| `yes` | `boolean` | `--yes` | Omitted |
| `names` | `string (CSV)` | `<names>` | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `forceBuild` | `boolean` | `--force-build` | Omitted |
| `modules` | `string (CSV)` | `--module=<value>` | Omitted |
| `skip` | `string (CSV)` | `--skip=<value>` | Omitted |
| `skipDependencies` | `boolean` | `--skip-dependencies` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `run_actions`

Execute named Run actions and dependencies for migrations, seed jobs or integration tasks.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `environment` | `string` | `--env=<value>` (global) | Omitted |
| `variables` | `string (CSV)` | `--var=<value>` (global) | Omitted |
| `output` | `string (json, yaml)` | `--output=<value>` (global) | Omitted |
| `logLevel` | `string (error, warn, info, verbose, debug, silly)` | `--log-level=<value>` (global) | Omitted |
| `yes` | `boolean` | `--yes` | Omitted |
| `names` | `string (CSV)` | `<names>` | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `forceBuild` | `boolean` | `--force-build` | Omitted |
| `modules` | `string (CSV)` | `--module=<value>` | Omitted |
| `skip` | `string (CSV)` | `--skip=<value>` | Omitted |
| `skipDependencies` | `boolean` | `--skip-dependencies` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `workflow`

Execute a project-defined workflow in the selected environment.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `environment` | `string` | `--env=<value>` (global) | Omitted |
| `variables` | `string (CSV)` | `--var=<value>` (global) | Omitted |
| `output` | `string (json, yaml)` | `--output=<value>` (global) | Omitted |
| `logLevel` | `string (error, warn, info, verbose, debug, silly)` | `--log-level=<value>` (global) | Omitted |
| `yes` | `boolean` | `--yes` | Omitted |
| `name` | `string` | `<name>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `status`

Inspect provider and action status for the selected environment.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `environment` | `string` | `--env=<value>` (global) | Omitted |
| `variables` | `string (CSV)` | `--var=<value>` (global) | Omitted |
| `output` | `string (json, yaml)` | `--output=<value>` (global) | Omitted |
| `logLevel` | `string (error, warn, info, verbose, debug, silly)` | `--log-level=<value>` (global) | Omitted |
| `yes` | `boolean` | `--yes` | Omitted |
| `skipDetail` | `boolean` | `--skip-detail` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `outputs`

Resolve project outputs, including configured runtime output references.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `environment` | `string` | `--env=<value>` (global) | Omitted |
| `variables` | `string (CSV)` | `--var=<value>` (global) | Omitted |
| `output` | `string (json, yaml)` | `--output=<value>` (global) | Omitted |
| `logLevel` | `string (error, warn, info, verbose, debug, silly)` | `--log-level=<value>` (global) | Omitted |
| `yes` | `boolean` | `--yes` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `graph`

Inspect the project dependency graph.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `environment` | `string` | `--env=<value>` (global) | Omitted |
| `variables` | `string (CSV)` | `--var=<value>` (global) | Omitted |
| `output` | `string (json, yaml)` | `--output=<value>` (global) | Omitted |
| `logLevel` | `string (error, warn, info, verbose, debug, silly)` | `--log-level=<value>` (global) | Omitted |
| `yes` | `boolean` | `--yes` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `config`

Inspect resolved project configuration.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `environment` | `string` | `--env=<value>` (global) | Omitted |
| `variables` | `string (CSV)` | `--var=<value>` (global) | Omitted |
| `output` | `string (json, yaml)` | `--output=<value>` (global) | Omitted |
| `logLevel` | `string (error, warn, info, verbose, debug, silly)` | `--log-level=<value>` (global) | Omitted |
| `yes` | `boolean` | `--yes` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `publish`

Build and publish selected artifacts to configured registries.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `environment` | `string` | `--env=<value>` (global) | Omitted |
| `variables` | `string (CSV)` | `--var=<value>` (global) | Omitted |
| `output` | `string (json, yaml)` | `--output=<value>` (global) | Omitted |
| `logLevel` | `string (error, warn, info, verbose, debug, silly)` | `--log-level=<value>` (global) | Omitted |
| `yes` | `boolean` | `--yes` | Omitted |
| `names` | `string (CSV)` | `<names>` | Omitted |
| `forceBuild` | `boolean` | `--force-build` | Omitted |
| `tag` | `string` | `--tag=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `logs`

Collect deployment logs without following by default.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `environment` | `string` | `--env=<value>` (global) | Omitted |
| `variables` | `string (CSV)` | `--var=<value>` (global) | Omitted |
| `output` | `string (json, yaml)` | `--output=<value>` (global) | Omitted |
| `logLevel` | `string (error, warn, info, verbose, debug, silly)` | `--log-level=<value>` (global) | Omitted |
| `yes` | `boolean` | `--yes` | Omitted |
| `names` | `string (CSV)` | `<names>` | Omitted |
| `since` | `string` | `--since=<value>` | Omitted |
| `tail` | `integer` | `--tail=<value>` | Omitted |
| `follow` | `boolean` | `--follow` | Omitted |
| `timestamps` | `boolean` | `--timestamps` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `cleanup_deploy`

Remove selected deployments; omitted names targets all eligible deployments in this project environment.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `environment` | `string` | `--env=<value>` (global) | Omitted |
| `variables` | `string (CSV)` | `--var=<value>` (global) | Omitted |
| `output` | `string (json, yaml)` | `--output=<value>` (global) | Omitted |
| `logLevel` | `string (error, warn, info, verbose, debug, silly)` | `--log-level=<value>` (global) | Omitted |
| `yes` | `boolean` | `--yes` | Omitted |
| `names` | `string (CSV)` | `<names>` | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `dependantsFirst` | `boolean` | `--dependants-first` | Omitted |
| `withDependants` | `boolean` | `--with-dependants` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `cleanup_namespace`

Clean the project environment namespace; explicitly select the intended environment.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `environment` | `string` | `--env=<value>` (global) | Omitted |
| `variables` | `string (CSV)` | `--var=<value>` (global) | Omitted |
| `output` | `string (json, yaml)` | `--output=<value>` (global) | Omitted |
| `logLevel` | `string (error, warn, info, verbose, debug, silly)` | `--log-level=<value>` (global) | Omitted |
| `yes` | `boolean` | `--yes` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |
