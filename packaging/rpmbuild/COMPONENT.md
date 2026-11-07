# rpmbuild component functions

Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `build`

Build packages from a Linux rpmbuild package tree and target architecture.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `directory` | `string` | yes | Input directory containing the package tree to validate and build. |
| `arch` | `string` | yes | Target package CPU architecture; the payload must already be compiled for this architecture. |
| `output` | `string` | no | Destination path for generated packages. |
| `spec` | `string` | yes | RPM spec file inside the package tree. |

Returns `Array String`.

## `validate`

Validate a Linux rpmbuild package tree and target architecture.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `directory` | `string` | yes | Input directory containing the package tree to validate and build. |
| `arch` | `string` | yes | Target package CPU architecture; the payload must already be compiled for this architecture. |
| `output` | `string` | no | Destination path for generated packages. |
| `spec` | `string` | yes | RPM spec file inside the package tree. |

Returns `Boolean`.
