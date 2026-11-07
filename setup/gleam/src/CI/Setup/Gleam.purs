module CI.Setup.Gleam (setup, setupWith, defaultConfig) where

import Prelude (Unit)
import CI.Setup as Setup
import CI.Setup.Types (Config, Result, defaults)
import Effect (Effect)

defaultConfig :: Config
defaultConfig = defaults "gleam"

setupWith :: Config -> Effect Result
setupWith = Setup.install "gleam"

setup :: Effect Unit
setup = Setup.setup "gleam"
