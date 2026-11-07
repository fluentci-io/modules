module CI.Setup.Go (setup, setupWith, defaultConfig) where

import Prelude (Unit)
import CI.Setup as Setup
import CI.Setup.Types (Config, Result, defaults)
import Effect (Effect)

defaultConfig :: Config
defaultConfig = defaults "go"

setupWith :: Config -> Effect Result
setupWith = Setup.install "go"

setup :: Effect Unit
setup = Setup.setup "go"
