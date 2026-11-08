module CI.Setup.Packages (install) where

import Prelude
import CI.Setup.Host as H
import CI.Setup.Types (Config, Result)
import Data.Argonaut.Core (Json)
import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Array as Array
import Data.Either (either)
import Data.Foldable (all, traverse_)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as String
import Data.String.CodeUnits as CU
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..))
import Effect (Effect)
import Effect.Exception (throw)
import Foreign.Object as Object

decode :: forall a. DecodeJson a => Json -> Effect a
decode = either (throw <<< show) pure <<< decodeJson

validKey :: String -> Boolean
validKey key = case CU.charAt 0 key of
  Just c | (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '_' ->
    all (\x -> (x >= 'A' && x <= 'Z') || (x >= 'a' && x <= 'z') || (x >= '0' && x <= '9') || x == '_') (CU.toCharArray key)
  _ -> false

-- Print only named package variables, rather than dumping inherited CI secrets.
-- Identifiers are validated before interpolating them into this fixed script.
envScript :: Array String -> Effect String
envScript names = do
  unless (all validKey names) $ throw "Package manager returned an invalid environment variable name"
  pure (String.joinWith "\n" (map (\key -> "if test \"${" <> key <> "+x}\" = x; then printf '%s\\000%s\\000' '" <> key <> "' \"$" <> key <> "\"; fi") names))

decodeEnvironment :: String -> Effect (Object.Object String)
decodeEnvironment text = go Object.empty (String.split (Pattern "\x0000") text)
  where
  go result tokens = case Array.uncons tokens of
    Nothing -> pure result
    Just { head, tail } -> if Array.null tail && trim head == "" then pure result else do
      unless (validKey head) $ throw "Invalid package environment output"
      case Array.uncons tail of
        Nothing -> throw "Incomplete package environment output"
        Just { head: value, tail: rest } -> go (Object.insert head value result) rest

install :: String -> Config -> Result -> Effect Result
install tool config installed
  | Array.null config.packages = pure installed
  | otherwise = do
    let executable = installed.binDir <> "/" <> if Array.elem tool [ "macports", "macports-rs" ] then "port" else tool
        capture = H.captureWith installed.environment false
        run = void <<< capture
    environment <- if Array.elem tool [ "macports", "macports-rs" ] then do
      when config.sudo $ H.requireTools [ "sudo" ]
      run ((if config.sudo then [ "sudo", "-n" ] else []) <> [ executable, "-N", "install" ] <> config.packages)
      pure (Object.singleton "PATH" "/opt/local/bin:/opt/local/sbin")
    else if tool == "mise" then do
      run ([ executable, "--yes", "install", "--" ] <> config.packages)
      json <- capture ([ executable, "env", "--json", "--" ] <> config.packages) >>= H.json
      decode json :: Effect (Object.Object String)
    else if tool == "pkgx" then do
      let packages = map ("+" <> _) config.packages
      metadata <- capture ([ executable, "--json" ] <> packages) >>= H.json
      paths <- H.field "env" metadata :: Effect (Object.Object Json)
      object <- decode metadata :: Effect (Object.Object Json)
      runtime <- case Object.lookup "runtime_env" object of
        Nothing -> pure Object.empty
        Just value -> decode value :: Effect (Object.Object (Object.Object Json))
      let keys = Array.nub (Object.keys paths <> Array.concatMap (\key -> Object.keys (fromMaybe Object.empty (Object.lookup key runtime))) (Object.keys runtime))
      script <- envScript keys
      capture ([ executable ] <> packages <> [ "--", "/bin/sh", "-c", script ]) >>= decodeEnvironment
    else if Array.elem tool [ "devbox", "flox" ] then do
      H.requireTools [ "sh" ]
      H.run [ "test", "-d", config.project ]
      project <- trim <$> capture [ "sh", "-c", "cd \"$1\" && pwd -P", "fluentci-package-project", config.project ]
      unless (String.startsWith (Pattern "/") project && not (String.contains (Pattern "\n") project)) $ throw "Unable to resolve package project directory"
      present <- H.exists (project <> if tool == "devbox" then "/devbox.json" else "/.flox")
      if tool == "devbox" then do
        unless present $ run [ executable, "init", project ]
        run ([ executable, "add", "--config", project, "--" ] <> config.packages)
        run [ executable, "install", "--config", project ]
      else do
        unless present $ run [ executable, "init", "--dir", project, "--name", "fluentci", "--no-auto-setup" ]
        run ([ executable, "install", "--dir", project, "--" ] <> config.packages)
      -- Export the executable search path; full hooks, services and shell state
      -- remain under the native devbox run / flox activate lifecycle.
      script <- envScript [ "PATH" ]
      let command = if tool == "devbox" then [ "run", "--config", project, "--", "/bin/sh", "-c", script ]
            else [ "activate", "--dir", project, "--no-start-services", "--", "/bin/sh", "-c", script ]
      capture ([ executable ] <> command) >>= decodeEnvironment
    else throw ("Package installation is not supported by setup-" <> tool)
    traverse_ (\key -> unless (validKey key) (throw "Invalid package environment variable")) (Object.keys environment)
    path <- case Object.lookup "PATH" environment of
      Just value | trim value /= "" -> pure value
      _ -> throw "Package manager did not return a usable PATH"
    -- Keep both the selected package executables and the setup CLI available,
    -- retaining the prior host path even when a manager returns only additions.
    let oldPath = fromMaybe "" (Object.lookup "PATH" installed.environment)
        paths = Array.nub (Array.filter (_ /= "") (String.split (Pattern ":") (installed.binDir <> ":" <> path <> ":" <> oldPath)))
    pure (installed { environment = Object.insert "PATH" (String.joinWith ":" paths) (Object.union environment installed.environment) })
