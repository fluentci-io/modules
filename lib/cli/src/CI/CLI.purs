module CI.CLI (makePlan, invoke) where

import Prelude
import CI.CLI.Catalog as Catalog
import Data.Argonaut.Core (Json, isNull)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, getFieldOptional)
import Data.Argonaut.Parser (jsonParser)
import Data.Array as Array
import Data.Either (Either(..), either)
import Data.Foldable (all, foldl)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as String
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..))
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Exception (catchException, message, throw)
import FluentCI.Host.Client (RunOutcome(..))
import FluentCI.Host.Plan as Plan
import FluentCI.Plugin as P
import Foreign.Object as Object

type Field =
  { key :: String, kind :: String, flag :: String, default :: Json, required :: Boolean
  , style :: String, scope :: String, choices :: Array String
  }
type Command =
  { name :: String, args :: Array String, fields :: Array Field, program :: String
  , environment :: Object.Object String
  }
type Tool = { name :: String, program :: String, environment :: Object.Object String, commands :: Array Command }
type Runtime = { project :: String, runDir :: String, executable :: String, timeoutMs :: Int }
type Prepared = { runtime :: Runtime, plan :: Plan.Plan }

jsonValue :: forall a. DecodeJson a => Json -> Either String a
jsonValue = either (Left <<< show) Right <<< decodeJson

lookup :: String -> String -> Either String { tool :: Tool, command :: Command }
lookup name commandName = do
  json <- jsonParser Catalog.definitions
  tools <- jsonValue json :: Either String (Array Tool)
  tool <- case Array.find (\tool -> tool.name == name) tools of
    Nothing -> Left ("Unknown CLI module: " <> name)
    Just tool -> Right tool
  command <- case Array.find (\command -> command.name == commandName) tool.commands of
    Nothing -> Left ("Unknown CLI export: " <> commandName)
    Just command -> Right command
  pure { tool, command }

optional :: forall a. DecodeJson a => Object.Object Json -> String -> a -> Either String a
optional object key fallback =
  either (Left <<< show) (Right <<< fromMaybe fallback) (getFieldOptional object key)

validText :: String -> Boolean
validText value = not (String.contains (Pattern "\x0000") value)

valueTokens :: Field -> Json -> Either String (Array String)
valueTokens field value = do
  tokens <- case field.kind of
    "string" -> do
      text <- jsonValue value
      unless (trim text /= "" && validText text) $ Left (field.key <> " must be a nonempty string without NUL")
      unless (Array.null field.choices || Array.elem text field.choices) $ Left ("Invalid value for " <> field.key)
      pure [ text ]
    "strings" -> do
      values <- jsonValue value
      when (field.required && Array.null values) $ Left (field.key <> " must not be empty")
      unless (all (\text -> trim text /= "" && validText text) values) $ Left (field.key <> " must contain nonempty strings without NUL")
      pure values
    "boolean" -> do
      enabled <- jsonValue value
      pure if field.style == "switch" then if enabled then [ "true" ] else []
        else [ if enabled then "true" else "false" ]
    "integer" -> do
      number <- jsonValue value :: Either String Int
      unless (number > 0) $ Left (field.key <> " must be positive")
      pure [ show number ]
    _ -> Left ("Unknown CLI field type: " <> field.kind)
  when (field.scope == "positional" && Array.any (\text -> text == "-" || String.startsWith (Pattern "-") text) tokens) $
    Left (field.key <> " cannot begin with '-'; use an explicit ./ path for such filenames")
  pure if field.flag == "" then case String.stripPrefix (Pattern "prefix:") field.style of
      Just prefix -> map (prefix <> _) tokens
      Nothing -> tokens
    else if field.style == "switch" then if Array.null tokens then [] else [ field.flag ]
    else if field.style == "space-list" then if Array.null tokens then [] else [ field.flag ] <> tokens
    else case String.stripPrefix (Pattern "prefix:") field.style of
      Just prefix -> map (\token -> field.flag <> "=" <> prefix <> token) tokens
      Nothing -> map (\token -> field.flag <> "=" <> token) tokens

resolveField :: Object.Object Json -> Field -> Either String { scope :: String, args :: Array String }
resolveField object field = do
  let value = fromMaybe field.default (Object.lookup field.key object)
  args <- if isNull value then if field.required then Left ("Missing required argument: " <> field.key) else Right []
    else valueTokens field value
  pure { scope: field.scope, args }

prepare :: String -> String -> Json -> Either String Prepared
prepare name commandName json = do
  { tool, command } <- lookup name commandName
  object <- jsonValue json
  let allowed = [ "project", "runDir", "executable", "timeoutMs" ] <> map _.key command.fields
  case Array.find (\key -> not (Array.elem key allowed)) (Object.keys object) of
    Just key -> Left ("Unknown " <> name <> " argument: " <> key)
    Nothing -> pure unit
  when (Array.any isNull (Object.values object)) $ Left "CLI arguments cannot be null"
  project <- optional object "project" "."
  runDir <- optional object "runDir" ""
  executable <- optional object "executable" (if command.program == "" then tool.program else command.program)
  timeoutMs <- optional object "timeoutMs" 900000
  unless (all (\text -> trim text /= "" && validText text) [ project, runDir, executable ]) $
    Left "project, runDir, and executable must be nonempty strings without NUL"
  unless (timeoutMs > 0) $ Left "timeoutMs must be positive"
  fields <- traverse (resolveField object) command.fields
  let scope scopeName = Array.concatMap _.args (Array.filter (\field -> field.scope == scopeName) fields)
      args = scope "global" <> command.args <> scope "option" <> scope "positional" <> scope "raw"
      environment = Object.union command.environment tool.environment
      task = Plan.task name executable project # Plan.withArgs args # Plan.withTimeout timeoutMs
      configured = foldl (\current key -> current # Plan.withEnv key (fromMaybe "" (Object.lookup key environment))) task (Object.keys environment)
  pure { runtime: { project, runDir, executable, timeoutMs }
       , plan: Plan.plan [ configured ] # Plan.withInheritedEnv true # Plan.withJobs 1 }

makePlan :: String -> String -> Json -> Either String Plan.Plan
makePlan name commandName json = _.plan <$> prepare name commandName json

unwrap :: forall a. P.Result a -> Effect a
unwrap = case _ of
  Left error -> throw (P.errorMessage error)
  Right value -> pure value

capture :: Array String -> Effect String
capture args = P.pipeline "cli-preflight" # P.exec args # P.stdout >>= unwrap

invoke :: String -> String -> Effect Unit
invoke name commandName = do
  input <- P.input >>= unwrap
  json <- either throw pure (jsonParser input)
  prepared <- either throw pure (prepare name commandName json)
  os <- P.getOS >>= unwrap
  unless (Array.elem os [ "linux", "macos", "freebsd", "openbsd", "netbsd" ]) $
    throw ("Unsupported CLI host OS: " <> os)
  when (name == "ubicloud") $ do
    present <- P.hasEnv "UBI_TOKEN" >>= unwrap
    token <- if present then P.getEnv "UBI_TOKEN" >>= unwrap else pure ""
    when (trim token == "") $ throw "Set UBI_TOKEN before invoking the Ubicloud CLI"
  void (capture [ "test", "-d", prepared.runtime.project ])
  catchException (\error -> throw ("Required CLI is unavailable: " <> prepared.runtime.executable <> ". " <> message error)) do
    void (capture (if String.contains (Pattern "/") prepared.runtime.executable
      then [ "test", "-x", prepared.runtime.executable ] else [ "which", prepared.runtime.executable ]))
  report <- P.runPlan prepared.runtime.runDir prepared.plan >>= unwrap
  unless (report.outcome == Just RunSucceeded) $
    throw (name <> " failed; inspect " <> prepared.runtime.runDir <> "/result.json")
  capture [ "cat", prepared.runtime.runDir <> "/result.json" ] >>= P.output >>= unwrap
