# Spin module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` is a comma-separated NAME=PATH string in the public component contract.

## `run`

Execute additional Spin or plugin commands with literal CSV arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Required |

## `version`

Print the installed Spin version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `build`

Build application components with the project toolchains.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `from` | `string` | `--from=<value>` | Omitted |
| `profile` | `string` | `--profile=<value>` | Omitted |
| `components` | `string (CSV)` | `--component-id=<value>` | Omitted |
| `skipTargetChecks` | `boolean` | `--skip-target-checks` | Omitted |
| `skipGenerateWits` | `boolean` | `--skip-generate-wits` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `registry_push`

Push an application as an OCI artifact using native registry credentials.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `reference` | `string` | `<reference>` | Required |
| `from` | `string` | `--from=<value>` | Omitted |
| `profile` | `string` | `--profile=<value>` | Omitted |
| `build` | `boolean` | `--build` | Omitted |
| `compose` | `boolean` | `--compose=<value>` | Omitted |
| `annotations` | `string (CSV)` | `--annotation=<value>` | Omitted |
| `cacheDir` | `string` | `--cache-dir=<value>` | Omitted |
| `insecure` | `boolean` | `--insecure` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `registry_pull`

Pull an application from an OCI registry.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `reference` | `string` | `<reference>` | Required |
| `prepare` | `string` | `--prepare=<value>` | Omitted |
| `cacheDir` | `string` | `--cache-dir=<value>` | Omitted |
| `insecure` | `boolean` | `--insecure` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `deploy`

Deploy through the plugin named by SPIN_DEPLOY_PLUGIN; arguments are plugin-specific.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `cloud_deploy`

Deploy through the explicitly installed Fermyon cloud plugin.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `from` | `string` | `--from=<value>` | Omitted |
| `build` | `boolean` | `--build` | Omitted |
| `environmentName` | `string` | `--environment-name=<value>` | Omitted |
| `readinessTimeout` | `integer` | `--readiness-timeout=<value>` | Omitted |
| `variables` | `string (CSV)` | `--variable=<value>` | Omitted |
| `keyValues` | `string (CSV)` | `--key-value=<value>` | Omitted |
| `links` | `string (CSV)` | `--link=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `cloud_login`

Authenticate the cloud plugin using inherited SPIN_AUTH_TOKEN without browser login.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `environmentName` | `string` | `--environment-name=<value>` | Omitted |
| `url` | `string` | `--url=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `plugins_install`

Install a selected deployment/runtime plugin explicitly.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `name` | `string` | `<name>` | Required |
| `pluginVersion` | `string` | `--version=<value>` | Omitted |
| `yes` | `boolean` | `--yes` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `plugins_list`

Inspect installed Spin plugins.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `installed` | `boolean` | `--installed` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `up`

Run an application in the foreground; use a scoped lifecycle and bounded timeout.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `from` | `string` | `--from=<value>` | Omitted |
| `build` | `boolean` | `--build` | Omitted |
| `env` | `string (CSV)` | `--env=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |
