# Terragrunt module arguments

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

## `hcl_fmt`

hcl fmt

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `init`

Run init in the current Terragrunt unit.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `plan`

Run plan in the current Terragrunt unit.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `apply`

Run apply in the current Terragrunt unit.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `autoApprove` | `boolean` | `-auto-approve` | Omitted |

## `destroy`

Run destroy in the current Terragrunt unit.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `autoApprove` | `boolean` | `-auto-approve` | Omitted |

## `validate`

validate

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
