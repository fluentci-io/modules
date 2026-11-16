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

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add discord --path /path/to/fluentci-modules/notifications/discord
```

For a published module, use `fluentci add @fluentci.io/discord@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

Send one Discord notification through curl and verify its delivery acknowledgement. Credentials come from the host environment.

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
import FluentCI.Modules.Discord as Discord

run :: Effect String
run =
  Flow.pipeline "discord-send"
    # Flow.workdir "."
    # Discord.send (Discord.sendArgs { "message": "Release v1.0.0 deployed to staging: https://staging.example.com" })
    # Flow.map (\result -> result.messageId)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/discord

pub fn run() -> String {
  flow.pipeline("discord-send")
  |> flow.workdir(".")
  |> discord.send(discord.send_args("Release v1.0.0 deployed to staging: https://staging.example.com"))
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
  alias FluentCI.Modules.Discord

  defplugin run do
    Flow.pipeline("discord-send")
    |> Flow.workdir(".")
    |> Discord.send(%{"message" => "Release v1.0.0 deployed to staging: https://staging.example.com"})
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
            [fluentci-modules.discord :as discord]))

(defn run []
  (-> (flow/pipeline "discord-send")
      (flow/workdir ".")
      (discord/send {:message "Release v1.0.0 deployed to staging: https://staging.example.com"})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("discord-send")
  ->Flow.workdir(".")
  ->FluentciModulesDiscord.send(FluentciModulesDiscord.sendArgs(~message="Release v1.0.0 deployed to staging: https://staging.example.com"))
  ->Flow.map(result => result.messageId)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import discord


def run() -> str:
    return (
        pipeline("discord-send")
        .workdir(".")
        .pipe(discord.send, {"message": "Release v1.0.0 deployed to staging: https://staging.example.com"})
        .map(lambda result: result.message_id)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as discord from "./fluentci_modules/discord/index";

export function run(): string {
  return flow.pipeline("discord-send")
    .workdir(".")
    .pipe(discord.send, {"message":"Release v1.0.0 deployed to staging: https://staging.example.com"})
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
| `send` | Send one Discord notification through curl and verify its delivery acknowledgement. Credentials come from the host environment. |
<!-- /generated:language-examples -->
