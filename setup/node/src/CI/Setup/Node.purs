module CI.Setup.Node (setup, setupWith, defaultConfig) where

import Prelude (Unit)
import CI.Setup as Setup
import CI.Setup.Types (Config, Result, defaults)
import Effect (Effect)

defaultConfig :: Config
defaultConfig = defaults "node"

setupWith :: Config -> Effect Result
setupWith = Setup.install "node"

setup :: Effect Unit
setup = Setup.setup "node"
