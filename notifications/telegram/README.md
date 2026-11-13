# Telegram notifications

Send CI/CD notifications using curl from a typed PureScript Wasm component.
Requires FluentCI v0.17.3+. Configure `TELEGRAM_BOT_TOKEN` through your CI secret store.

## Usage

```sh
fluentci run telegram send --chat-id=-1001234567890 --message "Build passed"
fluentci run telegram send --chat-id @build_channel --message "<b>Deployment complete</b>" --parse-mode HTML --disable-notification
fluentci run telegram send --timeout-seconds 60 --message "Release published" --chat-id @build_channel
fluentci run telegram send --help
```

Every CLI argument is a named scalar. Do not pass a JSON object or JSON array.
The module JSON-encodes message text, including quotes, newlines and Unicode,
without shell interpolation. `tokenEnv` selects an alternate credential variable
name; it never accepts the secret value itself.

## Behavior

Set TELEGRAM_BOT_TOKEN to the bot token issued by BotFather. The bot needs permission to send to the selected chat/channel. chatId accepts a nonzero numeric ID or @channel username. Message text is limited to 4096 Unicode characters; default formatting is plain. parseMode selects HTML, MarkdownV2 or legacy Markdown; escape content for that mode yourself. messageThreadId selects a forum topic. Optional booleans configure silent delivery, content protection and link previews. The returned messageId identifies the acknowledged Telegram message.

Returns a typed record with `provider`, `sent`, `httpStatus`, and `messageId`.
Missing credentials, invalid arguments, unsupported hosts, transport failures,
non-2xx responses and invalid API acknowledgements fail the call. All values are
validated before installing prerequisites or sending a request. There are no
automatic retries, since retrying after a lost response could duplicate a message.
`timeoutSeconds` defaults to 30 and must be from 1 to 600.

The module reuses curl on PATH and invokes its typed `setup-curl` dependency when
curl is absent. Linux, macOS, FreeBSD, OpenBSD and NetBSD are supported. Curl >= 8.3.0
is required for environment-variable expansion; an older curl fails clearly before
posting and must be upgraded. Redirects and curl config files are disabled.
Credential values do not appear in argv or returned records. Notification text
itself is present in the JSON argument and should not contain CI secrets.

[COMPONENT.md](./COMPONENT.md) describes every argument and return field, with
matching [schema metadata](./schema.json). Dependencies are composed into the
published component, so consumers need no local source paths. The CJS bundles are
private regression artifacts; `dist/plugin.wasm` is the native component.

See [official Telegram documentation](https://core.telegram.org/bots/api#sendmessage),
[shared transport](../../lib/notifications/README.md), and [MIT License](./LICENSE).
Builds and mocked regression suites run in the repository's grouped CI jobs;
no real notification credentials or network requests are used in those tests.
