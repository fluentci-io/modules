module CI.Setup.UvEnvironment (Config, defaultConfig, decodeConfig, setupWith, setup) where

import Prelude
import CI.Setup.Host as H
import CI.Setup.Tools as Tools
import CI.Setup.Types as Types
import Data.Argonaut.Core (Json, isNull, stringify)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, getFieldOptional)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Parser (jsonParser)
import Data.Array as Array
import Data.Either (Either(..), either)
import Data.Foldable (traverse_)
import Data.Maybe (fromMaybe)
import Data.String as String
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..))
import Data.String.Regex as Regex
import Data.String.Regex.Flags (noFlags)
import Effect (Effect)
import Effect.Exception (throw)
import FluentCI.Plugin as P
import Foreign.Object as Object

type Config = { base :: Types.Config, pythonVersion :: String, tools :: Array String }

defaultConfig :: Config
defaultConfig = { base: Types.defaults "uv", pythonVersion: "", tools: [] }

optional :: forall a. DecodeJson a => Object.Object Json -> String -> a -> Either String a
optional object key fallback = either (Left <<< show) (Right <<< fromMaybe fallback) (getFieldOptional object key)

validate :: Config -> Either String Unit
validate config = do
  Types.validateConfig "uv" config.base
  python <- Regex.regex "^[A-Za-z0-9][A-Za-z0-9._+@-]*$" noFlags
  unless (config.pythonVersion == "" || Regex.test python config.pythonVersion) $ Left "Invalid Python version selector"
  package <- Regex.regex "^[A-Za-z0-9]([A-Za-z0-9._-]*[A-Za-z0-9])?(\\[[A-Za-z0-9._-]+\\])?((===|==|~=|!=|<=|>=|<|>)[A-Za-z0-9.*+_-]+)?$" noFlags
  traverse_ (\tool -> unless (Regex.test package tool) (Left "tools must contain package names or single version constraints, such as ruff==0.12.0, without empty entries or shell syntax")) config.tools
  unless (Array.length (Array.nub config.tools) == Array.length config.tools) $ Left "Duplicate uv tools"

decodeConfig :: Json -> Either String Config
decodeConfig json = do
  object <- either (Left <<< show) pure (decodeJson json)
  when (Array.any isNull (Object.values object)) $ Left "Setup arguments cannot be null"
  pythonVersion <- optional object "pythonVersion" ""
  text <- optional object "tools" ""
  let tools = Types.commaSeparated text
  base <- Types.decodeConfig "uv" (encodeJson (Object.delete "pythonVersion" (Object.delete "tools" object)))
  let config = { base, pythonVersion, tools }
  validate config
  pure config

setupWith :: Config -> Effect Types.Result
setupWith config = do
  either throw pure (validate config)
  host <- H.host
  either throw pure (Types.hostSupported "uv" host)
  when (Types.isBSD host.os && config.base.installDir /= "") $ throw "Native BSD packages use the system prefix; omit installDir"
  installed <- Tools.install "uv" host (config.base { installDir = Types.cleanDirectory config.base.installDir })
  prepared <- if config.pythonVersion == "" && Array.null config.tools then pure installed else do
    H.requireTools [ "mkdir", "ln", "test" ]
    home <- H.userHome
    let prefix = home <> "/.local/share/fluentci/uv-environments/" <> installed.version <> "/" <> if config.pythonVersion == "" then "default" else config.pythonVersion
        pythonBin = prefix <> "/python-bin"
        toolBin = prefix <> "/tool-bin"
        uv = installed.binDir <> "/uv"
        environment = Object.insert "UV_TOOL_DIR" (prefix <> "/tools")
          (Object.insert "UV_TOOL_BIN_DIR" toolBin (Object.insert "UV_PYTHON_INSTALL_DIR" (prefix <> "/python")
            (Object.insert "UV_PYTHON_BIN_DIR" pythonBin installed.environment)))
        capture = H.captureWith environment false
        bsdFlags = if Types.isBSD host.os then [ "--no-python-downloads" ] else []
    selected <- if config.pythonVersion == "" then pure environment else do
      H.run [ "mkdir", "-p", pythonBin ]
      unless (Types.isBSD host.os) $ void (capture [ uv, "python", "install", "--", config.pythonVersion ])
      python <- trim <$> capture ([ uv, "python", "find" ] <> (if Types.isBSD host.os then bsdFlags else [ "--managed-python" ]) <> [ "--", config.pythonVersion ])
      unless (Types.validDirectory python) $ throw "uv returned an invalid Python executable path"
      H.run [ "test", "-x", python ]
      void (capture [ python, "--version" ] >>= H.versionFrom "python")
      H.run [ "ln", "-sf", python, pythonBin <> "/python" ]
      H.run [ "ln", "-sf", python, pythonBin <> "/python3" ]
      pure (Object.insert "UV_PYTHON" python environment)
    let execute = H.captureWith selected false
    traverse_ (\tool -> void (execute ([ uv, "tool", "install", "--force" ] <> bsdFlags
      <> (if config.pythonVersion == "" then [] else [ "--python", fromMaybe "" (Object.lookup "UV_PYTHON" selected) ]) <> [ "--", tool ]))) config.tools
    let paths = (if Array.null config.tools then [] else [ toolBin ]) <> (if config.pythonVersion == "" then [] else [ pythonBin ])
        path = String.joinWith ":" paths <> ":" <> fromMaybe "" (Object.lookup "PATH" installed.environment)
    pure (installed { environment = Object.insert "PATH" path selected })
  H.activate prepared
  pure prepared

setup :: Effect Unit
setup = do
  raw <- trim <$> (P.input >>= H.unwrap)
  config <- if raw == "" then pure defaultConfig
    else if String.startsWith (Pattern "{") raw then either throw pure (jsonParser raw >>= decodeConfig)
    else pure (defaultConfig { base = (Types.defaults "uv") { version = raw } })
  result <- setupWith config
  P.output (stringify (encodeJson result)) >>= H.unwrap
