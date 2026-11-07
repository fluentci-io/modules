module CI.Cachix.Support (run, unwrap, requiredEnv) where

import Prelude
import Data.Either (Either(..))
import Data.Foldable (foldl)
import Effect (Effect)
import Effect.Exception (throw)
import FluentCI.Plugin as P

unwrap :: forall a. P.Result a -> Effect a
unwrap = case _ of
  Left error -> throw (P.errorMessage error)
  Right value -> pure value

requiredEnv :: String -> Effect String
requiredEnv name = do
  present <- P.hasEnv name >>= unwrap
  unless present $ throw ("Set " <> name <> " before running this job")
  value <- P.getEnv name >>= unwrap
  when (value == "") $ throw ("Set " <> name <> " before running this job")
  pure value

run :: String -> Array (Array String) -> Effect Unit
run name commands = do
  text <- foldl (flip P.exec) (P.pipeline name) commands # P.stdout >>= unwrap
  P.output text >>= unwrap
