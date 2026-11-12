module CI.Dpkg (Config, decodeConfig, validateWith, buildWith, validateWithSetup, buildWithSetup, validate, build) where

import Prelude
import CI.Dpkg.Support as Package
import Data.Argonaut.Core (Json)
import Data.Array as Array
import Data.Either (Either)
import Data.Foldable (traverse_)
import Data.String as String
import Data.String.CodeUnits as CU
import Data.String.Common (toLower, trim)
import Data.String.Pattern (Pattern(..))
import Effect (Effect)
import Effect.Exception (throw)

type Config = { directory :: String, arch :: String, output :: String }

decodeConfig :: Json -> Either String Config
decodeConfig json = do
  fields <- Package.object [ "directory", "arch", "output" ] json
  directory <- Package.required fields "directory"
  arch <- Package.required fields "arch"
  output <- Package.optional fields "output" (directory <> ".deb")
  pure { directory, arch, output }

architecture :: String -> String
architecture = case _ of
  "x86_64" -> "amd64"
  "aarch64" -> "arm64"
  "i686" -> "i386"
  value -> value

controlField :: String -> String -> Effect String
controlField name contents = do
  let prefix = toLower name <> ":"
      matches = Array.filter (\line -> String.startsWith (Pattern prefix) (toLower line))
        (String.split (Pattern "\n") contents)
  case matches of
    [ line ] -> do
      let value = trim (CU.drop (CU.length prefix) line)
      when (value == "") $ throw ("DEBIAN/control has an empty " <> name <> " field")
      pure value
    _ -> throw ("DEBIAN/control must contain exactly one " <> name <> " field")

-- Return canonical paths and architecture after checking layout and metadata.
prepare :: Config -> Effect Config
prepare = prepareWithSetup (pure unit)

prepareWithSetup :: Effect Unit -> Config -> Effect Config
prepareWithSetup setupDependency config = do
  Package.linuxToolsWithSetup setupDependency [ "dpkg-deb", "dpkg", "realpath" ]
  Package.token "arch" config.arch
  Package.path "output" config.output
  unless (String.endsWith (Pattern ".deb") config.output) $ throw "output must be a .deb file path"
  root <- Package.directory config.directory
  destination <- Package.absolute config.output
  when (Package.inside root destination) $ throw "output must be outside the package directory"
  Package.run [ "test", "-d", root <> "/DEBIAN" ]
  Package.file (root <> "/DEBIAN/control")
  control <- Package.capture [ "cat", root <> "/DEBIAN/control" ]
  -- A binary control file is one paragraph, unlike a source debian/control file.
  when (Array.length (String.split (Pattern "\n\n") (trim control)) /= 1) $
    throw "DEBIAN/control must contain a single binary package paragraph"
  name <- controlField "Package" control
  version <- controlField "Version" control
  actualArch <- controlField "Architecture" control
  traverse_ (\field -> void (controlField field control)) [ "Maintainer", "Description" ]
  Package.run [ "dpkg", "--validate-pkgname", name ]
  Package.run [ "dpkg", "--validate-version", version ]
  let arch = architecture config.arch
  Package.checkArch arch actualArch
  pure { directory: root, arch, output: destination }

validateWith :: Config -> Effect Unit
validateWith = void <<< prepare

validateWithSetup :: Effect Unit -> Config -> Effect Unit
validateWithSetup setupDependency = void <<< prepareWithSetup setupDependency

buildWith :: Config -> Effect (Array String)
buildWith = buildWithSetup (pure unit)

buildWithSetup :: Effect Unit -> Config -> Effect (Array String)
buildWithSetup setupDependency config = do
  checked <- prepareWithSetup setupDependency config
  parent <- trim <$> Package.capture [ "dirname", "--", checked.output ]
  Package.run [ "mkdir", "-p", "--", parent ]
  -- Keep dpkg-deb's own control syntax and maintainer-script permission checks.
  Package.run [ "dpkg-deb", "--root-owner-group", "--build", checked.directory, checked.output ]
  Package.file checked.output
  actualArch <- trim <$> Package.capture [ "dpkg-deb", "--field", checked.output, "Architecture" ]
  Package.checkArch checked.arch actualArch
  pure [ checked.output ]

validate :: Effect Unit
validate = Package.input decodeConfig >>= validateWith

build :: Effect Unit
build = Package.input decodeConfig >>= buildWith >>= Package.output
