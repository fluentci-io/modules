module CI.Setup.Installer (install) where

import Prelude
import CI.Setup.Host as H
import CI.Setup.Types (Config, Host, Result)
import Data.Maybe (fromMaybe)
import Data.String as String
import Data.String.Pattern (Pattern(..))
import Effect (Effect)
import Effect.Exception (throw)
import Foreign.Object as Object

install :: String -> Host -> Config -> Effect Result
install tool host config = do
  unless (config.packageName == "") $ throw "packageName is only supported by BSD package installations"
  H.requireTools [ "curl", "sh", "mktemp", "rm" ]
  home <- H.userHome
  if tool == "rust" then do
    when config.sudo $ throw "Rustup installations are per-user; omit sudo"
    let prefix = if config.installDir == "" then home <> "/.local/share/fluentci/rust/" <> config.version else config.installDir
        cargoHome = prefix <> "/cargo"
        rustupHome = prefix <> "/rustup"
        version = if config.version == "latest" then "stable" else config.version
        environment = Object.insert "RUSTUP_TOOLCHAIN" version (Object.insert "CARGO_HOME" cargoHome (Object.singleton "RUSTUP_HOME" rustupHome))
    H.withTemp \temp -> do
      H.download "https://sh.rustup.rs" (temp <> "/install.sh")
      H.runWith (Object.insert "RUSTUP_INIT_SKIP_PATH_CHECK" "yes" environment)
        [ "sh", temp <> "/install.sh", "-y", "--no-modify-path", "--profile", "minimal", "--default-toolchain", version ]
    actual <- H.verifyWith environment "rust" version (cargoHome <> "/bin/rustc")
    void (H.verifyWith environment "rust" version (cargoHome <> "/bin/cargo"))
    H.result tool actual (cargoHome <> "/bin") environment
  else do
    unless (config.installDir == "") $ throw "Nix uses /nix and system-managed profiles; omit installDir"
    when (tool == "nix" && host.os == "macos" && not config.daemon) $ throw "The macOS Nix installer requires daemon mode"
    when (tool == "determinate-nix" && host.os == "macos" && config.init == "none") $ throw "init=none is only supported on Linux"
    let daemon = tool == "determinate-nix" || config.daemon
        binDir = if daemon then "/nix/var/nix/profiles/default/bin" else home <> "/.nix-profile/bin"
        executable = binDir <> "/nix"
        pinned = fromMaybe config.version (String.stripPrefix (Pattern "v") config.version)
        url = if tool == "nix"
          then if pinned == "latest" then "https://nixos.org/nix/install" else "https://releases.nixos.org/nix/nix-" <> pinned <> "/install"
          else "https://install.determinate.systems/nix" <> if pinned == "latest" then "" else "/tag/v" <> pinned
        args = if tool == "nix" then
          [ if config.daemon then "--daemon" else "--no-daemon", "--yes", "--no-modify-profile", "--no-channel-add" ]
          else [ "install" ] <> (if host.os == "linux" then [ "linux" ] else []) <>
            [ "--no-confirm", "--no-modify-profile" ] <>
            (if host.os == "linux" then [ "--init", config.init ] else [])
        privilege = if config.sudo then [ "sudo", "-n" ] else []
    when config.sudo $ H.requireTools [ "sudo" ]
    present <- H.exists executable
    unless present $ H.withTemp \temp -> do
      H.download url (temp <> "/install.sh")
      H.run (privilege <> [ "sh", temp <> "/install.sh" ] <> args)
    when (tool == "determinate-nix" && pinned /= "latest") $
      void (H.verify "nix-installer" pinned "/nix/nix-installer")
    text <- H.capture [ executable, "--version" ]
    let determinate = String.contains (Pattern "Determinate") text
    unless (determinate == (tool == "determinate-nix")) $ throw "The existing Nix installation is a different distribution; uninstall it explicitly before switching"
    actual <- H.verify "nix" (if tool == "determinate-nix" then "latest" else config.version) executable
    H.result tool actual binDir Object.empty
