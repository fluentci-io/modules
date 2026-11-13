# GitLab CLI

Manage merge requests, releases and GitLab CI jobs and pipelines through typed GitLab CLI functions.
Native PureScript WebAssembly component; requires FluentCI v0.17.3+.

```sh
fluentci run glab setup --version latest
fluentci run glab mr-create --project source --run-dir /tmp/glab-mr-001 --repo group/app --source-branch automation/update --target-branch main --title 'Update dependencies' --description 'Validated dependency update' --labels dependencies,automation
fluentci run glab ci-run --run-dir /tmp/glab-run-001 --repo group/app --branch main --variables DEPLOY_ENV:staging,VERSION:1.2.3
fluentci run glab ci-get --run-dir /tmp/glab-get-001 --repo group/app --pipeline-id 123456
fluentci run glab ci-retry --run-dir /tmp/glab-retry-001 --repo group/app --pipeline-id 123456 --job lint
fluentci run glab ci-cancel --run-dir /tmp/glab-cancel-001 --repo group/app --pipeline-id 123456
fluentci run glab release-upload --run-dir /tmp/glab-upload-001 --repo group/app --tag v1.2.3 --files dist/app.deb,dist/app.rpm
```

## Setup and platforms

Every named operation, including calls with an executable override, performs setup
preflight after input validation and before running its command. Usable installed
tools skip installation. Missing tools use typed setup dependencies and must pass
the availability check again. Git is also checked and installed through setup-git when missing.

The exported setup function accepts version, install-dir, package-name and sudo,
then returns tool, version, bin-dir and environment. A matching installed release
is reused; an exact requested version is verified. GitLab CLI uses SHA-256 checked official GitLab release archives on Linux/macOS and native glab packages on BSD.
Linux, macOS, FreeBSD, OpenBSD and NetBSD are supported. Native package availability,
permissions and repository versions determine installation success on BSD.
Unsupported OS values fail before installation.

For native packages, omit install-dir; package-name selects a repository-specific
versioned package and sudo requests noninteractive elevation. Official archive
installs are per-user and require package-name/sudo to be omitted. A custom
install-dir selects a managed archive prefix instead of PATH reuse. Separate shell
processes must apply the returned environment themselves.

## Pipeline behavior

Exports cover authentication status, repository inspection, merge request
creation/listing/checkout/comments/merging, release creation and asset transfer,
pipeline dispatch/status/details/cancellation, explicitly selected job retry,
configuration linting and authenticated API calls. `ci-retry` retries a job,
not an entire pipeline. `ci-cancel` uses the native `ci cancel pipeline` command.
Merge request creation and merging use confirmation bypass only when those named
operations are explicitly invoked. Source branch deletion remains opt-in. Release
creation uses no-update by default to protect an existing release.

Authentication remains in `GITLAB_TOKEN`, `GLAB_TOKEN` or native credential storage;
GitLab CI job tokens can use native `GLAB_ENABLE_CI_AUTOLOGIN` configuration. Use
`GITLAB_HOST`/hostname for self-managed GitLab. Setup never opens an interactive
login. Pipeline variables use comma-separated KEY:VALUE entries. Native typed
pipeline inputs use KEY:VALUE or KEY:type(value); CSV-quote entries containing
commas. API fields use comma-separated KEY=VALUE strings, or an existing
input-file for a request body. Tokens and sensitive request values should remain
in credential configuration rather than recorded argument fields.

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
fluentci run glab run --run-dir /tmp/glab-native-001 --arguments=--help
```

The run escape hatch exposes every remaining native CLI feature. No CLI argument
requires a JSON object or array. See [COMPONENT.md](./COMPONENT.md) for all typed
arguments, return fields and descriptions, [OPTIONS.md](./OPTIONS.md) for native
flag mappings, and the [upstream CLI reference](https://docs.gitlab.com/cli/). Source descriptions
are embedded in the compiled component.

## Development

CI builds the component and runs contract, installer, dependency, and literal-argument
regression suites. License: MIT.
