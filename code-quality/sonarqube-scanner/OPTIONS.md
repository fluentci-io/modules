# SonarQube Scanner module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` is a comma-separated NAME=PATH string in the public component contract.

## `run`

Execute arbitrary literal CLI arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Required |

## `version`

Print the CLI version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `scan`

Analyze the configured project and submit results to SonarQube.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `projectKey` | `string` | `-Dsonar.projectKey=<value>` | Omitted |
| `sources` | `string (CSV)` | `-Dsonar.sources=<comma-separated values>` | Omitted |
| `hostUrl` | `string` | `-Dsonar.host.url=<value>` | Omitted |
| `organization` | `string` | `-Dsonar.organization=<value>` | Omitted |
| `qualityGateWait` | `boolean` | `-Dsonar.qualitygate.wait=<value>` | Omitted |
| `properties` | `string (CSV)` | `-D<value>` | Omitted |
