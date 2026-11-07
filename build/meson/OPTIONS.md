# Meson module arguments

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

## `configure`

configure

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `buildtype` | `string (plain, debug, debugoptimized, release, minsize, custom)` | `--buildtype=<value>` | Omitted |
| `prefix` | `string` | `--prefix=<value>` | Omitted |
| `backend` | `string` | `--backend=<value>` | Omitted |
| `reconfigure` | `boolean` | `--reconfigure` | Omitted |
| `definitions` | `strings` | `-D<value>` | Omitted |
| `buildDir` | `string` | `<buildDir>` | `"build"` |
| `sourceDir` | `string` | `<sourceDir>` | `"."` |

## `compile`

compile

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `buildDir` | `string` | `-C <value>` | `"build"` |
| `jobs` | `integer` | `-j <value>` | Omitted |
| `verbose` | `boolean` | `--verbose` | Omitted |
| `targets` | `strings` | `<targets>` | `[]` |

## `test`

test

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `buildDir` | `string` | `-C <value>` | `"build"` |
| `jobs` | `integer` | `-j <value>` | Omitted |
| `suite` | `strings` | `--suite=<value>` | Omitted |
| `names` | `strings` | `<names>` | `[]` |

## `install`

install

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `buildDir` | `string` | `-C <value>` | `"build"` |
| `destdir` | `string` | `--destdir=<value>` | Omitted |
| `noRebuild` | `boolean` | `--no-rebuild` | Omitted |
