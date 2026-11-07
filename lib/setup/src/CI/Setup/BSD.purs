module CI.Setup.BSD (install) where

import Prelude
import CI.Setup.Host as H
import CI.Setup.Types (Config, Host, Result)
import Data.Array as Array
import Data.Foldable (all, traverse_)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as String
import Data.String.CodeUnits as CU
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..))
import Effect (Effect)
import Effect.Exception (catchException, message, throw, try)
import Data.Either (Either(..))
import Foreign.Object as Object

packageName :: String -> String -> String -> String
packageName os tool version = case tool of
  "purescript" -> if os == "freebsd" then "hs-purescript" else "purescript"
  "node" -> if os == "netbsd" then "nodejs" else "node"
  "java" -> do
    let major = if version == "latest" then "21" else fromMaybe "21" (Array.head (String.split (Pattern ".") version))
    if os == "openbsd" then "jdk%" <> major else "openjdk" <> major
  _ -> tool

ownedExecutable :: String -> String -> Boolean
ownedExecutable name path =
  String.endsWith (Pattern ("/bin/" <> name)) path || case String.split (Pattern ("/bin/" <> name)) path of
    [ _, suffix ] -> CU.length suffix > 0 && all (\c -> c >= '0' && c <= '9') (CU.toCharArray suffix)
    _ -> false

choose :: String -> String -> Array String -> Effect { path :: String, version :: String }
choose tool expected paths = case Array.uncons paths of
  Nothing -> throw ("Installed package has no working " <> tool <> " executable matching version " <> expected)
  Just { head, tail } -> do
    result <- try (H.verify tool expected head)
    case result of
      Right version -> pure { path: head, version }
      Left error -> if Array.null tail then throw (message error) else choose tool expected tail

install :: String -> Host -> Config -> Effect Result
install tool host config = do
  unless (config.installDir == "") $ throw "BSD package installations use the system prefix; omit installDir"
  let manager = case host.os of
        "freebsd" -> "pkg"
        "openbsd" -> "pkg_add"
        _ -> "pkgin"
      name = packageName host.os tool config.version
      selector = if config.packageName /= "" then config.packageName
        else if config.version == "latest" || tool == "java" || (tool == "rust" && config.version == "stable")
          then name else name <> "-" <> config.version
      privilege = if config.sudo then [ "sudo", "-n" ] else []
      args = case host.os of
        "freebsd" -> [ "pkg", "install", "-y", selector ]
        "openbsd" -> [ "pkg_add", "-I", selector ]
        _ -> [ "pkgin", "-y", "install", selector ]
  H.requireTools ([ manager, "mkdir", "ln" ] <> (if host.os /= "freebsd" then [ "pkg_info" ] else [])
    <> if config.sudo then [ "sudo" ] else [])
  catchException (\error -> throw ("Unable to install " <> selector <> " from the " <> host.os
    <> " repository. Check package/version availability or set packageName. " <> message error))
    (H.run (privilege <> args))
  -- pkg_add accepts branch selectors; pkg_info queries installed package names.
  query <- if host.os == "openbsd" then case String.split (Pattern "%") selector of
    [ stem, branch ] -> do
      installed <- H.capture [ "pkg_info", "-q", "-e", stem <> "-" <> branch <> "*" ]
      case Array.head (Array.filter (_ /= "") (map trim (String.split (Pattern "\n") installed))) of
        Just value -> pure value
        Nothing -> throw "The selected OpenBSD package branch was not installed"
    _ -> pure selector
    else pure selector
  listing <- H.capture (if host.os == "freebsd" then [ "pkg", "info", "-l", query ] else [ "pkg_info", "-L", query ])
  let paths = Array.filter (String.startsWith (Pattern "/")) (map trim (String.split (Pattern "\n") listing))
      executableName = if tool == "rust" then "rustc" else if tool == "purescript" then "purs" else tool
      candidates = Array.filter (ownedExecutable executableName) paths
  selected <- choose tool config.version candidates
  let nativeBin = fromMaybe "" (Array.head (String.split (Pattern "/bin/") selected.path)) <> "/bin"
  binDir <- if String.endsWith (Pattern ("/" <> executableName)) selected.path then pure nativeBin
    else do
      -- Versioned BSD packages can install go124/node22-style executables.
      -- Publish an unversioned shim without changing the system's default.
      home <- H.userHome
      let shim = home <> "/.local/share/fluentci/" <> tool <> "/" <> selected.version <> "/bin"
      H.run [ "mkdir", "-p", shim ]
      H.run [ "ln", "-sf", selected.path, shim <> "/" <> executableName ]
      when (tool == "go") $ traverse_ (\path -> H.run [ "ln", "-sf", path, shim <> "/gofmt" ])
        (Array.take 1 (Array.filter (ownedExecutable "gofmt") paths))
      pure shim
  extra <- if tool == "java" then pure (Object.singleton "JAVA_HOME"
      (fromMaybe "" (String.stripSuffix (Pattern "/bin/java") selected.path)))
    else if tool == "go" then do
      root <- trim <$> H.capture [ selected.path, "env", "GOROOT" ]
      pure (Object.singleton "GOROOT" root)
    else pure Object.empty
  when (tool == "rust") $ do
    void (choose tool config.version (Array.filter (ownedExecutable "cargo") paths))
  H.result tool selected.version binDir extra
