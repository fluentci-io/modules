# uv module arguments

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

## `sync`

Create or synchronize a project environment from pyproject.toml and uv.lock.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `locked` | `boolean` | `--locked` | Omitted |
| `frozen` | `boolean` | `--frozen` | Omitted |
| `noDev` | `boolean` | `--no-dev` | Omitted |
| `group` | `string` | `--group=<value>` | Omitted |
| `python` | `string` | `--python=<value>` | Omitted |

## `lock`

Resolve project dependencies or check the existing lockfile.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `check` | `boolean` | `--check` | Omitted |
| `upgrade` | `boolean` | `--upgrade` | Omitted |
| `python` | `string` | `--python=<value>` | Omitted |

## `run_command`

Run a command in the project environment.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `locked` | `boolean` | `--locked` | Omitted |
| `frozen` | `boolean` | `--frozen` | Omitted |
| `noSync` | `boolean` | `--no-sync` | Omitted |
| `python` | `string` | `--python=<value>` | Omitted |
| `command` | `strings` | `<command>` | Required |

## `build`

Build Python source and wheel distributions.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outDir` | `string` | `--out-dir=<value>` | Omitted |
| `wheel` | `boolean` | `--wheel` | Omitted |
| `sdist` | `boolean` | `--sdist` | Omitted |
| `python` | `string` | `--python=<value>` | Omitted |

## `publish`

Publish distributions to a configured Python package index.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `publishUrl` | `string` | `--publish-url=<value>` | Omitted |
| `index` | `string` | `--index=<value>` | Omitted |
| `files` | `strings` | `<files>` | `[]` |

## `venv`

Create a Python virtual environment.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `python` | `string` | `--python=<value>` | Omitted |
| `path` | `string` | `<path>` | `".venv"` |

## `add`

Add project dependencies and update the lockfile.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `dev` | `boolean` | `--dev` | Omitted |
| `group` | `string` | `--group=<value>` | Omitted |
| `packages` | `strings` | `<packages>` | Required |

## `pip_install`

Install packages into a selected virtual environment or interpreter.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `python` | `string` | `--python=<value>` | Omitted |
| `system` | `boolean` | `--system` | Omitted |
| `packages` | `strings` | `<packages>` | Required |
