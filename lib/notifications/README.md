# Notification transport

Shared PureScript implementation for `notifications/slack`, `notifications/discord`,
and `notifications/telegram`. Public modules expose one typed `send` operation;
callers provide named strings, booleans and integers. API JSON is encoded internally.

The common sender validates inputs and credentials before invoking setup or curl.
It uses curl >= 8.3.0 environment variables (`--variable %NAME`, `--expand-url`) to
keep webhook URLs and tokens out of recorded argv. Curl config files are disabled,
URLs use HTTPS, redirects are rejected, and requests have bounded timeouts. There
are no automatic retries because a lost response can still mean a delivered message.

Only a successful HTTP response and a valid service acknowledgement produce
`{ provider, sent, httpStatus, messageId }`. Slack webhook acknowledgements have
no message ID, so their `messageId` is empty. The sender does not log response bodies
in error messages. Message contents remain visible in curl's JSON payload argument;
CI secrets belong in the documented credential environment variables.

Credentials are validated against the service's official webhook/API URL format.
Slack GovSlack webhooks are supported. Discord waits for a returned message and
suppresses mentions by default. Telegram supports plain/HTML/Markdown formatting,
forum topics, silent messages, content protection and link preview options.

See the [curl variables manual](https://curl.se/docs/manpage.html#--variable),
[Slack incoming webhooks](https://docs.slack.dev/messaging/sending-messages-using-incoming-webhooks/),
[Discord webhooks](https://docs.discord.com/developers/resources/webhook#execute-webhook),
and [Telegram sendMessage](https://core.telegram.org/bots/api#sendmessage).
