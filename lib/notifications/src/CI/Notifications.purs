module CI.Notifications (SendResult, SlackArgs, DiscordArgs, TelegramArgs, slack, discord, telegram) where

import Prelude
import Data.Argonaut.Core (Json, stringify)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, getField)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Parser (jsonParser)
import Data.Array as A
import Data.Either (either)
import Data.Foldable (all, traverse_)
import Data.Int as Int
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as S
import Data.String.CodePoints as CP
import Data.String.CodeUnits as CU
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..))
import Data.String.Regex as Regex
import Data.String.Regex.Flags (noFlags)
import Data.Tuple (Tuple(..))
import Foreign.Object as Object
import Effect (Effect)
import Effect.Exception (throw)
import FluentCI.Plugin as P

-- Credential values never cross the public function boundary or enter curl argv.
type SendResult = { provider :: String, sent :: Boolean, httpStatus :: Int, messageId :: String }
type SlackArgs = { message :: String, webhookEnv :: Maybe String, threadTs :: Maybe String, timeoutSeconds :: Maybe Int }
type DiscordArgs = { message :: String, webhookEnv :: Maybe String, username :: Maybe String, avatarUrl :: Maybe String, threadId :: Maybe String, allowMentions :: Maybe Boolean, timeoutSeconds :: Maybe Int }
type TelegramArgs = { message :: String, chatId :: String, tokenEnv :: Maybe String, parseMode :: Maybe String, messageThreadId :: Maybe Int, disableNotification :: Maybe Boolean, protectContent :: Maybe Boolean, disableWebPagePreview :: Maybe Boolean, timeoutSeconds :: Maybe Int }

unwrap :: forall a. P.Result a -> Effect a
unwrap = either (throw <<< P.errorMessage) pure

matches :: String -> String -> Effect Boolean
matches pattern value = do
  compiled <- either throw pure (Regex.regex pattern noFlags)
  pure (Regex.test compiled value)

singleLine :: String -> String -> Effect Unit
singleLine label value = unless (trim value /= "" && all (\c -> c /= '\x0000' && c /= '\n' && c /= '\r') (CU.toCharArray value)) $
  throw (label <> " must be nonempty without NUL or line breaks")

message :: Int -> String -> Effect Unit
message limit value = unless (trim value /= "" && CP.length value <= limit && not (S.contains (Pattern "\x0000") value)) $
  throw ("message must contain 1-" <> show limit <> " characters without NUL")

environmentName :: String -> Effect Unit
environmentName name = do
  singleLine "Credential environment variable name" name
  valid <- matches "^[A-Za-z_][A-Za-z0-9_]*$" name
  unless valid $ throw "Credential environment variable name must be a valid environment identifier"

credential :: String -> Effect String
credential name = do
  present <- P.hasEnv name >>= unwrap
  value <- if present then P.getEnv name >>= unwrap else pure ""
  -- Never include credential values in errors, including malformed URLs/tokens.
  singleLine ("Environment variable " <> name) value
  pure value

optionalText :: String -> Int -> Maybe String -> Effect Unit
optionalText label limit = traverse_ (\value -> do
  singleLine label value
  unless (CP.length value <= limit) $ throw (label <> " is too long"))

positiveId :: String -> String -> Effect Unit
positiveId label value = do
  singleLine label value
  valid <- matches "^[0-9]+$" value
  unless (valid && A.any (_ /= '0') (CU.toCharArray value)) $ throw (label <> " must be a positive numeric identifier")

timeout :: Maybe Int -> Effect Int
timeout requested = do
  let value = fromMaybe 30 requested
  unless (value >= 1 && value <= 600) $ throw "timeoutSeconds must be between 1 and 600"
  pure value

jsonField :: forall a. DecodeJson a => String -> Json -> Effect a
jsonField key object = either (const (throw "Notification service returned an invalid acknowledgement")) pure (decodeJson object >>= \fields -> getField fields key)

jsonResponse :: String -> Effect Json
jsonResponse = either (const (throw "Notification service returned malformed JSON")) pure <<< jsonParser

withOption :: forall a. (a -> Json) -> String -> Maybe a -> Array { key :: String, value :: Json }
withOption encode key value = case value of
  Nothing -> []
  Just actual -> [ { key, value: encode actual } ]

-- Construct payloads with a JSON encoder; no shell interpolation or string-built JSON.
payload :: Array { key :: String, value :: Json } -> String
payload fields = stringify (encodeJson (Object.fromFoldable (map (\field -> Tuple field.key field.value) fields)))

request :: Effect Unit -> String -> Int -> String -> String -> Array String -> String -> Effect { body :: String, status :: Int }
request setup provider seconds envName endpoint query body = do
  os <- P.getOS >>= unwrap
  unless (A.elem os [ "linux", "macos", "freebsd", "openbsd", "netbsd" ]) $ throw ("Unsupported notification host OS: " <> os)
  setup
  version <- P.pipeline "notification-curl-version" # P.exec [ "curl", "--disable", "--version" ] # P.stdout >>= unwrap
  let word = fromMaybe "" (A.index (S.split (Pattern " ") (trim version)) 1)
      parts = S.split (Pattern ".") word
      major = A.index parts 0 >>= Int.fromString
      minor = A.index parts 1 >>= Int.fromString
  unless (case major, minor of
    Just a, Just b -> a > 8 || (a == 8 && b >= 3)
    _, _ -> false) $ throw "Notifications require curl >= 8.3.0 for environment-based credential expansion; upgrade curl first"
  response <- P.pipeline (provider <> "-notification") # P.exec
    ([ "curl", "--disable", "--silent", "--show-error", "--globoff", "--proto", "=https"
     , "--connect-timeout", show (min 10 seconds), "--max-time", show seconds
     , "--request", "POST", "--header", "Content-Type: application/json"
     , "--variable", "%" <> envName, "--expand-url", endpoint
     , "--data-raw", body, "--write-out", "\n%{http_code}" ] <> query) # P.stdout
  output <- either (const (throw (provider <> " notification transport failed"))) pure response
  let lines = S.split (Pattern "\n") (trim output)
  status <- case A.last lines >>= Int.fromString of
    Just value | value >= 100 && value <= 599 -> pure value
    _ -> throw "curl did not return a valid HTTP status"
  unless (status >= 200 && status < 300) $ throw (provider <> " notification failed with HTTP " <> show status)
  pure { body: S.joinWith "\n" (A.take (A.length lines - 1) lines), status }

slack :: Effect Unit -> SlackArgs -> Effect SendResult
slack setup args = do
  message 4000 args.message
  seconds <- timeout args.timeoutSeconds
  let name = fromMaybe "SLACK_WEBHOOK_URL" args.webhookEnv
  environmentName name
  traverse_ (\value -> do
    singleLine "threadTs" value
    valid <- matches "^[0-9]+\\.[0-9]+$" value
    unless valid $ throw "threadTs must be a Slack message timestamp") args.threadTs
  secret <- credential name
  valid <- matches "^https://hooks\\.(slack\\.com|slack-gov\\.com)/services/[A-Za-z0-9_-]+/[A-Za-z0-9_-]+/[A-Za-z0-9_-]+$" secret
  unless valid $ throw "Slack webhook must be a bare HTTPS incoming-webhook URL on hooks.slack.com or hooks.slack-gov.com"
  let body = payload ([ { key: "text", value: encodeJson args.message } ] <> withOption encodeJson "thread_ts" args.threadTs)
  result <- request setup "slack" seconds name ("{{" <> name <> "}}") [] body
  unless (trim result.body == "ok") $ throw "Slack did not acknowledge the notification"
  pure { provider: "slack", sent: true, httpStatus: result.status, messageId: "" }

discord :: Effect Unit -> DiscordArgs -> Effect SendResult
discord setup args = do
  message 2000 args.message
  seconds <- timeout args.timeoutSeconds
  let name = fromMaybe "DISCORD_WEBHOOK_URL" args.webhookEnv
  environmentName name
  optionalText "username" 80 args.username
  traverse_ (\url -> do
    singleLine "avatarUrl" url
    valid <- matches "^https://[^\\s]+$" url
    unless valid $ throw "avatarUrl must use HTTPS") args.avatarUrl
  traverse_ (positiveId "threadId") args.threadId
  secret <- credential name
  valid <- matches "^https://(discord\\.com|discordapp\\.com)/api/(v[0-9]+/)?webhooks/[0-9]+/[A-Za-z0-9_-]+$" secret
  unless valid $ throw "Discord webhook must be a bare HTTPS incoming-webhook URL on discord.com or discordapp.com"
  let mentions = if fromMaybe false args.allowMentions then [ "users", "roles", "everyone" ] else []
      body = payload ([ { key: "content", value: encodeJson args.message }, { key: "allowed_mentions", value: encodeJson { parse: mentions } } ]
        <> withOption encodeJson "username" args.username <> withOption encodeJson "avatar_url" args.avatarUrl)
      query = [ "--url-query", "wait=true" ] <> case args.threadId of
        Nothing -> []
        Just value -> [ "--url-query", "thread_id=" <> value ]
  result <- request setup "discord" seconds name ("{{" <> name <> "}}") query body
  response <- jsonResponse result.body
  id <- jsonField "id" response
  positiveId "Discord acknowledgement ID" id
  pure { provider: "discord", sent: true, httpStatus: result.status, messageId: id }

telegram :: Effect Unit -> TelegramArgs -> Effect SendResult
telegram setup args = do
  message 4096 args.message
  seconds <- timeout args.timeoutSeconds
  let name = fromMaybe "TELEGRAM_BOT_TOKEN" args.tokenEnv
  environmentName name
  singleLine "chatId" args.chatId
  validChat <- matches "^(-?[0-9]+|@[A-Za-z][A-Za-z0-9_]+)$" args.chatId
  unless (validChat && (S.startsWith (Pattern "@") args.chatId || A.any (\c -> c >= '1' && c <= '9') (CU.toCharArray args.chatId))) $ throw "chatId must be a nonzero numeric chat ID or @channel username"
  traverse_ (\mode -> unless (A.elem mode [ "HTML", "MarkdownV2", "Markdown" ]) $ throw "parseMode must be HTML, MarkdownV2 or Markdown") args.parseMode
  traverse_ (\value -> unless (value > 0) $ throw "messageThreadId must be positive") args.messageThreadId
  secret <- credential name
  valid <- matches "^[0-9]+:[A-Za-z0-9_-]+$" secret
  unless valid $ throw "Telegram bot token has an invalid format"
  let body = payload ([ { key: "chat_id", value: encodeJson args.chatId }, { key: "text", value: encodeJson args.message } ]
        <> withOption encodeJson "parse_mode" args.parseMode
        <> withOption encodeJson "message_thread_id" args.messageThreadId
        <> withOption encodeJson "disable_notification" args.disableNotification
        <> withOption encodeJson "protect_content" args.protectContent
        <> withOption (\disabled -> encodeJson { is_disabled: disabled }) "link_preview_options" args.disableWebPagePreview)
  result <- request setup "telegram" seconds name ("https://api.telegram.org/bot{{" <> name <> "}}/sendMessage") [] body
  response <- jsonResponse result.body
  ok <- jsonField "ok" response
  unless ok $ throw "Telegram rejected the notification"
  sent <- jsonField "result" response
  id <- jsonField "message_id" sent :: Effect Int
  unless (id > 0) $ throw "Telegram returned an invalid message ID"
  pure { provider: "telegram", sent: true, httpStatus: result.status, messageId: show id }
