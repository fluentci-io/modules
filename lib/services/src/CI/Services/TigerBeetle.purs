module CI.Services.TigerBeetle (start, stop, restart, status, logs) where

import Prelude
import CI.Contract as Contract
import CI.Contract.CSV as CSV
import CI.Services (ServiceResult, capture, unwrap)
import Data.Argonaut.Core (Json, stringify)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, getFieldOptional)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Parser (jsonParser)
import Data.Array as A
import Data.Either (Either(..), either)
import Data.Foldable (all, any, traverse_)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as S
import Data.String.CodeUnits as CU
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..))
import Data.String.Regex as Regex
import Data.String.Regex.Flags (noFlags)
import Effect (Effect)
import Effect.Exception (catchException, message, throw, try)
import FluentCI.Host.Client (RunOutcome(..))
import FluentCI.Host.Files as Files
import FluentCI.Host.Plan as Plan
import FluentCI.Plugin as P
import Foreign.Object as O

foreign import setupTigerBeetle :: String -> Effect Contract.SetupResult

type Control = { project :: String, name :: String }
type Wire = { name :: String, backend :: String, state :: String }
type Metadata = { owner :: String, name :: String, port :: Int, signature :: String }

optional :: forall a. DecodeJson a => O.Object Json -> String -> a -> Effect a
optional fields key fallback = either (throw <<< show) (pure <<< fromMaybe fallback) (getFieldOptional fields key)

input :: Array String -> Json -> Effect (O.Object Json)
input allowed json = do
  fields <- either (throw <<< show) pure (decodeJson json)
  traverse_ (\key -> unless (A.elem key allowed) $ throw ("Unknown TigerBeetle argument: " <> key)) (O.keys fields)
  pure fields

validText :: String -> Boolean
validText value = trim value /= "" && all (\c -> c /= '\x0000' && c /= '\n' && c /= '\r') (CU.toCharArray value)

control :: O.Object Json -> Effect Control
control fields = do
  project <- optional fields "project" "."
  name <- optional fields "name" "module-tigerbeetle-default"
  valid <- either throw pure (Regex.regex "^module-tigerbeetle-[A-Za-z0-9_-]{1,64}$" noFlags) <#> flip Regex.test name
  unless (validText project && valid) $ throw "Invalid or foreign TigerBeetle service control"
  pure { project, name }

host :: Effect Unit
host = do
  os <- P.getOS >>= unwrap
  unless (A.elem os [ "linux", "macos" ]) $ throw ("TigerBeetle host services support Linux and macOS only; unsupported OS: " <> os)

marker :: Control -> String
marker cfg = ".fluentci/tigerbeetle/" <> cfg.name <> ".json"

readMetadata :: Control -> Effect Metadata
readMetadata cfg = do
  text <- capture cfg.project [ "cat", marker cfg ]
  json <- either throw pure (jsonParser text)
  metadata <- either (throw <<< show) pure (decodeJson json)
  unless (metadata.owner == "fluentci-tigerbeetle-v1" && metadata.name == cfg.name && metadata.port >= 1 && metadata.port <= 65535) $ throw "Invalid TigerBeetle ownership metadata"
  pure metadata

owned :: Control -> Effect (Maybe Wire)
owned cfg = do
  text <- capture cfg.project [ "fluentci", "services", "status", "--json" ]
  json <- either throw pure (jsonParser text)
  rows <- either (throw <<< show) pure (decodeJson json)
  let found = A.find (\row -> row.name == cfg.name) rows
  traverse_ (\row -> do
    unless (row.backend == "host") $ throw "Refusing an unrelated non-host TigerBeetle service"
    void (readMetadata cfg)) found
  pure found

result :: Control -> Maybe Wire -> Effect ServiceResult
result cfg found = do
  let state = fromMaybe "absent" (map _.state found)
      active = A.elem state [ "ready", "running" ]
  port <- if active then _.port <$> readMetadata cfg else pure 0
  let address = "127.0.0.1:" <> show port
  pure { name: cfg.name, state, backend: "host", host: "127.0.0.1", port
       , endpoint: if active then "tigerbeetle://" <> address else ""
       , ports: if active then [ { containerPort: port, port, address } ] else [] }

writeMetadata :: Control -> Metadata -> Effect Unit
writeMetadata cfg metadata = do
  void (capture cfg.project [ "mkdir", "-p", ".fluentci/tigerbeetle" ])
  temp <- trim <$> capture cfg.project [ "mktemp", "-d", "/tmp/fluentci-tigerbeetle.XXXXXXXX" ]
  unless (S.startsWith (Pattern "/tmp/fluentci-tigerbeetle.") temp && validText temp && not (S.contains (Pattern "/../") temp)) $ throw "Invalid TigerBeetle task directory"
  let cleanup = catchException (const (pure unit)) (void (capture cfg.project [ "rm", "-rf", "--", temp ]))
  checked <- try do
    report <- P.runPlan (temp <> "/run") (Plan.plan [ Files.writeText "ownership" (marker cfg) (stringify (encodeJson metadata)) true cfg.project ]) >>= unwrap
    unless (report.outcome == Just RunSucceeded) $ throw "TigerBeetle ownership metadata write failed"
  cleanup
  either (throw <<< message) pure checked

start :: Json -> Effect ServiceResult
start json = do
  fields <- input [ "project", "name", "version", "port", "stateDir", "cacheGrid", "extraArgs", "startupTimeoutMs", "stopTimeoutMs" ] json
  cfg <- control fields
  version <- optional fields "version" "0.17.9"
  port <- optional fields "port" 3000
  stateDir <- optional fields "stateDir" ""
  cacheGrid <- optional fields "cacheGrid" "256MiB"
  extra <- optional fields "extraArgs" "" >>= either throw pure <<< CSV.parse
  startup <- optional fields "startupTimeoutMs" 60000
  shutdown <- optional fields "stopTimeoutMs" 5000
  validVersion <- either throw pure (Regex.regex "^(latest|[0-9]+\\.[0-9]+\\.[0-9]+)$" noFlags) <#> flip Regex.test version
  validCache <- either throw pure (Regex.regex "^[1-9][0-9]*(MiB|GiB)$" noFlags) <#> flip Regex.test cacheGrid
  unless (validVersion && validCache && port >= 1 && port <= 65535 && startup >= 100 && startup <= 600000 && shutdown >= 100 && shutdown <= 120000) $ throw "Invalid TigerBeetle version, port, cache size, or deadline"
  unless (validText stateDir && S.startsWith (Pattern "/") stateDir && stateDir /= "/" && not (A.elem ".." (S.split (Pattern "/") stateDir))) $ throw "stateDir must be an absolute caller-owned data directory"
  unless (all (\value -> validText value && not (S.startsWith (Pattern "--addresses") value) && not (S.startsWith (Pattern "--cache-grid") value) && S.startsWith (Pattern "--") value) extra) $ throw "extraArgs must be nonempty native option tokens; addresses and cache-grid use typed arguments"
  let signature = stringify (encodeJson { version, port, stateDir, cacheGrid, extra, startup, shutdown })
  host
  before <- owned cfg
  if any (\row -> A.elem row.state [ "ready", "running" ]) before then do
    metadata <- readMetadata cfg
    unless (metadata.signature == signature) $ throw "Stop TigerBeetle before changing its configuration"
    result cfg before
  else do
    installed <- setupTigerBeetle version
    unless (installed.tool == "tigerbeetle" && S.startsWith (Pattern "/") installed.binDir) $ throw "Invalid setup-tigerbeetle result"
    let executable = installed.binDir <> "/tigerbeetle"
        dataFile = stateDir <> "/0_0.tigerbeetle"
    void (capture cfg.project [ "mkdir", "-p", stateDir ])
    exists <- try (capture cfg.project [ "test", "-f", dataFile ])
    case exists of
      Right _ -> pure unit
      Left _ -> do
        let guard = stateDir <> "/.fluentci-format.guard"
        void (capture cfg.project [ "mkdir", guard ])
        formatted <- try do
          stillMissing <- try (capture cfg.project [ "test", "-f", dataFile ])
          case stillMissing of
            Right _ -> pure unit
            Left _ -> void (capture cfg.project [ executable, "format", "--cluster=0", "--replica=0", "--replica-count=1", "--development", dataFile ])
        void (capture cfg.project [ "rmdir", guard ])
        either (throw <<< message) pure formatted
    writeMetadata cfg { owner: "fluentci-tigerbeetle-v1", name: cfg.name, port, signature }
    let probe = { type: "tcp", address: "127.0.0.1:" <> show port }
        definition = { name: cfg.name, backend: "host", command: [ executable, "start", "--addresses=127.0.0.1:" <> show port, "--development", "--cache-grid=" <> cacheGrid ] <> extra <> [ dataFile ], readiness: probe, health: probe, restart: "never", max_restarts: 0, startup_timeout_ms: startup, stop_timeout_ms: shutdown }
    checked <- try do
      void (capture cfg.project [ "fluentci", "services", "apply", "--json", stringify (encodeJson [ definition ]) ])
      running <- owned cfg
      unless (map _.state running == Just "ready") $ throw "Native TigerBeetle service did not become ready"
      result cfg running
    case checked of
      Right value -> pure value
      Left error -> do
        catchException (const (pure unit)) (void (capture cfg.project [ "fluentci", "stop", cfg.name ]))
        throw (message error)

status :: Json -> Effect ServiceResult
status json = do
  fields <- input [ "project", "name" ] json
  cfg <- control fields
  host
  owned cfg >>= result cfg

stop :: Json -> Effect ServiceResult
stop json = do
  fields <- input [ "project", "name" ] json
  cfg <- control fields
  host
  before <- owned cfg
  when (any (\row -> not (A.elem row.state [ "absent", "stopped" ])) before) $ void (capture cfg.project [ "fluentci", "stop", cfg.name ])
  stopped <- owned cfg >>= result cfg
  unless (A.elem stopped.state [ "absent", "stopped" ]) $ throw "TigerBeetle did not stop"
  pure (stopped { state = "stopped" })

restart :: Json -> Effect ServiceResult
restart json = do
  fields <- input [ "project", "name" ] json
  cfg <- control fields
  host
  before <- owned cfg
  when (before == Nothing) $ throw "Start TigerBeetle before restarting it"
  void (capture cfg.project [ "fluentci", "restart", cfg.name ])
  running <- owned cfg >>= result cfg
  unless (running.state == "ready") $ throw "TigerBeetle did not become ready after restart"
  pure running

logs :: Json -> Effect String
logs json = do
  fields <- input [ "project", "name", "tail", "follow" ] json
  cfg <- control fields
  tail <- optional fields "tail" 100
  follow <- optional fields "follow" false
  unless (tail >= 1 && tail <= 10000) $ throw "Invalid tail count"
  host
  void (owned cfg)
  capture cfg.project ([ "fluentci", "logs", cfg.name, "--tail", show tail ] <> if follow then [ "--follow" ] else [])
