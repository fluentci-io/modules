module CI.Setup.Bun (setup, setupWith, defaultConfig) where

import Prelude (Unit)
import CI.Setup as Setup
import CI.Setup.Types (Config, Result, defaults)
import Effect (Effect)

defaultConfig :: Config
defaultConfig = defaults "bun"

setupWith :: Config -> Effect Result
setupWith = Setup.install "bun"

setup :: Effect Unit
setup = Setup.setup "bun"
