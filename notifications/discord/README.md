# Discord notifications

Send CI/CD notifications using curl from a typed PureScript Wasm component.
Requires FluentCI v0.17.3+. Configure `DISCORD_WEBHOOK_URL` through your CI secret store.

## Usage

```sh
fluentci run discord send --message "Build passed" --username "CI bot"
fluentci run discord send --message "Deployment complete" --thread-id 123456789012345678
fluentci run discord send --timeout-seconds 60 --message "Release published"
fluentci run discord send --help
```

Every CLI argument is a named scalar. Do not pass a JSON object or JSON array.
The module JSON-encodes message text, including quotes, newlines and Unicode,
without shell interpolation. `webhookEnv` selects an alternate credential variable
name; it never accepts the secret value itself.

## Behavior

Set DISCORD_WEBHOOK_URL to a bare HTTPS incoming-webhook URL on discord.com or discordapp.com without query parameters. Text is limited to 2000 Unicode characters. Optional username/avatarUrl override presentation, and threadId targets an existing channel thread. Forum/media channels need an existing thread ID. Mention parsing is disabled by default; opt in with --allow-mentions. The request uses wait=true and returns the acknowledged Discord message ID.

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

See [official Discord documentation](https://docs.discord.com/developers/resources/webhook#execute-webhook),
[shared transport](../../lib/notifications/README.md), and [MIT License](./LICENSE).
Builds and mocked regression suites run in the repository's grouped CI jobs;
no real notification credentials or network requests are used in those tests.
