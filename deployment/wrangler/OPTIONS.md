# Cloudflare Wrangler module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` (an object mapping output names to file paths).

## `run`

Run a Wrangler operation with literal arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `strings` | `<arguments>` | Required |

## `version`

Report the installed Wrangler version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `deploy`

Deploy a Worker using existing Cloudflare credentials.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `env` | `string` | `--env=<value>` | Omitted |
| `name` | `string` | `--name=<value>` | Omitted |
| `outdir` | `string` | `--outdir=<value>` | Omitted |
| `minify` | `boolean` | `--minify` | Omitted |
| `script` | `string` | `<script>` | Omitted |

## `dry_run`

Bundle a Worker locally without deploying it.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `env` | `string` | `--env=<value>` | Omitted |
| `name` | `string` | `--name=<value>` | Omitted |
| `outdir` | `string` | `--outdir=<value>` | Omitted |
| `minify` | `boolean` | `--minify` | Omitted |
| `script` | `string` | `<script>` | Omitted |

## `versions_upload`

Upload a Worker version without deploying it to traffic.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `config` | `string` | `--config=<value>` | Omitted |
| `env` | `string` | `--env=<value>` | Omitted |
| `name` | `string` | `--name=<value>` | Omitted |
| `outdir` | `string` | `--outdir=<value>` | Omitted |
| `minify` | `boolean` | `--minify` | Omitted |
| `script` | `string` | `<script>` | Omitted |

## `pages_deploy`

Deploy a built site to an existing Cloudflare Pages project.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `projectName` | `string` | `--project-name=<value>` | Required |
| `branch` | `string` | `--branch=<value>` | Omitted |
| `commitHash` | `string` | `--commit-hash=<value>` | Omitted |
| `directory` | `string` | `<directory>` | Required |

## `pages_projects`

List Cloudflare Pages projects available to the authenticated account.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
