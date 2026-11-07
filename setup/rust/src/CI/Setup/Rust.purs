module CI.Setup.Rust (setup, setupWith, defaultConfig) where

import Prelude (Unit)
import CI.Setup as Setup
import CI.Setup.Types (Config, Result, defaults)
import Effect (Effect)

defaultConfig :: Config
defaultConfig = defaults "rust"

setupWith :: Config -> Effect Result
setupWith = Setup.install "rust"

setup :: Effect Unit
setup = Setup.setup "rust"
