# Nix publishing

Publish a checked-out Nix flake to **FlakeHub** or **Flakestry** from a CI release
job. This PureScript module is a native Wasm component for FluentCI v0.17.2+.
It generalizes the pipeline in FluentCI's `.fluentci/nix` without hardcoding a
repository name. Every function has named typed arguments and returns an
execution result with report and log paths.

## Usage

Check out the intended release tag/commit before publishing. `version` names
that release; Flakestry's `ref` must identify the same checked-out commit.
Each invocation requires a fresh `run-dir`.

```sh
fluentci run nix-publish check --run-dir .fluentci/nix-check
fluentci run nix-publish metadata --run-dir .fluentci/nix-metadata
fluentci run nix-publish outputs --run-dir .fluentci/nix-outputs

fluentci run nix-publish flakehub --run-dir .fluentci/flakehub \
  --name example/project --version v1.2.3 --visibility public

fluentci run nix-publish flakestry --run-dir .fluentci/flakestry \
  --version v1.2.3 --ref "$(git rev-parse HEAD)"
```

Use `--project PATH` for another checkout directory. Nix checks, metadata, and
output inspection enable `nix-command flakes` and use `--no-write-lock-file`.
They do not rewrite `flake.lock`. `check` may build derivations and access the
network. Flakestry evaluates metadata and outputs for all systems before making
publication requests; evaluation failures cancel publication.

FlakeHub accepts `public`, `unlisted`, or `private` visibility. Its publisher
inherits `FLAKEHUB_PUSH_REV` when provided; set it to the release commit when
pinning the revision explicitly. The native publisher controls its upload and
release validation behavior.

Flakestry accepts an optional repository-relative `--readme` filename (default
`README.md`), an HTTPS registry origin via `--url`, and `--ignore-conflicts` to
treat an existing release (HTTP 409) as success. Other HTTP failures still fail.
The registry origin becomes the GitHub OIDC audience. The default is
`https://flakestry.dev`; `readme` is the filename expected by the registry API.

See [COMPONENT.md](./COMPONENT.md) for every argument and return type, or run:

```sh
fluentci run nix-publish flakehub --help
fluentci run nix-publish flakestry --help
```

## Prerequisites and authentication

Linux and macOS are supported. Install Nix using [setup-nix](../../setup/nix/README.md)
or [setup-determinate-nix](../../setup/determinate-nix/README.md).
FlakeHub additionally needs [setup-flakehub-push](../../setup/flakehub-push/README.md);
Flakestry needs [setup-bun](../../setup/bun/README.md). Flakestry uses Bun's HTTP
and JSON support, so `curl`, `jq`, and `jo` are not required for publication.
Setup calls publish PATH within a host session; separate CLI processes must add
the returned `bin-dir` to PATH explicitly.

Publishing currently uses the GitHub Actions OIDC flow from the reference
pipeline. Configure `permissions: {contents: read, id-token: write}`. Both
publishers require `ACTIONS_ID_TOKEN_REQUEST_TOKEN` and
`ACTIONS_ID_TOKEN_REQUEST_URL` in the inherited environment. Additionally:

| Registry | Required GitHub token |
| --- | --- |
| FlakeHub | `FLAKEHUB_PUSH_GITHUB_TOKEN` |
| Flakestry | `GH_TOKEN` |

These variables must be nonempty. Tokens are never function arguments or embedded
in execution plans. Generic `GITHUB_TOKEN` does not replace either explicit
variable. For Jenkins or Tekton, an equivalent supported identity flow is needed;
a generic GitHub token alone does not provide GitHub Actions OIDC.

For an existing runner with FluentCI, Nix, Bun, and `flakehub-push` on PATH:

```yaml
permissions:
  contents: read
  id-token: write
steps:
  - uses: actions/checkout@v6
    with:
      ref: ${{ github.ref_name }}
      fetch-depth: 0
  - name: Validate and publish the release
    env:
      RELEASE_VERSION: ${{ github.ref_name }}
      GH_TOKEN: ${{ github.token }}
      FLAKEHUB_PUSH_GITHUB_TOKEN: ${{ github.token }}
      FLAKEHUB_PUSH_REV: ${{ github.sha }}
    run: |
      fluentci run nix-publish check --run-dir .fluentci/check
      fluentci run nix-publish flakehub --run-dir .fluentci/flakehub --name example/project --version "$RELEASE_VERSION"
      fluentci run nix-publish flakestry --run-dir .fluentci/flakestry --version "$RELEASE_VERSION" --ref "$(git rev-parse HEAD)"
```

The example belongs in a tag-triggered workflow. Each publisher is a separate
operation: an earlier successful publication remains published if a later one
fails. There is no automatic checkout, release creation, rollback, or combined
cross-registry transaction.

## Results and failures

Functions return `outcome`, `run-dir`, `report-path`, `stdout-path`, and
`stderr-path`. Missing credentials and unsupported hosts fail before host
commands. Missing tools, Nix evaluation errors, HTTP failures, cancellation,
and timeouts fail the component call. Flakestry's successful JSON receipt is in
its stdout log; an ignored conflict reports `alreadyExists: true`.

## Development

```sh
bun install --cwd ../../lib/component --frozen-lockfile
npm ci
npm run build
npm test
```

Tests execute compiled PureScript and exercise the Flakestry payload using a local
Nix fixture and mocked HTTP/OIDC responses. They never publish to either registry.
The native component is `dist/plugin.wasm`; its typed contract sidecar is
`dist/fluentci.metadata.json`. Private CJS/legacy entries only support regression
testing. See the [component guide](../../docs/COMPONENTS.md) and [MIT License](./LICENSE).

Protocol references: [Flakestry's publishing action](https://github.com/flakestry/flakestry-publish/blob/main/action.yaml)
and [FlakeHub publishing](https://docs.determinate.systems/flakehub/publishing/).
