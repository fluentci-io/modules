module CI.ContainerSetup (setupWith) where

import Prelude
import CI.Contract as Contract
import CI.Setup.Host as H
import CI.Setup.Types as Types
import Data.Argonaut.Core (Json)
import Data.Either (either)
import Effect (Effect)
import Effect.Exception (throw)

foreign import install :: Json -> Effect Contract.SetupResult

setupWith :: Json -> Effect Contract.SetupResult
setupWith json = do
  _ <- either throw pure (Types.decodeConfig "buildx" json)
  host <- H.host
  either throw pure (Types.hostSupported "buildx" host)
  install json
