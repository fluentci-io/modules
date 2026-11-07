# Bazel module arguments

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

## `build`

Build selected Bazel targets.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `compilationMode` | `string (fastbuild, dbg, opt)` | `-c <value>` | Omitted |
| `jobs` | `integer` | `--jobs=<value>` | Omitted |
| `define` | `strings` | `--define=<value>` | Omitted |
| `copt` | `strings` | `--copt=<value>` | Omitted |
| `targets` | `strings` | `<targets>` | `["//..."]` |

## `test`

Build and test selected Bazel targets.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `compilationMode` | `string (fastbuild, dbg, opt)` | `-c <value>` | Omitted |
| `jobs` | `integer` | `--jobs=<value>` | Omitted |
| `define` | `strings` | `--define=<value>` | Omitted |
| `copt` | `strings` | `--copt=<value>` | Omitted |
| `testOutput` | `string (summary, errors, all, streamed)` | `--test-output=<value>` | Omitted |
| `targets` | `strings` | `<targets>` | `["//..."]` |

## `run_target`

Build and run a target with literal program arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `compilationMode` | `string (fastbuild, dbg, opt)` | `-c <value>` | Omitted |
| `jobs` | `integer` | `--jobs=<value>` | Omitted |
| `define` | `strings` | `--define=<value>` | Omitted |
| `copt` | `strings` | `--copt=<value>` | Omitted |
| `target` | `string` | `<target>` | Required |
| `arguments` | `strings` | `-- <values...>` | Omitted |

## `query`

query

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `output` | `string` | `--output=<value>` | Omitted |
| `expression` | `string` | `<expression>` | Required |

## `clean`

clean

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `expunge` | `boolean` | `--expunge` | Omitted |
