# OpenTofu module arguments

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

## `init`

Initialize providers and the configured backend noninteractively.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `backend` | `boolean` | `-backend=<value>` | Omitted |
| `backendConfig` | `strings` | `-backend-config=<value>` | Omitted |
| `upgrade` | `boolean` | `-upgrade` | Omitted |
| `reconfigure` | `boolean` | `-reconfigure` | Omitted |

## `validate`

Validate the initialized configuration.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `json` | `boolean` | `-json` | Omitted |

## `fmt`

Format configuration, or check when check=true.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `check` | `boolean` | `-check` | Omitted |
| `diff` | `boolean` | `-diff` | Omitted |
| `recursive` | `boolean` | `-recursive` | Omitted |

## `plan`

Create an infrastructure plan without applying it.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `out` | `string` | `-out=<value>` | Omitted |
| `refresh` | `boolean` | `-refresh=<value>` | Omitted |
| `lock` | `boolean` | `-lock=<value>` | Omitted |
| `var` | `strings` | `-var=<value>` | Omitted |
| `varFile` | `strings` | `-var-file=<value>` | Omitted |
| `target` | `strings` | `-target=<value>` | Omitted |

## `apply`

Apply changes; use a saved plan or autoApprove=true.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `autoApprove` | `boolean` | `-auto-approve` | Omitted |
| `var` | `strings` | `-var=<value>` | Omitted |
| `varFile` | `strings` | `-var-file=<value>` | Omitted |
| `target` | `strings` | `-target=<value>` | Omitted |
| `planFile` | `string` | `<planFile>` | Omitted |

## `destroy`

Destroy managed infrastructure; autoApprove=true is required for unattended runs.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `autoApprove` | `boolean` | `-auto-approve` | Omitted |
| `var` | `strings` | `-var=<value>` | Omitted |
| `varFile` | `strings` | `-var-file=<value>` | Omitted |
| `target` | `strings` | `-target=<value>` | Omitted |

## `output`

Read state output values.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `json` | `boolean` | `-json` | Omitted |
| `raw` | `boolean` | `-raw` | Omitted |
| `name` | `string` | `<name>` | Omitted |
