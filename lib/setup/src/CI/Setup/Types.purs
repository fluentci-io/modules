module CI.Setup.Types where

import Prelude
import Data.Argonaut.Core (Json, isNull)
import Data.Argonaut.Decode (decodeJson, getFieldOptional)
import Data.Array as Array
import Data.Either (Either(..), either)
import Data.Foldable (all, traverse_)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as String
import Data.String.CodeUnits as CU
import Data.String.Pattern (Pattern(..))
import Foreign.Object as Object

-- Shared configuration is decoded against each tool's own allowed fields.
type Config =
  { version :: String
  , installDir :: String
  , packageName :: String
  , sudo :: Boolean
  , otpVersion :: String
  , daemon :: Boolean
  , init :: String
  , baseline :: Boolean
  , libc :: String
  }

type Result = { tool :: String, version :: String, binDir :: String, environment :: Object.Object String }
type Host = { os :: String, arch :: String }

names :: Array String
names = [ "bun", "deno", "determinate-nix", "elixir", "gleam", "go", "java", "nix", "node", "rust", "zig" ]

isNix :: String -> Boolean
isNix name = name == "nix" || name == "determinate-nix"

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
  { version: if name == "rust" then "stable" else if name == "java" then "21" else "latest"
  , installDir: "", packageName: "", sudo: false, otpVersion: ""
  , daemon: true, init: "systemd", baseline: false, libc: "auto"
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
validateConfig _ config = do
  unless (versionToken config.version) $ Left "version must be a nonempty release or channel token"
  traverse_ (\value -> unless (not (String.contains (Pattern "\x0000") value)
    && not (String.contains (Pattern "\n") value) && not (String.contains (Pattern "\r") value))
      (Left "Setup arguments cannot contain NUL or line breaks")) [ config.installDir, config.packageName, config.otpVersion ]
  unless (config.installDir == "" || validDirectory config.installDir) $
    Left "installDir must be an absolute directory other than /, without parent traversal, colons, or control characters"
  unless (config.packageName == "" || (not (String.startsWith (Pattern "-") config.packageName)
    && all (\c -> (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')
      || Array.elem c [ '.', '-', '_', '+', '%' ]) (CU.toCharArray config.packageName))) $
    Left "packageName must be a native package name or selector, without paths or options"
  unless (config.otpVersion == "" || all (\c -> c >= '0' && c <= '9') (CU.toCharArray config.otpVersion)) $
    Left "otpVersion must be an Erlang/OTP major version"
  unless (Array.elem config.init [ "systemd", "none" ]) $ Left "init must be systemd or none"
  unless (Array.elem config.libc [ "auto", "gnu", "musl" ]) $ Left "libc must be auto, gnu, or musl"

-- Reject unknown and null-valued fields instead of silently ignoring mistakes.
decodeConfig :: String -> Json -> Either String Config
decodeConfig name json = do
  fields <- either (Left <<< show) Right (decodeJson json)
  let allowed = [ "version", "installDir", "packageName", "sudo" ] <>
        (if name == "elixir" then [ "otpVersion" ] else []) <>
        (if name == "nix" then [ "daemon" ] else []) <>
        (if name == "determinate-nix" then [ "init" ] else []) <>
        (if name == "bun" then [ "baseline", "libc" ] else [])
  case Array.find (\key -> not (Array.elem key allowed)) (Object.keys fields) of
    Just key -> Left ("Unknown setup argument: " <> key)
    Nothing -> pure unit
  when (Array.any isNull (Object.values fields)) $ Left "Setup arguments cannot be null"
  let initial = defaults name
  version <- either (Left <<< show) (Right <<< fromMaybe initial.version) (getFieldOptional fields "version")
  installDir <- either (Left <<< show) (Right <<< fromMaybe initial.installDir) (getFieldOptional fields "installDir")
  packageName <- either (Left <<< show) (Right <<< fromMaybe initial.packageName) (getFieldOptional fields "packageName")
  sudo <- either (Left <<< show) (Right <<< fromMaybe initial.sudo) (getFieldOptional fields "sudo")
  otpVersion <- either (Left <<< show) (Right <<< fromMaybe initial.otpVersion) (getFieldOptional fields "otpVersion")
  daemon <- either (Left <<< show) (Right <<< fromMaybe initial.daemon) (getFieldOptional fields "daemon")
  init <- either (Left <<< show) (Right <<< fromMaybe initial.init) (getFieldOptional fields "init")
  baseline <- either (Left <<< show) (Right <<< fromMaybe initial.baseline) (getFieldOptional fields "baseline")
  libc <- either (Left <<< show) (Right <<< fromMaybe initial.libc) (getFieldOptional fields "libc")
  let config = { version, installDir, packageName, sudo, otpVersion, daemon, init, baseline, libc }
  validateConfig name config
  pure config
