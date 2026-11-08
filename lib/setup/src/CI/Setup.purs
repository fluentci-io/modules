module CI.Setup (setup, install) where

import Prelude
import CI.Setup.Archive as Archive
import CI.Setup.BSD as BSD
import CI.Setup.Host as H
import CI.Setup.Installer as Installer
import CI.Setup.Tools as Tools
import CI.Setup.Types (Config, Result, decodeConfig, defaults, hostSupported, isBSD, isNix, validateConfig, cleanDirectory)
import Data.Array as Array
import Data.Argonaut.Core (stringify)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Parser (jsonParser)
import Data.Either (either)
import Data.String as String
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..))
import Effect (Effect)
import Effect.Exception (throw)
import FluentCI.Plugin as P

install :: String -> Config -> Effect Result
install tool config = do
  either throw pure (validateConfig tool config)
  host <- H.host
  either throw pure (hostSupported tool host)
  when (isBSD host.os && (config.baseline || config.libc /= "auto" || config.otpVersion /= "")) $
    throw "baseline, libc, and otpVersion apply to upstream installs, not native BSD packages"
  when (tool == "rust" && isBSD host.os && (config.toolchain /= "" || not (Array.null config.components) || not (Array.null config.targets) || config.profile /= "minimal")) $
    throw "Rust toolchain, components, targets, and profile require rustup; native BSD packages do not support these options"
  let configured = config { installDir = cleanDirectory config.installDir }
  result <- if Tools.supports tool then Tools.install tool host configured
    else if isBSD host.os then BSD.install tool host configured
    else if isNix tool || tool == "rust" then Installer.install tool host configured
    else Archive.install tool host configured
  H.activate result
  pure result

setup :: String -> Effect Unit
setup tool = do
  raw <- trim <$> (P.input >>= H.unwrap)
  config <- if raw == "" then pure (defaults tool)
    else if String.startsWith (Pattern "{") raw then either throw pure (jsonParser raw >>= decodeConfig tool)
    else pure ((defaults tool) { version = raw })
  result <- install tool config
  P.output (stringify (encodeJson result)) >>= H.unwrap
