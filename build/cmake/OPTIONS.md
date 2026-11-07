# CMake module arguments

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

Configure a CMake build tree.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `sourceDir` | `string` | `-S <value>` | `"."` |
| `buildDir` | `string` | `-B <value>` | `"build"` |
| `generator` | `string` | `-G <value>` | Omitted |
| `preset` | `string` | `--preset=<value>` | Omitted |
| `buildType` | `string` | `-DCMAKE_BUILD_TYPE=<value>` | Omitted |
| `definitions` | `strings` | `-D<value>` | Omitted |

## `build`

Build an existing CMake build tree.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `buildDir` | `string` | `--build <value>` (global) | `"build"` |
| `config` | `string` | `--config=<value>` | Omitted |
| `parallel` | `integer` | `--parallel=<value>` | Omitted |
| `target` | `strings` | `--target=<value>` | Omitted |
| `cleanFirst` | `boolean` | `--clean-first` | Omitted |

## `install`

Install build artifacts into the selected prefix.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `buildDir` | `string` | `--install <value>` (global) | `"build"` |
| `config` | `string` | `--config=<value>` | Omitted |
| `prefix` | `string` | `--prefix=<value>` | Omitted |
| `component` | `string` | `--component=<value>` | Omitted |

## `test`

Run CTest tests in a configured build tree.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `buildDir` | `string` | `--test-dir <value>` (global) | `"build"` |
| `config` | `string` | `-C <value>` | Omitted |
| `parallel` | `integer` | `--parallel=<value>` | Omitted |
| `outputOnFailure` | `boolean` | `--output-on-failure` | `true` |
