# Trivy module arguments

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

## `filesystem`

Scan a filesystem and fail when selected findings are present.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `severity` | `string` | `--severity=<value>` | `"HIGH,CRITICAL"` |
| `format` | `string` | `--format=<value>` | `"json"` |
| `output` | `string` | `--output=<value>` | Omitted |
| `scanners` | `string` | `--scanners=<value>` | Omitted |
| `ignoreUnfixed` | `boolean` | `--ignore-unfixed` | Omitted |
| `skipDbUpdate` | `boolean` | `--skip-db-update` | Omitted |
| `offlineScan` | `boolean` | `--offline-scan` | Omitted |
| `directory` | `string` | `<directory>` | `"."` |

## `image`

Scan a container image and fail at the selected severity.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `severity` | `string` | `--severity=<value>` | `"HIGH,CRITICAL"` |
| `format` | `string` | `--format=<value>` | `"json"` |
| `output` | `string` | `--output=<value>` | Omitted |
| `scanners` | `string` | `--scanners=<value>` | Omitted |
| `ignoreUnfixed` | `boolean` | `--ignore-unfixed` | Omitted |
| `skipDbUpdate` | `boolean` | `--skip-db-update` | Omitted |
| `offlineScan` | `boolean` | `--offline-scan` | Omitted |
| `image` | `string` | `<image>` | Required |

## `config`

Scan infrastructure configuration for misconfigurations.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `severity` | `string` | `--severity=<value>` | `"HIGH,CRITICAL"` |
| `format` | `string` | `--format=<value>` | `"json"` |
| `output` | `string` | `--output=<value>` | Omitted |
| `skipCheckUpdate` | `boolean` | `--skip-check-update` | Omitted |
| `directory` | `string` | `<directory>` | `"."` |

## `sbom`

Scan an existing SBOM for vulnerabilities.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `severity` | `string` | `--severity=<value>` | `"HIGH,CRITICAL"` |
| `format` | `string` | `--format=<value>` | `"json"` |
| `output` | `string` | `--output=<value>` | Omitted |
| `skipDbUpdate` | `boolean` | `--skip-db-update` | Omitted |
| `file` | `string` | `<file>` | Required |
