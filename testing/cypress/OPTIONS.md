# Cypress module arguments

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

## `setup`

Install the test framework in project using Bun. Browser binaries are installed separately with install.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `version` | `string` | `cypress@<value>` | `"latest"` |

## `test`

Run Cypress specs headlessly, returning a failure if any tests fail.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `browser` | `string` | `--browser=<value>` | Omitted |
| `configFile` | `string` | `--config-file=<value>` | Omitted |
| `config` | `string` | `--config=<value>` | Omitted |
| `spec` | `string` | `--spec=<value>` | Omitted |
| `reporter` | `string` | `--reporter=<value>` | Omitted |
| `reporterOptions` | `string` | `--reporter-options=<value>` | Omitted |
| `component` | `boolean` | `--component` | Omitted |
| `record` | `boolean` | `--record` | Omitted |
| `parallel` | `boolean` | `--parallel` | Omitted |
| `group` | `string` | `--group=<value>` | Omitted |
| `ciBuildId` | `string` | `--ci-build-id=<value>` | Omitted |
| `tag` | `string` | `--tag=<value>` | Omitted |

## `install`

Download the Cypress binary matching the installed npm package.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `force` | `boolean` | `--force` | Omitted |

## `verify`

Verify that the installed Cypress binary can start.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `cache_list`

List installed Cypress binaries.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
