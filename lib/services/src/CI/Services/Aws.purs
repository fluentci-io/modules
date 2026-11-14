module CI.Services.Aws (build) where

import Prelude
import CI.Services as Services
import Data.Argonaut.Core (Json, stringify)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, getFieldOptional)
import Data.Argonaut.Encode (encodeJson)
import Data.Array as A
import Data.Either (either)
import Data.Foldable (all)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as S
import Data.String.CodeUnits as CU
import Data.String.Common (trim)
import Data.String.Pattern (Pattern(..))
import Effect (Effect)
import Effect.Exception (catchException, message, throw)
import FluentCI.Host.Client (RunOutcome(..))
import FluentCI.Host.Files as Files
import FluentCI.Host.Plan as Plan
import FluentCI.Plugin as P
import Foreign.Object as O

optional :: forall a. DecodeJson a => O.Object Json -> String -> a -> Effect a
optional fields key fallback = either (throw <<< show) (pure <<< fromMaybe fallback) (getFieldOptional fields key)

build :: Effect Unit -> Json -> Effect String
build setup json = do
  fields <- either (throw <<< show) pure (decodeJson json)
  unless (all (\key -> A.elem key [ "project", "image", "architecture", "packageUrl", "packageSha256", "timeoutMs" ]) (O.keys fields)) $ throw "Unknown AWS Emulator image build argument"
  project <- optional fields "project" "."
  image <- optional fields "image" "fluentci/aws-emulator:local"
  arch <- optional fields "architecture" "auto"
  packageUrl <- optional fields "packageUrl" ""
  sha <- optional fields "packageSha256" ""
  timeout <- optional fields "timeoutMs" 1800000
  Services.validateImage image
  when (S.contains (Pattern "@") image) $ throw "Image build output needs a tag, not a digest"
  unless (trim project /= "" && not (S.contains (Pattern "\x0000") project)) $ throw "Invalid build project"
  unless (A.elem arch [ "auto", "x86_64", "aarch64" ]) $ throw "architecture must be auto, x86_64 or aarch64"
  when (sha /= "" && not (CU.length sha == 64 && all (\c -> (c >= 'a' && c <= 'f') || (c >= '0' && c <= '9')) (CU.toCharArray sha))) $ throw "packageSha256 must be a lowercase SHA-256"
  when (packageUrl /= "" && (not (S.startsWith (Pattern "https://") packageUrl) || sha == "" || not (all (\c -> c > ' ' && c /= '\x007f') (CU.toCharArray packageUrl)))) $ throw "Custom packageUrl requires HTTPS and packageSha256"
  unless (timeout >= 1000 && timeout <= 3600000) $ throw "timeoutMs must be from 1000 to 3600000"
  Services.validateHost
  setup
  daemonArch <- trim <$> Services.capture project [ "docker", "info", "--format", "{{.Architecture}}" ]
  let detected = if A.elem daemonArch [ "amd64", "x86_64" ] then "x86_64" else if A.elem daemonArch [ "arm64", "aarch64" ] then "aarch64" else ""
      selected = if arch == "auto" then detected else arch
  unless (A.elem selected [ "x86_64", "aarch64" ]) $ throw "Docker daemon architecture is not supported by AWS Emulator"
  uid <- trim <$> Services.capture project [ "id", "-u" ]
  gid <- trim <$> Services.capture project [ "id", "-g" ]
  unless (uid /= "" && gid /= "" && all (\c -> c >= '0' && c <= '9') (CU.toCharArray (uid <> gid))) $ throw "Unable to determine image file ownership"
  let url = if packageUrl == "" then "https://downloads.aws.com/aws-emulator/packages/aws-emulator/LTS/latest/aws-emulator-" <> selected <> ".rpm" else packageUrl
      -- JSON-form Dockerfile instructions keep implementation logic in PureScript.
      run args = "RUN " <> stringify (encodeJson args) <> "\n"
      recipe = "FROM public.ecr.aws/amazonlinux/amazonlinux:2023-minimal\nADD " <> (if sha == "" then "" else "--checksum=sha256:" <> sha <> " ") <> url <> " /tmp/aws-emulator.rpm\n"
        <> run [ "microdnf", "install", "-y", "curl-minimal" ] <> run [ "microdnf", "clean", "all" ]
        <> run [ "rpm", "-i", "/tmp/aws-emulator.rpm" ] <> run [ "rm", "/tmp/aws-emulator.rpm" ]
        <> run [ "mkdir", "-p", "/home/emulator/.aws/emulator" ] <> run [ "chown", "-R", uid <> ":" <> gid, "/home/emulator" ]
        <> "USER " <> uid <> ":" <> gid <> "\nENV HOME=/home/emulator EMULATOR_TELEMETRY=off\nEXPOSE 9297\nENTRYPOINT [\"aws-emulator\", \"-b\", \"0.0.0.0\"]\n"
  temp <- trim <$> Services.capture project [ "mktemp", "-d", "/tmp/fluentci-aws-image.XXXXXXXX" ]
  unless (S.startsWith (Pattern "/tmp/fluentci-aws-image.") temp && not (S.contains (Pattern "\n") temp) && not (S.contains (Pattern "/../") temp)) $ throw "Invalid image build temporary directory"
  let recipeTask = Files.writeText "recipe" "Dockerfile" recipe false temp
      buildTask = Plan.task "build" "docker" project # Plan.withArgs [ "build", "--platform", if selected == "aarch64" then "linux/arm64" else "linux/amd64", "--tag", image, "--file", temp <> "/Dockerfile", temp ] # Plan.after [ recipeTask ] # Plan.withTimeout timeout
      cleanup = void (Services.capture project [ "rm", "-rf", "--", temp ])
  catchException (\error -> do
    catchException (const (pure unit)) cleanup
    throw (message error)) do
      report <- P.runPlan (temp <> "/run") (Plan.plan [ recipeTask, buildTask ] # Plan.withInheritedEnv true) >>= Services.unwrap
      unless (report.outcome == Just RunSucceeded) $ throw "AWS Emulator image build failed"
      cleanup
      pure image
