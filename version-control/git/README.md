# Git

Check out source, inspect revisions, create commits and tags, and publish refs with typed Git functions.
Native PureScript WebAssembly component; requires FluentCI v0.17.3+.

```sh
fluentci run git setup
fluentci run git clone --run-dir /tmp/git-clone-001 --url https://github.com/acme/app.git --directory source --depth 1
fluentci run git fetch --project source --run-dir /tmp/git-fetch-001 --tags --prune
fluentci run git checkout --project source --run-dir /tmp/git-checkout-001 --ref main
fluentci run git add --project source --run-dir /tmp/git-add-001 --paths Cargo.toml,Cargo.lock
fluentci run git tag --project source --run-dir /tmp/git-tag-001 --name v1.2.3 --message 'Release 1.2.3'
fluentci run git push --project source --run-dir /tmp/git-push-001 --remote origin --refspecs refs/tags/v1.2.3
```

## Setup and platforms

Every named operation, including calls with an executable override, performs setup
preflight after input validation and before running its command. Usable installed
tools skip installation. Missing tools use typed setup dependencies and must pass
the availability check again.

The exported setup function accepts version, install-dir, package-name and sudo,
then returns tool, version, bin-dir and environment. A matching installed release
is reused; an exact requested version is verified. Git uses native package repositories; exact versions depend on configured repositories and are verified after installation.
Linux, macOS, FreeBSD, OpenBSD and NetBSD are supported. Native package availability,
permissions and repository versions determine installation success on BSD.
Unsupported OS values fail before installation.

For native packages, omit install-dir; package-name selects a repository-specific
versioned package and sudo requests noninteractive elevation. Official archive
installs are per-user and require package-name/sudo to be omitted. A custom
install-dir selects a managed archive prefix instead of PATH reuse. Separate shell
processes must apply the returned environment themselves.

## Pipeline behavior

Exports cover clone/fetch/checkout, status/diff/log/show, rev-parse/describe,
add/commit/tag/push/pull, submodule updates, remote refs/URLs, source archives and
configuration reads. Pull requires fast-forward-only by default. Diff uses
exit-code by default, so changes fail the pipeline; pass `--exit-code=false`
when collecting an informational diff. Commits require a literal message and use
the inherited author/committer identity. There is no implicit add-all, hard reset,
branch deletion, or unguarded force push. `--force-with-lease` and tag publication
must be requested explicitly. Native Git configuration, SSH agents and credential
helpers remain inherited; `GIT_TERMINAL_PROMPT=0` disables password prompts.

Every operation requires a fresh run-dir and returns typed outcome, run-dir,
report-path, stdout-path and stderr-path fields. Read the captured stdout for
native results. Nonzero native exits, timeout, setup failures and transport errors
propagate without returning success. Polling operations remain bounded by timeout-ms.
Commands that create comments, releases, requests, commits or tags mutate remote or
local state only when explicitly invoked.

All public lists use comma-separated strings; whitespace is trimmed, blank optional
lists keep native defaults, and empty entries/malformed CSV are rejected before
setup. CSV double quotes preserve literal commas within a token. Arguments remain
literal argv, with no shell expansion. Filenames are literal; shell globs are not
expanded by the module. Release uploads and body-file inputs are checked before
setup can install anything.

```sh
fluentci run git run --run-dir /tmp/git-native-001 --arguments=--help
```

The run escape hatch exposes every remaining native CLI feature. No CLI argument
requires a JSON object or array. See [COMPONENT.md](./COMPONENT.md) for all typed
arguments, return fields and descriptions, [OPTIONS.md](./OPTIONS.md) for native
flag mappings, and the [upstream CLI reference](https://git-scm.com/docs). Source descriptions
are embedded in the compiled component.

## Development

CI builds the component and runs contract, installer, dependency, and literal-argument
regression suites. License: MIT.
