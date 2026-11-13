# gemfury component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `upload`

Upload Linux packages to Gemfury using credentials from the host environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `files` | `string` | yes | Required comma-separated package paths. Whitespace is trimmed; CSV quotes preserve commas inside a filename. Empty lists and malformed entries are rejected. |

Returns `{ uploaded :: Boolean, files :: Array String }`.
