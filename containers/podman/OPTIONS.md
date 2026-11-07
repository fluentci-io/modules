# Podman module arguments

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

Build an image from a context.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `tag` | `strings` | `--tag=<value>` | Omitted |
| `file` | `string` | `--file=<value>` | Omitted |
| `buildArg` | `strings` | `--build-arg=<value>` | Omitted |
| `target` | `string` | `--target=<value>` | Omitted |
| `platform` | `string` | `--platform=<value>` | Omitted |
| `noCache` | `boolean` | `--no-cache` | Omitted |
| `pull` | `boolean` | `--pull` | Omitted |
| `context` | `string` | `<context>` | `"."` |

## `pull`

Pull an image.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `platform` | `string` | `--platform=<value>` | Omitted |
| `image` | `string` | `<image>` | Required |

## `push`

Push an authenticated image reference.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `image` | `string` | `<image>` | Required |

## `tag`

Create an image tag.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `source` | `string` | `<source>` | Required |
| `target` | `string` | `<target>` | Required |

## `container_run`

Run an image with optional command arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `rm` | `boolean` | `--rm` | Omitted |
| `detach` | `boolean` | `--detach` | Omitted |
| `name` | `string` | `--name=<value>` | Omitted |
| `publish` | `strings` | `--publish=<value>` | Omitted |
| `volume` | `strings` | `--volume=<value>` | Omitted |
| `env` | `strings` | `--env=<value>` | Omitted |
| `network` | `string` | `--network=<value>` | Omitted |
| `workdir` | `string` | `--workdir=<value>` | Omitted |
| `image` | `string` | `<image>` | Required |
| `command` | `strings` | `<command>` | `[]` |

## `compose`

Run Compose with its native subcommand arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `file` | `strings` | `--file=<value>` | Omitted |
| `projectName` | `string` | `--project-name=<value>` | Omitted |
| `arguments` | `strings` | `<arguments>` | Required |
