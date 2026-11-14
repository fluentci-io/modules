foreign import installDependency :: String -> Effect Unit

probe :: Array String -> Effect Unit
probe args = do
  result <- P.pipeline "setup-dependency-preflight" # P.exec args # P.stdout
  case result of
    Left error -> throw (P.errorMessage error)
    Right _ -> pure unit

ensure :: String -> Array String -> Effect Unit
ensure alias args = do
  present <- try (probe args)
  case present of
    Right _ -> pure unit
    Left _ -> do
      installDependency alias
      probe args

