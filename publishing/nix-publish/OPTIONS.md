# Nix publishing module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` (an object mapping output names to file paths).

## `check`

Evaluate and build flake checks without modifying flake.lock.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `flake` | `string` | `<flake>` | `"."` |

## `metadata`

Inspect locked flake metadata as JSON without modifying flake.lock.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `flake` | `string` | `<flake>` | `"."` |

## `outputs`

Inspect flake outputs for every supported system as JSON.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `flake` | `string` | `<flake>` | `"."` |

## `flakehub`

Publish the checked-out flake release to FlakeHub using GitHub OIDC.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `name` | `string` | `--name=<value>` | Required |
| `version` | `string` | `--tag=<value>` | Required |
| `visibility` | `string (public, unlisted, private)` | `--visibility=<value>` | `"public"` |

## `flakestry`

Publish locked flake metadata and outputs to Flakestry using GitHub OIDC.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `version` | `string` | `<version>` | Required |
| `ref` | `string` | `<ref>` | Required |
| `readme` | `string` | `<readme>` | `"README.md"` |
| `url` | `string` | `<url>` | `"https://flakestry.dev"` |
| `ignoreConflicts` | `boolean` | `<ignoreConflicts>` | `false` |
