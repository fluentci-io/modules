module CI.Dpkg.Support where

import Prelude
import Data.Argonaut.Core (Json, stringify)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, getField, getFieldOptional)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Parser (jsonParser)
import Data.Array as Array
import Data.Either (Either(..), either)
import Data.Foldable (all, traverse_)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as String
import Data.String.CodeUnits as CU
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..))
import Effect (Effect)
import Effect.Exception (catchException, message, throw)
import FluentCI.Plugin as P
import Foreign.Object as Object

unwrap :: forall a. P.Result a -> Effect a
unwrap = case _ of
  Left error -> throw (P.errorMessage error)
  Right value -> pure value

object :: Array String -> Json -> Either String (Object.Object Json)
object allowed json = do
  fields <- either (Left <<< show) Right (decodeJson json)
  case Array.find (\key -> not (Array.elem key allowed)) (Object.keys fields) of
    Nothing -> Right fields
    Just key -> Left ("Unknown argument: " <> key)

required :: forall a. DecodeJson a => Object.Object Json -> String -> Either String a
required fields key = either (Left <<< show) Right (getField fields key)

optional :: forall a. DecodeJson a => Object.Object Json -> String -> a -> Either String a
optional fields key fallback =
  either (Left <<< show) (Right <<< fromMaybe fallback) (getFieldOptional fields key)

input :: forall a. (Json -> Either String a) -> Effect a
input decode = do
  raw <- P.input >>= unwrap
  either throw pure (jsonParser raw >>= decode)

capture :: Array String -> Effect String
capture args = P.pipeline "linux-package" # P.exec args # P.stdout >>= unwrap

run :: Array String -> Effect Unit
run = void <<< capture

-- Check the host first, then actually execute each tool to check availability.
linuxTools :: Array String -> Effect Unit
linuxTools tools = do
  os <- P.getOS >>= unwrap
  unless (os == "linux") $ throw "Linux packaging modules require a Linux host"
  traverse_ (\tool -> catchException
    (\error -> throw ("Required packaging tool is unavailable: " <> tool <> ". " <> message error))
    (run [ tool, "--version" ])) tools

path :: String -> String -> Effect Unit
path label value = unless
  (trim value /= "" && all (\c -> c /= '\x0000' && c /= '\r' && c /= '\n') (CU.toCharArray value)) $
  throw (label <> " must be nonempty and cannot contain NUL or line breaks")

token :: String -> String -> Effect Unit
token label value = unless
  (CU.length value > 0 && all (\c -> (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || c == '_') (CU.toCharArray value)) $
  throw (label <> " must contain lowercase letters, digits, or underscores")

directory :: String -> Effect String
directory value = do
  path "directory" value
  run [ "test", "-d", value ]
  trim <$> capture [ "realpath", "--", value ]

file :: String -> Effect Unit
file value = do
  run [ "test", "-f", value ]
  run [ "test", "-r", value ]
  run [ "test", "-s", value ]

absolute :: String -> Effect String
absolute value = do
  path "output" value
  trim <$> capture [ "realpath", "-m", "--", value ]

inside :: String -> String -> Boolean
inside parent child = child == parent || String.startsWith (Pattern (parent <> "/")) child

lines :: String -> Array String
lines = Array.filter (_ /= "") <<< map trim <<< String.split (Pattern "\n")

checkArch :: String -> String -> Effect Unit
checkArch expected actual = unless (expected == actual) $
  throw ("Package architecture mismatch: requested " <> expected <> ", metadata declares " <> actual)

output :: Array String -> Effect Unit
output files = P.output (stringify (encodeJson files)) >>= unwrap
