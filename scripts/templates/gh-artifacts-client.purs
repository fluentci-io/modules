  when (executable == "bun") $ do
    available <- P.hasEnv "FLUENTCI_GH_ARTIFACT_CLIENT" >>= case _ of
      Left error -> throw (P.errorMessage error)
      Right value -> pure value
    location <-
      if available then do
        result <- P.getEnv "FLUENTCI_GH_ARTIFACT_CLIENT"
        case result of
          Left error -> throw (P.errorMessage error)
          Right value -> pure value
      else pure ""
    when (trim location == "") $ do
      installDependency "setup-gh-artifacts"
      configured <- P.getEnv "FLUENTCI_GH_ARTIFACT_CLIENT"
      case configured of
        Right value | trim value /= "" -> pure unit
        _ -> throw "setup-gh-artifacts did not configure the artifact client SDK"
