module CI.Setup.Pkl (setup, setupWith, defaultConfig) where

import Prelude (Unit)
import CI.Setup as Setup
import CI.Setup.Types (Config, Result, defaults)
import Effect (Effect)

defaultConfig :: Config
defaultConfig = defaults "pkl"

setupWith :: Config -> Effect Result
setupWith = Setup.install "pkl"

setup :: Effect Unit
setup = Setup.setup "pkl"
