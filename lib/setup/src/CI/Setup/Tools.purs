module CI.Setup.Tools (install, supports, substitute) where

import Prelude
import CI.Setup.Archive as Archive
import CI.Setup.Installer as Installer
import CI.Setup.BSD as BSD
import CI.Setup.Host as H
import CI.Setup.OTP as Erlang
import CI.Setup.MacPortsInstaller as MacPorts
import CI.Setup.Types (Config, Host, Result, defaults, isBSD, versionToken)
import CI.Setup.ToolCatalog as Catalog
import Data.Argonaut.Decode (decodeJson)
import Data.Array as Array
import Data.Either (Either(..), either)
import Data.Foldable (all, foldl)
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Data.String as String
import Data.Traversable (traverse)
import Data.String.Common (trim)
import Data.String.CodeUnits as CU
import Data.String.Pattern (Pattern(..), Replacement(..))
import Effect (Effect)
import Effect.Exception (catchException, message, throw, try)
import FluentCI.Plugin as P
import Foreign.Object as Object

type Tool =
  { name :: String, program :: String, backend :: String, package :: String
  , repository :: String, asset :: String, format :: String, member :: String, tagPrefix :: String
  , versionArgs :: Array String, checkVersion :: Boolean, defaultVersion :: String
  , linuxPackage :: String, macPackage :: String, freebsdPackage :: String
  , openbsdPackage :: String, netbsdPackage :: String
  }

supports :: String -> Boolean
supports name = Array.elem name Catalog.names

lookup :: String -> Effect Tool
lookup name = do
  json <- H.json Catalog.definitions
  tools <- either (throw <<< show) pure (decodeJson json)
  case Array.find (\tool -> tool.name == name) tools of
    Nothing -> throw ("Unknown setup tool: " <> name)
    Just tool -> pure tool

stripV :: String -> String
stripV value = fromMaybe value (String.stripPrefix (Pattern "v") value)

verify :: Tool -> String -> String -> Effect String
verify tool expected executable = do
  H.run [ "test", "-x", executable ]
  if tool.name == "erlang" then Erlang.verify expected executable else if not tool.checkVersion then pure expected else do
    text <- H.capture ([ executable ] <> tool.versionArgs)
    actual <- H.versionFrom tool.name text
    when (tool.name == "aws" && not (String.startsWith (Pattern "2.") actual)) $ throw "AWS CLI v2 is required"
    let wanted = stripV expected
    unless (wanted == "latest" || wanted == actual || String.startsWith (Pattern (wanted <> ".")) actual) $
      throw ("Installed " <> tool.name <> " version mismatch: requested " <> expected <> ", got " <> actual)
    pure actual

available :: String -> Effect Boolean
available name = (_ /= "") <$> H.findExecutable name

firstManager :: Array String -> Effect String
firstManager names = case Array.uncons names of
  Nothing -> throw "No supported native package manager found; configure a repository or install the tool manually"
  Just { head, tail } -> do
    found <- available head
    if found then pure head else firstManager tail

native :: Tool -> Host -> Config -> Effect Result
native tool host config = do
  existing <- try do
    executable <- H.findExecutable tool.program
    unless (String.startsWith (Pattern "/") executable) $ throw "Executable not found"
    found <- H.exists executable
    unless found $ throw "Executable not found"
    actual <- verify tool (if config.version == "stable" then "latest" else config.version) executable
    binDir <- trim <$> H.capture [ "dirname", executable ]
    H.result tool.name actual binDir Object.empty
  case existing of
    Right result -> pure result
    Left _ -> nativeInstall tool host config

nativeInstall :: Tool -> Host -> Config -> Effect Result
nativeInstall tool host config = do
  unless (config.installDir == "") $ throw "Native packages use their system prefix; omit installDir"
  manager <- if host.os == "freebsd" then pure "pkg"
    else if host.os == "openbsd" then pure "pkg_add"
    else if host.os == "netbsd" then pure "pkgin"
    else if host.os == "macos" then firstManager [ "brew", "port" ]
    else firstManager [ "apt-get", "dnf", "yum", "apk", "pacman", "zypper" ]
  let base = case host.os of
        "freebsd" -> tool.freebsdPackage
        "openbsd" -> tool.openbsdPackage
        "netbsd" -> tool.netbsdPackage
        "macos" -> tool.macPackage
        _ -> tool.linuxPackage
      pinned = config.version /= "latest" && config.version /= "stable"
      selector = if config.packageName /= "" then config.packageName
        else if not pinned then base
        else if manager == "apt-get" || manager == "apk" then base <> "=" <> stripV config.version
        else if manager == "brew" then base <> "@" <> stripV config.version
        else base <> "-" <> stripV config.version
      privilege = if config.sudo then [ "sudo", "-n" ] else []
      args = case manager of
        "pkg" -> [ "pkg", "install", "-y", selector ]
        "pkg_add" -> [ "pkg_add", "-I", selector ]
        "pkgin" -> [ "pkgin", "-y", "install", selector ]
        "brew" -> [ "brew", "install", selector ]
        "port" -> [ "port", "-N", "install", selector ]
        "apt-get" -> [ "apt-get", "install", "-y", "--no-install-recommends", selector ]
        "apk" -> [ "apk", "add", "--no-cache", selector ]
        "pacman" -> [ "pacman", "-S", "--needed", "--noconfirm", selector ]
        "zypper" -> [ "zypper", "--non-interactive", "install", selector ]
        _ -> [ manager, "install", "-y", selector ]
  when (manager == "brew" && config.sudo) $ throw "Homebrew installs must run as the normal user; omit sudo"
  H.requireTools ([ manager, "which", "dirname" ] <> if config.sudo then [ "sudo" ] else [])
  catchException (\error -> throw ("Native setup of " <> tool.name <> " failed. Configure the vendor repository, select an available version/packageName, and check permissions. " <> message error)) $
    H.run (privilege <> args)
  executable <- if tool.name == "erlang" && manager == "brew" then do
    prefix <- trim <$> H.capture [ "brew", "--prefix", selector ]
    unless (String.startsWith (Pattern "/") prefix) $ throw "Homebrew returned an invalid Erlang prefix"
    pure (prefix <> "/bin/erl")
    else trim <$> H.capture [ "which", tool.program ]
  unless (String.startsWith (Pattern "/") executable) $ throw ("Installed package did not provide " <> tool.program <> " on PATH")
  actual <- verify tool (if config.version == "stable" then "latest" else config.version) executable
  binDir <- trim <$> H.capture [ "dirname", executable ]
  H.result tool.name actual binDir Object.empty

substitute :: Host -> String -> String -> String
substitute host version template = foldl (\value pair -> String.replaceAll (Pattern pair.key) (Replacement pair.value) value) template substitutions
  where
  arm = host.arch == "aarch64"
  mac = host.os == "macos"
  os = if mac then "darwin" else "linux"
  substitutions =
    [ { key: "{version}", value: version }, { key: "{os}", value: os }
    , { key: "{hostos}", value: host.os }
    , { key: "{pkgxarch}", value: if arm then "aarch64" else "x86-64" }
    , { key: "{sqruffplatform}", value: (if mac then "darwin-" else "linux-") <> (if arm then "aarch64" else "x86_64") <> (if mac then "" else "-musl") }
    , { key: "{doppleros}", value: if mac then "macOS" else "linux" }
    , { key: "{rcloneos}", value: if mac then "osx" else "linux" }
    , { key: "{ghos}", value: if mac then "macOS" else "linux" }
    , { key: "{ghformat}", value: if mac then "zip" else "tar.gz" }
    , { key: "{binaryenarch}", value: if arm then if mac then "arm64" else "aarch64" else "x86_64" }
    , { key: "{miseplatform}", value: host.os <> "-" <> if arm then "arm64" else "x64" }
    , { key: "{jfarch}", value: if arm then "arm64" else "amd64" }
    , { key: "{goarch}", value: if arm then "arm64" else "amd64" }
    , { key: "{xarch}", value: if arm then "arm64" else "x64" }
    , { key: "{rustarch}", value: if arm then "aarch64" else "x86_64" }
    , { key: "{rustos}", value: if mac then "apple-darwin" else "unknown-linux-musl" }
    , { key: "{rustosmusl}", value: if mac then "apple-darwin" else "unknown-linux-musl" }
    , { key: "{bazelarch}", value: if arm then "arm64" else "x86_64" }
    , { key: "{cmakeplatform}", value: if mac then "macos-universal" else "linux-" <> if arm then "aarch64" else "x86_64" }
    , { key: "{ninjaplatform}", value: if mac then "mac" else if arm then "linux-aarch64" else "linux" }
    , { key: "{flyos}", value: if mac then "macOS" else "Linux" }
    , { key: "{flyarch}", value: if arm then "arm64" else "x86_64" }
    , { key: "{trivyplatform}", value: (if mac then "macOS-" else "Linux-") <> if arm then "ARM64" else "64bit" }
    , { key: "{coverallsplatform}", value: if mac then "macos" else "linux-" <> if arm then "aarch64" else "x86_64" }
    , { key: "{bbplatform}", value: (if mac then "macos-" else "linux-") <> (if arm then "aarch64" else "amd64") <> (if mac then "" else "-static") }
    ]

release :: Tool -> String -> Effect { version :: String, url :: String, sha256 :: String }
release tool requested = do
  let tag = tool.tagPrefix <> fromMaybe requested (String.stripPrefix (Pattern tool.tagPrefix) requested)
      endpoint = "https://api.github.com/repos/" <> tool.repository <> "/releases/" <>
        if requested == "latest" then "latest" else "tags/" <> tag
  json <- H.fetch endpoint >>= H.json
  value <- H.field "tag_name" json
  let version = fromMaybe value (String.stripPrefix (Pattern tool.tagPrefix) value)
  unless (versionToken version) $ throw "Upstream returned an invalid release version"
  pure { version, url: value, sha256: "" }

xataRelease :: Host -> String -> Effect { version :: String, url :: String, sha256 :: String }
xataRelease host requested = do
  H.requireTools [ "curl" ]
  when (host.os == "linux") $ do
    alpine <- H.exists "/etc/alpine-release"
    when alpine $ throw "Xata upstream binaries require glibc; Alpine/musl is not supported"
  let root = "https://xata-cli-versions.s3.amazonaws.com/"
      wanted = stripV requested
      endpoint = root <> if wanted == "latest" then "channels/latest/manifest.json" else "versions/" <> wanted <> "-latest/manifest.json"
      target = (if host.os == "macos" then "darwin" else "linux") <> "-" <> if host.arch == "aarch64" then "arm64" else "x64"
  manifest <- H.fetch endpoint >>= H.json
  version <- H.field "version" manifest
  unless (versionToken version && (wanted == "latest" || wanted == version)) $ throw "Xata manifest version mismatch"
  targets <- H.field "targets" manifest
  binary <- H.field target targets :: Effect { url :: String, sha256sum :: String }
  unless (String.startsWith (Pattern (root <> "versions/")) binary.url) $ throw "Unexpected Xata download URL"
  unless (CU.length binary.sha256sum == 64 && all (\c -> (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f')) (CU.toCharArray binary.sha256sum)) $
    throw "Xata manifest must provide a SHA-256 checksum"
  pure { version, url: binary.url, sha256: binary.sha256sum }

githubRelease :: Tool -> Host -> String -> Effect { version :: String, url :: String, sha256 :: String }
githubRelease tool host requested = do
  let tag = tool.tagPrefix <> fromMaybe requested (String.stripPrefix (Pattern tool.tagPrefix) requested)
      endpoint = "https://api.github.com/repos/" <> tool.repository <> "/releases/" <>
        if requested == "latest" then "latest" else "tags/" <> tag
  json <- H.fetch endpoint >>= H.json
  tagName <- H.field "tag_name" json
  let version = fromMaybe tagName (String.stripPrefix (Pattern tool.tagPrefix) tagName)
  unless (versionToken version) $ throw "Upstream returned an invalid release version"
  assets <- H.field "assets" json :: Effect (Array { name :: String, browser_download_url :: String, digest :: Maybe String })
  let wanted = substitute host version tool.asset
  asset <- case Array.find (\asset -> asset.name == wanted) assets of
    Nothing -> throw ("No official " <> tool.name <> " asset for " <> host.os <> "/" <> host.arch <> ": " <> wanted)
    Just asset -> pure asset
  digest <- case asset.digest >>= String.stripPrefix (Pattern "sha256:") of
    Nothing -> if tool.name == "macports-rs" then do
      checksum <- case Array.find (\entry -> entry.name == wanted <> ".sha256") assets of
        Nothing -> throw "macports-rs release has no SHA-256 checksum"
        Just entry -> pure entry
      text <- trim <$> H.fetch checksum.browser_download_url
      case Array.head (String.split (Pattern " ") text) of
        Just value | value /= "" -> pure value
        _ -> throw "Invalid macports-rs release checksum"
      else pure ""
    Just value -> pure value
  pure { version, url: asset.browser_download_url, sha256: digest }

extract :: Tool -> String -> String -> String -> Effect Unit
extract tool url digest destination = do
  unless (String.startsWith (Pattern "https://") url) $ throw "Installer download must use HTTPS"
  H.withTemp \temp -> do
    H.download url (temp <> "/archive")
    when (digest /= "") $ do
      actual <- P.sha256 (P.file (temp <> "/archive")) >>= H.unwrap
      unless (trim actual == digest) $ throw "Setup download SHA-256 mismatch"
    H.run [ "mkdir", "-p", destination <> "/payload" ]
    if tool.format == "gz" then do
      H.requireTools [ "gzip", "sh" ]
      H.run [ "mkdir", "-p", destination <> "/bin" ]
      H.run [ "sh", "-c", "gzip -dc \"$1\" > \"$2\"", "_", temp <> "/archive", destination <> "/bin/" <> tool.program ]
    else if tool.format == "raw" then do
      H.run [ "mkdir", "-p", destination <> "/bin" ]
      H.run [ "cp", temp <> "/archive", destination <> "/bin/" <> tool.program ]
    else do
      if tool.format == "zip" || (Array.elem tool.name [ "gh", "gh-artifact" ] && String.contains (Pattern "macOS") url) then H.run [ "unzip", "-q", temp <> "/archive", "-d", destination <> "/payload" ]
      else H.run [ "tar", "-xf", temp <> "/archive", "-C", destination <> "/payload" ]
      -- Preserve adjacent resources and helper programs. Locate exactly one main executable.
      matches <- trim <$> H.capture [ "find", destination <> "/payload", "-type", "f", "-name", tool.program ]
      let paths = Array.filter (_ /= "") (String.split (Pattern "\n") matches)
      executable <- case paths of
        [ path ] -> pure path
        _ -> throw ("Archive must contain exactly one " <> tool.program <> " executable")
      bin <- trim <$> H.capture [ "dirname", executable ]
      if tool.name == "extism-py" then do
        H.requireTools [ "bash", "sh" ]
        H.run [ "mkdir", "-p", destination <> "/bin" ]
        H.run [ "sh", "-c", "printf '%s\\n' \"$2\" > \"$1\"", "_", destination <> "/bin/extism-py", pythonWrapper ]
      else H.run [ "ln", "-s", bin, destination <> "/bin" ]
    H.run [ "chmod", "+x", destination <> "/bin/" <> tool.program ]

pythonWrapper :: String
pythonWrapper = """#!/usr/bin/env bash
set -eu
prefix=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
export EXTISM_PYTHON_WASI_DEPS_DIR="$prefix/payload/extism-py/share/extism-py"
exec -a "$0" "$prefix/payload/extism-py/bin/extism-py" "$@"
"""

ensureRuntime :: String -> Host -> Effect Unit
ensureRuntime tool host = do
  let program = if tool == "node" then "node" else "bun"
  found <- available program
  unless found $ do
    result <- if isBSD host.os then BSD.install tool host (defaults tool) else Archive.install tool host ((defaults tool) { version = if tool == "node" then "lts" else "latest" })
    H.activate result

install :: String -> Host -> Config -> Effect Result
install name host config = do
  tool <- lookup name
  when (Array.elem name [ "dpkg", "rpmbuild" ] && host.os /= "linux") $ throw (name <> " setup is Linux-only")
  when (name == "gh" && isBSD host.os && config.installDir /= "") $ throw "Native GitHub CLI packages use the system prefix; omit installDir"
  when (Array.elem name [ "macports", "macports-rs" ] && host.os /= "macos") $ throw (name <> " setup is macOS-only")
  if name == "macports" then MacPorts.install host config
  else if tool.name == "erlang" then do
    target <- if isBSD host.os || config.packageName /= "" || config.sudo then pure Nothing else Erlang.platform host
    case target of
      Just value -> Erlang.install host value config
      Nothing -> do
        unless (config.installDir == "") $ throw "Native Erlang packages use the system prefix; omit installDir"
        native tool host (config { version = Erlang.normalizeVersion config.version })
  else if tool.backend == "extism-family" then do
    let components =
          [ { name: "binaryen", version: config.binaryenVersion, variable: "BINARYEN_VERSION" }
          , { name: "extism-cli", version: if config.cliVersion == "" then config.version else config.cliVersion, variable: "EXTISM_CLI_VERSION" }
          , { name: "extism-js", version: config.jsVersion, variable: "EXTISM_JS_VERSION" }
          , { name: "extism-py", version: config.pythonVersion, variable: "EXTISM_PY_VERSION" }
          , { name: "xtp", version: config.xtpVersion, variable: "XTP_VERSION" }
          ]
    installed <- traverse (\component -> do
      result <- install component.name host (config { version = component.version, installDir = if config.installDir == "" then "" else config.installDir <> "/" <> component.name })
      H.activate result
      pure { name: component.name, variable: component.variable, result }) components
    cli <- case Array.find (\entry -> entry.name == "extism-cli") installed of
      Nothing -> throw "Extism CLI component was not installed"
      Just entry -> pure entry.result
    H.result name cli.version cli.binDir (foldl (\env entry -> Object.insert entry.variable entry.result.version (Object.union entry.result.environment env)) Object.empty installed)
  else if isBSD host.os || tool.backend == "native" || (Array.elem name [ "aws", "clojure", "coveralls" ] && host.os == "macos") then do
    installed <- native tool host config
    when (Array.elem name [ "gh-artifact", "gitlab-artifacts", "scorecard" ]) $ do
      ensureRuntime "node" host
      ensureRuntime "bun" host
    extra <- if name == "gh-artifact" then do
      home <- H.userHome
      let sdk = home <> "/.local/share/fluentci/github-artifact-client/2.3.2"
      H.run [ "mkdir", "-p", sdk ]
      H.run [ "bun", "add", "--cwd", sdk, "--exact", "@actions/artifact@2.3.2" ]
      pure (Object.singleton "FLUENTCI_GH_ARTIFACT_CLIENT" (sdk <> "/node_modules/@actions/artifact/lib/artifact.js"))
      else pure Object.empty
    H.result installed.tool installed.version installed.binDir (Object.union extra installed.environment)
  else if tool.backend == "nix" then Installer.install "nix" host config
  else if tool.backend == "rustfmt" then do
    rust <- Installer.install "rust" host config
    H.runWith rust.environment [ rust.binDir <> "/rustup", "component", "add", "rustfmt" ]
    actual <- verify tool "latest" (rust.binDir <> "/rustfmt")
    H.result name actual rust.binDir rust.environment
  else do
    unless (config.packageName == "") $ throw "packageName is only supported by native package installations"
    when (config.sudo && not (name == "macports-rs" && not (Array.null config.packages))) $
      throw (if name == "macports-rs" then "sudo requires a nonempty packages list; the CLI installation is per-user" else "This installer is per-user; omit sudo")
    H.requireTools [ "mkdir", "test", "which", "chmod", "cp", "mv", "ln", "find", "dirname" ]
    githubInfo <- if tool.backend == "github" then Just <$> githubRelease tool host config.version
      else if tool.backend == "xata" then Just <$> xataRelease host config.version else pure Nothing
    let selectedVersion = maybe config.version _.version githubInfo
    home <- if config.installDir == "" then H.userHome else pure ""
    let destination = if config.installDir == "" then home <> "/.local/share/fluentci/" <> name <> "/" <> selectedVersion else config.installDir
        executable = destination <> "/bin/" <> tool.program
    present <- H.exists destination
    actual <- if present then verify tool selectedVersion executable else do
      -- Own the destination with atomic mkdir. Venv launchers embed this prefix;
      -- remove only this newly created directory if installation fails.
      parent <- trim <$> H.capture [ "dirname", destination ]
      H.run [ "mkdir", "-p", parent ]
      H.run [ "mkdir", destination ]
      outcome <- try do
        expected <- if tool.backend == "python" then do
          H.requireTools [ "python3" ]
          H.run [ "python3", "-m", "venv", destination ]
          let dependency = tool.package <> if config.version == "latest" then "" else "==" <> stripV config.version
          H.run [ executablePrefix destination <> "python", "-m", "pip", "install", "--disable-pip-version-check", dependency ]
          pure config.version
        else if tool.backend == "bun" then do
          ensureRuntime "node" host
          ensureRuntime "bun" host
          H.runWith (Object.singleton "CYPRESS_INSTALL_BINARY" "0")
            [ "bun", "add", "--cwd", destination, "--exact", "--dev", tool.package <> "@" <> config.version ]
          H.run [ "mkdir", "-p", destination <> "/bin" ]
          H.run [ "ln", "-s", destination <> "/node_modules/.bin/" <> tool.program, executable ]
          pure config.version
        else if tool.backend == "gem" then do
          H.requireTools [ "gem", "ruby" ]
          H.run ([ "gem", "install", tool.package, "--no-document", "--install-dir", destination <> "/gems", "--bindir", destination <> "/bin" ] <>
            if config.version == "latest" then [] else [ "--version", config.version ])
          pure config.version
        else if tool.backend == "go" then do
          H.requireTools [ "go" ]
          H.run [ "mkdir", "-p", destination <> "/bin" ]
          let requested = if config.version == "latest" || String.startsWith (Pattern "v") config.version then config.version else "v" <> config.version
          H.runWith (Object.singleton "GOBIN" (destination <> "/bin")) [ "go", "install", tool.package <> "@" <> requested ]
          when (name == "ubicloud") $ H.run [ "mv", destination <> "/bin/cli", executable ]
          if tool.checkVersion then pure config.version else do
            metadata <- H.capture [ "go", "version", "-m", executable ]
            case Array.head (Array.filter (String.startsWith (Pattern "mod\t") <<< trim) (String.split (Pattern "\n") metadata)) of
              Nothing -> throw "Unable to identify installed Go module version"
              Just line -> case Array.index (String.split (Pattern "\t") (trim line)) 2 of
                Nothing -> throw "Invalid Go build metadata"
                Just version -> pure (stripV version)
        else if tool.backend == "aws" then do
          H.requireTools [ "curl", "unzip", "sh" ]
          H.withTemp \temp -> do
            H.download ("https://awscli.amazonaws.com/awscli-exe-linux-" <> (if host.arch == "aarch64" then "aarch64" else "x86_64") <>
              (if config.version == "latest" then "" else "-" <> stripV config.version) <> ".zip") (temp <> "/aws.zip")
            H.run [ "unzip", "-q", temp <> "/aws.zip", "-d", temp ]
            H.run [ "sh", temp <> "/aws/install", "--install-dir", destination <> "/aws", "--bin-dir", destination <> "/bin" ]
          pure config.version
        else if tool.backend == "clojure" then do
          H.requireTools [ "curl", "bash", "java", "tar", "sed" ]
          selected <- if config.version == "latest" then _.version <$> release tool "latest" else pure config.version
          unless (versionToken selected) $ throw "Invalid Clojure CLI release version"
          H.withTemp \temp -> do
            H.download ("https://download.clojure.org/install/linux-install-" <> selected <> ".sh") (temp <> "/install.sh")
            H.run [ "sh", "-c", "cd \"$1\" && exec bash \"$2\" --prefix \"$3\"", "_", temp, temp <> "/install.sh", destination ]
          pure selected
        else if tool.backend == "xtp" then do
          H.requireTools [ "curl" ]
          let os = if host.os == "macos" then "darwin" else "linux"
              arch = if host.arch == "aarch64" then "arm64" else "amd64"
          extract (tool { format = "raw" }) ("https://static.dylibso.com/cli/bin/xtp-" <> os <> "-" <> arch) "" destination
          pure config.version
        else if tool.backend == "gcloud" then do
          H.requireTools [ "curl", "tar", "python3" ]
          selected <- if config.version == "latest" then H.fetch "https://dl.google.com/dl/cloudsdk/channels/rapid/components-2.json" >>= H.json >>= H.field "version" else pure config.version
          unless (versionToken selected) $ throw "Invalid Google Cloud CLI version"
          let platform = (if host.os == "macos" then "darwin-" else "linux-") <> if host.arch == "aarch64" then "arm" else "x86_64"
          extract (tool { format = "tar" }) ("https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-" <> selected <> "-" <> platform <> ".tar.gz") "" destination
          pure selected
        else if tool.backend == "nixpkgs" then do
          H.requireTools [ "nix" ]
          H.run [ "nix", "--extra-experimental-features", "nix-command flakes", "profile", "install", "--profile", destination <> "/profile", "nixpkgs#" <> tool.package ]
          H.run [ "ln", "-s", destination <> "/profile/bin", destination <> "/bin" ]
          pure config.version
        else if tool.backend == "cachix" then do
          H.requireTools [ "nix", "curl" ]
          selected <- if config.version == "latest" then _.version <$> release tool "latest" else pure config.version
          H.run [ "nix", "--extra-experimental-features", "nix-command flakes", "profile", "install", "--profile", destination <> "/profile", "github:" <> tool.repository <> "/v" <> stripV selected ]
          H.run [ "ln", "-s", destination <> "/profile/bin", destination <> "/bin" ]
          pure selected
        else if tool.backend == "kubectl" then do
          H.requireTools [ "curl" ]
          selected <- if config.version == "latest" then stripV <<< trim <$> H.fetch "https://dl.k8s.io/release/stable.txt" else pure (stripV config.version)
          unless (versionToken selected) $ throw "Invalid kubectl release version"
          extract (tool { format = "raw" }) ("https://dl.k8s.io/release/v" <> selected <> "/bin/" <> (if host.os == "macos" then "darwin" else "linux") <> "/" <> (if host.arch == "aarch64" then "arm64" else "amd64") <> "/kubectl") "" destination
          pure selected
        else if tool.backend == "jfrog" then do
          selected <- if config.version == "latest" then _.version <$> release tool "latest" else pure (stripV config.version)
          let platform = (if host.os == "macos" then "mac-" else "linux-") <> if host.arch == "aarch64" then "arm64" else "amd64"
          extract (tool { format = "raw" }) ("https://releases.jfrog.io/artifactory/jfrog-cli/v2-jf/" <> selected <> "/jfrog-cli-" <> platform <> "/jf") "" destination
          pure selected
        else if Array.elem tool.backend [ "helm", "terraform", "hashicorp", "sonar" ] then do
          H.requireTools [ "curl", "unzip", "tar" ]
          info <- release tool config.version
          let os = if host.os == "macos" then "darwin" else "linux"
              arch = if host.arch == "aarch64" then "arm64" else "amd64"
              url = if tool.backend == "helm" then "https://get.helm.sh/helm-v" <> info.version <> "-" <> os <> "-" <> arch <> ".tar.gz"
                else if Array.elem tool.backend [ "terraform", "hashicorp" ] then "https://releases.hashicorp.com/" <> name <> "/" <> info.version <> "/" <> name <> "_" <> info.version <> "_" <> os <> "_" <> arch <> ".zip"
                else "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-" <> info.version <> ".zip"
          when (tool.backend == "sonar") $ H.requireTools [ "java" ]
          extract (tool { format = if tool.backend == "helm" then "tar" else "zip" }) url "" destination
          pure info.version
        else do
          H.requireTools (if tool.format == "raw" then [ "curl" ] else [ "curl", "tar", "unzip" ])
          when (name == "buildx") $ H.requireTools [ "docker" ]
          info <- case githubInfo of
            Just value -> pure value
            Nothing -> throw "Missing upstream release metadata"
          extract tool info.url info.sha256 destination
          when (name == "macports-rs") $ H.run [ "ln", "-sf", "port", destination <> "/bin/portindex" ]
          pure info.version
        version <- verify tool expected executable
        when (name == "aws" && not (String.startsWith (Pattern "2.") version)) $ throw "AWS CLI v2 is required"
        pure version
      case outcome of
        Left error -> do
          H.run [ "rm", "-rf", "--", destination ]
          throw (message error)
        Right value -> pure value
    when (Array.elem name [ "gh-artifact", "gitlab-artifacts", "scorecard" ]) $ do
      ensureRuntime "node" host
      ensureRuntime "bun" host
    when (name == "gh-artifact") $ do
      H.run [ "bun", "add", "--cwd", destination, "--exact", "@actions/artifact@2.3.2" ]
    extra <- if name == "extism-py" then pure (Object.singleton "EXTISM_PYTHON_WASI_DEPS_DIR" (destination <> "/payload/extism-py/share/extism-py"))
      else if name == "gh-artifact" then pure (Object.singleton "FLUENTCI_GH_ARTIFACT_CLIENT" (destination <> "/node_modules/@actions/artifact/lib/artifact.js"))
      else if name == "sccache" then pure (Object.singleton "RUSTC_WRAPPER" executable)
      else if tool.backend == "gem" then pure (Object.singleton "GEM_HOME" (destination <> "/gems"))
      else pure Object.empty
    when (name == "buildx") $ do
      userHome <- H.userHome
      dockerConfig <- H.env "DOCKER_CONFIG" (userHome <> "/.docker")
      H.run [ "mkdir", "-p", dockerConfig <> "/cli-plugins" ]
      H.run [ "ln", "-sf", executable, dockerConfig <> "/cli-plugins/docker-buildx" ]
    H.result name actual (destination <> "/bin") extra
  where
  executablePrefix directory = directory <> "/bin/"
