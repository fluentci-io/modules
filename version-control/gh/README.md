# GitHub CLI

Manage pull requests, releases and GitHub Actions runs through typed GitHub CLI functions.
Native PureScript WebAssembly component; requires FluentCI v0.17.3+.

```sh
fluentci run gh setup --version latest
fluentci run gh pr-create --project source --run-dir /tmp/gh-pr-001 --repo acme/app --head automation/update --base main --title 'Update dependencies' --body 'Validated dependency update' --labels dependencies,automation
fluentci run gh pr-checks --run-dir /tmp/gh-checks-001 --repo acme/app --number 42 --watch --required
fluentci run gh workflow-run --run-dir /tmp/gh-dispatch-001 --repo acme/app --workflow release.yml --ref main --inputs version=1.2.3,environment=staging
fluentci run gh run-watch --run-dir /tmp/gh-watch-001 --repo acme/app --run-id 123456
fluentci run gh release-upload --run-dir /tmp/gh-upload-001 --repo acme/app --tag v1.2.3 --files dist/app.deb,dist/app.rpm
```

## Setup and platforms

Every named operation, including calls with an executable override, performs setup
preflight after input validation and before running its command. Usable installed
tools skip installation. Missing tools use typed setup dependencies and must pass
the availability check again. Git is also checked and installed through setup-git when missing.

The exported setup function accepts version, install-dir, package-name and sudo,
then returns tool, version, bin-dir and environment. A matching installed release
is reused; an exact requested version is verified. GitHub CLI uses the existing setup-gh companion.
Linux, macOS, FreeBSD, OpenBSD and NetBSD are supported. Native package availability,
permissions and repository versions determine installation success on BSD.
Unsupported OS values fail before installation.

For native packages, omit install-dir; package-name selects a repository-specific
versioned package and sudo requests noninteractive elevation. Official archive
installs are per-user and require package-name/sudo to be omitted. A custom
install-dir selects a managed archive prefix instead of PATH reuse. Separate shell
processes must apply the returned environment themselves.

## Pipeline behavior

Exports cover authentication status, repository inspection, pull request
creation/listing/checkout/checks/comments/merging, release creation/asset transfer,
workflow dispatch and run listing/inspection/watching/rerunning/cancellation, and
authenticated API calls. PR merging requires an explicit `method` (squash, merge,
or rebase). Run-watch and run-view enable exit-status by default so failed runs
fail the calling pipeline. Release creation requires an existing tag by default;
pass `--verify-tag=false` to allow native tag creation. Asset replacement and
branch deletion are opt-in.

Authentication remains in `GH_TOKEN`, `GH_ENTERPRISE_TOKEN` or native gh credential
storage. Set `GH_HOST`/hostname for enterprise instances. `GH_PROMPT_DISABLED=1`
and `GIT_TERMINAL_PROMPT=0` keep named operations noninteractive; insufficient
inputs or credentials fail clearly. Setup never runs an interactive login. API
fields and workflow inputs use comma-separated KEY=VALUE strings; API request
bodies may also come from an existing input-file. Do not pass tokens through
recorded arguments.

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
fluentci run gh run --run-dir /tmp/gh-native-001 --arguments=--help
```

The run escape hatch exposes every remaining native CLI feature. No CLI argument
requires a JSON object or array. See [COMPONENT.md](./COMPONENT.md) for all typed
arguments, return fields and descriptions, [OPTIONS.md](./OPTIONS.md) for native
flag mappings, and the [upstream CLI reference](https://cli.github.com/manual/). Source descriptions
are embedded in the compiled component.

## Development

CI builds the component and runs contract, installer, dependency, and literal-argument
regression suites. License: MIT.
