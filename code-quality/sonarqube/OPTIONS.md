# SonarQube module arguments

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

## `scan`

Analyze the configured project and submit results to SonarQube.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `projectKey` | `string` | `-Dsonar.projectKey=<value>` | Omitted |
| `sources` | `string` | `-Dsonar.sources=<value>` | Omitted |
| `hostUrl` | `string` | `-Dsonar.host.url=<value>` | Omitted |
| `organization` | `string` | `-Dsonar.organization=<value>` | Omitted |
| `qualityGateWait` | `boolean` | `-Dsonar.qualitygate.wait=<value>` | Omitted |
| `properties` | `strings` | `-D<value>` | Omitted |
