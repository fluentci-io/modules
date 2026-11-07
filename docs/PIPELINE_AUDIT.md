# Pipeline module audit

The registry contains 165 modules. This inventory covers every public
WebAssembly function, including diagnostics and literal-argument escape hatches.
Regenerate with `python3 scripts/audit_modules.py`; CI checks for drift.

## Execution and failure contracts

- Setup functions install prerequisites, verify the executable/version, and publish PATH.
  Native repositories determine BSD availability; package failures remain failures.
  Nix installers reject BSD; dpkg and rpmbuild reject non-Linux hosts.
- CLI functions validate typed input, OS, working directory, and executable before execution.
  Upload file arguments marked in the catalog are checked before starting the command.
  Every invocation needs a fresh run directory, records stdout/stderr and result JSON,
  and propagates a nonzero command exit, timeout, cancellation, or host failure.
- `artifacts` declares named output files for size/SHA-256 reporting. Output files and
  remote identifiers still depend on the native command; see each module’s OPTIONS.md.
- Diagnostics support toolchain troubleshooting and cache inspection; `run` supports
  native features without inventing unsupported service endpoints. Ubicloud is a
  server-defined CLI and deliberately relies on authenticated command discovery.
- Accounts, registries, clusters, remote caches, and secret services use inherited
  credentials or existing native configuration. Tokens do not belong in module JSON.

## Policy decisions for pipeline authors

- Formatter check exports and lint/test exports are gates; format/install exports mutate files.
- Scorecard scan produces findings; its `gate` export enforces a minimum per-check score.
  Syft produces an SBOM; use Grype or Trivy to evaluate vulnerabilities in that inventory.
- SonarScanner needs the server-side quality gate wait option when a blocking gate is needed.
  Coverage upload success confirms delivery, not a passing coverage threshold.
- Terraform/OpenTofu plans do not enable detailed exit codes by default. Use the native
  options deliberately: exit code 2 is treated as a failed task by the shared executor.
- Preview deployments and infrastructure plans are available separately from mutations.
  Apply/destroy/deploy exports execute immediately; review and approvals belong in the CI engine.
- GitHub job upload requires the Actions runtime; GitLab job upload requires an active job token.
  Release upload functions serve other runners. Tangled requires a pushed annotated tag
  and the repository owner’s app password in its uploader environment variable.
- Docker/Podman and build daemons, Kubernetes contexts, Python/Java/Ruby toolchains, and
  native mobile SDKs remain host prerequisites where documented. Installing a CLI does
  not start a daemon, create an account, or provision a cluster.
- Mutable channels such as latest should be pinned for reproducibility. Native package
  selectors must exist in the configured repository. XTP has a latest-only public endpoint;
  Python PDK v0.1.5 has no Linux ARM64 release. These limitations are explicit failures.

## Validation scope

Compiled PureScript tests cover argv, input rejection, supported OS routing, failure
propagation, environment publication, and artifact declarations. Local fixtures cover
native packaging/builds, formatting/linting, browsers, secret detection, and SBOM output
when their tools are installed. Upload adapters use synthetic credentials and controlled
responses. No live cloud deployment, secret service mutation, or paid upload is claimed.
BSD package routing is fixture-tested; availability varies by OS release and repository.

## Export inventory

| Module | CI/CD purpose | Public functions |
| --- | --- | --- |
| [actionlint](../linting/actionlint/README.md) | Check source or configuration and fail on lint violations. | `run` (escape hatch), `version` (diagnostic), `lint` (pipeline operation) |
| [argocd](../deployment/argocd/README.md) | Deploy an application and inspect its rollout or service state. | `run` (escape hatch), `version` (diagnostic), `app_get` (pipeline operation), `app_sync` (pipeline operation), `app_wait` (pipeline operation) |
| [artifactory](../artifacts/artifactory/README.md) | Publish or retrieve build outputs and release assets. | `run` (escape hatch), `version` (diagnostic), `upload` (pipeline operation), `download` (pipeline operation), `search` (pipeline operation) |
| [aws](../cloud/aws/README.md) | Inspect accounts, provision resources, or transfer deployment outputs. | `run` (escape hatch), `version` (diagnostic), `identity` (pipeline operation), `s3_cp` (pipeline operation), `s3_sync` (pipeline operation), `cloudformation_deploy` (pipeline operation) |
| [azure](../cloud/azure/README.md) | Inspect accounts, provision resources, or transfer deployment outputs. | `run` (escape hatch), `version` (diagnostic), `account_show` (pipeline operation), `group_deploy` (pipeline operation), `webapp_deploy` (pipeline operation) |
| [bazel](../build/bazel/README.md) | Configure, compile, test, or inspect a build graph. | `run` (escape hatch), `version` (diagnostic), `build` (pipeline operation), `test` (pipeline operation), `run_target` (pipeline operation), `query` (diagnostic), `clean` (pipeline operation) |
| [betterleaks](../security/betterleaks/README.md) | Produce security findings, inventory dependencies, or enforce a security gate. | `run` (escape hatch), `version` (diagnostic), `scan_dir` (pipeline operation), `scan_git` (pipeline operation) |
| [biome](../linting/biome/README.md) | Check source or configuration and fail on lint violations. | `run` (escape hatch), `version` (diagnostic), `check` (pipeline operation), `lint` (pipeline operation), `format` (pipeline operation), `ci` (pipeline operation) |
| [black](../formatting/black/README.md) | Format source files or fail CI when formatting differs. | `run` (escape hatch), `version` (diagnostic), `format` (pipeline operation), `check` (pipeline operation) |
| [buildkit](../containers/buildkit/README.md) | Build, tag, publish, or inspect container images and build caches. | `run` (escape hatch), `version` (diagnostic), `build` (pipeline operation), `prune` (pipeline operation), `du` (diagnostic) |
| [buildx](../containers/buildx/README.md) | Build, tag, publish, or inspect container images and build caches. | `buildx` (pipeline operation), `dap` (pipeline operation), `debug` (pipeline operation), `history` (pipeline operation), `imagetools` (pipeline operation), `policy` (pipeline operation), `bake` (pipeline operation), `build` (pipeline operation), `create` (pipeline operation), `dial_stdio` (pipeline operation), `du` (diagnostic), `inspect` (pipeline operation), `ls` (pipeline operation), `prune` (pipeline operation), `rm` (pipeline operation), `stop` (pipeline operation), `use` (pipeline operation), `version` (diagnostic), `dap_build` (pipeline operation), `debug_build` (pipeline operation), `history_inspect` (pipeline operation), `history_export` (pipeline operation), `history_import` (pipeline operation), `history_logs` (pipeline operation), `history_ls` (pipeline operation), `history_open` (pipeline operation), `history_rm` (pipeline operation), `history_trace` (pipeline operation), `imagetools_create` (pipeline operation), `imagetools_inspect` (pipeline operation), `policy_eval` (pipeline operation), `policy_test` (pipeline operation), `history_inspect_attachment` (pipeline operation) |
| [cachix](../caching/cachix/README.md) | Reuse build outputs or compiler results across CI jobs. | `setup` (pipeline operation), `push` (pipeline operation) |
| [checkov](../security/checkov/README.md) | Produce security findings, inventory dependencies, or enforce a security gate. | `run` (escape hatch), `version` (diagnostic), `scan` (pipeline operation) |
| [cmake](../build/cmake/README.md) | Configure, compile, test, or inspect a build graph. | `run` (escape hatch), `version` (diagnostic), `configure` (pipeline operation), `build` (pipeline operation), `install` (pipeline operation), `test` (pipeline operation) |
| [codacy](../code-quality/codacy/README.md) | Upload coverage or run a code quality analysis. | `run` (escape hatch), `help` (diagnostic), `upload` (pipeline operation) |
| [codecov](../code-quality/codecov/README.md) | Upload coverage or run a code quality analysis. | `run` (escape hatch), `version` (diagnostic), `upload` (pipeline operation) |
| [coveralls](../code-quality/coveralls/README.md) | Upload coverage or run a code quality analysis. | `run` (escape hatch), `version` (diagnostic), `upload` (pipeline operation), `done` (pipeline operation) |
| [cypress](../testing/cypress/README.md) | Install test dependencies or browsers, run tests, and propagate failures. | `run` (escape hatch), `version` (diagnostic), `setup` (pipeline operation), `test` (pipeline operation), `install` (pipeline operation), `verify` (pipeline operation), `cache_list` (diagnostic) |
| [digitalocean](../cloud/digitalocean/README.md) | Inspect accounts, provision resources, or transfer deployment outputs. | `run` (escape hatch), `version` (diagnostic), `account_get` (pipeline operation), `droplets_list` (pipeline operation), `apps_create` (pipeline operation), `apps_update` (pipeline operation), `apps_deploy` (pipeline operation) |
| [docker](../containers/docker/README.md) | Build, tag, publish, or inspect container images and build caches. | `run` (escape hatch), `version` (diagnostic), `build` (pipeline operation), `pull` (pipeline operation), `push` (pipeline operation), `tag` (pipeline operation), `container_run` (pipeline operation), `compose` (pipeline operation) |
| [doppler](../secrets/doppler/README.md) | Inject secrets into child commands or manage secret metadata and files. | `run` (escape hatch), `version` (diagnostic), `run_command` (pipeline operation), `names` (pipeline operation), `upload` (pipeline operation) |
| [dpkg](../packaging/dpkg/README.md) | Validate a Linux package tree and produce an architecture-specific package. | `build` (pipeline operation), `validate` (pipeline operation) |
| [flyctl](../deployment/flyctl/README.md) | Deploy an application and inspect its rollout or service state. | `run` (escape hatch), `version` (diagnostic), `deploy` (pipeline operation), `status` (pipeline operation), `logs` (pipeline operation) |
| [gcloud](../cloud/gcloud/README.md) | Inspect accounts, provision resources, or transfer deployment outputs. | `run` (escape hatch), `version` (diagnostic), `config_list` (pipeline operation), `run_deploy` (pipeline operation), `storage_cp` (pipeline operation), `instances_list` (pipeline operation) |
| [gemfury](../publishing/gemfury/README.md) | Publish built packages to a package repository. | `upload` (pipeline operation) |
| [gh-artifact](../artifacts/gh-artifact/README.md) | Publish or retrieve build outputs and release assets. | `run` (escape hatch), `version` (diagnostic), `upload` (pipeline operation), `download` (pipeline operation), `release_upload` (pipeline operation), `release_download` (pipeline operation) |
| [gitlab-artifacts](../artifacts/gitlab-artifacts/README.md) | Publish or retrieve build outputs and release assets. | `run` (escape hatch), `version` (diagnostic), `upload` (pipeline operation), `download` (pipeline operation), `release_upload` (pipeline operation) |
| [gitleaks](../security/gitleaks/README.md) | Produce security findings, inventory dependencies, or enforce a security gate. | `run` (escape hatch), `version` (diagnostic), `scan_dir` (pipeline operation), `scan_git` (pipeline operation) |
| [grype](../security/grype/README.md) | Produce security findings, inventory dependencies, or enforce a security gate. | `run` (escape hatch), `version` (diagnostic), `scan` (pipeline operation), `db_update` (pipeline operation) |
| [helm](../deployment/helm/README.md) | Deploy an application and inspect its rollout or service state. | `run` (escape hatch), `version` (diagnostic), `lint` (pipeline operation), `template` (pipeline operation), `upgrade` (pipeline operation), `uninstall` (pipeline operation) |
| [infisical](../secrets/infisical/README.md) | Inject secrets into child commands or manage secret metadata and files. | `run` (escape hatch), `version` (diagnostic), `run_command` (pipeline operation) |
| [jfrog-cli](../artifacts/jfrog-cli/README.md) | Publish or retrieve build outputs and release assets. | `run` (escape hatch), `version` (diagnostic), `upload` (pipeline operation), `download` (pipeline operation), `search` (pipeline operation), `build_publish` (pipeline operation), `build_promote` (pipeline operation) |
| [kamal](../deployment/kamal/README.md) | Deploy an application and inspect its rollout or service state. | `run` (escape hatch), `version` (diagnostic), `deploy` (pipeline operation), `setup` (pipeline operation), `details` (pipeline operation), `rollback` (pipeline operation) |
| [kubectl](../deployment/kubectl/README.md) | Deploy an application and inspect its rollout or service state. | `run` (escape hatch), `version` (diagnostic), `apply` (pipeline operation), `get` (pipeline operation), `delete_resources` (pipeline operation), `rollout_status` (pipeline operation) |
| [meson](../build/meson/README.md) | Configure, compile, test, or inspect a build graph. | `run` (escape hatch), `version` (diagnostic), `configure` (pipeline operation), `compile` (pipeline operation), `test` (pipeline operation), `install` (pipeline operation) |
| [netlify](../deployment/netlify/README.md) | Deploy an application and inspect its rollout or service state. | `run` (escape hatch), `version` (diagnostic), `deploy` (pipeline operation), `build` (pipeline operation), `status` (pipeline operation), `sites_list` (pipeline operation) |
| [nexus](../artifacts/nexus/README.md) | Publish or retrieve build outputs and release assets. | `run` (escape hatch), `version` (diagnostic), `upload` (pipeline operation), `download` (pipeline operation), `head` (pipeline operation) |
| [ninja](../build/ninja/README.md) | Configure, compile, test, or inspect a build graph. | `run` (escape hatch), `version` (diagnostic), `build` (pipeline operation), `clean` (pipeline operation), `targets` (diagnostic) |
| [nix-package](../package-management/nix/README.md) | Resolve, lock, build, or publish project dependencies. | `run` (escape hatch), `version` (diagnostic), `build` (pipeline operation), `eval` (pipeline operation), `flake_check` (pipeline operation), `flake_update` (pipeline operation), `profile_install` (pipeline operation), `store_gc` (pipeline operation) |
| [openbao](../secrets/openbao/README.md) | Inject secrets into child commands or manage secret metadata and files. | `run` (escape hatch), `version` (diagnostic), `status` (pipeline operation), `kv_list` (pipeline operation), `kv_metadata` (pipeline operation), `kv_put` (pipeline operation), `kv_delete` (pipeline operation) |
| [opentofu](../infrastructure/opentofu/README.md) | Validate, preview, apply, or inspect infrastructure changes. | `run` (escape hatch), `version` (diagnostic), `init` (pipeline operation), `validate` (pipeline operation), `fmt` (pipeline operation), `plan` (pipeline operation), `apply` (pipeline operation), `destroy` (pipeline operation), `output` (pipeline operation) |
| [oras](../artifacts/oras/README.md) | Publish or retrieve build outputs and release assets. | `run` (escape hatch), `version` (diagnostic), `push` (pipeline operation), `pull` (pipeline operation), `copy` (pipeline operation), `discover` (pipeline operation) |
| [playwright](../testing/playwright/README.md) | Install test dependencies or browsers, run tests, and propagate failures. | `run` (escape hatch), `version` (diagnostic), `setup` (pipeline operation), `test` (pipeline operation), `list` (pipeline operation), `install` (pipeline operation), `install_deps` (pipeline operation) |
| [plumber](../security/plumber/README.md) | Produce security findings, inventory dependencies, or enforce a security gate. | `run` (escape hatch), `version` (diagnostic), `analyze` (pipeline operation), `validate_config` (pipeline operation) |
| [podman](../containers/podman/README.md) | Build, tag, publish, or inspect container images and build caches. | `run` (escape hatch), `version` (diagnostic), `build` (pipeline operation), `pull` (pipeline operation), `push` (pipeline operation), `tag` (pipeline operation), `container_run` (pipeline operation), `compose` (pipeline operation) |
| [prettier](../formatting/prettier/README.md) | Format source files or fail CI when formatting differs. | `run` (escape hatch), `version` (diagnostic), `format` (pipeline operation), `check` (pipeline operation) |
| [pulumi](../infrastructure/pulumi/README.md) | Validate, preview, apply, or inspect infrastructure changes. | `run` (escape hatch), `version` (diagnostic), `preview` (pipeline operation), `up` (pipeline operation), `destroy` (pipeline operation), `stack_select` (pipeline operation), `stack_output` (pipeline operation), `login` (pipeline operation) |
| [railway](../deployment/railway/README.md) | Deploy an application and inspect its rollout or service state. | `run` (escape hatch), `version` (diagnostic), `up` (pipeline operation), `status` (pipeline operation), `redeploy` (pipeline operation) |
| [rclone](../artifacts/rclone/README.md) | Publish or retrieve build outputs and release assets. | `run` (escape hatch), `version` (diagnostic), `copy` (pipeline operation), `copyto` (pipeline operation), `check` (pipeline operation), `lsjson` (diagnostic) |
| [render](../deployment/render/README.md) | Deploy an application and inspect its rollout or service state. | `run` (escape hatch), `version` (diagnostic), `services` (pipeline operation), `deploy` (pipeline operation), `deploys_list` (pipeline operation) |
| [rpmbuild](../packaging/rpmbuild/README.md) | Validate a Linux package tree and produce an architecture-specific package. | `build` (pipeline operation), `validate` (pipeline operation) |
| [ruff](../linting/ruff/README.md) | Check source or configuration and fail on lint violations. | `run` (escape hatch), `version` (diagnostic), `check` (pipeline operation), `format` (pipeline operation), `format_check` (pipeline operation) |
| [rustfmt](../formatting/rustfmt/README.md) | Format source files or fail CI when formatting differs. | `run` (escape hatch), `version` (diagnostic), `format` (pipeline operation), `check` (pipeline operation), `cargo_fmt` (pipeline operation) |
| [sccache](../caching/sccache/README.md) | Reuse build outputs or compiler results across CI jobs. | `run` (escape hatch), `version` (diagnostic), `start_server` (pipeline operation), `stop_server` (pipeline operation), `stats` (diagnostic), `zero_stats` (pipeline operation), `compile` (pipeline operation) |
| [scorecard](../security/scorecard/README.md) | Produce security findings, inventory dependencies, or enforce a security gate. | `run` (escape hatch), `version` (diagnostic), `scan` (pipeline operation), `scan_local` (pipeline operation), `gate` (pipeline operation) |
| [semgrep](../security/semgrep/README.md) | Produce security findings, inventory dependencies, or enforce a security gate. | `run` (escape hatch), `version` (diagnostic), `scan` (pipeline operation), `ci` (pipeline operation) |
| [setup-actionlint](../setup/actionlint/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-argocd](../setup/argocd/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-artifactory](../setup/artifactory/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-aws](../setup/aws/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-azure](../setup/azure/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-babashka](../setup/babashka/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-bazel](../setup/bazel/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-betterleaks](../setup/betterleaks/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-binaryen](../setup/binaryen/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-biome](../setup/biome/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-black](../setup/black/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-buildkit](../setup/buildkit/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-buildx](../setup/buildx/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-bun](../setup/bun/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-cachix](../setup/cachix/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-checkov](../setup/checkov/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-clojure](../setup/clojure/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-cmake](../setup/cmake/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-codacy](../setup/codacy/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-codecov](../setup/codecov/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-coveralls](../setup/coveralls/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-cypress](../setup/cypress/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-deno](../setup/deno/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-determinate-nix](../setup/determinate-nix/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-digitalocean](../setup/digitalocean/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-docker](../setup/docker/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-doppler](../setup/doppler/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-dpkg](../setup/dpkg/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-elixir](../setup/elixir/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-expo](../setup/expo/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-extism](../setup/extism/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-extism-cli](../setup/extism-cli/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-extism-js](../setup/extism-js/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-extism-py](../setup/extism-py/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-flyctl](../setup/flyctl/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-gcloud](../setup/gcloud/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-gemfury](../setup/gemfury/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-gh-artifact](../setup/gh-artifact/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-gitlab-artifacts](../setup/gitlab-artifacts/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-gitleaks](../setup/gitleaks/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-gleam](../setup/gleam/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-go](../setup/go/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-grype](../setup/grype/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-helm](../setup/helm/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-infisical](../setup/infisical/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-java](../setup/java/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-jfrog-cli](../setup/jfrog-cli/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-kamal](../setup/kamal/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-kubectl](../setup/kubectl/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-meson](../setup/meson/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-mise](../setup/mise/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-netlify](../setup/netlify/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-nexus](../setup/nexus/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-ninja](../setup/ninja/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-nix](../setup/nix/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-nix-package](../setup/nix-package/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-node](../setup/node/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-openbao](../setup/openbao/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-opentofu](../setup/opentofu/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-oras](../setup/oras/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-pkl](../setup/pkl/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-playwright](../setup/playwright/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-plumber](../setup/plumber/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-podman](../setup/podman/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-prettier](../setup/prettier/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-pulumi](../setup/pulumi/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-purescript](../setup/purescript/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-railway](../setup/railway/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-rclone](../setup/rclone/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-render](../setup/render/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-rpmbuild](../setup/rpmbuild/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-ruff](../setup/ruff/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-rust](../setup/rust/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-rustfmt](../setup/rustfmt/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-sccache](../setup/sccache/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-scorecard](../setup/scorecard/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-semgrep](../setup/semgrep/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-shellcheck](../setup/shellcheck/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-snyk](../setup/snyk/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-sonarqube](../setup/sonarqube/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-syft](../setup/syft/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-tangled-artifacts](../setup/tangled-artifacts/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-terraform](../setup/terraform/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-terragrunt](../setup/terragrunt/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-tg](../setup/tg/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-trivy](../setup/trivy/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-trufflehog](../setup/trufflehog/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-turborepo](../setup/turborepo/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-ubicloud](../setup/ubicloud/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-uv](../setup/uv/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-vault](../setup/vault/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-vercel](../setup/vercel/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-xtp](../setup/xtp/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-yamllint](../setup/yamllint/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [setup-zig](../setup/zig/README.md) | Install and verify a prerequisite tool, select its version, and publish PATH. | `setup` (pipeline operation) |
| [shellcheck](../linting/shellcheck/README.md) | Check source or configuration and fail on lint violations. | `run` (escape hatch), `version` (diagnostic), `lint` (pipeline operation) |
| [snyk](../security/snyk/README.md) | Produce security findings, inventory dependencies, or enforce a security gate. | `run` (escape hatch), `version` (diagnostic), `setup` (pipeline operation), `test` (pipeline operation), `code_test` (pipeline operation), `iac_test` (pipeline operation), `container_test` (pipeline operation), `monitor` (pipeline operation) |
| [sonarqube](../code-quality/sonarqube/README.md) | Upload coverage or run a code quality analysis. | `run` (escape hatch), `version` (diagnostic), `scan` (pipeline operation) |
| [syft](../security/syft/README.md) | Produce security findings, inventory dependencies, or enforce a security gate. | `run` (escape hatch), `version` (diagnostic), `scan` (pipeline operation), `convert` (pipeline operation) |
| [tangled-artifacts](../artifacts/tangled-artifacts/README.md) | Publish or retrieve build outputs and release assets. | `run` (escape hatch), `upload` (pipeline operation) |
| [terraform](../infrastructure/terraform/README.md) | Validate, preview, apply, or inspect infrastructure changes. | `run` (escape hatch), `version` (diagnostic), `init` (pipeline operation), `validate` (pipeline operation), `fmt` (pipeline operation), `plan` (pipeline operation), `apply` (pipeline operation), `destroy` (pipeline operation), `output` (pipeline operation) |
| [terragrunt](../infrastructure/terragrunt/README.md) | Validate, preview, apply, or inspect infrastructure changes. | `run` (escape hatch), `version` (diagnostic), `hcl_fmt` (pipeline operation), `init` (pipeline operation), `plan` (pipeline operation), `apply` (pipeline operation), `destroy` (pipeline operation), `validate` (pipeline operation) |
| [trivy](../security/trivy/README.md) | Produce security findings, inventory dependencies, or enforce a security gate. | `run` (escape hatch), `version` (diagnostic), `filesystem` (pipeline operation), `image` (pipeline operation), `config` (pipeline operation), `sbom` (pipeline operation) |
| [trufflehog](../security/trufflehog/README.md) | Produce security findings, inventory dependencies, or enforce a security gate. | `run` (escape hatch), `version` (diagnostic), `filesystem` (pipeline operation), `git` (pipeline operation) |
| [ubicloud](../cloud/ubicloud/README.md) | Inspect accounts, provision resources, or transfer deployment outputs. | `run` (escape hatch), `help` (diagnostic) |
| [uv](../package-management/uv/README.md) | Resolve, lock, build, or publish project dependencies. | `run` (escape hatch), `version` (diagnostic), `sync` (pipeline operation), `lock` (pipeline operation), `run_command` (pipeline operation), `build` (pipeline operation), `publish` (pipeline operation), `venv` (pipeline operation), `add` (pipeline operation), `pip_install` (pipeline operation) |
| [vault](../secrets/vault/README.md) | Inject secrets into child commands or manage secret metadata and files. | `run` (escape hatch), `version` (diagnostic), `status` (pipeline operation), `kv_list` (pipeline operation), `kv_metadata` (pipeline operation), `kv_put` (pipeline operation), `kv_delete` (pipeline operation) |
| [vercel](../deployment/vercel/README.md) | Deploy an application and inspect its rollout or service state. | `run` (escape hatch), `version` (diagnostic), `deploy` (pipeline operation), `build` (pipeline operation), `pull` (pipeline operation) |
| [yamllint](../linting/yamllint/README.md) | Check source or configuration and fail on lint violations. | `run` (escape hatch), `version` (diagnostic), `lint` (pipeline operation) |
