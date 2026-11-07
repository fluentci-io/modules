# JFrog Artifactory module arguments

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

## `upload`

Upload build artifacts using a configured JFrog server.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `serverId` | `string` | `--server-id=<value>` | Omitted |
| `flat` | `boolean` | `--flat` | Omitted |
| `recursive` | `boolean` | `--recursive` | Omitted |
| `buildName` | `string` | `--build-name=<value>` | Omitted |
| `buildNumber` | `string` | `--build-number=<value>` | Omitted |
| `pattern` | `string` | `<pattern>` | Required |
| `target` | `string` | `<target>` | Required |

## `download`

download

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `serverId` | `string` | `--server-id=<value>` | Omitted |
| `flat` | `boolean` | `--flat` | Omitted |
| `pattern` | `string` | `<pattern>` | Required |
| `destination` | `string` | `<destination>` | `"dist/"` |

## `search`

search

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `serverId` | `string` | `--server-id=<value>` | Omitted |
| `pattern` | `string` | `<pattern>` | Required |
