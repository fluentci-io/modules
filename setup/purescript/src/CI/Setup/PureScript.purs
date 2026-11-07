module CI.Setup.PureScript (Config, Toolchain, defaultConfig, decodeConfig, setupWith, setup) where

import Prelude
import CI.Setup as Setup
import CI.Setup.BSD as BSD
import CI.Setup.Host as H
import CI.Setup.Types as Types
import Data.Argonaut.Core (Json, isNull, stringify)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, getFieldOptional)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Parser (jsonParser)
import Data.Array as Array
import Data.Either (Either(..), either)
import Data.Foldable (traverse_)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as String
import Data.String.CodeUnits as CU
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..))
import Effect (Effect)
import Effect.Exception (throw)
import FluentCI.Plugin as P
import Foreign.Object as Object

type Config =
  { version :: String, nodeVersion :: String, bunVersion :: String
  , spagoVersion :: String, npmVersion :: String, installDir :: String
  , sudo :: Boolean, packageName :: String, nodePackageName :: String, bunPackageName :: String
  }

type Toolchain =
  { tool :: String, version :: String, binDir :: String, environment :: Object.Object String
  , nodeVersion :: String, bunVersion :: String, spagoVersion :: String, npmVersion :: String
  }

defaultConfig :: Config
defaultConfig =
  { version: "latest", nodeVersion: "lts", bunVersion: "latest", spagoVersion: "latest"
  , npmVersion: "10.9.2", installDir: "", sudo: false, packageName: "", nodePackageName: "", bunPackageName: ""
  }

optional :: forall a. DecodeJson a => Object.Object Json -> String -> a -> Either String a
optional object key fallback = either (Left <<< show) (Right <<< fromMaybe fallback) (getFieldOptional object key)

decodeConfig :: Json -> Either String Config
decodeConfig json = do
  object <- either (Left <<< show) pure (decodeJson json)
  let allowed = [ "version", "nodeVersion", "bunVersion", "spagoVersion", "npmVersion", "installDir", "sudo", "packageName", "nodePackageName", "bunPackageName" ]
  when (Array.any isNull (Object.values object)) $ Left "Toolchain arguments cannot be null"
  case Array.find (\key -> not (Array.elem key allowed)) (Object.keys object) of
    Just key -> Left ("Unknown PureScript setup argument: " <> key)
    Nothing -> pure unit
  version <- optional object "version" defaultConfig.version
  nodeVersion <- optional object "nodeVersion" defaultConfig.nodeVersion
  bunVersion <- optional object "bunVersion" defaultConfig.bunVersion
  spagoVersion <- optional object "spagoVersion" defaultConfig.spagoVersion
  npmVersion <- optional object "npmVersion" defaultConfig.npmVersion
  installDir <- optional object "installDir" defaultConfig.installDir
  sudo <- optional object "sudo" defaultConfig.sudo
  packageName <- optional object "packageName" defaultConfig.packageName
  nodePackageName <- optional object "nodePackageName" defaultConfig.nodePackageName
  bunPackageName <- optional object "bunPackageName" defaultConfig.bunPackageName
  pure { version, nodeVersion, bunVersion, spagoVersion, npmVersion, installDir, sudo, packageName, nodePackageName, bunPackageName }

setupWith :: Config -> Effect Toolchain
setupWith config = do
  traverse_ (\version -> unless (Types.versionToken version) (throw "Invalid toolchain version token"))
    [ config.version, config.nodeVersion, config.bunVersion, config.spagoVersion, config.npmVersion ]
  let npmParts = String.split (Pattern ".") config.npmVersion
  unless (Array.length npmParts == 3 && Array.all (\part -> CU.length part > 0
    && Array.all (\c -> c >= '0' && c <= '9') (CU.toCharArray part)) npmParts) $ throw "npmVersion must be an exact numeric release"
  traverse_ (\packageName -> either throw pure (Types.validateConfig "purescript"
    ((Types.defaults "node") { version = config.version, installDir = config.installDir, packageName = packageName })))
    [ config.packageName, config.nodePackageName, config.bunPackageName ]
  host <- H.host
  either throw pure (Types.hostSupported "node" host)
  let bsd = Types.isBSD host.os
  unless (bsd || (not config.sudo && Array.all (_ == "") [ config.packageName, config.nodePackageName, config.bunPackageName ])) $
    throw "sudo and package selectors apply only to native BSD packages"
  H.requireTools [ "curl", "tar", "mktemp", "mkdir", "rm" ]
  node <- Setup.install "node" ((Types.defaults "node")
    { version = config.nodeVersion, sudo = config.sudo, packageName = config.nodePackageName })
  bun <- Setup.install "bun" ((Types.defaults "bun")
    { version = config.bunVersion, sudo = config.sudo, packageName = config.bunPackageName })
  home <- if config.installDir == "" then H.userHome else pure ""
  let prefix = if config.installDir == "" then home <> "/.local/share/fluentci/purescript/" <> config.version
        else Types.cleanDirectory config.installDir
      binDir = prefix <> "/node_modules/.bin"
  native <- if bsd then do
    compiler <- BSD.install "purescript" host ((Types.defaults "purescript")
      { version = config.version, sudo = config.sudo, packageName = config.packageName })
    H.activate compiler
    pure (Just compiler)
    else pure Nothing
  H.run [ "mkdir", "-p", prefix ]
  -- Bootstrap npm as portable JavaScript, including on BSD where Node packages
  -- may not include npm. Keep npm installed alongside purs and Spago afterwards.
  H.withTemp \temp -> do
    H.download ("https://registry.npmjs.org/npm/-/npm-" <> config.npmVersion <> ".tgz") (temp <> "/npm.tgz")
    H.run [ "tar", "-xzf", temp <> "/npm.tgz", "-C", temp ]
    H.run ([ node.binDir <> "/node", temp <> "/package/bin/npm-cli.js", "install", "--prefix", prefix
      , "--no-audit", "--no-fund", "--save-exact", "npm@" <> config.npmVersion, "spago@" <> config.spagoVersion ]
      <> if bsd then [] else [ "purescript@" <> config.version ])
  version <- case native of
    Just compiler -> pure compiler.version
    Nothing -> H.verify "purescript" config.version (binDir <> "/purs")
  spagoVersion <- H.verify "spago" config.spagoVersion (binDir <> "/spago")
  npmVersion <- H.verify "npm" config.npmVersion (binDir <> "/npm")
  result <- H.result "purescript" version binDir Object.empty
  H.activate result
  pure { tool: result.tool, version, binDir, environment: result.environment
    , nodeVersion: node.version, bunVersion: bun.version, spagoVersion, npmVersion }

setup :: Effect Unit
setup = do
  raw <- trim <$> (P.input >>= H.unwrap)
  config <- if raw == "" then pure defaultConfig
    else if String.startsWith (Pattern "{") raw then either throw pure (jsonParser raw >>= decodeConfig)
    else pure (defaultConfig { version = raw })
  result <- setupWith config
  P.output (stringify (encodeJson result)) >>= H.unwrap
