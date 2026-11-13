module CI.ToolSetup (setupWith) where

import Prelude
import CI.Contract as Contract
import CI.Setup.Host as H
import CI.Setup.Types as Types
import Data.Argonaut.Core (Json)
import Data.Either (Either(..), either)
import Data.String as String
import Data.String.CodeUnits as CU
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..))
import Foreign.Object as Object
import Effect (Effect)
import Effect.Exception (throw, try)

foreign import installGit :: Effect Unit

foreign import install :: Json -> Effect Contract.SetupResult

setupWith :: Json -> Effect Contract.SetupResult
setupWith json = do
  config <- either throw pure (Types.decodeConfig "gh" json)
  host <- H.host
  either throw pure (Types.hostSupported "gh" host)
  present <- try (H.run [ "git", "--version" ])
  case present of
    Right _ -> pure unit
    Left _ -> do
      installGit
      H.run [ "git", "--version" ]
  reusable <- try do
    unless (config.installDir == "" && config.packageName == "" && not config.sudo) $
      throw "Explicit installation requested"
    executable <- H.findExecutable "gh"
    unless (String.startsWith (Pattern "/") executable) $ throw "GitHub CLI is unavailable"
    actual <- H.capture [ executable, "--version" ] >>= H.versionFrom "gh"
    let expected = if String.startsWith (Pattern "v") config.version then CU.drop 1 config.version else config.version
    unless (expected == "latest" || expected == actual) $ throw "GitHub CLI version mismatch"
    bin <- trim <$> H.capture [ "dirname", executable ]
    result <- H.result "gh" actual bin Object.empty
    H.activate result
    pure (Contract.setupResult result)
  case reusable of
    Right result -> pure result
    Left _ -> install json
