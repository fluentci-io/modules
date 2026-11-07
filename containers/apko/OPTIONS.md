# apko module arguments

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

## `build`

Build an OCI image and SBOM from an APK package configuration.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arch` | `strings` | `--arch=<value>` | Omitted |
| `lockfile` | `string` | `--lockfile=<value>` | Omitted |
| `cacheDir` | `string` | `--cache-dir=<value>` | Omitted |
| `offline` | `boolean` | `--offline` | Omitted |
| `sbomPath` | `string` | `--sbom-path=<value>` | Omitted |
| `buildDate` | `string` | `--build-date=<value>` | Omitted |
| `config` | `string` | `<config>` | Required |
| `tag` | `string` | `<tag>` | Required |
| `output` | `string` | `<output>` | Required |

## `publish`

Build and publish an OCI image using native registry credentials.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arch` | `strings` | `--arch=<value>` | Omitted |
| `lockfile` | `string` | `--lockfile=<value>` | Omitted |
| `cacheDir` | `string` | `--cache-dir=<value>` | Omitted |
| `offline` | `boolean` | `--offline` | Omitted |
| `sbomPath` | `string` | `--sbom-path=<value>` | Omitted |
| `buildDate` | `string` | `--build-date=<value>` | Omitted |
| `config` | `string` | `<config>` | Required |
| `tags` | `strings` | `<tags>` | Required |
