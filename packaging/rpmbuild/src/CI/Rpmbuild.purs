module CI.Rpmbuild (Config, decodeConfig, validateWith, buildWith, validateWithSetup, buildWithSetup, validate, build) where

import Prelude
import CI.Rpmbuild.Support as Package
import Data.Argonaut.Core (Json)
import Data.Array as Array
import Data.Either (Either)
import Data.Foldable (all, traverse_)
import Data.String as String
import Data.String.CodeUnits as CU
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..))
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Exception (throw)

type Config = { directory :: String, arch :: String, spec :: String, output :: String }
type Prepared = { config :: Config, packages :: Array String }

decodeConfig :: Json -> Either String Config
decodeConfig json = do
  fields <- Package.object [ "directory", "arch", "spec", "output" ] json
  directory <- Package.required fields "directory"
  arch <- Package.required fields "arch"
  spec <- Package.required fields "spec"
  output <- Package.optional fields "output" (directory <> "/RPMS")
  pure { directory, arch, spec, output }

architecture :: String -> String
architecture = case _ of
  "amd64" -> "x86_64"
  "arm64" -> "aarch64"
  "i386" -> "i686"
  value -> value

-- RPM path macros can expand shell fragments in spec recipes. Require paths
-- that remain literal when RPM expands them; the spec itself is trusted code.
macroPath :: String -> Effect Unit
macroPath value = unless
  (all (\c -> (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')
    || Array.elem c [ '/', '_', '-', '.', '+' ]) (CU.toCharArray value)) $
  throw "RPM directory and output paths must contain only letters, digits, /, _, -, ., or +"

queryFormat :: String
queryFormat = "%{ARCH}\t%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}.rpm\n"

packageFile :: String -> String -> Effect String
packageFile arch row = case String.split (Pattern "\t") row of
  [ actualArch, name ] -> do
    Package.checkArch arch actualArch
    -- Headers determine file paths; reject traversal and nested path components.
    unless (String.endsWith (Pattern ".rpm") name && not (String.contains (Pattern "/") name)
      && not (String.contains (Pattern "\\") name) && not (String.startsWith (Pattern ".") name)) $
      throw "Invalid RPM package filename in spec metadata"
    Package.path "RPM filename" name
    pure (arch <> "/" <> name)
  _ -> throw "Invalid RPM metadata returned by rpmspec"

prepare :: Config -> Effect Prepared
prepare = prepareWithSetup (pure unit)

prepareWithSetup :: Effect Unit -> Config -> Effect Prepared
prepareWithSetup setupDependency config = do
  Package.linuxToolsWithSetup setupDependency [ "rpmbuild", "rpmspec", "rpm", "realpath" ]
  Package.token "arch" config.arch
  Package.path "spec" config.spec
  unless (String.endsWith (Pattern ".spec") config.spec
    && not (String.contains (Pattern "/") config.spec)
    && not (String.contains (Pattern "\\") config.spec)
    && not (String.startsWith (Pattern ".") config.spec)) $
    throw "spec must be a .spec filename inside SPECS, without directory components"
  root <- Package.directory config.directory
  output <- Package.absolute config.output
  macroPath root
  macroPath output
  -- Avoid mixing artifacts into sources, specs, or the build's working trees.
  when (Package.inside root output && not (Package.inside (root <> "/RPMS") output)) $
    throw "output inside the RPM tree must be RPMS or a directory beneath it"
  Package.run [ "test", "-d", root <> "/SPECS" ]
  Package.run [ "test", "-d", root <> "/SOURCES" ]
  Package.file (root <> "/SPECS/" <> config.spec)
  let arch = architecture config.arch
  metadata <- Package.capture
    [ "rpmspec", "--target", arch, "--define", "_topdir " <> root
    , "--query", "--rpms", "--queryformat", queryFormat, root <> "/SPECS/" <> config.spec ]
  let rows = Package.lines metadata
  when (Array.null rows) $ throw "The spec does not declare any binary packages"
  packages <- traverse (packageFile arch) rows
  unless (Array.length packages == Array.length (Array.nub packages)) $
    throw "The spec declares duplicate package filenames"
  pure { config: { directory: root, arch, spec: config.spec, output }, packages }

validateWith :: Config -> Effect Unit
validateWith = void <<< prepare

validateWithSetup :: Effect Unit -> Config -> Effect Unit
validateWithSetup setupDependency = void <<< prepareWithSetup setupDependency

buildWith :: Config -> Effect (Array String)
buildWith = buildWithSetup (pure unit)

buildWithSetup :: Effect Unit -> Config -> Effect (Array String)
buildWithSetup setupDependency config = do
  prepared <- prepareWithSetup setupDependency config
  let checked = prepared.config
  Package.run ([ "mkdir", "-p", "--", checked.output ] <>
    map (\name -> checked.directory <> "/" <> name) [ "BUILD", "BUILDROOT", "SRPMS" ])
  Package.run
    [ "rpmbuild", "--target", checked.arch
    , "--define", "_topdir " <> checked.directory
    , "--define", "_rpmdir " <> checked.output
    , "--define", "_rpmfilename %{ARCH}/%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}.rpm"
    , "-bb", checked.directory <> "/SPECS/" <> checked.spec ]
  let files = map (\name -> checked.output <> "/" <> name) prepared.packages
  traverse_ (\file -> do
    Package.file file
    actualArch <- trim <$> Package.capture [ "rpm", "--query", "--package", "--queryformat", "%{ARCH}", file ]
    Package.checkArch checked.arch actualArch) files
  pure files

validate :: Effect Unit
validate = Package.input decodeConfig >>= validateWith

build :: Effect Unit
build = Package.input decodeConfig >>= buildWith >>= Package.output
