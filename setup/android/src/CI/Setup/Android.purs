module CI.Setup.Android (Config, Result, defaultConfig, decodeConfig, setupWith, setup) where

import Prelude
import CI.Contract as Contract
import CI.Setup.Host as H
import CI.Setup.Types as Types
import Data.Argonaut.Core (Json, isNull, stringify)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, getFieldOptional)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Parser (jsonParser)
import Data.Array as Array
import Data.Either (Either(..), either)
import Data.Foldable (foldl, traverse_)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as String
import Data.String.Common (trim)
import Data.String.CodeUnits as CU
import Data.String.Pattern (Pattern(..))
import Data.String.Regex as Regex
import Data.String.Regex.Flags (noFlags)
import Effect (Effect)
import Effect.Exception (throw, try, throwException)
import FluentCI.Plugin as P
import Foreign.Object as Object

-- Native typed component import, composed from the declared setup-java dependency.
foreign import setupJava :: String -> Effect Contract.SetupResult

type Config =
  { version :: String, javaVersion :: String, sdkRoot :: String
  , packages :: String, apiLevels :: String, buildToolsVersions :: String
  , ndkVersions :: String, cmakeVersions :: String, systemImages :: String
  , packageFile :: String, channel :: Int, acceptLicenses :: Boolean
  , proxyType :: String, proxyHost :: String, proxyPort :: Int
  , sdkManagerArgs :: String, archiveUrl :: String, archiveSha256 :: String
  }
type Result = { tool :: String, version :: String, binDir :: String, environment :: Object.Object String, sdkRoot :: String, javaVersion :: String, commandLineToolsBuild :: String }

defaultConfig :: Config
defaultConfig =
  { version: "15859902", javaVersion: "21", sdkRoot: "", packages: "platform-tools"
  , apiLevels: "", buildToolsVersions: "", ndkVersions: "", cmakeVersions: "", systemImages: ""
  , packageFile: "", channel: 0, acceptLicenses: true, proxyType: "", proxyHost: "", proxyPort: 0
  , sdkManagerArgs: "", archiveUrl: "", archiveSha256: "" }

optional :: forall a. DecodeJson a => Object.Object Json -> String -> a -> Either String a
optional object key fallback = either (Left <<< show) (Right <<< fromMaybe fallback) (getFieldOptional object key)

decodeConfig :: Json -> Either String Config
decodeConfig json = do
  object <- either (Left <<< show) pure (decodeJson json)
  when (Array.any isNull (Object.values object)) $ Left "Android setup arguments cannot be null"
  let allowed = [ "version", "javaVersion", "sdkRoot", "packages", "apiLevels", "buildToolsVersions", "ndkVersions", "cmakeVersions", "systemImages", "packageFile", "channel", "acceptLicenses", "proxyType", "proxyHost", "proxyPort", "sdkManagerArgs", "archiveUrl", "archiveSha256" ]
  case Array.find (\key -> not (Array.elem key allowed)) (Object.keys object) of
    Just key -> Left ("Unknown Android setup argument: " <> key)
    Nothing -> pure unit
  version <- optional object "version" defaultConfig.version
  javaVersion <- optional object "javaVersion" defaultConfig.javaVersion
  sdkRoot <- optional object "sdkRoot" defaultConfig.sdkRoot
  packages <- optional object "packages" defaultConfig.packages
  apiLevels <- optional object "apiLevels" ""
  buildToolsVersions <- optional object "buildToolsVersions" ""
  ndkVersions <- optional object "ndkVersions" ""
  cmakeVersions <- optional object "cmakeVersions" ""
  systemImages <- optional object "systemImages" ""
  packageFile <- optional object "packageFile" ""
  channel <- optional object "channel" 0
  acceptLicenses <- optional object "acceptLicenses" true
  proxyType <- optional object "proxyType" ""
  proxyHost <- optional object "proxyHost" ""
  proxyPort <- optional object "proxyPort" 0
  sdkManagerArgs <- optional object "sdkManagerArgs" ""
  archiveUrl <- optional object "archiveUrl" ""
  archiveSha256 <- optional object "archiveSha256" ""
  pure { version, javaVersion, sdkRoot, packages, apiLevels, buildToolsVersions, ndkVersions, cmakeVersions, systemImages, packageFile, channel, acceptLicenses, proxyType, proxyHost, proxyPort, sdkManagerArgs, archiveUrl, archiveSha256 }

matches :: String -> String -> Either String Boolean
matches pattern value = flip Regex.test value <$> Regex.regex pattern noFlags

validText :: String -> Boolean
validText value = trim value /= "" && not (Array.any (\char -> char < ' ' || char == '\x007f') (CU.toCharArray value))

validate :: Config -> Either String Unit
validate config = do
  unless (Types.versionToken config.version && Types.versionToken config.javaVersion) $ Left "Invalid command-line tools build or Java version"
  unless (config.sdkRoot == "" || Types.validDirectory config.sdkRoot) $ Left "sdkRoot must be an absolute directory other than / without traversal or control characters"
  unless (config.channel >= 0 && config.channel <= 3) $ Left "channel must be 0, 1, 2, or 3"
  unless (config.packageFile == "" || Types.validProject config.packageFile) $ Left "Invalid package file path"
  path <- Regex.regex "^[A-Za-z0-9][A-Za-z0-9._-]*(;[A-Za-z0-9][A-Za-z0-9._-]*)*$" noFlags
  traverse_ (\value -> unless (Regex.test path value) (Left "Malformed Android SDK package ID or empty package entry"))
    (Types.commaSeparated config.packages <> Types.commaSeparated config.systemImages)
  revision <- Regex.regex "^[A-Za-z0-9][A-Za-z0-9._-]*$" noFlags
  traverse_ (\value -> unless (Regex.test revision value) (Left "Invalid SDK version list or empty entry"))
    (Types.commaSeparated config.apiLevels <> Types.commaSeparated config.buildToolsVersions <> Types.commaSeparated config.ndkVersions <> Types.commaSeparated config.cmakeVersions)
  let reserved = [ "--sdk_root", "--version", "--help", "--list", "--list_installed", "--licenses", "--uninstall", "--update", "--package_file" ]
  traverse_ (\value -> do
    unless (validText value) $ Left "sdkManagerArgs entries must be nonempty literal tokens without control characters"
    let option = fromMaybe value (Array.head (String.split (Pattern "=") value))
    when (Array.elem option reserved) $ Left "Use named arguments for SDK root/package files; extra arguments cannot change the sdkmanager operation") (Types.commaSeparated config.sdkManagerArgs)
  unless (Array.elem config.proxyType [ "", "http", "socks" ] && config.proxyPort >= 0 && config.proxyPort <= 65535) $ Left "Invalid SDK proxy type or port"
  host <- matches "^[A-Za-z0-9._:-]+$" config.proxyHost
  unless ((config.proxyType == "" && config.proxyHost == "" && config.proxyPort == 0) || (config.proxyType /= "" && host && config.proxyPort > 0)) $ Left "Set proxyType, proxyHost, and proxyPort together"
  sha <- matches "^[a-f0-9]{64}$" config.archiveSha256
  unless (config.archiveUrl == "" && config.archiveSha256 == "" && config.version == defaultConfig.version
    || (String.startsWith (Pattern "https://") config.archiveUrl && validText config.archiveUrl && sha)) $
    Left "Archive overrides or nondefault builds require an HTTPS archiveUrl and its SHA-256 checksum"

archive :: Types.Host -> { url :: String, sha256 :: String }
archive host =
  { url: "https://dl.google.com/android/repository/commandlinetools-" <> file <> "-15859902_latest.zip", sha256 }
  where
  file = if host.os == "linux" then "linux" else if host.arch == "aarch64" then "mac_arm64" else "mac_x86_64"
  sha256 = if host.os == "linux" then "4e4c464f145a7512b57d088ac6c278c03c9eea610886b35a5e0804e74eedf583"
    else if host.arch == "aarch64" then "835b62a26162b229b441d1f6d4680383815a270809eb33522c0d480fa5002c4e"
    else "c5a6378ab5cf7e0d5701921405115befff13e9ff7417fb588389338f8bd050f3"

sdkVersion :: Object.Object String -> String -> Effect String
sdkVersion environment executable = do
  H.run [ "test", "-x", executable ]
  output <- H.captureWith environment false [ executable, "--version" ]
  let version = fromMaybe "" (Array.last (Array.filter (_ /= "") (map trim (String.split (Pattern "\n") output))))
  valid <- either throw pure (matches "^[0-9]+([.][0-9]+)*[A-Za-z0-9.+_-]*$" version)
  unless valid $ throw "sdkmanager did not report a valid command-line tools version"
  pure version

installArchive :: Object.Object String -> String -> { url :: String, sha256 :: String } -> Effect String
installArchive environment root release = do
  let destination = root <> "/cmdline-tools/latest"
      executable = destination <> "/bin/sdkmanager"
      marker = destination <> "/.fluentci-archive-sha256"
  existing <- H.exists destination
  if existing then do
    marked <- H.exists marker
    unless marked $ throw "Existing cmdline-tools/latest is unmanaged; choose a different sdkRoot"
    previous <- trim <$> H.capture [ "cat", marker ]
    unless (previous == release.sha256) $ throw "Existing SDK bootstrap archive differs; choose a separate sdkRoot for this command-line tools build"
    sdkVersion environment executable
  else do
    H.run [ "mkdir", "-p", root <> "/cmdline-tools" ]
    H.run [ "mkdir", destination ]
    outcome <- try (H.withTemp \temp -> do
      H.download release.url (temp <> "/tools.zip")
      actual <- P.sha256 (P.file (temp <> "/tools.zip")) >>= H.unwrap
      unless (trim actual == release.sha256) $ throw "Android command-line tools SHA-256 mismatch"
      H.run [ "unzip", "-q", temp <> "/tools.zip", "-d", temp ]
      H.run [ "test", "-f", temp <> "/cmdline-tools/source.properties" ]
      H.run [ "test", "-f", temp <> "/cmdline-tools/bin/sdkmanager" ]
      H.run [ "cp", "-R", temp <> "/cmdline-tools/.", destination ]
      version <- sdkVersion environment executable
      H.run [ "sh", "-c", "printf '%s' \"$2\" > \"$1\"", "fluentci-sdk-marker", marker, release.sha256 ]
      pure version)
    case outcome of
      Right version -> pure version
      Left error -> do
        H.run [ "rm", "-rf", "--", destination ]
        throwException error

setupWith :: Config -> Effect Result
setupWith config = do
  either throw pure (validate config)
  host <- H.host
  unless (Array.elem host.os [ "linux", "macos" ]) $
    throw ("Unsupported Android SDK OS: " <> host.os <> ". Supported OS: linux, macos")
  unless ((host.os == "linux" && host.arch == "x86_64") || (host.os == "macos" && Array.elem host.arch [ "x86_64", "aarch64" ])) $
    throw ("Unsupported Android SDK architecture: " <> host.os <> "/" <> host.arch <> ". Supported: linux/x86_64, macos/x86_64, macos/aarch64")
  filePackages <- if config.packageFile == "" then pure [] else do
    H.run [ "test", "-f", config.packageFile ]
    contents <- H.capture [ "cat", config.packageFile ]
    let entries = Array.filter (_ /= "") (map trim (String.split (Pattern "\n") contents))
    path <- either throw pure (Regex.regex "^[A-Za-z0-9][A-Za-z0-9._-]*(;[A-Za-z0-9][A-Za-z0-9._-]*)*$" noFlags)
    traverse_ (\value -> unless (Regex.test path value) (throw "Malformed SDK package ID in packageFile")) entries
    pure entries
  H.requireTools ([ "curl", "unzip", "mkdir", "cp", "rm", "cat", "sh", "mktemp", "test" ] <> if config.acceptLicenses then [ "bash", "yes" ] else [])
  java <- setupJava config.javaVersion
  let javaEnvironment = foldl (\env entry -> Object.insert entry.name entry.value env) Object.empty java.environment
  javaHome <- case Object.lookup "JAVA_HOME" javaEnvironment of
    Just value | Types.validDirectory value -> pure value
    _ -> throw "setup-java did not return an absolute JAVA_HOME"
  H.run [ "test", "-x", javaHome <> "/bin/java" ]
  home <- if config.sdkRoot == "" then H.userHome else pure ""
  let root = if config.sdkRoot == "" then home <> "/.local/share/fluentci/android-sdk/" <> config.version else Types.cleanDirectory config.sdkRoot
      environment = Object.insert "ANDROID_HOME" root (Object.insert "ANDROID_SDK_ROOT" root javaEnvironment)
      release = if config.archiveUrl == "" then archive host else { url: config.archiveUrl, sha256: config.archiveSha256 }
      executable = root <> "/cmdline-tools/latest/bin/sdkmanager"
  void (installArchive environment root release)
  let options = [ "--sdk_root=" <> root, "--channel=" <> show config.channel ]
        <> (if config.proxyType == "" then [] else [ "--proxy=" <> config.proxyType, "--proxy_host=" <> config.proxyHost, "--proxy_port=" <> show config.proxyPort ])
        <> Types.commaSeparated config.sdkManagerArgs
      execute args = void (H.captureWith environment false
        (if config.acceptLicenses then [ "bash", "-c", "set +o pipefail; yes | \"$@\"", "fluentci-sdk-input", executable ] <> args
         else [ "sh", "-c", "exec \"$@\" < /dev/null", "fluentci-sdk-input", executable ] <> args))
      packages = Array.nub (Types.commaSeparated config.packages
        <> map ("platforms;android-" <> _) (Types.commaSeparated config.apiLevels)
        <> map ("build-tools;" <> _) (Types.commaSeparated config.buildToolsVersions)
        <> map ("ndk;" <> _) (Types.commaSeparated config.ndkVersions)
        <> map ("cmake;" <> _) (Types.commaSeparated config.cmakeVersions)
        <> Types.commaSeparated config.systemImages <> filePackages)
  when config.acceptLicenses $ execute ([ "--licenses" ] <> options)
  unless (Array.null packages && config.packageFile == "") $
    execute ([ "--install" ] <> options <> packages)
  unless (Array.null packages && Array.null filePackages) $ do
    output <- H.captureWith environment false ([ executable, "--list_installed", "--sdk_root=" <> root ]
      <> (if config.proxyType == "" then [] else [ "--proxy=" <> config.proxyType, "--proxy_host=" <> config.proxyHost, "--proxy_port=" <> show config.proxyPort ]))
    let installed = map (trim <<< fromMaybe "" <<< Array.head <<< String.split (Pattern "|")) (String.split (Pattern "\n") output)
    traverse_ (\package -> unless (Array.elem package installed) (throw ("SDK package missing after installation (check licenses and repository availability): " <> package))) (Array.nub (packages <> filePackages))
  finalVersion <- sdkVersion environment executable
  let bins = [ root <> "/cmdline-tools/latest/bin", root <> "/platform-tools", root <> "/emulator" ]
        <> map (\value -> root <> "/build-tools/" <> value) (Types.commaSeparated config.buildToolsVersions)
        <> map (\value -> root <> "/cmake/" <> value <> "/bin") (Types.commaSeparated config.cmakeVersions)
      path = String.joinWith ":" bins <> ":" <> fromMaybe "" (Object.lookup "PATH" javaEnvironment)
      ndk = Array.head (Types.commaSeparated config.ndkVersions)
      configured = case ndk of
        Just value -> Object.insert "ANDROID_NDK_HOME" (root <> "/ndk/" <> value) environment
        Nothing -> environment
      prepared = { tool: "android", version: finalVersion, binDir: root <> "/cmdline-tools/latest/bin", environment: Object.insert "PATH" path configured }
  H.activate prepared
  pure { tool: prepared.tool, version: finalVersion, binDir: prepared.binDir, environment: prepared.environment, sdkRoot: root, javaVersion: java.version, commandLineToolsBuild: config.version }

setup :: Effect Unit
setup = do
  raw <- trim <$> (P.input >>= H.unwrap)
  config <- if raw == "" then pure defaultConfig else either throw pure (jsonParser raw >>= decodeConfig)
  result <- setupWith config
  P.output (stringify (encodeJson result)) >>= H.unwrap
