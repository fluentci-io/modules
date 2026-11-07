module CI.Contract where

import Prelude
import Data.Argonaut.Core (Json, isNull)
import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Encode (encodeJson)
import Data.Either (Either(..), either)
import Data.Foldable (foldl)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as String
import Data.String.CodeUnits as CU
import Data.String.Pattern (Pattern(..))
import Effect (Effect)
import Effect.Exception (throw)
import Foreign.Object as Object

foreign import encodeInput :: forall row. { | row } -> Json

type Variable = { name :: String, value :: String }
type SetupResult = { tool :: String, version :: String, binDir :: String, environment :: Array Variable }
type ExecutionResult = { outcome :: String, runDir :: String, reportPath :: String, stdoutPath :: String, stderrPath :: String }

variables :: Object.Object String -> Array Variable
variables object = map (\name -> { name, value: fromMaybe "" (Object.lookup name object) }) (Object.keys object)

setupResult :: { tool :: String, version :: String, binDir :: String, environment :: Object.Object String } -> SetupResult
setupResult result = result { environment = variables result.environment }

-- Encode Maybe arguments as omitted fields so existing default/validation rules apply.
input :: Json -> Json
input json = case decodeJson json of
  Left _ -> json
  Right object -> encodeJson (Object.filter (not <<< isNull) (object :: Object.Object Json))

cliInput :: Json -> Effect Json
cliInput json = do
  object <- either (throw <<< show) pure (decodeJson (input json))
  case Object.lookup "artifacts" object of
    Nothing -> pure (encodeJson (object :: Object.Object Json))
    Just value -> do
      declarations <- either (throw <<< show) pure (decodeJson value :: Either _ (Array String))
      pairs <- traverseArtifact declarations
      pure (encodeJson (Object.insert "artifacts" (encodeJson pairs) object))
  where
  traverseArtifact values = foldl (\acc value -> do
    pairs <- acc
    case String.indexOf (Pattern "=") value of
      Nothing -> throw "artifacts entries must be NAME=PATH"
      Just index -> do
        let name = CU.take index value
            path = CU.drop (index + 1) value
        when (name == "" || path == "") $ throw "artifacts entries need both NAME and PATH"
        when (Object.member name pairs) $ throw "Duplicate artifact name"
        pure (Object.insert name path pairs)) (pure Object.empty) values

buildxInput :: Json -> Json
buildxInput json = case decodeJson (input json) of
  Left _ -> input json
  Right object -> case Object.lookup "type" object of
    Nothing -> encodeJson (object :: Object.Object Json)
    Just value -> encodeJson (Object.insert "type_" value (Object.delete "type" object))
