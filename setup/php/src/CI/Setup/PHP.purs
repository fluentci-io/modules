module CI.Setup.PHP (Config, defaultConfig, decodeConfig, setupWith, setup) where

import Prelude
import CI.Setup.BSD as BSD
import CI.Setup.Host as H
import CI.Setup.Tools as Tools
import CI.Setup.Types as Types
import Data.Argonaut.Core (Json, isNull, stringify)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, getFieldOptional)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Parser (jsonParser)
import Data.Array as Array
import Data.Either (Either(..), either)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as String
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..), Replacement(..))
import Data.String.Regex as Regex
import Data.String.Regex.Flags (noFlags)
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Exception (throw)
import FluentCI.Plugin as P
import Foreign.Object as Object

type Config = { version :: String, tools :: String, installDir :: String, miseVersion :: String, packageName :: String, sudo :: Boolean }
type Tool = { name :: String, package :: String, executable :: String, version :: String }

defaultConfig :: Config
defaultConfig = { version: "latest", tools: "composer", installDir: "", miseVersion: "latest", packageName: "", sudo: false }

optional :: forall a. DecodeJson a => Object.Object Json -> String -> a -> Either String a
optional object key fallback = either (Left <<< show) (Right <<< fromMaybe fallback) (getFieldOptional object key)

matches :: String -> String -> Either String Boolean
matches pattern value = flip Regex.test value <$> Regex.regex pattern noFlags

normalize :: String -> String
normalize value = if value == "stable" then "latest" else fromMaybe value (String.stripPrefix (Pattern "v") value)

decodeConfig :: Json -> Either String Config
decodeConfig json = do
  object <- either (Left <<< show) pure (decodeJson json)
  when (Array.any isNull (Object.values object)) $ Left "PHP setup arguments cannot be null"
  let allowed = [ "version", "tools", "installDir", "miseVersion", "packageName", "sudo" ]
  case Array.find (\key -> not (Array.elem key allowed)) (Object.keys object) of
    Just key -> Left ("Unknown PHP setup argument: " <> key)
    Nothing -> pure unit
  version <- optional object "version" defaultConfig.version
  tools <- optional object "tools" defaultConfig.tools
  installDir <- optional object "installDir" defaultConfig.installDir
  miseVersion <- optional object "miseVersion" defaultConfig.miseVersion
  packageName <- optional object "packageName" defaultConfig.packageName
  sudo <- optional object "sudo" defaultConfig.sudo
  pure { version, tools, installDir, miseVersion, packageName, sudo }

parseTool :: String -> Either String Tool
parseTool input = do
  let parts = String.split (Pattern ":") input
      name = fromMaybe "" (Array.head parts)
      version = fromMaybe "latest" (Array.index parts 1)
  unless (Array.length parts <= 2 && version /= "") $ Left "Tools use name:version selectors"
  validVersion <- matches "^[A-Za-z0-9*^~][A-Za-z0-9.*+^~_-]*$" version
  unless validVersion $ Left "Invalid PHP tool version selector"
  package <- case name of
    "composer" -> pure ""
    "phpunit" -> pure "phpunit/phpunit"
    "phpstan" -> pure "phpstan/phpstan"
    "psalm" -> pure "vimeo/psalm"
    "php-cs-fixer" -> pure "friendsofphp/php-cs-fixer"
    "phpcs" -> pure "squizlabs/php_codesniffer"
    "phpcbf" -> pure "squizlabs/php_codesniffer"
    "pest" -> pure "pestphp/pest"
    "rector" -> pure "rector/rector"
    "infection" -> pure "infection/infection"
    "deployer" -> pure "deployer/deployer"
    "behat" -> pure "behat/behat"
    "phpspec" -> pure "phpspec/phpspec"
    "phpmd" -> pure "phpmd/phpmd"
    "pint" -> pure "laravel/pint"
    "parallel-lint" -> pure "php-parallel-lint/php-parallel-lint"
    _ -> do
      valid <- matches "^[a-z0-9][a-z0-9_.-]*/[a-z0-9][a-z0-9_.-]*$" name
      unless valid $ Left ("Unknown PHP tool: " <> name <> "; use a supported alias or vendor/package:version")
      pure name
  when (name == "composer") $ do
    valid <- matches "^(latest|1|2|2\\.2|[0-9]+\\.[0-9]+\\.[0-9]+([A-Za-z0-9.+_-]*))$" version
    unless valid $ Left "Composer accepts latest, 1, 2, 2.2, or an exact release"
  let executable = if name == "deployer" then "dep" else fromMaybe name (Array.last (String.split (Pattern "/") name))
  pure { name, package, executable, version }

parseTools :: String -> Either String (Array Tool)
parseTools text
  | trim text == "" || trim text == "none" = Right []
  | otherwise = do
      tools <- traverse (parseTool <<< trim) (String.split (Pattern ",") text)
      unless (Array.length (Array.nub (map _.executable tools)) == Array.length tools) $ Left "Duplicate PHP tool executable"
      pure tools

verifyPHP :: Object.Object String -> String -> String -> Effect String
verifyPHP environment expected executable = do
  H.run [ "test", "-x", executable ]
  actual <- trim <$> H.captureWith environment false [ executable, "-r", "echo PHP_VERSION;" ]
  valid <- either throw pure (matches "^[0-9]+\\.[0-9]+\\.[0-9]+[A-Za-z0-9.+_-]*$" actual)
  unless (valid && (expected == "latest" || actual == expected || String.startsWith (Pattern (expected <> ".")) actual)) $
    throw ("Installed PHP version mismatch: requested " <> expected <> ", got " <> actual)
  pure actual

composer :: Object.Object String -> String -> String -> String -> Effect String
composer environment php prefix requested = do
  H.requireTools [ "curl", "mktemp", "rm" ]
  let bin = prefix <> "/composer/bin"
  H.run [ "mkdir", "-p", bin ]
  H.withTemp \temp -> do
    let installer = temp <> "/composer-setup.php"
    H.download "https://getcomposer.org/installer" installer
    expected <- trim <$> H.fetch "https://composer.github.io/installer.sig"
    valid <- either throw pure (matches "^[a-fA-F0-9]{96}$" expected)
    unless valid $ throw "Invalid Composer installer SHA-384 signature"
    actual <- trim <$> H.captureWith environment false [ php, "-r", "echo hash_file('sha384', $argv[1]);", installer ]
    unless (actual == expected) $ throw "Composer installer SHA-384 mismatch"
    legacy <- trim <$> H.captureWith environment false [ php, "-r", "echo version_compare(PHP_VERSION, '7.2.5', '<') ? 'yes' : 'no';" ]
    let selected = if requested == "latest" then if legacy == "yes" then "2.2" else "2" else requested
        selector = if Array.elem selected [ "1", "2", "2.2" ] then [ "--" <> selected ] else [ "--version=" <> selected ]
    H.runWith environment ([ php, installer, "--install-dir=" <> bin, "--filename=composer", "--quiet" ] <> selector)
    reported <- H.captureWith environment false [ php, bin <> "/composer", "--version", "--no-ansi" ]
    version <- H.versionFrom "composer" reported
    unless (requested == "latest" || version == selected || String.startsWith (Pattern (selected <> ".")) version) $
      throw "Installed Composer version mismatch"
  pure bin

setupWith :: Config -> Effect Types.Result
setupWith config = do
  let requested = normalize config.version
  valid <- either throw pure (matches "^(latest|[0-9]+(\\.[0-9]+){0,2}([A-Za-z][A-Za-z0-9.-]*)?)$" requested)
  unless valid $ throw "PHP version must be latest, stable, a major/minor prefix, or an exact upstream release"
  unless (Types.versionToken config.miseVersion) $ throw "Invalid mise version"
  tools <- either throw pure (parseTools config.tools)
  either throw pure (Types.validateConfig "node" ((Types.defaults "node") { version = requested, installDir = config.installDir, packageName = config.packageName }))
  host <- H.host
  either throw pure (Types.hostSupported "node" host)
  let bsd = Types.isBSD host.os
  unless (bsd || (not config.sudo && config.packageName == "")) $ throw "sudo and packageName apply only to native BSD PHP packages"
  when (bsd && config.installDir /= "") $ throw "Native BSD PHP packages use the system prefix; omit installDir"
  H.requireTools [ "mkdir", "sh", "env", "test" ]
  home <- H.userHome
  let prefix = if config.installDir == "" then home <> "/.local/share/fluentci/php/" <> requested else Types.cleanDirectory config.installDir
      scoped = Object.insert "MISE_DATA_DIR" (prefix <> "/mise")
        (Object.insert "MISE_CONFIG_DIR" (prefix <> "/mise-config") (Object.singleton "MISE_CACHE_DIR" (prefix <> "/mise-cache")))
  installed <- if bsd then BSD.install "php" host ((Types.defaults "node") { version = requested, sudo = config.sudo, packageName = config.packageName })
    else do
      -- Install the manager without publishing its environment before PHP succeeds.
      manager <- Tools.install "mise" host ((Types.defaults "node") { version = config.miseVersion })
      H.requireTools [ "git", "curl", "make", "cc", "autoconf", "bison", "re2c", "pkg-config" ]
      H.run [ "mkdir", "-p", prefix ]
      let environment = Object.union scoped manager.environment
          mise = manager.binDir <> "/mise"
          selector = "vfox:jdx/vfox-php@" <> requested
          capture args = H.captureWith environment false ([ "sh", "-c", "cd \"$1\" && shift && exec \"$@\"", "fluentci-php", prefix, mise ] <> args)
      resolved <- trim <$> capture [ "latest", selector ]
      release <- either throw pure (matches "^[0-9]+\\.[0-9]+\\.[0-9]+[A-Za-z0-9.+_-]*$" resolved)
      unless release $ throw "PHP backend did not resolve an exact release"
      let exact = "vfox:jdx/vfox-php@" <> resolved
      void (capture [ "--yes", "install", "--", exact ])
      location <- trim <$> capture [ "where", exact ]
      unless (Types.validDirectory location) $ throw "PHP backend returned an invalid installation directory"
      json <- capture [ "env", "--json", "--", exact ] >>= H.json
      runtime <- either (throw <<< show) pure (decodeJson json :: Either _ (Object.Object String))
      version <- verifyPHP runtime resolved (location <> "/bin/php")
      H.result "php" version (location <> "/bin") runtime
  let php = installed.binDir <> "/php"
  version <- verifyPHP installed.environment requested php
  prepared <- if Array.null tools then pure installed else do
    let wantedComposer = fromMaybe "latest" (map _.version (Array.find (\tool -> tool.name == "composer") tools))
        environment = Object.insert "COMPOSER" "composer.json" (Object.insert "COMPOSER_HOME" (prefix <> "/composer/home")
          (Object.insert "COMPOSER_CACHE_DIR" (prefix <> "/composer/cache") installed.environment))
    bin <- composer environment php prefix wantedComposer
    bins <- traverse (\tool -> if tool.name == "composer" then pure bin else do
      let directory = prefix <> "/tools/" <> String.replaceAll (Pattern "/") (Replacement "-") tool.name
          executable = directory <> "/vendor/bin/" <> tool.executable
          constraint = if tool.version == "latest" then "*" else tool.version
          toolEnvironment = Object.insert "COMPOSER_VENDOR_DIR" (directory <> "/vendor")
            (Object.insert "COMPOSER_BIN_DIR" (directory <> "/vendor/bin") environment)
      H.run [ "mkdir", "-p", directory ]
      H.runWith toolEnvironment [ php, bin <> "/composer", "--no-interaction", "--no-plugins", "--working-dir=" <> directory, "require", "--no-scripts", "--prefer-dist", "--no-progress", "--", tool.package <> ":" <> constraint ]
      H.run [ "test", "-f", executable ]
      H.run [ "test", "-x", executable ]
      void (H.captureWith environment false [ php, executable, "--version" ] >>= H.versionFrom tool.name)
      pure (directory <> "/vendor/bin")) tools
    pure (installed { environment = Object.insert "PATH" (String.joinWith ":" (Array.nub ([ bin ] <> bins)) <> ":" <> fromMaybe "" (Object.lookup "PATH" installed.environment)) environment })
  let result = prepared { tool = "php", version = version }
  H.activate result
  pure result

setup :: Effect Unit
setup = do
  raw <- trim <$> (P.input >>= H.unwrap)
  config <- if raw == "" then pure defaultConfig else either throw pure (jsonParser raw >>= decodeConfig)
  result <- setupWith config
  P.output (stringify (encodeJson result)) >>= H.unwrap
