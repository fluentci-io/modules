# Pulumi module arguments

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

## `preview`

Preview a stack update.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `stack` | `string` | `--stack=<value>` | Omitted |
| `diff` | `boolean` | `--diff` | Omitted |
| `refresh` | `boolean` | `--refresh` | Omitted |
| `target` | `strings` | `--target=<value>` | Omitted |

## `up`

Apply a stack update without prompting.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `stack` | `string` | `--stack=<value>` | Omitted |
| `diff` | `boolean` | `--diff` | Omitted |
| `refresh` | `boolean` | `--refresh` | Omitted |
| `target` | `strings` | `--target=<value>` | Omitted |

## `destroy`

Destroy a stack without prompting.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `stack` | `string` | `--stack=<value>` | Omitted |
| `target` | `strings` | `--target=<value>` | Omitted |

## `stack_select`

Select an existing stack.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `name` | `string` | `<name>` | Required |

## `stack_output`

Read stack outputs without revealing secret values.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `stack` | `string` | `--stack=<value>` | Omitted |
| `json` | `boolean` | `--json` | Omitted |
| `name` | `string` | `<name>` | Omitted |

## `login`

Select a backend; cloud credentials are read from the host environment.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `backend` | `string` | `<backend>` | Omitted |
