module CI.Setup.Nix (setup, setupWith, defaultConfig) where

import Prelude (Unit)
import CI.Setup as Setup
import CI.Setup.Types (Config, Result, defaults)
import Effect (Effect)

defaultConfig :: Config
defaultConfig = defaults "nix"

setupWith :: Config -> Effect Result
setupWith = Setup.install "nix"

setup :: Effect Unit
setup = Setup.setup "nix"
