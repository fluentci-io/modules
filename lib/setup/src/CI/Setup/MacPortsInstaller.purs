module CI.Setup.MacPortsInstaller (install) where

import Prelude
import CI.Setup.Host as H
import CI.Setup.Types (Config, Host, Result, versionToken)
import Data.Array as Array
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as String
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..))
import Effect (Effect)
import Effect.Exception (throw)
import FluentCI.Plugin as P
import Foreign.Object as Object

-- Use the signed upstream system package, never another implementation of port
-- found on PATH. MacPorts packages have a fixed /opt/local installation prefix.
install :: Host -> Config -> Effect Result
install host config = do
  unless (host.os == "macos") $ throw "MacPorts setup is macOS-only"
  unless (config.installDir == "" && config.packageName == "") $
    throw "MacPorts system packages use /opt/local; omit installDir and packageName"
  H.requireTools [ "curl", "sw_vers", "pkgutil", "installer", "id" ]
  system <- trim <$> H.capture [ "sw_vers", "-productVersion" ]
  let parts = String.split (Pattern ".") system
      major = fromMaybe "" (Array.head parts)
      platform = if major == "10" then "10." <> fromMaybe "" (Array.index parts 1) else major
      requested = fromMaybe config.version (String.stripPrefix (Pattern "v") config.version)
      endpoint = "https://api.github.com/repos/macports/macports-base/releases/" <>
        if requested == "latest" then "latest" else "tags/v" <> requested
  unless (versionToken platform) $ throw "Unable to determine the macOS package version"
  metadata <- H.fetch endpoint >>= H.json
  tag <- H.field "tag_name" metadata
  let selected = fromMaybe tag (String.stripPrefix (Pattern "v") tag)
  unless (versionToken selected && (requested == "latest" || requested == selected)) $
    throw "MacPorts release does not match the requested version"
  let executable = "/opt/local/bin/port"
      verify = do
        H.run [ "test", "-x", executable ]
        actual <- H.capture [ executable, "version" ] >>= H.versionFrom "macports"
        unless (actual == selected) $ throw ("MacPorts version mismatch: expected " <> selected <> ", got " <> actual)
        pure actual
  present <- H.exists executable
  actual <- if present then verify else do
    uid <- trim <$> H.capture [ "id", "-u" ]
    unless (uid == "0" || config.sudo) $ throw "MacPorts installation requires root or --sudo for the signed macOS system package"
    when config.sudo $ H.requireTools [ "sudo" ]
    assets <- H.field "assets" metadata :: Effect (Array { name :: String, browser_download_url :: String, digest :: Maybe String })
    asset <- case Array.filter (\asset -> String.startsWith (Pattern ("MacPorts-" <> selected <> "-" <> platform <> "-")) asset.name && String.endsWith (Pattern ".pkg") asset.name) assets of
      [ value ] -> pure value
      _ -> throw ("No unique official MacPorts package for macOS " <> platform)
    digest <- case asset.digest >>= String.stripPrefix (Pattern "sha256:") of
      Just value -> pure value
      Nothing -> throw "MacPorts package has no upstream SHA-256 digest"
    unless (String.startsWith (Pattern "https://github.com/macports/macports-base/releases/download/") asset.browser_download_url) $
      throw "Unexpected MacPorts package URL"
    H.withTemp \temp -> do
      let package = temp <> "/MacPorts.pkg"
      H.download asset.browser_download_url package
      checksum <- trim <$> (P.sha256 (P.file package) >>= H.unwrap)
      unless (checksum == digest) $ throw "MacPorts package SHA-256 mismatch"
      H.run [ "pkgutil", "--check-signature", package ]
      H.run ((if config.sudo then [ "sudo", "-n" ] else []) <> [ "installer", "-pkg", package, "-target", "/" ])
    verify
  H.result "macports" actual "/opt/local/bin" Object.empty
