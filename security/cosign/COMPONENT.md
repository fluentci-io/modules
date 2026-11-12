# cosign component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `run`

Run arbitrary Cosign commands with literal arguments.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `arguments` | `array` | yes | Literal Cosign arguments in native order. |

Returns `Contract.ExecutionResult`.

## `version`

Report the installed Cosign version.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |

Returns `Contract.ExecutionResult`.

## `sign`

Sign an OCI image using a key or ambient CI OIDC credentials; publish the signature to its registry.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `key` | `string` | no | Key file, env:// reference, or supported KMS URI; credentials are inherited. |
| `image` | `string` | yes | OCI image reference, preferably pinned by digest. |

Returns `Contract.ExecutionResult`.

## `sign-blob`

Sign a local release artifact and write its Sigstore verification bundle.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `key` | `string` | no | Key file, env:// reference, or supported KMS URI; credentials are inherited. |
| `bundle` | `string` | yes | Destination Sigstore bundle file; parent directory must exist. |
| `file` | `string` | yes | Artifact file to sign or verify. |

Returns `Contract.ExecutionResult`.

## `verify`

Verify an OCI image signature against an exact keyless identity and issuer; fail the pipeline on verification errors.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `certificate-identity` | `string` | yes | Exact expected certificate subject identity. |
| `certificate-oidc-issuer` | `string` | yes | Exact expected certificate OIDC issuer. |
| `image` | `string` | yes | OCI image reference, preferably pinned by digest. |

Returns `Contract.ExecutionResult`.

## `verify-key`

Verify an OCI image signature against an explicit public key or KMS key.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `key` | `string` | yes | Key file, env:// reference, or supported KMS URI; credentials are inherited. |
| `image` | `string` | yes | OCI image reference, preferably pinned by digest. |

Returns `Contract.ExecutionResult`.

## `verify-blob`

Verify a release artifact and Sigstore bundle against an exact keyless identity and issuer.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `certificate-identity` | `string` | yes | Exact expected certificate subject identity. |
| `certificate-oidc-issuer` | `string` | yes | Exact expected certificate OIDC issuer. |
| `bundle` | `string` | yes | Sigstore bundle file to read. |
| `file` | `string` | yes | Artifact file to sign or verify. |

Returns `Contract.ExecutionResult`.

## `verify-blob-key`

Verify a release artifact and Sigstore bundle against an explicit public key or KMS key.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `project` | `string` | no | Working directory containing the source checkout; defaults to the current directory. Default: ".". |
| `run-dir` | `string` | yes | Fresh directory for this invocation’s execution report and task logs; must not already exist. |
| `executable` | `string` | no | Native CLI executable name or absolute path; defaults to this operation’s tool. |
| `timeout-ms` | `integer` | no | Maximum task duration in milliseconds; defaults to 900000. Default: 900000. |
| `artifacts` | `array` | no | Output artifacts to collect as NAME=PATH entries; names must be unique. |
| `key` | `string` | yes | Key file, env:// reference, or supported KMS URI; credentials are inherited. |
| `bundle` | `string` | yes | Sigstore bundle file to read. |
| `file` | `string` | yes | Artifact file to sign or verify. |

Returns `Contract.ExecutionResult`.
