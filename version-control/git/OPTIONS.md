# Git module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` is a comma-separated NAME=PATH string in the public component contract.

## `run`

Run any native git command with literal argv.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Required |

## `version`

Report the installed git CLI version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `clone`

Clone a repository with optional shallow, partial and submodule checkout.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `branch` | `string` | `--branch=<value>` | Omitted |
| `depth` | `integer` | `--depth=<value>` | Omitted |
| `filter` | `string` | `--filter=<value>` | Omitted |
| `recursive` | `boolean` | `--recurse-submodules` | Omitted |
| `singleBranch` | `boolean` | `--single-branch` | Omitted |
| `url` | `string` | `<url>` | Required |
| `directory` | `string` | `<directory>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `fetch`

Fetch selected refs and tags without merging them.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `prune` | `boolean` | `--prune` | Omitted |
| `tags` | `boolean` | `--tags` | Omitted |
| `depth` | `integer` | `--depth=<value>` | Omitted |
| `remote` | `string` | `<remote>` | `"origin"` |
| `refspecs` | `string (CSV)` | `<refspecs>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `checkout`

Check out a revision while retaining native dirty-worktree safety checks.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `detach` | `boolean` | `--detach` | Omitted |
| `ref` | `string` | `<ref>` | Required |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `status`

Inspect checkout and index state with stable machine-readable output.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `porcelain` | `string (v1, v2)` | `--porcelain=<value>` | `"v1"` |
| `branch` | `boolean` | `--branch` | Omitted |
| `paths` | `string (CSV)` | `<paths>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `diff`

Compare source revisions or the working tree and optionally fail on differences.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `exitCode` | `boolean` | `--exit-code` | `true` |
| `cached` | `boolean` | `--cached` | Omitted |
| `stat` | `boolean` | `--stat` | Omitted |
| `revisions` | `string (CSV)` | `<revisions>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `log`

Read bounded commit history for release notes or change detection.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `maxCount` | `integer` | `--max-count=<value>` | `20` |
| `format` | `string` | `--format=<value>` | `"%H %s"` |
| `revision` | `string` | `<revision>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `show`

Inspect a selected commit, tree or versioned file.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `format` | `string` | `--format=<value>` | Omitted |
| `stat` | `boolean` | `--stat` | Omitted |
| `object` | `string` | `<object>` | `"HEAD"` |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `rev_parse`

Resolve an exact commit or object identifier.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `verify` | `boolean` | `--verify` | `true` |
| `revision` | `string` | `<revision>` | `"HEAD"` |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `describe`

Derive a release identifier from Git tags and commit history.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `tags` | `boolean` | `--tags` | `true` |
| `always` | `boolean` | `--always` | `true` |
| `match` | `string` | `--match=<value>` | Omitted |
| `revision` | `string` | `<revision>` | `"HEAD"` |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `add`

Stage explicitly selected paths without implicitly staging all files.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `paths` | `string (CSV)` | `<paths>` | Required |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `commit`

Create a commit from staged changes using the inherited Git author identity.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `message` | `string` | `--message=<value>` | Required |
| `allowEmpty` | `boolean` | `--allow-empty` | Omitted |
| `signoff` | `boolean` | `--signoff` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `tag`

Create an explicitly named release tag without forcing replacement.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `message` | `string` | `--message=<value>` | Omitted |
| `sign` | `boolean` | `--sign` | Omitted |
| `name` | `string` | `<name>` | Required |
| `target` | `string` | `<target>` | `"HEAD"` |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `push`

Push selected refs; force updates and tag publication are opt-in.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `tags` | `boolean` | `--tags` | Omitted |
| `atomic` | `boolean` | `--atomic` | Omitted |
| `setUpstream` | `boolean` | `--set-upstream` | Omitted |
| `forceWithLease` | `boolean` | `--force-with-lease` | Omitted |
| `remote` | `string` | `<remote>` | `"origin"` |
| `refspecs` | `string (CSV)` | `<refspecs>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `pull`

Update the checkout, requiring a fast-forward by default.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `ffOnly` | `boolean` | `--ff-only` | `true` |
| `remote` | `string` | `<remote>` | `"origin"` |
| `branch` | `string` | `<branch>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `submodule_update`

Initialize and update submodules at their committed revisions.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `init` | `boolean` | `--init` | `true` |
| `recursive` | `boolean` | `--recursive` | `true` |
| `depth` | `integer` | `--depth=<value>` | Omitted |
| `paths` | `string (CSV)` | `<paths>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `ls_remote`

Inspect remote refs without checking out or modifying repository contents.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `tags` | `boolean` | `--tags` | Omitted |
| `heads` | `boolean` | `--heads` | Omitted |
| `remote` | `string` | `<remote>` | `"origin"` |
| `patterns` | `string (CSV)` | `<patterns>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `archive`

Create a source release archive from a selected Git tree.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `format` | `string (tar, zip)` | `--format=<value>` | `"tar"` |
| `output` | `string` | `--output=<value>` | Required |
| `prefix` | `string` | `--prefix=<value>` | Omitted |
| `tree` | `string` | `<tree>` | `"HEAD"` |
| `paths` | `string (CSV)` | `<paths>` | Omitted |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `config_get`

Read one configured Git value without modifying configuration.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `key` | `string` | `<key>` | Required |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |

## `remote_get_url`

Read the configured repository remote URL.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `remote` | `string` | `<remote>` | `"origin"` |
| `extraArgs` | `string (CSV)` | `<extraArgs>` | Omitted |
