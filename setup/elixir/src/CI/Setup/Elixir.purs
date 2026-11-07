module CI.Setup.Elixir (setup, setupWith, defaultConfig) where

import Prelude (Unit)
import CI.Setup as Setup
import CI.Setup.Types (Config, Result, defaults)
import Effect (Effect)

defaultConfig :: Config
defaultConfig = defaults "elixir"

setupWith :: Config -> Effect Result
setupWith = Setup.install "elixir"

setup :: Effect Unit
setup = Setup.setup "elixir"
