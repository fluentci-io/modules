module CI.Setup.Java (setup, setupWith, defaultConfig) where

import Prelude (Unit)
import CI.Setup as Setup
import CI.Setup.Types (Config, Result, defaults)
import Effect (Effect)

defaultConfig :: Config
defaultConfig = defaults "java"

setupWith :: Config -> Effect Result
setupWith = Setup.install "java"

setup :: Effect Unit
setup = Setup.setup "java"
