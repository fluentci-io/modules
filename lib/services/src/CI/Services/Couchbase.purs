module CI.Services.Couchbase (initialize, createBucket, configureNetwork) where

import Prelude
import CI.Contract.CSV as CSV
import CI.Services as Services
import Data.Argonaut.Core (Json)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, getFieldOptional)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Parser (jsonParser)
import Data.Array as A
import Data.Either (either)
import Data.Foldable (all, any, traverse_)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as S
import Data.String.CodeUnits as CU
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..))
import Data.String.Regex as Regex
import Data.String.Regex.Flags (noFlags)
import Effect (Effect)
import Effect.Exception (throw)
import Foreign.Object as O

optional :: forall a. DecodeJson a => O.Object Json -> String -> a -> Effect a
optional fields key fallback = either (throw <<< show) (pure <<< fromMaybe fallback) (getFieldOptional fields key)

fields :: Array String -> Json -> Effect (O.Object Json)
fields allowed json = do
  value <- either (throw <<< show) pure (decodeJson json)
  traverse_ (\key -> unless (A.elem key allowed) $ throw ("Unknown Couchbase argument: " <> key)) (O.keys value)
  pure value

safeText :: String -> Boolean
safeText value = trim value /= "" && all (\c -> c /= '\x0000' && c /= '\n' && c /= '\r') (CU.toCharArray value)

connection :: Effect Unit -> O.Object Json -> Effect { project :: String, name :: String, endpoint :: String, user :: String, password :: String }
connection setup value = do
  project <- optional value "project" "."
  name <- optional value "name" "module-couchbase-default"
  user <- optional value "username" "Administrator"
  password <- optional value "password" "fluentci-test-password"
  unless (safeText user && safeText password && not (S.contains (Pattern ":") user)) $ throw "Invalid Couchbase credentials"
  running <- Services.status "couchbase" (encodeJson { project, name })
  unless (running.state == "ready") $ throw "Start the Couchbase service before initializing it"
  setup
  pure { project, name, endpoint: running.endpoint, user, password }

request :: { project :: String, name :: String, endpoint :: String, user :: String, password :: String } -> Boolean -> String -> Array String -> Effect String
request cfg authenticated path args = Services.capture cfg.project
  ([ "curl", "--fail", "--silent", "--show-error", "--max-time", "60" ] <>
   (if authenticated then [ "--user", cfg.user <> ":" <> cfg.password ] else []) <>
   args <> [ cfg.endpoint <> path ])

initialize :: Effect Unit -> Json -> Effect String
initialize setup json = do
  value <- fields [ "project", "name", "username", "password", "services", "memoryQuotaMb" ] json
  requested <- optional value "services" "kv" >>= either throw pure <<< CSV.parse
  quota <- optional value "memoryQuotaMb" 256
  unless (not (A.null requested) && A.length requested == A.length (A.nub requested) && all (\service -> A.elem service [ "kv", "n1ql", "index", "fts", "cbas", "eventing" ]) requested && quota >= 256 && quota <= 65536) $ throw "Invalid Couchbase services or memory quota"
  cfg <- connection setup value
  raw <- request cfg false "/pools" []
  parsed <- either throw pure (jsonParser raw)
  object <- either (throw <<< show) pure (decodeJson parsed)
  pools <- optional object "pools" ([] :: Array Json)
  if A.null pools then void (request cfg false "/clusterInit"
    [ "--data-urlencode", "username=" <> cfg.user, "--data-urlencode", "password=" <> cfg.password
    , "--data-urlencode", "clusterName=" <> cfg.name, "--data-urlencode", "services=" <> S.joinWith "," requested
    , "--data-urlencode", "memoryQuota=" <> show quota ])
  else void (request cfg true "/pools/default" [])
  pure cfg.name

createBucket :: Effect Unit -> Json -> Effect String
createBucket setup json = do
  value <- fields [ "project", "name", "username", "password", "bucket", "ramQuotaMb", "flushEnabled" ] json
  bucket <- optional value "bucket" "fluentci_test"
  quota <- optional value "ramQuotaMb" 128
  flush <- optional value "flushEnabled" false
  valid <- either throw pure (Regex.regex "^[A-Za-z0-9._%-]{1,100}$" noFlags) <#> flip Regex.test bucket
  unless (valid && quota >= 100 && quota <= 65536) $ throw "Invalid Couchbase bucket name or memory quota"
  cfg <- connection setup value
  raw <- request cfg true "/pools/default/buckets" []
  parsed <- either throw pure (jsonParser raw)
  buckets <- either (throw <<< show) pure (decodeJson parsed) :: Effect (Array { name :: String })
  unless (any (\entry -> entry.name == bucket) buckets) $ void (request cfg true "/pools/default/buckets"
    [ "--data-urlencode", "name=" <> bucket, "--data-urlencode", "bucketType=couchbase"
    , "--data-urlencode", "ramQuotaMB=" <> show quota, "--data-urlencode", "flushEnabled=" <> if flush then "1" else "0" ])
  pure bucket

-- Advertise the actual native Docker bindings to SDK clients on the runner.
configureNetwork :: Effect Unit -> Json -> Effect String
configureNetwork setup json = do
  value <- fields [ "project", "name", "username", "password" ] json
  cfg <- connection setup value
  running <- Services.status "couchbase" (encodeJson { project: cfg.project, name: cfg.name })
  let ports = A.mapMaybe (\binding -> map (\service -> [ "--data-urlencode", service <> "=" <> show binding.port ])
        (lookupService binding.containerPort)) running.ports
  void (request cfg true "/node/controller/setupAlternateAddresses/external"
    ([ "--request", "PUT", "--data-urlencode", "hostname=127.0.0.1" ] <> A.concat ports))
  pure running.endpoint
  where
  lookupService port = case port of
    8091 -> Just "mgmt"
    11210 -> Just "kv"
    8093 -> Just "n1ql"
    8094 -> Just "fts"
    8095 -> Just "cbas"
    _ -> Nothing
