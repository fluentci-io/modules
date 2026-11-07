# Snyk module arguments

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

## `setup`

Install a selected Snyk CLI release in project using Bun.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `version` | `string` | `snyk@<value>` | `"latest"` |

## `test`

Test application dependencies and fail on vulnerabilities selected by policy.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `org` | `string` | `--org=<value>` | Omitted |
| `severityThreshold` | `string (low, medium, high, critical)` | `--severity-threshold=<value>` | Omitted |
| `file` | `string` | `--file=<value>` | Omitted |
| `allProjects` | `boolean` | `--all-projects` | Omitted |
| `exclude` | `string` | `--exclude=<value>` | Omitted |
| `path` | `string` | `<path>` | `"."` |

## `code_test`

Run Snyk Code analysis using the configured Snyk service.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `org` | `string` | `--org=<value>` | Omitted |
| `severityThreshold` | `string (low, medium, high, critical)` | `--severity-threshold=<value>` | Omitted |
| `path` | `string` | `<path>` | `"."` |

## `iac_test`

Scan infrastructure-as-code configuration.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `org` | `string` | `--org=<value>` | Omitted |
| `severityThreshold` | `string (low, medium, high, critical)` | `--severity-threshold=<value>` | Omitted |
| `path` | `string` | `<path>` | `"."` |

## `container_test`

Test a container image for vulnerabilities.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `org` | `string` | `--org=<value>` | Omitted |
| `severityThreshold` | `string (low, medium, high, critical)` | `--severity-threshold=<value>` | Omitted |
| `file` | `string` | `--file=<value>` | Omitted |
| `image` | `string` | `<image>` | Required |

## `monitor`

Publish a dependency snapshot for ongoing monitoring.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `org` | `string` | `--org=<value>` | Omitted |
| `file` | `string` | `--file=<value>` | Omitted |
| `allProjects` | `boolean` | `--all-projects` | Omitted |
| `path` | `string` | `<path>` | `"."` |
