# slack component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `send`

Send one Slack notification through curl and verify its delivery acknowledgement. Credentials come from the host environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `message` | `string` | yes | Notification text, passed literally and JSON-encoded internally. Maximum 4000 Unicode characters; no JSON object is accepted. |
| `webhook-env` | `string` | no | Name of the host environment variable holding the credential; pass the variable name, never the secret URL or token. Default: "SLACK_WEBHOOK_URL". |
| `timeout-seconds` | `integer` | no | HTTP request timeout in seconds, from 1 to 600. Notifications are sent once without automatic retries. Default: 30. |
| `thread-ts` | `string` | no | Existing Slack message timestamp for a threaded reply, such as 1712345678.123456. |

Returns `{ provider :: String, sent :: Boolean, httpStatus :: Int, messageId :: String }`.
