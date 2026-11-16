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

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add telegram --path /path/to/fluentci-modules/notifications/telegram
```

For a published module, use `fluentci add @fluentci.io/telegram@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Send one Telegram notification through curl and verify its delivery acknowledgement. Credentials come from the host environment.

Replace the sample organization, paths and identifiers with your own. Configure
credentials through your CI secret provider before running authenticated operations. Optional arguments use the
callee's defaults, and public list fields use comma-separated strings. See
[COMPONENT.md](./COMPONENT.md) for argument descriptions and return types.

These examples use the generated composition API and builder chaining in
FluentCI 0.17.6; full cross-SDK compilation and execution coverage is still pending.
See [composition support and limitations](../../docs/COMPOSITION.md).



### PureScript

```purescript
module Main where

import Prelude
import Effect (Effect)
import FluentCI.Flow as Flow
import FluentCI.Modules.Telegram as Telegram

run :: Effect String
run =
  Flow.pipeline "telegram-send"
    # Flow.workdir "."
    # Telegram.send (Telegram.sendArgs { "message": "Release v1.0.0 deployed to staging: https://staging.example.com", "chatId": "-1001234567890" })
    # Flow.map (\result -> result.messageId)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/telegram

pub fn run() -> String {
  flow.pipeline("telegram-send")
  |> flow.workdir(".")
  |> telegram.send(telegram.send_args("Release v1.0.0 deployed to staging: https://staging.example.com", "-1001234567890"))
  |> flow.map(fn(result) { result.message_id })
  |> flow.run
}
```

Use Gleam's JavaScript target for the Wasm guest. BEAM escripts used for repository
automation are separate from component guests.

### Elixir

```elixir
defmodule Main do
  use FluentCI.Plugin
  alias FluentCI.Flow
  alias FluentCI.Modules.Telegram

  defplugin run do
    Flow.pipeline("telegram-send")
    |> Flow.workdir(".")
    |> Telegram.send(%{"message" => "Release v1.0.0 deployed to staging: https://staging.example.com", "chat_id" => "-1001234567890"})
    |> Flow.stdout()
  end
end
```

Elixir compiles this sequence to Rust/Wasm. Its initial Flow API does not yet
provide the typed result callbacks or cleanup combinators of the other examples.

### ClojureScript

```clojure
(ns main.plugin
  (:require [fluentci.flow :as flow]
            [fluentci-modules.telegram :as telegram]))

(defn run []
  (-> (flow/pipeline "telegram-send")
      (flow/workdir ".")
      (telegram/send {:message "Release v1.0.0 deployed to staging: https://staging.example.com", :chatId "-1001234567890"})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("telegram-send")
  ->Flow.workdir(".")
  ->FluentciModulesTelegram.send(FluentciModulesTelegram.sendArgs(~message="Release v1.0.0 deployed to staging: https://staging.example.com", ~chatId="-1001234567890"))
  ->Flow.map(result => result.messageId)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import telegram


def run() -> str:
    return (
        pipeline("telegram-send")
        .workdir(".")
        .pipe(telegram.send, {"message": "Release v1.0.0 deployed to staging: https://staging.example.com", "chat_id": "-1001234567890"})
        .map(lambda result: result.message_id)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as telegram from "./fluentci_modules/telegram/index";

export function run(): string {
  return flow.pipeline("telegram-send")
    .workdir(".")
    .pipe(telegram.send, {"message":"Release v1.0.0 deployed to staging: https://staging.example.com","chatId":"-1001234567890"})
    .map(result => result.messageId)
    .run();
}
```

Python and TypeScript use FluentCI builder chains: `.pipe(module.function, args)`
composes generated module functions with `.workdir`, `.env`, and `.exec`.
Functions return a pipeline carrying their typed result. Use a generated result
callback (`With`/`_with`, or a callback argument in TypeScript/Python) when a later
module needs a preceding result; use Flow's map operation to select a result field.
Execution begins at `run` (or the Elixir plugin terminal), in declared order.

### Exported functions

| Function | Purpose |
| --- | --- |
| `send` | Send one Telegram notification through curl and verify its delivery acknowledgement. Credentials come from the host environment. |
<!-- /generated:language-examples -->
