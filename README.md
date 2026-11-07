# FluentCI Modules

Reusable CI/CD modules written in PureScript and compiled to WebAssembly for
FluentCI. Build containers, package Linux applications, publish artifacts, and
cache Nix build outputs, format and lint sources, manage infrastructure, and
deploy applications using independently configured modules.

## Modules

All modules are registered alphabetically in [fluentci.toml](./fluentci.toml).
See the [pipeline audit](./docs/PIPELINE_AUDIT.md) and [CI integration guide](./docs/PIPELINES.md) for failure, credential, and artifact contracts.

| Module | Purpose | WebAssembly functions |
| --- | --- | --- |
| [actionlint](./linting/actionlint/README.md) | Run Actionlint pipeline operations. | `run`, `version`, `lint` |
| [argocd](./deployment/argocd/README.md) | Run Argo CD pipeline operations. | `run`, `version`, `app_get`, `app_sync`, [all commands](./deployment/argocd/OPTIONS.md) |
| [artifactory](./artifacts/artifactory/README.md) | Run JFrog Artifactory pipeline operations. | `run`, `version`, `upload`, `download`, [all commands](./artifacts/artifactory/OPTIONS.md) |
| [aws](./cloud/aws/README.md) | Run AWS pipeline operations. | `run`, `version`, `identity`, `s3_cp`, [all commands](./cloud/aws/OPTIONS.md) |
| [azure](./cloud/azure/README.md) | Run Azure pipeline operations. | `run`, `version`, `account_show`, `group_deploy`, [all commands](./cloud/azure/OPTIONS.md) |
| [bazel](./build/bazel/README.md) | Run Bazel pipeline operations. | `run`, `version`, `build`, `test`, [all commands](./build/bazel/OPTIONS.md) |
| [betterleaks](./security/betterleaks/README.md) | Run Betterleaks pipeline operations. | `run`, `version`, `scan_dir`, `scan_git` |
| [biome](./linting/biome/README.md) | Run Biome pipeline operations. | `run`, `version`, `check`, `lint`, [all commands](./linting/biome/OPTIONS.md) |
| [black](./formatting/black/README.md) | Run Black pipeline operations. | `run`, `version`, `format`, `check` |
| [buildkit](./containers/buildkit/README.md) | Run BuildKit pipeline operations. | `run`, `version`, `build`, `prune`, [all commands](./containers/buildkit/OPTIONS.md) |
| [buildx](./containers/buildx/README.md) | Build and publish container images. | `buildx`, `dap`, `debug`, `history`, [all commands](./containers/buildx/OPTIONS.md) |
| [cachix](./caching/cachix/README.md) | Configure and publish Nix cache outputs. | `setup`, `push` |
| [checkov](./security/checkov/README.md) | Run Checkov pipeline operations. | `run`, `version`, `scan` |
| [cmake](./build/cmake/README.md) | Run CMake pipeline operations. | `run`, `version`, `configure`, `build`, [all commands](./build/cmake/OPTIONS.md) |
| [codacy](./code-quality/codacy/README.md) | Run Codacy pipeline operations. | `run`, `help`, `upload` |
| [codecov](./code-quality/codecov/README.md) | Run Codecov pipeline operations. | `run`, `version`, `upload` |
| [coveralls](./code-quality/coveralls/README.md) | Run Coveralls pipeline operations. | `run`, `version`, `upload`, `done` |
| [cypress](./testing/cypress/README.md) | Run Cypress pipeline operations. | `run`, `version`, `setup`, `test`, [all commands](./testing/cypress/OPTIONS.md) |
| [digitalocean](./cloud/digitalocean/README.md) | Run DigitalOcean pipeline operations. | `run`, `version`, `account_get`, `droplets_list`, [all commands](./cloud/digitalocean/OPTIONS.md) |
| [docker](./containers/docker/README.md) | Run Docker pipeline operations. | `run`, `version`, `build`, `pull`, [all commands](./containers/docker/OPTIONS.md) |
| [doppler](./secrets/doppler/README.md) | Run Doppler pipeline operations. | `run`, `version`, `run_command`, `names`, [all commands](./secrets/doppler/OPTIONS.md) |
| [dpkg](./packaging/dpkg/README.md) | Validate and build architecture-specific .deb packages. | `build`, `validate` |
| [flyctl](./deployment/flyctl/README.md) | Run Fly.io pipeline operations. | `run`, `version`, `deploy`, `status`, [all commands](./deployment/flyctl/OPTIONS.md) |
| [gcloud](./cloud/gcloud/README.md) | Run Google Cloud pipeline operations. | `run`, `version`, `config_list`, `run_deploy`, [all commands](./cloud/gcloud/OPTIONS.md) |
| [gemfury](./publishing/gemfury/README.md) | Upload Linux packages to Gemfury. | `upload` |
| [gh-artifact](./artifacts/gh-artifact/README.md) | Run GitHub artifacts pipeline operations. | `run`, `version`, `upload`, `download`, [all commands](./artifacts/gh-artifact/OPTIONS.md) |
| [gitlab-artifacts](./artifacts/gitlab-artifacts/README.md) | Run GitLab artifacts pipeline operations. | `run`, `version`, `upload`, `download`, [all commands](./artifacts/gitlab-artifacts/OPTIONS.md) |
| [gitleaks](./security/gitleaks/README.md) | Run Gitleaks pipeline operations. | `run`, `version`, `scan_dir`, `scan_git` |
| [grype](./security/grype/README.md) | Run Grype pipeline operations. | `run`, `version`, `scan`, `db_update` |
| [helm](./deployment/helm/README.md) | Run Helm pipeline operations. | `run`, `version`, `lint`, `template`, [all commands](./deployment/helm/OPTIONS.md) |
| [infisical](./secrets/infisical/README.md) | Run Infisical pipeline operations. | `run`, `version`, `run_command` |
| [jfrog-cli](./artifacts/jfrog-cli/README.md) | Run JFrog CLI pipeline operations. | `run`, `version`, `upload`, `download`, [all commands](./artifacts/jfrog-cli/OPTIONS.md) |
| [kamal](./deployment/kamal/README.md) | Run Kamal pipeline operations. | `run`, `version`, `deploy`, `setup`, [all commands](./deployment/kamal/OPTIONS.md) |
| [kubectl](./deployment/kubectl/README.md) | Run Kubectl pipeline operations. | `run`, `version`, `apply`, `get`, [all commands](./deployment/kubectl/OPTIONS.md) |
| [meson](./build/meson/README.md) | Run Meson pipeline operations. | `run`, `version`, `configure`, `compile`, [all commands](./build/meson/OPTIONS.md) |
| [netlify](./deployment/netlify/README.md) | Run Netlify pipeline operations. | `run`, `version`, `deploy`, `build`, [all commands](./deployment/netlify/OPTIONS.md) |
| [nexus](./artifacts/nexus/README.md) | Run Nexus Repository pipeline operations. | `run`, `version`, `upload`, `download`, [all commands](./artifacts/nexus/OPTIONS.md) |
| [ninja](./build/ninja/README.md) | Run Ninja pipeline operations. | `run`, `version`, `build`, `clean`, [all commands](./build/ninja/OPTIONS.md) |
| [nix-package](./package-management/nix/README.md) | Run Nix packages pipeline operations. | `run`, `version`, `build`, `eval`, [all commands](./package-management/nix/OPTIONS.md) |
| [openbao](./secrets/openbao/README.md) | Run OpenBao pipeline operations. | `run`, `version`, `status`, `kv_list`, [all commands](./secrets/openbao/OPTIONS.md) |
| [opentofu](./infrastructure/opentofu/README.md) | Run OpenTofu pipeline operations. | `run`, `version`, `init`, `validate`, [all commands](./infrastructure/opentofu/OPTIONS.md) |
| [oras](./artifacts/oras/README.md) | Run ORAS pipeline operations. | `run`, `version`, `push`, `pull`, [all commands](./artifacts/oras/OPTIONS.md) |
| [playwright](./testing/playwright/README.md) | Run Playwright pipeline operations. | `run`, `version`, `setup`, `test`, [all commands](./testing/playwright/OPTIONS.md) |
| [plumber](./security/plumber/README.md) | Run Plumber pipeline operations. | `run`, `version`, `analyze`, `validate_config` |
| [podman](./containers/podman/README.md) | Run Podman pipeline operations. | `run`, `version`, `build`, `pull`, [all commands](./containers/podman/OPTIONS.md) |
| [prettier](./formatting/prettier/README.md) | Run Prettier pipeline operations. | `run`, `version`, `format`, `check` |
| [pulumi](./infrastructure/pulumi/README.md) | Run Pulumi pipeline operations. | `run`, `version`, `preview`, `up`, [all commands](./infrastructure/pulumi/OPTIONS.md) |
| [railway](./deployment/railway/README.md) | Run Railway pipeline operations. | `run`, `version`, `up`, `status`, [all commands](./deployment/railway/OPTIONS.md) |
| [rclone](./artifacts/rclone/README.md) | Run rclone pipeline operations. | `run`, `version`, `copy`, `copyto`, [all commands](./artifacts/rclone/OPTIONS.md) |
| [render](./deployment/render/README.md) | Run Render pipeline operations. | `run`, `version`, `services`, `deploy`, [all commands](./deployment/render/OPTIONS.md) |
| [rpmbuild](./packaging/rpmbuild/README.md) | Validate and build architecture-specific .rpm packages. | `build`, `validate` |
| [ruff](./linting/ruff/README.md) | Run Ruff pipeline operations. | `run`, `version`, `check`, `format`, [all commands](./linting/ruff/OPTIONS.md) |
| [rustfmt](./formatting/rustfmt/README.md) | Run Rustfmt pipeline operations. | `run`, `version`, `format`, `check`, [all commands](./formatting/rustfmt/OPTIONS.md) |
| [sccache](./caching/sccache/README.md) | Run sccache pipeline operations. | `run`, `version`, `start_server`, `stop_server`, [all commands](./caching/sccache/OPTIONS.md) |
| [scorecard](./security/scorecard/README.md) | Run OpenSSF Scorecard pipeline operations. | `run`, `version`, `scan`, `scan_local`, [all commands](./security/scorecard/OPTIONS.md) |
| [semgrep](./security/semgrep/README.md) | Run Semgrep pipeline operations. | `run`, `version`, `scan`, `ci` |
| [setup-actionlint](./setup/actionlint/README.md) | Install Actionlint and select a version. | `setup` |
| [setup-argocd](./setup/argocd/README.md) | Install Argo CD and select a version. | `setup` |
| [setup-artifactory](./setup/artifactory/README.md) | Install Artifactory and select a version. | `setup` |
| [setup-aws](./setup/aws/README.md) | Install AWS and select a version. | `setup` |
| [setup-azure](./setup/azure/README.md) | Install Azure and select a version. | `setup` |
| [setup-babashka](./setup/babashka/README.md) | Install Babashka and select a version. | `setup` |
| [setup-bazel](./setup/bazel/README.md) | Install Bazel and select a version. | `setup` |
| [setup-betterleaks](./setup/betterleaks/README.md) | Install Betterleaks and select a version. | `setup` |
| [setup-binaryen](./setup/binaryen/README.md) | Install Binaryen and select a version. | `setup` |
| [setup-biome](./setup/biome/README.md) | Install Biome and select a version. | `setup` |
| [setup-black](./setup/black/README.md) | Install Black and select a version. | `setup` |
| [setup-buildkit](./setup/buildkit/README.md) | Install BuildKit and select a version. | `setup` |
| [setup-buildx](./setup/buildx/README.md) | Install Buildx and select a version. | `setup` |
| [setup-bun](./setup/bun/README.md) | Install bun and select a version. | `setup` |
| [setup-cachix](./setup/cachix/README.md) | Install Cachix and select a version. | `setup` |
| [setup-checkov](./setup/checkov/README.md) | Install Checkov and select a version. | `setup` |
| [setup-clojure](./setup/clojure/README.md) | Install Clojure and select a version. | `setup` |
| [setup-cmake](./setup/cmake/README.md) | Install CMake and select a version. | `setup` |
| [setup-codacy](./setup/codacy/README.md) | Install Codacy and select a version. | `setup` |
| [setup-codecov](./setup/codecov/README.md) | Install Codecov and select a version. | `setup` |
| [setup-coveralls](./setup/coveralls/README.md) | Install Coveralls and select a version. | `setup` |
| [setup-cypress](./setup/cypress/README.md) | Install Cypress and select a version. | `setup` |
| [setup-deno](./setup/deno/README.md) | Install deno and select a version. | `setup` |
| [setup-determinate-nix](./setup/determinate-nix/README.md) | Install determinate-nix and select a version. | `setup` |
| [setup-digitalocean](./setup/digitalocean/README.md) | Install DigitalOcean and select a version. | `setup` |
| [setup-docker](./setup/docker/README.md) | Install Docker and select a version. | `setup` |
| [setup-doppler](./setup/doppler/README.md) | Install Doppler and select a version. | `setup` |
| [setup-dpkg](./setup/dpkg/README.md) | Install Dpkg and select a version. | `setup` |
| [setup-elixir](./setup/elixir/README.md) | Install elixir and select a version. | `setup` |
| [setup-expo](./setup/expo/README.md) | Install Expo CLI and select a version. | `setup` |
| [setup-extism](./setup/extism/README.md) | Install Extism and select a version. | `setup` |
| [setup-extism-cli](./setup/extism-cli/README.md) | Install Extism-Cli and select a version. | `setup` |
| [setup-extism-js](./setup/extism-js/README.md) | Install Extism-Js and select a version. | `setup` |
| [setup-extism-py](./setup/extism-py/README.md) | Install Extism-Py and select a version. | `setup` |
| [setup-flyctl](./setup/flyctl/README.md) | Install Fly.io and select a version. | `setup` |
| [setup-gcloud](./setup/gcloud/README.md) | Install Google Cloud and select a version. | `setup` |
| [setup-gemfury](./setup/gemfury/README.md) | Install Gemfury and select a version. | `setup` |
| [setup-gh-artifact](./setup/gh-artifact/README.md) | Install Gh-Artifact and select a version. | `setup` |
| [setup-gitlab-artifacts](./setup/gitlab-artifacts/README.md) | Install Gitlab-Artifacts and select a version. | `setup` |
| [setup-gitleaks](./setup/gitleaks/README.md) | Install Gitleaks and select a version. | `setup` |
| [setup-gleam](./setup/gleam/README.md) | Install gleam and select a version. | `setup` |
| [setup-go](./setup/go/README.md) | Install go and select a version. | `setup` |
| [setup-grype](./setup/grype/README.md) | Install Grype and select a version. | `setup` |
| [setup-helm](./setup/helm/README.md) | Install Helm and select a version. | `setup` |
| [setup-infisical](./setup/infisical/README.md) | Install Infisical and select a version. | `setup` |
| [setup-java](./setup/java/README.md) | Install java and select a version. | `setup` |
| [setup-jfrog-cli](./setup/jfrog-cli/README.md) | Install Jfrog-Cli and select a version. | `setup` |
| [setup-kamal](./setup/kamal/README.md) | Install Kamal and select a version. | `setup` |
| [setup-kubectl](./setup/kubectl/README.md) | Install Kubectl and select a version. | `setup` |
| [setup-meson](./setup/meson/README.md) | Install Meson and select a version. | `setup` |
| [setup-mise](./setup/mise/README.md) | Install Mise and select a version. | `setup` |
| [setup-netlify](./setup/netlify/README.md) | Install Netlify and select a version. | `setup` |
| [setup-nexus](./setup/nexus/README.md) | Install Nexus and select a version. | `setup` |
| [setup-ninja](./setup/ninja/README.md) | Install Ninja and select a version. | `setup` |
| [setup-nix](./setup/nix/README.md) | Install nix and select a version. | `setup` |
| [setup-nix-package](./setup/nix-package/README.md) | Install Nix packages and select a version. | `setup` |
| [setup-node](./setup/node/README.md) | Install node and select a version. | `setup` |
| [setup-openbao](./setup/openbao/README.md) | Install OpenBao and select a version. | `setup` |
| [setup-opentofu](./setup/opentofu/README.md) | Install OpenTofu and select a version. | `setup` |
| [setup-oras](./setup/oras/README.md) | Install Oras and select a version. | `setup` |
| [setup-pkl](./setup/pkl/README.md) | Install pkl and select a version. | `setup` |
| [setup-playwright](./setup/playwright/README.md) | Install Playwright and select a version. | `setup` |
| [setup-plumber](./setup/plumber/README.md) | Install Plumber and select a version. | `setup` |
| [setup-podman](./setup/podman/README.md) | Install Podman and select a version. | `setup` |
| [setup-prettier](./setup/prettier/README.md) | Install Prettier and select a version. | `setup` |
| [setup-pulumi](./setup/pulumi/README.md) | Install Pulumi and select a version. | `setup` |
| [setup-purescript](./setup/purescript/README.md) | Install purescript and select a version. | `setup` |
| [setup-railway](./setup/railway/README.md) | Install Railway and select a version. | `setup` |
| [setup-rclone](./setup/rclone/README.md) | Install Rclone and select a version. | `setup` |
| [setup-render](./setup/render/README.md) | Install Render and select a version. | `setup` |
| [setup-rpmbuild](./setup/rpmbuild/README.md) | Install Rpmbuild and select a version. | `setup` |
| [setup-ruff](./setup/ruff/README.md) | Install Ruff and select a version. | `setup` |
| [setup-rust](./setup/rust/README.md) | Install rust and select a version. | `setup` |
| [setup-rustfmt](./setup/rustfmt/README.md) | Install Rustfmt and select a version. | `setup` |
| [setup-sccache](./setup/sccache/README.md) | Install sccache and select a version. | `setup` |
| [setup-scorecard](./setup/scorecard/README.md) | Install OpenSSF Scorecard and select a version. | `setup` |
| [setup-semgrep](./setup/semgrep/README.md) | Install Semgrep and select a version. | `setup` |
| [setup-shellcheck](./setup/shellcheck/README.md) | Install ShellCheck and select a version. | `setup` |
| [setup-snyk](./setup/snyk/README.md) | Install Snyk and select a version. | `setup` |
| [setup-sonarqube](./setup/sonarqube/README.md) | Install SonarQube and select a version. | `setup` |
| [setup-syft](./setup/syft/README.md) | Install Syft and select a version. | `setup` |
| [setup-tangled-artifacts](./setup/tangled-artifacts/README.md) | Install Tangled-Artifacts and select a version. | `setup` |
| [setup-terraform](./setup/terraform/README.md) | Install Terraform and select a version. | `setup` |
| [setup-terragrunt](./setup/terragrunt/README.md) | Install Terragrunt and select a version. | `setup` |
| [setup-tg](./setup/tg/README.md) | Install Tg and select a version. | `setup` |
| [setup-trivy](./setup/trivy/README.md) | Install Trivy and select a version. | `setup` |
| [setup-trufflehog](./setup/trufflehog/README.md) | Install TruffleHog and select a version. | `setup` |
| [setup-turborepo](./setup/turborepo/README.md) | Install Turborepo and select a version. | `setup` |
| [setup-ubicloud](./setup/ubicloud/README.md) | Install Ubicloud and select a version. | `setup` |
| [setup-uv](./setup/uv/README.md) | Install uv and select a version. | `setup` |
| [setup-vault](./setup/vault/README.md) | Install Vault and select a version. | `setup` |
| [setup-vercel](./setup/vercel/README.md) | Install Vercel and select a version. | `setup` |
| [setup-xtp](./setup/xtp/README.md) | Install Xtp and select a version. | `setup` |
| [setup-yamllint](./setup/yamllint/README.md) | Install Yamllint and select a version. | `setup` |
| [setup-zig](./setup/zig/README.md) | Install zig and select a version. | `setup` |
| [shellcheck](./linting/shellcheck/README.md) | Run ShellCheck pipeline operations. | `run`, `version`, `lint` |
| [snyk](./security/snyk/README.md) | Run Snyk pipeline operations. | `run`, `version`, `setup`, `test`, [all commands](./security/snyk/OPTIONS.md) |
| [sonarqube](./code-quality/sonarqube/README.md) | Run SonarQube pipeline operations. | `run`, `version`, `scan` |
| [syft](./security/syft/README.md) | Run Syft pipeline operations. | `run`, `version`, `scan`, `convert` |
| [tangled-artifacts](./artifacts/tangled-artifacts/README.md) | Run Tangled release artifacts pipeline operations. | `run`, `upload` |
| [terraform](./infrastructure/terraform/README.md) | Run Terraform pipeline operations. | `run`, `version`, `init`, `validate`, [all commands](./infrastructure/terraform/OPTIONS.md) |
| [terragrunt](./infrastructure/terragrunt/README.md) | Run Terragrunt pipeline operations. | `run`, `version`, `hcl_fmt`, `init`, [all commands](./infrastructure/terragrunt/OPTIONS.md) |
| [trivy](./security/trivy/README.md) | Run Trivy pipeline operations. | `run`, `version`, `filesystem`, `image`, [all commands](./security/trivy/OPTIONS.md) |
| [trufflehog](./security/trufflehog/README.md) | Run TruffleHog pipeline operations. | `run`, `version`, `filesystem`, `git` |
| [ubicloud](./cloud/ubicloud/README.md) | Run Ubicloud pipeline operations. | `run`, `help` |
| [uv](./package-management/uv/README.md) | Run uv pipeline operations. | `run`, `version`, `sync`, `lock`, [all commands](./package-management/uv/OPTIONS.md) |
| [vault](./secrets/vault/README.md) | Run Vault pipeline operations. | `run`, `version`, `status`, `kv_list`, [all commands](./secrets/vault/OPTIONS.md) |
| [vercel](./deployment/vercel/README.md) | Run Vercel pipeline operations. | `run`, `version`, `deploy`, `build`, [all commands](./deployment/vercel/OPTIONS.md) |
| [yamllint](./linting/yamllint/README.md) | Run Yamllint pipeline operations. | `run`, `version`, `lint` |

Each module has its own dependencies, build scripts, tests, and documentation.
Source APIs also expose helpers for composition in PureScript pipelines.

## Usage

Install FluentCI and the host tools required by the module you want to use.
Declare the module in your project's `fluentci.toml`, pointing `path` to its
local source directory. For example, when the module is available under
`vendor/fluentci-modules`:

```toml
[[modules]]
name = "gemfury"
version = "0.1.0"
path = "vendor/fluentci-modules/publishing/gemfury"
sdk = "purescript"
```

Build a package using your project's packaging tools, supply credentials
through your environment or CI secret store, and upload it:

```sh
export FURY_ACCOUNT=my-account
export FURY_USER=publisher
# Supply FURY_TOKEN through your shell or CI secret store.
fluentci run gemfury upload dist/widget_1.2.0_arm64.deb
```

Buildx, the CLI modules, dpkg, and rpmbuild accept JSON objects as plugin input.
For example, the dpkg `build` function accepts:

```json
{
  "directory": "package",
  "arch": "arm64",
  "output": "dist/widget_1.2.0_arm64.deb"
}
```

The package directory must contain `DEBIAN/control` and the files to install.
RPM builds instead use a tree containing `SPECS/` and `SOURCES/`. Both packaging
modules require Linux, check their required tools before proceeding, and
validate metadata against the requested CPU architecture. Architecture
selection does not cross-compile the payload.

See each module's README for complete input formats, required host tools,
authentication, and examples. Buildx requires a fresh `runDir` for every
invocation; Cachix requires a Nix flake workspace. The CLI modules also require
a fresh `runDir`, use an existing native CLI installation, and inherit its
authentication configuration. See [the shared CLI guide](./lib/cli/README.md).
The `nix-package` module manages packages; `nix` installs the runtime.

## Runtime setup

The [setup modules](./setup/README.md) install runtimes on Linux and macOS
and use native package repositories on FreeBSD, OpenBSD, and NetBSD. BSD
availability depends on the selected repository. Nix and Determinate Nix are
limited to Linux/macOS. Select a specific version when available:

```sh
fluentci run node setup 22.14.0
fluentci run rust setup stable
```

Setup verifies the installed runtime and publishes its PATH and runtime
environment to later FluentCI commands. The shared setup guide documents
version channels, BSD package selectors, and platform prerequisites.

## Development

Install Node.js, Spago, the PureScript compiler, and `extism-js`. Build and
test modules from their own directories:

```sh
cd packaging/dpkg
npm ci
npm run build
npm test
```

Each build produces `dist/plugin.wasm`. Linux integration tests for dpkg and
rpmbuild create and inspect real packages when their native tools are
available; those tests are skipped on other hosts.

Buildx requires Python 3 for its generator checks. All module source dependencies
and its generated command schema are included in this checkout.

GitHub Actions builds and tests every registered module on Linux and macOS,
validates compiled WASM exports, and runs scheduled upstream runtime smoke tests.
See [the CI guide](./.github/README.md) for coverage and local checks.

See [CONTRIBUTING.md](./CONTRIBUTING.md) for contribution conventions and
verification guidance.

## License

All modules are licensed under the [MIT License](./LICENSE).
