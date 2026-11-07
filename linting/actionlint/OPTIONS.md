# Actionlint module arguments

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

## `lint`

Lint workflows, discovering .github/workflows when files is empty.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `configFile` | `string` | `-config-file=<value>` | Omitted |
| `format` | `string` | `-format=<value>` | Omitted |
| `shellcheck` | `string` | `-shellcheck=<value>` | Omitted |
| `pyflakes` | `string` | `-pyflakes=<value>` | Omitted |
| `color` | `boolean` | `-color` | Omitted |
| `files` | `strings` | `<files>` | `[]` |
