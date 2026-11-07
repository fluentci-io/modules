# Playwright module arguments

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

Install the test framework in project using Bun. Browser binaries are installed separately with install.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `version` | `string` | `@playwright/test@<value>` | `"latest"` |

## `test`

Run Playwright Test headlessly, optionally filtering projects and tests.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `testProject` | `strings` | `--project=<value>` | Omitted |
| `grep` | `string` | `--grep=<value>` | Omitted |
| `grepInvert` | `string` | `--grep-invert=<value>` | Omitted |
| `workers` | `integer` | `--workers=<value>` | Omitted |
| `reporter` | `string` | `--reporter=<value>` | Omitted |
| `output` | `string` | `--output=<value>` | Omitted |
| `retries` | `integer` | `--retries=<value>` | Omitted |
| `shard` | `string` | `--shard=<value>` | Omitted |
| `forbidOnly` | `boolean` | `--forbid-only` | Omitted |
| `failOnFlakyTests` | `boolean` | `--fail-on-flaky-tests` | Omitted |
| `updateSnapshots` | `boolean` | `--update-snapshots` | Omitted |
| `tests` | `strings` | `<tests>` | `[]` |

## `list`

List matching tests without launching browsers.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `testProject` | `strings` | `--project=<value>` | Omitted |
| `grep` | `string` | `--grep=<value>` | Omitted |
| `grepInvert` | `string` | `--grep-invert=<value>` | Omitted |
| `workers` | `integer` | `--workers=<value>` | Omitted |
| `tests` | `strings` | `<tests>` | `[]` |

## `install`

Install browser binaries matching the installed Playwright package.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `withDeps` | `boolean` | `--with-deps` | Omitted |
| `onlyShell` | `boolean` | `--only-shell` | Omitted |
| `browsers` | `strings` | `<browsers>` | `[]` |

## `install_deps`

Install operating-system browser dependencies; may require elevated privileges.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `browsers` | `strings` | `<browsers>` | `[]` |
