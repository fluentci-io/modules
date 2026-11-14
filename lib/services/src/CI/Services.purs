module CI.Services (Binding, ServiceResult, start, stop, restart, status, logs, capture, unwrap, validateHost, validateImage) where

import Prelude
import CI.Services.Catalog as Catalog
import CI.Contract.CSV as CSV
import Data.Argonaut.Core (Json, fromObject, stringify)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, getField, getFieldOptional)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Parser (jsonParser)
import Data.Array as A
import Data.Either (Either(..), either)
import Data.Foldable (all, traverse_)
import Data.Int as Int
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as S
import Data.String.CodeUnits as CU
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..))
import Data.String.Regex as Regex
import Data.String.Regex.Flags (noFlags)
import Data.Traversable (traverse)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Exception (catchException, message, throw, try)
import FluentCI.Plugin as P
import Foreign.Object as O

type Binding = { containerPort :: Int, port :: Int, address :: String }
type ServiceResult = { name :: String, state :: String, backend :: String, host :: String, port :: Int, endpoint :: String, ports :: Array Binding }
type Profile = { name :: String, image :: String, version :: String, port :: Int, ports :: Array Int, command :: Array String, env :: O.Object String, probe :: String, path :: String, exec :: Array String, timeout :: Int, scheme :: String, volumes :: Array String }
type WireStatus = { name :: String, state :: String, backend :: String, ports :: O.Object String }
type Control = { project :: String, name :: String }

unwrap :: forall a. P.Result a -> Effect a
unwrap = either (throw <<< P.errorMessage) pure

capture :: String -> Array String -> Effect String
capture project argv = P.pipeline "native-workspace-services" # P.withWorkdir project # P.exec argv # P.stdout >>= unwrap

validateHost :: Effect Unit
validateHost = do
  os <- P.getOS >>= unwrap
  unless (A.elem os [ "linux", "macos", "freebsd", "openbsd", "netbsd" ]) $ throw ("Unsupported service host OS: " <> os)

matches :: String -> String -> Effect Boolean
matches pattern value = either throw pure (Regex.regex pattern noFlags) <#> flip Regex.test value

text :: String -> String -> Effect Unit
text label value = unless (trim value /= "" && all (\c -> c /= '\x0000' && c /= '\n' && c /= '\r') (CU.toCharArray value)) $ throw (label <> " must be nonempty without NUL or line breaks")

validateImage :: String -> Effect Unit
validateImage value = do
  text "image" value
  valid <- matches "^[A-Za-z0-9][A-Za-z0-9_./:@-]*$" value
  unless (valid && not (S.contains (Pattern "://") value)) $ throw "Invalid Docker image reference"
  when (S.contains (Pattern "@") value) do
    case S.split (Pattern "@sha256:") value of
      [ repository, digest ] | repository /= "" && CU.length digest == 64 && all (\c -> (c >= 'a' && c <= 'f') || (c >= '0' && c <= '9')) (CU.toCharArray digest) -> pure unit
      _ -> throw "Image digests must use @sha256: followed by 64 lowercase hexadecimal characters"

profile :: String -> Effect Profile
profile name = do
  json <- either throw pure (jsonParser Catalog.definitions)
  profiles <- either (throw <<< show) pure (decodeJson json)
  case A.find (\p -> p.name == name) profiles of
    Nothing -> throw ("Unknown service module: " <> name)
    Just value -> pure value

object :: Array (Tuple String Json) -> Json
object = fromObject <<< O.fromFoldable

input :: Array String -> Json -> Effect (O.Object Json)
input allowed json = do
  fields <- either (throw <<< show) pure (decodeJson json)
  traverse_ (\key -> unless (A.elem key allowed) $ throw ("Unknown service argument: " <> key)) (O.keys fields)
  pure fields

optional :: forall a. DecodeJson a => O.Object Json -> String -> a -> Effect a
optional fields key fallback = either (throw <<< show) (pure <<< fromMaybe fallback) (getFieldOptional fields key)

csv :: O.Object Json -> String -> Effect (Array String)
csv fields key = do
  value <- optional fields key ""
  values <- either throw pure (CSV.parse value)
  traverse_ (text key) values
  pure values

control :: Profile -> O.Object Json -> Effect Control
control p fields = do
  project <- optional fields "project" "."
  name <- optional fields "name" ("module-" <> p.name <> "-default")
  text "project" project
  valid <- matches "^[A-Za-z0-9_-]+$" name
  unless (valid && CU.length name <= 64 && S.startsWith (Pattern ("module-" <> p.name <> "-")) name) $
    throw ("name must start with module-" <> p.name <> "- and contain at most 64 ASCII letters, numbers, underscores or hyphens")
  pure { project, name }

bounded :: String -> Int -> Int -> Int -> Effect Unit
bounded label low high value = unless (value >= low && value <= high) $ throw (label <> " is outside its supported range")

portNumber :: String -> Effect Int
portNumber value = case Int.fromString value of
  Just number | show number == value && number > 0 && number <= 65535 -> pure number
  _ -> throw "Ports must be canonical positive integers from 1 to 65535"

containerPort :: String -> Effect Int
containerPort value = case S.split (Pattern ":") value of
  [ one ] -> portNumber one
  [ host, target ] -> portNumber host *> portNumber target
  _ -> throw "ports entries must be CONTAINER_PORT or HOST_PORT:CONTAINER_PORT"

absoluteDirectory :: String -> Effect Unit
absoluteDirectory value = do
  text "stateDir" value
  unless (S.startsWith (Pattern "/") value && value /= "/" && not (S.contains (Pattern ":") value) && not (A.elem ".." (S.split (Pattern "/") value))) $ throw "stateDir must be an absolute directory without parent traversal or colons"

validateVolume :: String -> Effect Unit
validateVolume value = case S.split (Pattern ":") value of
  [ target ] -> unless (S.startsWith (Pattern "/") target && target /= "/") $ throw "Anonymous volumes need an absolute container path"
  [ source, target ] -> check source target
  [ source, target, mode ] -> check source target *> unless (A.elem mode [ "ro", "rw" ]) (throw "Volume mode must be ro or rw")
  _ -> throw "volumes must be /CONTAINER_PATH or SOURCE:/CONTAINER_PATH[:ro|rw]"
  where
  check source target = do
    text "volume source" source
    unless (S.startsWith (Pattern "/") target && target /= "/" && not (S.startsWith (Pattern "-") source)) $ throw "Invalid volume source or container path"
    unless (S.startsWith (Pattern "/") source) do
      valid <- matches "^[A-Za-z0-9][A-Za-z0-9_.-]*$" source
      unless valid $ throw "Bind mounts require absolute source paths; named volumes use Docker volume identifiers"

environment :: Profile -> Array String -> Effect (O.Object String)
environment p entries = do
  pairs <- traverse (\entry -> case S.indexOf (Pattern "=") entry of
    Nothing -> throw "env entries must be KEY=VALUE"
    Just index -> do
      let key = CU.take index entry
      valid <- matches "^[A-Za-z_][A-Za-z0-9_]*$" key
      unless valid $ throw "Invalid environment variable name"
      pure (Tuple key (CU.drop (index + 1) entry))) entries
  let keys = map (\(Tuple key _) -> key) pairs
  unless (A.length keys == A.length (A.nub keys)) $ throw "Duplicate environment variable"
  pure (O.union (O.fromFoldable pairs) p.env)

statuses :: Control -> Effect (Array WireStatus)
statuses cfg = do
  raw <- capture cfg.project [ "fluentci", "services", "status", "--json" ]
  json <- either (const (throw "Native service manager returned malformed status JSON")) pure (jsonParser raw)
  either (const (throw "Native service manager returned an invalid status response")) pure (decodeJson json)

result :: Profile -> String -> Maybe WireStatus -> Effect ServiceResult
result p name found = do
  let row = fromMaybe { name, state: "absent", backend: "docker", ports: O.empty } found
      active = A.elem row.state [ "ready", "running" ]
  unless (row.backend == "docker") $ throw "Refusing to operate on a non-Docker service with this module's name"
  bindings <- if not active then pure [] else traverse (\key -> do
    let target = fromMaybe key (S.stripSuffix (Pattern "/tcp") key)
        address = fromMaybe "" (O.lookup key row.ports)
    port <- portNumber target
    host <- case S.split (Pattern ":") address of
      [ "127.0.0.1", value ] -> portNumber value
      _ -> throw "Service manager must return a loopback IPv4 port binding"
    pure { containerPort: port, port: host, address }) (O.keys row.ports)
  let primary = case A.find (\binding -> binding.containerPort == p.port) bindings of
        Nothing | p.name == "aws-emulator" -> A.head bindings
        value -> value
      port = fromMaybe 0 (map _.port primary)
      endpoint = if port == 0 then "" else p.scheme <> "://127.0.0.1:" <> show port
  when (active && port == 0) $ throw "Native service manager omitted the primary port binding"
  pure { name, state: row.state, backend: "docker", host: "127.0.0.1", port, endpoint, ports: bindings }

current :: Profile -> Control -> Effect ServiceResult
current p cfg = statuses cfg >>= result p cfg.name <<< A.find (\row -> row.name == cfg.name)

start :: Effect Unit -> String -> Json -> Effect ServiceResult
start setup tool json = do
  p <- profile tool
  fields <- input [ "project", "name", "image", "version", "port", "ports", "volumes", "env", "command", "dependsOn", "startupTimeoutMs", "stopTimeoutMs", "restartPolicy", "maxRestarts", "healthCheck", "readinessCommand", "readinessPath", "stateDir" ] json
  cfg <- control p fields
  image <- optional fields "image" ""
  when (O.member "image" fields && image == "") $ throw "image must be nonempty"
  version <- optional fields "version" p.version
  when (O.member "image" fields && O.member "version" fields) $ throw "Use image or version, not both"
  tagValid <- matches "^[A-Za-z0-9_][A-Za-z0-9_.-]{0,127}$" version
  unless tagValid $ throw "Invalid image version tag"
  let selected = if image == "" then p.image <> ":" <> version else image
  validateImage selected
  hostPort <- optional fields "port" (if tool == "aws-emulator" then 9297 else 0)
  bounded "port" (if tool == "aws-emulator" then 1 else 0) 65535 hostPort
  let primary = if tool == "aws-emulator" then hostPort else p.port
  suppliedPorts <- csv fields "ports"
  let ports = if A.null suppliedPorts then map (\port -> if port == p.port && hostPort > 0 then show hostPort <> ":" <> show primary else show port) p.ports else suppliedPorts
  targets <- traverse containerPort ports
  unless (A.elem primary targets && A.length targets == A.length (A.nub targets)) $ throw "ports must include the primary port exactly once, without duplicate container ports"
  when (tool == "aws-emulator" && ports /= [ show primary <> ":" <> show primary ]) $ throw "AWS Emulator requires the same fixed host and container port"
  volumes <- csv fields "volumes"
  traverse_ validateVolume volumes
  let volumeTarget value = fromMaybe value (A.index (S.split (Pattern ":") value) 1)
      userTargets = map volumeTarget volumes
  unless (A.length userTargets == A.length (A.nub userTargets)) $ throw "Duplicate container volume target"
  when (tool == "aws-emulator" && A.elem "/home/emulator/.aws/emulator" userTargets) $ throw "Use stateDir for AWS Emulator credential material"
  env <- csv fields "env" >>= environment p
  command <- csv fields "command"
  depends <- csv fields "dependsOn"
  traverse_ (\name -> do
    valid <- matches "^[A-Za-z0-9_-]{1,64}$" name
    unless (valid && name /= cfg.name) $ throw "Invalid or self-referencing dependsOn entry") depends
  startup <- optional fields "startupTimeoutMs" p.timeout
  shutdown <- optional fields "stopTimeoutMs" 5000
  restarts <- optional fields "maxRestarts" 0
  policy <- optional fields "restartPolicy" "never"
  health <- optional fields "healthCheck" true
  bounded "startupTimeoutMs" 100 600000 startup
  bounded "stopTimeoutMs" 100 120000 shutdown
  bounded "maxRestarts" 0 100 restarts
  unless (A.elem policy [ "never", "on_failure", "always" ]) $ throw "Invalid restartPolicy"
  readyCommand <- csv fields "readinessCommand"
  readyPath <- optional fields "readinessPath" p.path
  unless (S.startsWith (Pattern "/") readyPath && not (S.contains (Pattern "\x0000") readyPath)) $ throw "readinessPath must be an absolute URL path without NUL"
  stateDir <- optional fields "stateDir" ""
  when (tool == "aws-emulator") $ absoluteDirectory stateDir
  when (tool /= "aws-emulator" && stateDir /= "") $ throw "stateDir is specific to AWS Emulator; use volumes for other services"
  let readiness = if not (A.null readyCommand) || p.probe == "exec" then object [ Tuple "type" (encodeJson "exec"), Tuple "command" (encodeJson (if A.null readyCommand then p.exec else readyCommand)) ]
        else if p.probe == "http" then object [ Tuple "type" (encodeJson "http"), Tuple "url" (encodeJson ("http://${port:" <> show primary <> "}" <> readyPath)), Tuple "status" (encodeJson 200) ]
        else object [ Tuple "type" (encodeJson "tcp"), Tuple "address" (encodeJson ("${port:" <> show primary <> "}")) ]
      selectedCommand = if tool == "aws-emulator" && A.null command then [ "-p", show primary ] else if A.null command then p.command else command
      selectedVolumes = A.filter (\volume -> not (A.elem (volumeTarget volume) userTargets)) p.volumes <> volumes <> if tool == "aws-emulator" then [ stateDir <> ":/home/emulator/.aws/emulator" ] else []
      definition = object ([ Tuple "name" (encodeJson cfg.name), Tuple "backend" (encodeJson "docker"), Tuple "image" (encodeJson selected), Tuple "command" (encodeJson selectedCommand), Tuple "env" (encodeJson env), Tuple "ports" (encodeJson ports), Tuple "volumes" (encodeJson selectedVolumes), Tuple "depends_on" (encodeJson depends), Tuple "readiness" readiness, Tuple "restart" (encodeJson policy), Tuple "max_restarts" (encodeJson restarts), Tuple "startup_timeout_ms" (encodeJson startup), Tuple "stop_timeout_ms" (encodeJson shutdown) ] <> if health then [ Tuple "health" readiness ] else [])
  validateHost
  existing <- current p cfg
  setup
  void (capture cfg.project [ "docker", "info" ])
  when (tool == "aws-emulator") do
    void (capture cfg.project [ "docker", "image", "inspect", selected ])
    void (capture cfg.project [ "mkdir", "-p", stateDir ])
  raw <- capture cfg.project [ "fluentci", "services", "apply", "--json", stringify (encodeJson [ definition ]) ]
  response <- either (const (throw "Native service manager returned malformed apply JSON")) pure (jsonParser raw)
  ok <- either (const (throw "Invalid service apply acknowledgement")) pure (decodeJson response >>= \fields -> getField fields "ok")
  unless ok $ throw "Native service manager refused startup"
  rows <- either (const (throw "Invalid service apply states")) pure (decodeJson response >>= \fields -> getField fields "services")
  started <- result (p { port = primary }) cfg.name (A.find (\row -> row.name == cfg.name) rows)
  unless (started.state == "ready") $ throw "Native service did not reach readiness"
  when (tool == "aws-emulator") do
    checked <- try do
      let material = stateDir <> "/" <> show primary
      traverse_ (\file -> void (capture cfg.project [ "test", "-r", material <> "/" <> file ])) [ "ca.pem", "emulator_credentials", "config" ]
      void (capture cfg.project [ "curl", "--fail", "--silent", "--show-error", "--max-time", "10", "--cacert", material <> "/ca.pem", started.endpoint <> "/__admin/health" ])
    case checked of
      Right _ -> pure unit
      Left error -> do
        when (A.elem existing.state [ "absent", "stopped" ]) $
          catchException (const (pure unit)) (void (capture cfg.project [ "fluentci", "stop", cfg.name ]))
        throw (message error)
  pure started

status :: String -> Json -> Effect ServiceResult
status tool json = do
  p <- profile tool
  fields <- input [ "project", "name" ] json
  cfg <- control p fields
  validateHost
  current p cfg

stop :: String -> Json -> Effect ServiceResult
stop tool json = do
  p <- profile tool
  fields <- input [ "project", "name" ] json
  cfg <- control p fields
  validateHost
  before <- current p cfg
  if A.elem before.state [ "absent", "stopped" ] then pure (before { state = "stopped" }) else do
    void (capture cfg.project [ "fluentci", "stop", cfg.name ])
    stopped <- current p cfg
    unless (A.elem stopped.state [ "stopped", "absent" ]) $ throw "Native service manager did not stop the service"
    pure (stopped { state = "stopped" })

restart :: Effect Unit -> String -> Json -> Effect ServiceResult
restart setup tool json = do
  p <- profile tool
  fields <- input [ "project", "name" ] json
  cfg <- control p fields
  validateHost
  before <- current p cfg
  when (before.state == "absent") $ throw "Start this service before restarting it"
  setup
  void (capture cfg.project [ "docker", "info" ])
  void (capture cfg.project [ "fluentci", "restart", cfg.name ])
  restarted <- current p cfg
  unless (restarted.state == "ready") $ throw "Native service failed to become ready after restart"
  pure restarted

logs :: String -> Json -> Effect String
logs tool json = do
  p <- profile tool
  fields <- input [ "project", "name", "tail", "follow" ] json
  cfg <- control p fields
  tail <- optional fields "tail" 100
  follow <- optional fields "follow" false
  bounded "tail" 1 10000 tail
  validateHost
  void (current p cfg)
  capture cfg.project ([ "fluentci", "logs", cfg.name, "--tail", show tail ] <> if follow then [ "--follow" ] else [])
