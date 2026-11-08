module CI.Setup.OTP (platform, install, verify, versionArguments, normalizeVersion) where

import Prelude
import CI.Setup.Host as H
import CI.Setup.Types (Config, Host, Result)
import Data.Array as Array
import Data.Either (Either(..))
import Data.Foldable (all, traverse_)
import Data.Int as Int
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as String
import Data.String.CodeUnits as CU
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..), Replacement(..))
import Effect (Effect)
import Effect.Exception (message, throw, try)
import Foreign.Object as Object
import FluentCI.Plugin as P

normalizeVersion :: String -> String
normalizeVersion value =
  let withoutV = fromMaybe value (String.stripPrefix (Pattern "v") value)
  in fromMaybe withoutV (String.stripPrefix (Pattern "OTP-") withoutV)

versionArguments :: Array String
versionArguments =
  [ "+S", "1:1", "-noshell", "-noinput", "-eval"
  , "case {code:ensure_loaded(compile),file:read_file(filename:join([code:root_dir(),\"releases\",erlang:system_info(otp_release),\"OTP_VERSION\"]))} of {{module,compile},{ok,V}} -> io:put_chars(V), halt(0); _ -> io:format(standard_error,\"Erlang compiler or OTP_VERSION is unavailable~n\",[]), halt(1) end."
  ]

verify :: String -> String -> Effect String
verify requested executable = do
  bin <- trim <$> H.capture [ "dirname", executable ]
  traverse_ (\path -> H.run [ "test", "-x", path ]) [ executable, bin <> "/erlc", bin <> "/escript" ]
  actual <- H.capture ([ executable ] <> versionArguments) >>= H.versionFrom "erlang"
  let wanted = normalizeVersion requested
  unless (wanted == "latest" || wanted == actual || String.startsWith (Pattern (wanted <> ".")) actual) $
    throw ("Installed Erlang/OTP version mismatch: requested " <> requested <> ", got " <> actual)
  pure actual

-- Match the archive families used by erlef/setup-beam. Other distributions use
-- their native packages rather than trying to run an incompatible Ubuntu build.
platform :: Host -> Effect (Maybe String)
platform host
  | host.os == "macos" = pure (Just "darwin")
  | host.os == "linux" = do
      distribution <- trim <$> H.capture
        [ "sh", "-c", "if [ -r /etc/os-release ]; then . /etc/os-release; printf '%s-%s' \"$ID\" \"$VERSION_ID\"; fi" ]
      pure if Array.elem distribution [ "ubuntu-22.04", "ubuntu-24.04", "ubuntu-26.04" ] then Just distribution else Nothing
  | otherwise = pure Nothing

stable :: String -> Boolean
stable value = not (Array.null parts) && all (\part -> CU.length part > 0
  && all (\c -> c >= '0' && c <= '9') (CU.toCharArray part)) parts
  where
  parts = String.split (Pattern ".") value

select :: String -> Array String -> Effect String
select requested values = do
  let wanted = normalizeVersion requested
      numeric = map (fromMaybe 0 <<< Int.fromString) <<< String.split (Pattern ".")
      versions = Array.sortBy (\a b -> compare (numeric b) (numeric a)) (Array.nub (Array.filter stable values))
      matches = if wanted == "latest" then versions else Array.filter
        (\value -> value == wanted || String.startsWith (Pattern (wanted <> ".")) value) versions
  case Array.head (Array.filter (_ == wanted) versions <> matches) of
    Just value -> pure value
    Nothing -> throw ("No compatible Erlang/OTP archive for version " <> requested <> "; choose an available release or use packageName for a native package")

release :: Host -> String -> String -> Effect { version :: String, url :: String, sha256 :: String }
release host target requested = do
  let arch = if host.arch == "aarch64" then "arm64" else "amd64"
  if target == "darwin" then do
    let triple = (if host.arch == "aarch64" then "aarch64" else "x86_64") <> "-apple-darwin"
    index <- H.fetch ("https://raw.githubusercontent.com/erlef/otp_builds/main/builds/" <> triple <> ".csv")
    let lines = String.split (Pattern "\n") (trim index)
        refs = map (\line -> normalizeVersion (String.replaceAll (Pattern "\"") (Replacement "")
          (fromMaybe "" (Array.head (String.split (Pattern ",") line))))) (Array.drop 1 lines)
    version <- select requested refs
    let row = fromMaybe "" (Array.find (\line -> normalizeVersion (fromMaybe "" (Array.head (String.split (Pattern ",") line))) == version) lines)
        digest = fromMaybe "" (Array.index (String.split (Pattern ",") row) 3)
    unless (CU.length digest == 64 && all (\c -> (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f')) (CU.toCharArray digest)) $ throw "Invalid OTP archive SHA-256 in upstream index"
    pure { version, sha256: digest, url: "https://github.com/erlef/otp_builds/releases/download/OTP-" <> version <> "/OTP-" <> version <> "-macos-" <> arch <> ".tar.gz" }
  else do
    let base = "https://builds.hex.pm/builds/otp/" <> arch <> "/" <> target
    index <- H.fetch (base <> "/builds.txt")
    version <- select requested (map (\line -> normalizeVersion (fromMaybe "" (Array.head (String.split (Pattern " ") (trim line)))))
      (String.split (Pattern "\n") index))
    pure { version, sha256: "", url: base <> "/OTP-" <> version <> ".tar.gz" }

install :: Host -> String -> Config -> Effect Result
install host target config = do
  H.requireTools [ "curl", "tar", "mkdir", "dirname", "rm", "test" ]
  selected <- release host target config.version
  home <- if config.installDir == "" then H.userHome else pure ""
  let destination = if config.installDir == "" then home <> "/.local/share/fluentci/erlang/" <> selected.version else config.installDir
      executable = destination <> "/bin/erl"
  present <- H.exists destination
  actual <- if present then verify selected.version executable else do
    parent <- trim <$> H.capture [ "dirname", destination ]
    H.run [ "mkdir", "-p", parent ]
    H.run [ "mkdir", destination ]
    outcome <- try do
      H.withTemp \temporary -> do
        H.download selected.url (temporary <> "/otp.tar.gz")
        when (selected.sha256 /= "") do
          digest <- P.sha256 (P.file (temporary <> "/otp.tar.gz")) >>= H.unwrap
          unless (trim digest == selected.sha256) $ throw "OTP archive SHA-256 mismatch"
        H.run ([ "tar", "-xzf", temporary <> "/otp.tar.gz", "-C", destination ]
          <> if target == "darwin" then [] else [ "--strip-components=1" ])
        when (target /= "darwin") $ H.run [ destination <> "/Install", "-minimal", destination ]
      verify selected.version executable
    case outcome of
      Left error -> do
        H.run [ "rm", "-rf", "--", destination ]
        throw (message error)
      Right value -> pure value
  H.result "erlang" actual (destination <> "/bin") Object.empty
