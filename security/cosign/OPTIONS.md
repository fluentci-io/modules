# Cosign module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` (an object mapping output names to file paths).

## `run`

Run arbitrary Cosign commands with literal arguments.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `strings` | `<arguments>` | Required |

## `version`

Report the installed Cosign version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `sign`

Sign an OCI image using a key or ambient CI OIDC credentials; publish the signature to its registry.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `key` | `string` | `--key=<value>` | Omitted |
| `image` | `string` | `<image>` | Required |

## `sign_blob`

Sign a local release artifact and write its Sigstore verification bundle.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `key` | `string` | `--key=<value>` | Omitted |
| `bundle` | `string` | `--bundle=<value>` | Required |
| `file` | `string` | `<file>` | Required |

## `verify`

Verify an OCI image signature against an exact keyless identity and issuer; fail the pipeline on verification errors.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `certificateIdentity` | `string` | `--certificate-identity=<value>` | Required |
| `certificateOidcIssuer` | `string` | `--certificate-oidc-issuer=<value>` | Required |
| `image` | `string` | `<image>` | Required |

## `verify_key`

Verify an OCI image signature against an explicit public key or KMS key.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `key` | `string` | `--key=<value>` | Required |
| `image` | `string` | `<image>` | Required |

## `verify_blob`

Verify a release artifact and Sigstore bundle against an exact keyless identity and issuer.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `certificateIdentity` | `string` | `--certificate-identity=<value>` | Required |
| `certificateOidcIssuer` | `string` | `--certificate-oidc-issuer=<value>` | Required |
| `bundle` | `string` | `--bundle=<value>` | Required |
| `file` | `string` | `<file>` | Required |

## `verify_blob_key`

Verify a release artifact and Sigstore bundle against an explicit public key or KMS key.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `key` | `string` | `--key=<value>` | Required |
| `bundle` | `string` | `--bundle=<value>` | Required |
| `file` | `string` | `<file>` | Required |
