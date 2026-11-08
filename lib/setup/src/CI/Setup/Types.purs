module CI.Setup.Types where

import Prelude
import CI.Setup.ToolCatalog as ToolCatalog
import Data.Argonaut.Core (Json, isNull)
import Data.Argonaut.Decode (decodeJson, getFieldOptional)
import Data.Array as Array
import Data.Either (Either(..), either)
import Data.Foldable (all, traverse_)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as String
import Data.String.CodeUnits as CU
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..))
import Foreign.Object as Object

-- Shared configuration is decoded against each tool's own allowed fields.
type Config =
  { cache :: String
  , packages :: Array String
  , project :: String
  , version :: String
  , toolchain :: String
  , components :: Array String
  , targets :: Array String
  , trustedUsers :: Array String
  , extraConf :: Array String
  , profile :: String
  , installDir :: String
  , packageName :: String
  , sudo :: Boolean
  , otpVersion :: String
  , daemon :: Boolean
  , init :: String
  , baseline :: Boolean
  , libc :: String
  , cliVersion :: String
  , jsVersion :: String
  , pythonVersion :: String
  , xtpVersion :: String
  , binaryenVersion :: String
  }

type Result = { tool :: String, version :: String, binDir :: String, environment :: Object.Object String }
type Host = { os :: String, arch :: String }

names :: Array String
names = [ "bun", "deno", "determinate-nix", "elixir", "gleam", "go", "java", "nix", "node", "pkl", "rust", "zig" ] <> ToolCatalog.names

isNix :: String -> Boolean
isNix name = name == "nix" || name == "determinate-nix" || name == "nix-package"

isBSD :: String -> Boolean
isBSD os = Array.elem os [ "freebsd", "openbsd", "netbsd" ]

normalizeOS :: String -> String
normalizeOS "darwin" = "macos"
normalizeOS os = os

normalizeArch :: String -> String
normalizeArch = case _ of
  "amd64" -> "x86_64"
  "x64" -> "x86_64"
  "arm64" -> "aarch64"
  value -> value

hostSupported :: String -> Host -> Either String Unit
hostSupported name host
  | not (Array.elem name names) = Left ("Unknown setup tool: " <> name)
  | not (Array.elem host.os [ "linux", "macos", "freebsd", "openbsd", "netbsd" ]) = Left ("Unsupported setup OS: " <> host.os)
  | isNix name && isBSD host.os = Left (name <> " supports Linux and macOS only")
  | not (isBSD host.os) && not (Array.elem host.arch [ "x86_64", "aarch64" ]) = Left ("No upstream installer configured for architecture: " <> host.arch)
  | otherwise = Right unit

defaults :: String -> Config
defaults name =
  { version: if name == "rust" then "stable" else if name == "java" then "21" else ToolCatalog.defaultVersion name
  , cache: "", packages: [], project: "."
  , trustedUsers: [], extraConf: []
  , toolchain: "", components: [], targets: [], profile: "minimal"
  , installDir: "", packageName: "", sudo: false, otpVersion: ""
  , daemon: true, init: "systemd", baseline: false, libc: "auto"
  , cliVersion: "", jsVersion: "latest", pythonVersion: "latest", xtpVersion: "latest", binaryenVersion: "latest"
  }

versionToken :: String -> Boolean
versionToken value = CU.length value > 0 && case CU.charAt 0 value of
  Just c | (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') -> valid
  _ -> false
  where
  valid = all (\c -> (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')
    || Array.elem c [ '.', '-', '_', '+' ]) (CU.toCharArray value)

cleanDirectory :: String -> String
cleanDirectory value
  | value == "/" = value
  | otherwise = case String.stripSuffix (Pattern "/") value of
      Just prefix -> cleanDirectory prefix
      Nothing -> value

validDirectory :: String -> Boolean
validDirectory raw =
  let value = cleanDirectory raw
  in String.startsWith (Pattern "/") value && value /= "/"
    && not (Array.elem ".." (String.split (Pattern "/") value))
    && all (\c -> not (Array.elem c [ ':', '\x0000', '\n', '\r' ])) (CU.toCharArray value)

validateConfig :: String -> Config -> Either String Unit
validateConfig name config = do
  when (name /= "cachix" && config.cache /= "") $ Left "cache requires setup-cachix"
  unless (config.cache == "" || validCache config.cache) $ Left "cache must be a lowercase DNS label of 1-63 letters, digits, or hyphens"
  when (not (Array.elem name [ "pkgx", "mise", "devbox", "flox", "macports", "macports-rs" ]) && not (Array.null config.packages)) $ Left "packages requires a supported package-manager setup module"
  traverse_ (\value -> unless (validPackageSelector value) (Left "packages must contain nonempty package selectors, optionally with versions, without whitespace, shell syntax, or leading options")) config.packages
  when (Array.elem name [ "macports", "macports-rs" ]) $ traverse_ (\value -> unless (validPortName value) (Left "MacPorts packages must be port names, such as git,cmake,python312; versions and variants are selected by the configured ports tree")) config.packages
  unless (validProject config.project) $ Left "project must be a nonempty directory without control characters"
  when (not (Array.elem name [ "devbox", "flox" ]) && config.project /= ".") $ Left "project requires setup-devbox or setup-flox"
  when (name /= "determinate-nix" && (not (Array.null config.trustedUsers) || not (Array.null config.extraConf))) $ Left "trustedUsers and extraConf require setup-determinate-nix"
  traverse_ (\value -> unless (value /= "" && value /= "*" && all (\c -> (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || Array.elem c [ '_', '-', '@', '.' ]) (CU.toCharArray value)) (Left "Invalid trusted Nix user or group")) config.trustedUsers
  traverse_ (\line -> unless (String.contains (Pattern "=") line && not (Array.any (\c -> Array.elem c [ '\n', '\r', '\x0000' ]) (CU.toCharArray line))) (Left "extraConf entries must be single-line Nix key=value settings")) config.extraConf

  unless (config.toolchain == "" || versionToken config.toolchain) $ Left "Invalid Rust toolchain"
  traverse_ (\value -> unless (versionToken value) (Left "Invalid Rust component or target")) (config.components <> config.targets)
  unless (Array.elem config.profile [ "minimal", "default", "complete" ]) $ Left "Rust profile must be minimal, default, or complete"
  when (name /= "rust" && (config.toolchain /= "" || not (Array.null config.components) || not (Array.null config.targets) || config.profile /= "minimal")) $ Left "Rust options only apply to setup-rust"
  traverse_ (\value -> unless (versionToken value) (Left "Invalid Extism component version")) [ config.jsVersion, config.pythonVersion, config.xtpVersion, config.binaryenVersion ]
  unless (config.cliVersion == "" || versionToken config.cliVersion) $ Left "Invalid Extism CLI version"
  unless (versionToken config.version) $ Left "version must be a nonempty release or channel token"
  traverse_ (\value -> unless (not (String.contains (Pattern "\x0000") value)
    && not (String.contains (Pattern "\n") value) && not (String.contains (Pattern "\r") value))
      (Left "Setup arguments cannot contain NUL or line breaks")) [ config.installDir, config.packageName, config.otpVersion ]
  unless (config.installDir == "" || validDirectory config.installDir) $
    Left "installDir must be an absolute directory other than /, without parent traversal, colons, or control characters"
  unless (config.packageName == "" || (not (String.startsWith (Pattern "-") config.packageName)
    && all (\c -> (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')
      || Array.elem c [ '.', '-', '_', '+', '%', '@' ]) (CU.toCharArray config.packageName))) $
    Left "packageName must be a native package name or selector, without paths or options"
  unless (config.otpVersion == "" || all (\c -> c >= '0' && c <= '9') (CU.toCharArray config.otpVersion)) $
    Left "otpVersion must be an Erlang/OTP major version"
  unless (Array.elem config.init [ "systemd", "none" ]) $ Left "init must be systemd or none"
  unless (Array.elem config.libc [ "auto", "gnu", "musl" ]) $ Left "libc must be auto, gnu, or musl"

validCache :: String -> Boolean
validCache value = CU.length value > 0 && CU.length value <= 63
  && not (String.startsWith (Pattern "-") value) && not (String.endsWith (Pattern "-") value)
  && all (\c -> (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || c == '-') (CU.toCharArray value)

validPortName :: String -> Boolean
validPortName value = case CU.charAt 0 value of
  Just c | (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') ->
    all (\x -> (x >= 'a' && x <= 'z') || (x >= 'A' && x <= 'Z') || (x >= '0' && x <= '9')
      || Array.elem x [ '.', '_', '+', '-' ]) (CU.toCharArray value)
  _ -> false

validPackageSelector :: String -> Boolean
validPackageSelector value = case CU.charAt 0 value of
  Just c | (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') ->
    all (\x -> (x >= 'a' && x <= 'z') || (x >= 'A' && x <= 'Z') || (x >= '0' && x <= '9')
      || Array.elem x [ '.', '_', '/', '+', '-', '@', ':', '=', '^', '~', '*', '<', '>', ',', '#', '%', '!' ]) (CU.toCharArray value)
      && not (String.endsWith (Pattern "@") value)
  _ -> false

validProject :: String -> Boolean
validProject value = Array.any (\c -> c /= ' ' && c /= '\t') (CU.toCharArray value)
  && all (\c -> c >= ' ' && c /= '\x007f') (CU.toCharArray value)

-- Reject unknown and null-valued fields instead of silently ignoring mistakes.
decodeConfig :: String -> Json -> Either String Config
decodeConfig name json = do
  fields <- either (Left <<< show) Right (decodeJson json)
  let allowed = [ "version", "installDir", "packageName", "sudo" ] <>
        (if name == "cachix" then [ "cache" ] else []) <>
        (if Array.elem name [ "pkgx", "mise", "devbox", "flox", "macports", "macports-rs" ] then [ "packages" ] else []) <>
        (if Array.elem name [ "devbox", "flox" ] then [ "project" ] else []) <>
        (if name == "rust" then [ "toolchain", "components", "targets", "profile" ] else []) <>
        (if name == "elixir" then [ "otpVersion" ] else []) <>
        (if name == "nix" then [ "daemon" ] else []) <>
        (if name == "determinate-nix" then [ "init", "trustedUsers", "extraConf" ] else []) <>
        (if name == "extism" then [ "cliVersion", "jsVersion", "pythonVersion", "xtpVersion", "binaryenVersion" ] else []) <>
        (if name == "bun" then [ "baseline", "libc" ] else if name == "pkl" then [ "libc" ] else [])
  case Array.find (\key -> not (Array.elem key allowed)) (Object.keys fields) of
    Just key -> Left ("Unknown setup argument: " <> key)
    Nothing -> pure unit
  when (Array.any isNull (Object.values fields)) $ Left "Setup arguments cannot be null"
  let initial = defaults name
  cache <- either (Left <<< show) (Right <<< fromMaybe initial.cache) (getFieldOptional fields "cache")
  when (Object.member "cache" fields && not (validCache cache)) $ Left "cache must be a lowercase DNS label of 1-63 letters, digits, or hyphens"
  packageList <- either (Left <<< show) (Right <<< fromMaybe "") (getFieldOptional fields "packages")
  let packages = if trim packageList == "" then [] else map trim (String.split (Pattern ",") packageList)
  project <- either (Left <<< show) (Right <<< fromMaybe initial.project) (getFieldOptional fields "project")
  version <- either (Left <<< show) (Right <<< fromMaybe initial.version) (getFieldOptional fields "version")
  toolchain <- either (Left <<< show) (Right <<< fromMaybe initial.toolchain) (getFieldOptional fields "toolchain")
  trustedUsers <- either (Left <<< show) (Right <<< fromMaybe initial.trustedUsers) (getFieldOptional fields "trustedUsers")
  extraConf <- either (Left <<< show) (Right <<< fromMaybe initial.extraConf) (getFieldOptional fields "extraConf")
  components <- either (Left <<< show) (Right <<< fromMaybe initial.components) (getFieldOptional fields "components")
  targets <- either (Left <<< show) (Right <<< fromMaybe initial.targets) (getFieldOptional fields "targets")
  profile <- either (Left <<< show) (Right <<< fromMaybe initial.profile) (getFieldOptional fields "profile")
  when (toolchain /= "" && Object.member "version" fields && version /= toolchain) $ Left "version and toolchain must agree when both are supplied"
  installDir <- either (Left <<< show) (Right <<< fromMaybe initial.installDir) (getFieldOptional fields "installDir")
  packageName <- either (Left <<< show) (Right <<< fromMaybe initial.packageName) (getFieldOptional fields "packageName")
  sudo <- either (Left <<< show) (Right <<< fromMaybe initial.sudo) (getFieldOptional fields "sudo")
  otpVersion <- either (Left <<< show) (Right <<< fromMaybe initial.otpVersion) (getFieldOptional fields "otpVersion")
  daemon <- either (Left <<< show) (Right <<< fromMaybe initial.daemon) (getFieldOptional fields "daemon")
  init <- either (Left <<< show) (Right <<< fromMaybe initial.init) (getFieldOptional fields "init")
  baseline <- either (Left <<< show) (Right <<< fromMaybe initial.baseline) (getFieldOptional fields "baseline")
  libc <- either (Left <<< show) (Right <<< fromMaybe initial.libc) (getFieldOptional fields "libc")
  cliVersion <- either (Left <<< show) (Right <<< fromMaybe initial.cliVersion) (getFieldOptional fields "cliVersion")
  jsVersion <- either (Left <<< show) (Right <<< fromMaybe initial.jsVersion) (getFieldOptional fields "jsVersion")
  pythonVersion <- either (Left <<< show) (Right <<< fromMaybe initial.pythonVersion) (getFieldOptional fields "pythonVersion")
  xtpVersion <- either (Left <<< show) (Right <<< fromMaybe initial.xtpVersion) (getFieldOptional fields "xtpVersion")
  binaryenVersion <- either (Left <<< show) (Right <<< fromMaybe initial.binaryenVersion) (getFieldOptional fields "binaryenVersion")
  let config = { cache, packages, project, version: if toolchain == "" then version else toolchain, toolchain, components, targets, profile, trustedUsers, extraConf, installDir, packageName, sudo, otpVersion, daemon, init, baseline, libc, cliVersion, jsVersion, pythonVersion, xtpVersion, binaryenVersion }
  validateConfig name config
  pure config
