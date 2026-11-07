module CI.Setup.Archive (install, resolve) where

import Prelude
import CI.Setup.Host as H
import CI.Setup.Types (Config, Host, Result, versionToken)
import Data.Argonaut.Core (Json)
import Data.Argonaut.Decode (decodeJson)
import Data.Array as Array
import Data.Either (Either(..), either)
import Data.Argonaut.Decode.Error (JsonDecodeError)
import Data.Foldable (all)
import Data.Int as Int
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as String
import Data.String.CodeUnits as CU
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..))
import Effect (Effect)
import Effect.Exception (throw)
import FluentCI.Plugin as P
import Foreign.Object as Object

type Release = { version :: String, url :: String, layout :: String, executable :: String, sha256 :: String }

stripV :: String -> String
stripV value = fromMaybe value (String.stripPrefix (Pattern "v") value)

tag :: String -> String -> Effect String
tag repository prefix = do
  response <- H.fetch ("https://api.github.com/repos/" <> repository <> "/releases/latest") >>= H.json
  value <- H.field "tag_name" response
  pure (fromMaybe value (String.stripPrefix (Pattern prefix) value))

nodeVersion :: String -> Effect String
nodeVersion requested = do
  response <- H.fetch "https://nodejs.org/dist/index.json" >>= H.json
  rows <- either (throw <<< show) pure (decodeJson response :: Either JsonDecodeError (Array Json))
  candidates <- if requested == "lts" then do
    pure (Array.filter (\row -> case decodeJson row :: Either JsonDecodeError (Object.Object Json) of
      Right object -> case Object.lookup "lts" object of
        Just value -> case decodeJson value :: Either JsonDecodeError String of
          Right _ -> true
          _ -> false
        _ -> false
      _ -> false) rows)
    else pure rows
  case Array.head candidates of
    Nothing -> throw "Node release index contains no matching releases"
    Just row -> stripV <$> H.field "version" row

zigRelease :: String -> Host -> Effect Release
zigRelease requested host = do
  index <- H.fetch "https://ziglang.org/download/index.json" >>= H.json
  object <- either (throw <<< show) pure (decodeJson index :: Either JsonDecodeError (Object.Object Json))
  let versions = Array.filter (\v -> case CU.toCharArray v of
        [ ] -> false
        chars -> case Array.head chars of
          Just c -> c >= '0' && c <= '9'
          _ -> false) (Object.keys object)
      numeric = map (fromMaybe 0 <<< Int.fromString) <<< String.split (Pattern ".")
      sorted = Array.sortBy (\a b -> compare (numeric b) (numeric a)) versions
  version <- if requested == "latest" then case Array.head sorted of
    Nothing -> throw "Zig index contains no stable release"
    Just value -> pure value
    else pure (stripV requested)
  release <- H.field version index
  platform <- H.field (host.arch <> "-" <> host.os) release
  url <- H.field "tarball" platform
  sha256 <- H.field "shasum" platform
  pure { version, url, sha256, layout: "tar-root", executable: "zig" }

resolve :: String -> Host -> Config -> Effect Release
resolve tool host config = do
  let requested = stripV config.version
      darwin = if host.os == "macos" then "darwin" else "linux"
      arm = host.arch == "aarch64"
      nodeArch = if arm then "arm64" else "x64"
  case tool of
    "bun" -> do
      version <- if requested == "latest" then tag "oven-sh/bun" "bun-v" else pure requested
      musl <- case config.libc of
        "musl" -> pure true
        "gnu" -> pure false
        _ -> if host.os == "linux" then H.exists "/etc/alpine-release" else pure false
      when (host.os == "macos" && musl) $ throw "Bun musl builds are Linux-only"
      when (config.baseline && arm) $ throw "Bun baseline builds require x86_64"
      let asset = "bun-" <> darwin <> "-" <> (if arm then "aarch64" else "x64")
            <> (if musl then "-musl" else "") <> (if config.baseline then "-baseline" else "")
      pure { version, url: "https://github.com/oven-sh/bun/releases/download/bun-v" <> version <> "/" <> asset <> ".zip"
        , layout: "bun:" <> asset, executable: "bin/bun", sha256: "" }
    "deno" -> do
      version <- if requested == "latest" then tag "denoland/deno" "v" else pure requested
      let target = host.arch <> if host.os == "macos" then "-apple-darwin" else "-unknown-linux-gnu"
      pure { version, url: "https://github.com/denoland/deno/releases/download/v" <> version <> "/deno-" <> target <> ".zip"
        , layout: "zip-bin", executable: "bin/deno", sha256: "" }
    "elixir" -> do
      H.requireTools [ "erl" ]
      actualOtp <- trim <$> H.capture [ "erl", "-noshell", "-eval", "io:format(\"~s\", [erlang:system_info(otp_release)]), halt()." ]
      let otp = if config.otpVersion == "" then actualOtp else config.otpVersion
      unless (otp == actualOtp) $ throw ("Erlang/OTP mismatch: requested " <> otp <> ", installed " <> actualOtp)
      unless (CU.length otp > 0 && all (\c -> c >= '0' && c <= '9') (CU.toCharArray otp)) $ throw "Unable to determine Erlang/OTP major version"
      version <- if requested == "latest" then tag "elixir-lang/elixir" "v" else pure requested
      pure { version, url: "https://builds.hex.pm/builds/elixir/v" <> version <> "-otp-" <> otp <> ".zip"
        , layout: "zip-root", executable: "bin/elixir", sha256: "" }
    "gleam" -> do
      version <- if requested == "latest" then tag "gleam-lang/gleam" "v" else pure requested
      let target = host.arch <> if host.os == "macos" then "-apple-darwin" else "-unknown-linux-musl"
      pure { version, url: "https://github.com/gleam-lang/gleam/releases/download/v" <> version <> "/gleam-v" <> version <> "-" <> target <> ".tar.gz"
        , layout: "tar-bin", executable: "bin/gleam", sha256: "" }
    "go" -> do
      raw <- if requested == "latest" then H.fetch "https://go.dev/VERSION?m=text" else pure requested
      let first = fromMaybe "" (Array.head (String.split (Pattern "\n") raw))
          version = fromMaybe first (String.stripPrefix (Pattern "go") first)
      pure { version, url: "https://go.dev/dl/go" <> version <> "." <> darwin <> "-" <> (if arm then "arm64" else "amd64") <> ".tar.gz"
        , layout: "tar-root", executable: "bin/go", sha256: "" }
    "java" -> do
      version <- if requested == "latest" then do
        info <- H.fetch "https://api.adoptium.net/v3/info/available_releases" >>= H.json
        lts <- H.field "most_recent_lts" info :: Effect Int
        pure (show lts)
        else pure requested
      let os = if host.os == "macos" then "mac" else "linux"
          selector = if String.contains (Pattern ".") version then "version/jdk-" <> version else "latest/" <> version <> "/ga"
      pure { version, url: "https://api.adoptium.net/v3/binary/" <> selector <> "/" <> os <> "/" <> (if arm then "aarch64" else "x64") <> "/jdk/hotspot/normal/eclipse"
        , layout: "tar-root", executable: (if host.os == "macos" then "Contents/Home/" else "") <> "bin/java", sha256: "" }
    "node" -> do
      version <- if requested == "latest" || requested == "lts" then nodeVersion requested else pure requested
      pure { version, url: "https://nodejs.org/dist/v" <> version <> "/node-v" <> version <> "-" <> darwin <> "-" <> nodeArch <> ".tar.gz"
        , layout: "tar-root", executable: "bin/node", sha256: "" }
    "pkl" -> do
      version <- if requested == "latest" then tag "apple/pkl" "" else pure requested
      musl <- case config.libc of
        "musl" -> pure true
        "gnu" -> pure false
        _ -> if host.os == "linux" then H.exists "/etc/alpine-release" else pure false
      when (host.os == "macos" && musl) $ throw "Pkl musl builds are Linux-only"
      let java = (host.os == "macos" && not arm) || (musl && arm)
          asset = if java then "jpkl" else if host.os == "macos" then "pkl-macos-aarch64"
            else if musl then "pkl-alpine-linux-amd64"
            else "pkl-linux-" <> if arm then "aarch64" else "amd64"
      when java $ do
        H.requireTools [ "java" ]
        installed <- H.captureWith Object.empty true [ "java", "-version" ] >>= H.versionFrom "java"
        let major = fromMaybe 0 (Array.head (String.split (Pattern ".") installed) >>= Int.fromString)
        unless (major >= 17) $ throw "Pkl Java executable requires Java 17 or newer; run the java setup module first"
      pure { version, url: "https://github.com/apple/pkl/releases/download/" <> version <> "/" <> asset
        , layout: "raw-bin", executable: "bin/pkl", sha256: "" }
    "zig" -> zigRelease requested host
    _ -> throw ("No archive installer for " <> tool)

install :: String -> Host -> Config -> Effect Result
install tool host config = do
  unless (config.packageName == "") $ throw "packageName is only supported by BSD package installations"
  when config.sudo $ throw "Archive installations are per-user; sudo is only used for BSD or Nix installations"
  H.requireTools [ "curl", "mktemp", "mkdir", "mv", "chmod", "rm", "test" ]
  H.requireTools (if tool == "pkl" then [ "cp" ] else if Array.elem tool [ "bun", "deno", "elixir" ] then [ "unzip" ] else [ "tar" ])
  when (tool == "bun") $ H.requireTools [ "cp", "ln" ]
  release <- resolve tool host config
  unless (versionToken release.version) $ throw "Upstream returned an invalid release version"
  unless (String.startsWith (Pattern "https://") release.url) $ throw "Upstream returned a non-HTTPS download URL"
  home <- if config.installDir == "" then H.userHome else pure ""
  let destination = if config.installDir == "" then home <> "/.local/share/fluentci/" <> tool <> "/" <> release.version else config.installDir
      executable = destination <> "/" <> release.executable
      javaHome = destination <> if host.os == "macos" then "/Contents/Home" else ""
      binDir = if tool == "zig" then destination else if tool == "java" then javaHome <> "/bin" else destination <> "/bin"
      extra = if tool == "java" then Object.singleton "JAVA_HOME" javaHome
        else if tool == "go" then Object.singleton "GOROOT" destination else Object.empty
  present <- H.exists destination
  unless present $ do
    -- Stage on the destination filesystem so promotion is an atomic rename.
    parent <- trim <$> H.capture [ "dirname", destination ]
    H.run [ "mkdir", "-p", parent ]
    H.withTempAt parent \temp -> do
      let archive = temp <> "/archive"
          staged = temp <> "/payload"
      H.run [ "mkdir", "-p", staged ]
      H.download release.url archive
      when (release.sha256 /= "") $ do
        digest <- P.sha256 (P.file archive) >>= H.unwrap
        unless (trim digest == release.sha256) $ throw "Downloaded setup archive SHA-256 mismatch"
      if release.layout == "raw-bin" then do
        H.run [ "mkdir", "-p", staged <> "/bin" ]
        H.run [ "cp", archive, staged <> "/" <> release.executable ]
      else if release.layout == "tar-root" then
        H.run [ "tar", "-xf", archive, "-C", staged, "--strip-components=1" ]
      else if release.layout == "tar-bin" then do
        H.run [ "mkdir", "-p", staged <> "/bin" ]
        H.run [ "tar", "-xf", archive, "-C", staged <> "/bin" ]
      else if release.layout == "zip-root" then
        H.run [ "unzip", "-q", archive, "-d", staged ]
      else if release.layout == "zip-bin" then do
        H.run [ "mkdir", "-p", staged <> "/bin" ]
        H.run [ "unzip", "-q", archive, "-d", staged <> "/bin" ]
      else do
        let asset = fromMaybe "" (String.stripPrefix (Pattern "bun:") release.layout)
        H.run [ "unzip", "-q", archive, "-d", temp <> "/unpack" ]
        H.run [ "mkdir", "-p", staged <> "/bin" ]
        H.run [ "cp", temp <> "/unpack/" <> asset <> "/bun", staged <> "/bin/bun" ]
        H.run [ "ln", "-s", "bun", staged <> "/bin/bunx" ]
      H.run [ "chmod", "+x", staged <> "/" <> release.executable ]
      void (H.verify tool release.version (staged <> "/" <> release.executable))
      -- Concurrent installs should use separate destinations; setup does not
      -- provide a directory lock.
      H.run [ "mv", staged, destination ]
  version <- H.verify tool release.version executable
  H.result tool version binDir extra
