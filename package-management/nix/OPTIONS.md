# Nix packages module arguments

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

## `build`

Build one or more flake installables.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `outLink` | `string` | `--out-link=<value>` | Omitted |
| `noLink` | `boolean` | `--no-link` | Omitted |
| `printOutPaths` | `boolean` | `--print-out-paths` | Omitted |
| `noWriteLockFile` | `boolean` | `--no-write-lock-file` | Omitted |
| `installables` | `strings` | `<installables>` | `[".#default"]` |

## `eval`

Evaluate a Nix installable.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `json` | `boolean` | `--json` | Omitted |
| `raw` | `boolean` | `--raw` | Omitted |
| `installable` | `string` | `<installable>` | Required |

## `flake_check`

Evaluate and optionally build flake checks.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `noBuild` | `boolean` | `--no-build` | Omitted |
| `keepGoing` | `boolean` | `--keep-going` | Omitted |
| `noWriteLockFile` | `boolean` | `--no-write-lock-file` | Omitted |
| `flake` | `string` | `<flake>` | `"."` |

## `flake_update`

Update flake lock inputs in the project directory.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `inputs` | `strings` | `<inputs>` | `[]` |

## `profile_install`

Install packages into a Nix profile.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `profile` | `string` | `--profile=<value>` | Omitted |
| `installables` | `strings` | `<installables>` | Required |

## `store_gc`

Garbage-collect unreferenced Nix store paths.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
