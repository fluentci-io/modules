module CI.Setup.Host where

import Prelude
import CI.Setup.Types (Host, Result, normalizeOS, normalizeArch, cleanDirectory, validDirectory)
import Data.Argonaut.Core (Json, stringify)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, getField)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Parser (jsonParser)
import Data.Array as Array
import Data.Array.NonEmpty as NEA
import Data.Either (Either(..), either, isRight)
import Data.Foldable (foldl, traverse_)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as String
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..))
import Data.String.Regex as Regex
import Data.String.Regex.Flags (noFlags)
import Effect (Effect)
import Effect.Exception (catchException, message, throw, throwException, try)
import FluentCI.Plugin as P
import FluentCI.Plugin.Internal.Imports as Imports
import Foreign.Object as Object

unwrap :: forall a. P.Result a -> Effect a
unwrap = case _ of
  Left error -> throw (P.errorMessage error)
  Right value -> pure value

host :: Effect Host
host = do
  os <- normalizeOS <$> (P.getOS >>= unwrap)
  arch <- normalizeArch <$> (P.getArch >>= unwrap)
  pure { os, arch }

env :: String -> String -> Effect String
env name fallback = do
  present <- P.hasEnv name >>= unwrap
  if present then P.getEnv name >>= unwrap else pure fallback

userHome :: Effect String
userHome = do
  value <- env "HOME" ""
  unless (validDirectory value) $ throw "HOME must be an absolute directory other than /, without parent traversal, colons, or control characters"
  pure (cleanDirectory value)

captureWith :: Object.Object String -> Boolean -> Array String -> Effect String
captureWith environment stderr args = do
  let pipeline = foldl (\p key -> P.withEnv key (fromMaybe "" (Object.lookup key environment)) p)
        (P.pipeline "setup") (Object.keys environment) # P.exec args
  (if stderr then P.stderr pipeline else P.stdout pipeline) >>= unwrap

capture :: Array String -> Effect String
capture = captureWith Object.empty false

run :: Array String -> Effect Unit
run = void <<< capture

runWith :: Object.Object String -> Array String -> Effect Unit
runWith environment = void <<< captureWith environment false

requireTools :: Array String -> Effect Unit
requireTools = traverse_ (\tool -> catchException
  (\error -> throw ("Required setup tool is missing: " <> tool <> ". " <> message error))
  (run [ "which", tool ]))

exists :: String -> Effect Boolean
exists path = do
  output <- capture
    [ "sh", "-c", "if test -e \"$1\"; then printf yes; fi", "fluentci-probe-exists", path ]
  pure (trim output == "yes")

findExecutable :: String -> Effect String
findExecutable program = trim <$> capture
  [ "sh", "-c", "command -v \"$1\" 2>/dev/null || :", "fluentci-probe-tool", program ]

json :: String -> Effect Json
json = either throw pure <<< jsonParser

field :: forall a. DecodeJson a => String -> Json -> Effect a
field name value = do
  object <- either (throw <<< show) pure (decodeJson value)
  either (throw <<< show) pure (getField object name)

fetch :: String -> Effect String
fetch url = capture [ "curl", "--fail", "--location", "--silent", "--show-error", "--proto", "=https", "--proto-redir", "=https", url ]

download :: String -> String -> Effect Unit
download url destination = run
  [ "curl", "--fail", "--location", "--silent", "--show-error", "--proto", "=https", "--proto-redir", "=https", "--output", destination, url ]

withTemp :: forall a. (String -> Effect a) -> Effect a
withTemp action = do
  base <- env "TMPDIR" "/tmp"
  withTempAt base action

withTempAt :: forall a. String -> (String -> Effect a) -> Effect a
withTempAt base action = do
  unless (String.startsWith (Pattern "/") base && not (String.contains (Pattern "\n") base)) $
    throw "TMPDIR must be an absolute path without line breaks"
  path <- trim <$> capture [ "mktemp", "-d", base <> "/fluentci-setup.XXXXXXXX" ]
  unless (String.startsWith (Pattern (base <> "/fluentci-setup.")) path && path /= base) $
    throw "Invalid setup temporary directory returned by mktemp"
  outcome <- try (action path)
  cleanup <- try (run [ "rm", "-rf", "--", path ])
  case outcome of
    Left error -> throwException error
    Right value -> either throwException (const (pure value)) cleanup

versionFrom :: String -> String -> Effect String
versionFrom tool text = do
  let relevant = if tool == "elixir"
        then fromMaybe "" (Array.find (String.startsWith (Pattern "Elixir ")) (map trim (String.split (Pattern "\n") text)))
        else text
  pattern <- either throw pure (Regex.regex (if tool == "binaryen" then "[0-9]+" else "[0-9]+(\\.[0-9]+)+([-+][0-9A-Za-z.-]+)?") noFlags)
  case Regex.match pattern relevant of
    Just matched -> case NEA.head matched of
      Just version -> pure version
      Nothing -> throw "Version command did not report a version"
    Nothing -> throw ("Unable to determine installed " <> tool <> " version")

verify :: String -> String -> String -> Effect String
verify = verifyWith Object.empty

verifyWith :: Object.Object String -> String -> String -> String -> Effect String
verifyWith environment tool expected executable = do
  run [ "test", "-x", executable ]
  text <- if tool == "java" then captureWith environment true [ executable, "-version" ]
    else captureWith environment false ([ executable ] <> if tool == "go" || tool == "zig" then [ "version" ] else [ "--version" ])
  actual <- versionFrom tool text
  let wanted = fromMaybe expected (String.stripPrefix (Pattern "v") expected)
      release = fromMaybe wanted (Array.head (String.split (Pattern "+") wanted))
      floating = Array.elem wanted [ "latest", "stable", "lts" ]
      channel = String.startsWith (Pattern "nightly") wanted || String.startsWith (Pattern "beta") wanted
  when (channel && not (String.contains (Pattern (if String.startsWith (Pattern "nightly") wanted then "nightly" else "beta")) text)) $
    throw ("Installed " <> tool <> " is not the requested channel: " <> wanted)
  unless (floating || channel || actual == release || String.startsWith (Pattern (release <> ".")) actual) $
    throw ("Installed " <> tool <> " version mismatch: requested " <> expected <> ", got " <> actual)
  pure actual

publish :: Result -> Effect Unit
publish installed = do
  activate installed
  P.output (stringify (encodeJson installed)) >>= unwrap

activate :: Result -> Effect Unit
activate installed = do
  -- The SDK exposes the engine's typed environment import here; this updates
  -- subsequent FluentCI commands, without editing shell startup files.
  let pairs = map (\key -> [ key, fromMaybe "" (Object.lookup key installed.environment) ]) (Object.keys installed.environment)
  Imports.set_envs (stringify (encodeJson pairs))

result :: String -> String -> String -> Object.Object String -> Effect Result
result tool version binDir extra = do
  oldPath <- env "PATH" "/usr/bin:/bin"
  pure { tool, version, binDir, environment: Object.insert "PATH" (binDir <> ":" <> oldPath) extra }
