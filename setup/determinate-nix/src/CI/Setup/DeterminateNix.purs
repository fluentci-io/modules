module CI.Setup.DeterminateNix (setup, setupWith, defaultConfig) where

import Prelude (Unit)
import CI.Setup as Setup
import CI.Setup.Types (Config, Result, defaults)
import Effect (Effect)

defaultConfig :: Config
defaultConfig = defaults "determinate-nix"

setupWith :: Config -> Effect Result
setupWith = Setup.install "determinate-nix"

setup :: Effect Unit
setup = Setup.setup "determinate-nix"
