# telegram component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `send`

Send one Telegram notification through curl and verify its delivery acknowledgement. Credentials come from the host environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `message` | `string` | yes | Notification text, passed literally and JSON-encoded internally. Maximum 4096 Unicode characters; no JSON object is accepted. |
| `token-env` | `string` | no | Name of the host environment variable holding the credential; pass the variable name, never the secret URL or token. Default: "TELEGRAM_BOT_TOKEN". |
| `timeout-seconds` | `integer` | no | HTTP request timeout in seconds, from 1 to 600. Notifications are sent once without automatic retries. Default: 30. |
| `chat-id` | `string` | yes | Nonzero numeric Telegram chat ID (including negative group IDs), or an @channel username. |
| `parse-mode` | `string` | no | Optional Telegram formatting mode; omitted text is plain. Escape markup according to the selected mode. Allowed values: HTML, MarkdownV2, Markdown. |
| `message-thread-id` | `integer` | no | Optional positive forum topic message-thread ID. |
| `disable-notification` | `boolean` | no | Send silently when true. |
| `protect-content` | `boolean` | no | Protect the message from forwarding and saving when true. |
| `disable-web-page-preview` | `boolean` | no | Disable link previews when true. |

Returns `{ provider :: String, sent :: Boolean, httpStatus :: Int, messageId :: String }`.
