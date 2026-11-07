module CI.Setup.Zig (setup, setupWith, defaultConfig) where

import Prelude (Unit)
import CI.Setup as Setup
import CI.Setup.Types (Config, Result, defaults)
import Effect (Effect)

defaultConfig :: Config
defaultConfig = defaults "zig"

setupWith :: Config -> Effect Result
setupWith = Setup.install "zig"

setup :: Effect Unit
setup = Setup.setup "zig"
