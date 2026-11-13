# discord component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `send`

Send one Discord notification through curl and verify its delivery acknowledgement. Credentials come from the host environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `message` | `string` | yes | Notification text, passed literally and JSON-encoded internally. Maximum 2000 Unicode characters; no JSON object is accepted. |
| `webhook-env` | `string` | no | Name of the host environment variable holding the credential; pass the variable name, never the secret URL or token. Default: "DISCORD_WEBHOOK_URL". |
| `timeout-seconds` | `integer` | no | HTTP request timeout in seconds, from 1 to 600. Notifications are sent once without automatic retries. Default: 30. |
| `username` | `string` | no | Optional webhook display name, from 1 to 80 Unicode characters. |
| `avatar-url` | `string` | no | Optional HTTPS image URL overriding the webhook avatar. |
| `thread-id` | `string` | no | Positive numeric Discord thread ID; required for existing forum/media channel threads. |
| `allow-mentions` | `boolean` | no | Allow user, role and everyone mentions explicitly. The default disables all parsed mentions. Default: false. |

Returns `{ provider :: String, sent :: Boolean, httpStatus :: Int, messageId :: String }`.
