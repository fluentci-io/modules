module CI.ToolSetup (setupWith) where

import Prelude
import CI.Contract as Contract
import CI.Setup.Host as H
import CI.Setup.Types as Types
import Data.Argonaut.Core (Json)
import Data.Either (Either(..), either)
import Effect (Effect)
import Effect.Exception (throw, try)

foreign import installGit :: Effect Unit

foreign import install :: Json -> Effect Contract.SetupResult

setupWith :: Json -> Effect Contract.SetupResult
setupWith json = do
  _ <- either throw pure (Types.decodeConfig "glab" json)
  host <- H.host
  either throw pure (Types.hostSupported "glab" host)
  present <- try (H.run [ "git", "--version" ])
  case present of
    Right _ -> pure unit
    Left _ -> do
      installGit
      H.run [ "git", "--version" ]
  install json
