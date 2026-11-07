module CI.Setup.Deno (setup, setupWith, defaultConfig) where

import Prelude (Unit)
import CI.Setup as Setup
import CI.Setup.Types (Config, Result, defaults)
import Effect (Effect)

defaultConfig :: Config
defaultConfig = defaults "deno"

setupWith :: Config -> Effect Result
setupWith = Setup.install "deno"

setup :: Effect Unit
setup = Setup.setup "deno"
