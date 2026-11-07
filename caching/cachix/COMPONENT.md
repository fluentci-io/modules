# cachix component functions

Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `setup`

Configure a Cachix cache using host credentials.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `cache` | `string` | yes | Cachix cache name; credentials come from CACHIX_AUTH_TOKEN. |

Returns `{ enabled :: Boolean, cache :: String }`.

## `push`

Push the result closure to a Cachix cache using host credentials.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `cache` | `string` | yes | Cachix cache name; credentials come from CACHIX_AUTH_TOKEN. |

Returns `{ enabled :: Boolean, cache :: String }`.
