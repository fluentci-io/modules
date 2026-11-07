# gemfury component functions

Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `upload`

Upload Linux packages to Gemfury using credentials from the host environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `files` | `array` | yes | Files selected for the native operation; paths are passed literally without shell expansion. |

Returns `{ uploaded :: Boolean, files :: Array String }`.
