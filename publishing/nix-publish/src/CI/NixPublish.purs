module CI.NixPublish (execute, executeWithSetup) where

import Prelude
import CI.CLI as CLI
import CI.Contract (ExecutionResult)
import Data.Argonaut.Core (Json)
import Data.Argonaut.Decode (decodeJson)
import Data.Array as Array
import Data.Either (Either, either)
import Data.Foldable (traverse_)
import Data.String.Common (trim)
import Effect (Effect)
import Effect.Exception (throw)
import FluentCI.Plugin as P
import Foreign.Object as Object

requiredEnv :: String -> Effect Unit
requiredEnv name = do
  present <- P.hasEnv name >>= either (throw <<< P.errorMessage) pure
  value <- if present then P.getEnv name >>= either (throw <<< P.errorMessage) pure else pure ""
  when (trim value == "") $ throw ("Set " <> name <> " before publishing; GitHub Actions requires id-token: write")

execute :: String -> String -> Json -> Effect ExecutionResult
execute = executeInternal false (const (pure unit))

executeWithSetup :: (String -> Effect Unit) -> String -> String -> Json -> Effect ExecutionResult
executeWithSetup = executeInternal true

executeInternal :: Boolean -> (String -> Effect Unit) -> String -> String -> Json -> Effect ExecutionResult
executeInternal automaticSetup setupDependency name command json = do
  -- Validate the complete input before checking credentials or starting host tasks.
  void (either throw pure (CLI.makePlan name command json))
  os <- P.getOS >>= either (throw <<< P.errorMessage) pure
  unless (Array.elem os [ "linux", "macos" ]) $ throw "Nix publishing supports Linux and macOS only"
  when (Array.elem command [ "flakehub", "flakestry" ]) do
    traverse_ requiredEnv
      [ if command == "flakehub" then "FLAKEHUB_PUSH_GITHUB_TOKEN" else "GH_TOKEN"
      , "ACTIONS_ID_TOKEN_REQUEST_TOKEN", "ACTIONS_ID_TOKEN_REQUEST_URL"
      ]
    object <- either (throw <<< show) pure (decodeJson json :: Either _ (Object.Object Json))
    when (not automaticSetup || Object.member "executable" object) $
      void (P.pipeline "nix-publish-preflight" # P.exec [ "which", "nix" ] # P.stdout >>= either (throw <<< P.errorMessage) pure)
  if automaticSetup then CLI.executeWithSetup setupDependency name command json else CLI.execute name command json
