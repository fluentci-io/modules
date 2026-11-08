# Cosign

Sign OCI images and release files, then enforce signature verification in CI/CD.
Implemented in PureScript as a typed Wasm component for FluentCI v0.17.2+.
Install the native CLI with [setup-cosign](../../setup/cosign/README.md).
Blob operations target Cosign 3.x Sigstore bundles.

```sh
fluentci run setup-cosign setup --version 3.1.4
fluentci run cosign sign --run-dir /tmp/sign-image --image registry.example/app@sha256:DIGEST
fluentci run cosign verify --run-dir /tmp/verify-image \
  --image registry.example/app@sha256:DIGEST \
  --certificate-identity https://github.com/org/repo/.github/workflows/release.yml@refs/heads/main \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
fluentci run cosign sign-blob --run-dir /tmp/sign-file \
  --file dist/app.tar.gz --bundle dist/app.sigstore.json
fluentci run cosign verify-blob --run-dir /tmp/verify-file \
  --file dist/app.tar.gz --bundle dist/app.sigstore.json \
  --certificate-identity https://github.com/org/repo/.github/workflows/release.yml@refs/heads/main \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
```

`sign` and `sign-blob` use ambient OIDC credentials unless `--key` selects a
local key, an `env://` reference, or supported KMS URI. Signing skips confirmation
prompts and can publish to a transparency log; image signing also writes to its
registry. Configure CI OIDC permissions (for example GitHub `id-token: write`),
registry authentication, and key passwords through the runner environment.
Never place secret key material or tokens in module arguments.

`verify` and `verify-blob` require exact expected certificate identity and issuer.
`verify-key` and `verify-blob-key` instead require `--key` with the public key or
KMS reference. Verification keeps native transparency-log and certificate checks;
errors fail the pipeline. Prefer immutable image digests. `run` accepts literal
arguments for additional Cosign commands; `version` reports the installed CLI.

Every call requires a fresh `--run-dir`; optional `--project` selects its working
directory. Local input files and verification bundles are checked before starting
the command. Output bundle parent directories must exist. Declare output bundles
with `--artifacts NAME=PATH` to collect their sizes and SHA-256 in the report.
Returns a typed execution result with outcome, report, stdout, and stderr paths;
nonzero exits propagate as failures. Credentials remain inherited from the host.

The adapter accepts Linux, macOS, FreeBSD, NetBSD, and OpenBSD hosts with an
installed native Cosign; repository availability still limits BSD installations.
See [COMPONENT.md](./COMPONENT.md) and [OPTIONS.md](./OPTIONS.md) for named
arguments, descriptions, and return types.

[Cosign documentation](https://docs.sigstore.dev/cosign/) · [MIT License](./LICENSE).
