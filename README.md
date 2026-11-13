# FluentCI Modules

Reusable CI/CD modules written in PureScript and compiled to native WebAssembly
components for FluentCI **v0.17.3+**. Version 0.2.0 uses named typed arguments
and native return values; see the [migration guide](./docs/COMPONENTS.md). Build containers, package Linux applications, publish artifacts, and
cache Nix build outputs, format and lint sources, manage infrastructure, and
deploy applications using independently configured modules.

Operation modules declare their matching `setup-*` components as typed dependencies.
Missing tools are installed on demand; existing tools and explicit executable overrides
are preserved. See [module dependencies](./docs/MODULE_DEPENDENCIES.md) for publishing
and runtime behavior.

## Usage

Register source modules with the component runtime:

```toml
[[modules]]
name = "gemfury"
version = "0.2.0"
path = "vendor/fluentci-modules/publishing/gemfury"
sdk = "purescript"
runtime = "component"
```

Build packages first, configure credentials in the CI environment, then upload:

```sh
fluentci run gemfury upload --files '["dist/app.deb","dist/app.rpm"]'
fluentci run dpkg build --directory package --arch arm64 --output dist/app.deb
fluentci run setup-node setup --version 22.14.0
fluentci run cmake build --run-dir .fluentci/build --build-dir build --parallel 2
fluentci run wrangler dry-run --run-dir .fluentci/worker --outdir dist/worker
```

Functions use native named arguments and return typed values. Run
`fluentci run MODULE FUNCTION --help` for types, descriptions, and return values.
The [component guide](./docs/COMPONENTS.md) covers migration from JSON plugin
input, structured results, list arguments, building, and validation.

## Development

Install Node.js, Bun, PureScript, and Spago. Initialize the shared component
compiler once, then build/test individual modules:

```sh
bun install --cwd lib/component --frozen-lockfile
npm ci --prefix packaging/dpkg
npm run build --prefix packaging/dpkg
npm test --prefix packaging/dpkg
node scripts/validate_wasm.mjs packaging/dpkg
```

Every `dist/plugin.wasm` is a native component with embedded typed contracts.
CI checks compiled binary signatures and runs module tests on Linux/macOS;
BSD package routing uses fixtures. See [CI](./.github/README.md),
[CONTRIBUTING.md](./CONTRIBUTING.md), and the [audit](./docs/PIPELINE_AUDIT.md).

## Modules

All modules are registered alphabetically in [fluentci.toml](./fluentci.toml).
See the [pipeline audit](./docs/PIPELINE_AUDIT.md) and [CI integration guide](./docs/PIPELINES.md) for failure, credential, and artifact contracts.

| Module | Purpose | Component functions |
| --- | --- | --- |
| [actionlint](./linting/actionlint/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `lint`, [typed contract](./linting/actionlint/COMPONENT.md) |
| [apko](./containers/apko/README.md) | Run a native command with literal arguments. | `run`, `version`, `build`, [typed contract](./containers/apko/COMPONENT.md) |
| [argocd](./deployment/argocd/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `app-get`, [typed contract](./deployment/argocd/COMPONENT.md) |
| [artifactory](./artifacts/artifactory/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `upload`, [typed contract](./artifacts/artifactory/COMPONENT.md) |
| [aws](./cloud/aws/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `identity`, [typed contract](./cloud/aws/COMPONENT.md) |
| [azure](./cloud/azure/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `account-show`, [typed contract](./cloud/azure/COMPONENT.md) |
| [bazel](./build/bazel/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `build`, [typed contract](./build/bazel/COMPONENT.md) |
| [betterleaks](./security/betterleaks/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `scan-dir`, [typed contract](./security/betterleaks/COMPONENT.md) |
| [biome](./linting/biome/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `check`, [typed contract](./linting/biome/COMPONENT.md) |
| [black](./formatting/black/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `format`, [typed contract](./formatting/black/COMPONENT.md) |
| [buildkit](./containers/buildkit/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `build`, [typed contract](./containers/buildkit/COMPONENT.md) |
| [buildx](./containers/buildx/README.md) | Run Docker Buildx buildx and return execution report paths. | `buildx`, `dap`, `debug`, [typed contract](./containers/buildx/COMPONENT.md) |
| [cachix](./caching/cachix/README.md) | Configure a Cachix cache using host credentials. | `setup`, `push`, [typed contract](./caching/cachix/COMPONENT.md) |
| [checkov](./security/checkov/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `scan`, [typed contract](./security/checkov/COMPONENT.md) |
| [cmake](./build/cmake/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `configure`, [typed contract](./build/cmake/COMPONENT.md) |
| [codacy](./code-quality/codacy/README.md) | Execute arbitrary literal CLI arguments. | `run`, `help`, `upload`, [typed contract](./code-quality/codacy/COMPONENT.md) |
| [codecov](./code-quality/codecov/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `upload`, [typed contract](./code-quality/codecov/COMPONENT.md) |
| [cosign](./security/cosign/README.md) | Sign images and release files; enforce key or keyless signature verification. | `sign`, `sign-blob`, `verify`, `verify-key`, `verify-blob`, `verify-blob-key`, `run`, `version`, [typed contract](./security/cosign/COMPONENT.md) |
| [coveralls](./code-quality/coveralls/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `upload`, [typed contract](./code-quality/coveralls/COMPONENT.md) |
| [cypress](./testing/cypress/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `setup`, [typed contract](./testing/cypress/COMPONENT.md) |
| [digitalocean](./cloud/digitalocean/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `account-get`, [typed contract](./cloud/digitalocean/COMPONENT.md) |
| [docker](./containers/docker/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `build`, [typed contract](./containers/docker/COMPONENT.md) |
| [doppler](./secrets/doppler/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `run-command`, [typed contract](./secrets/doppler/COMPONENT.md) |
| [dpkg](./packaging/dpkg/README.md) | Build packages from a Linux dpkg package tree and target architecture. | `build`, `validate`, [typed contract](./packaging/dpkg/COMPONENT.md) |
| [drizzlekit](./databases/drizzlekit/README.md) | Generate, check and apply SQL migrations. | `run`, `version`, `migrate`, [typed contract](./databases/drizzlekit/COMPONENT.md) |
| [flyctl](./deployment/flyctl/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `deploy`, [typed contract](./deployment/flyctl/COMPONENT.md) |
| [garden](./deployment/garden/README.md) | Build, deploy, test and clean up Garden project environments. | `run`, `build`, `deploy`, `test`, [typed contract](./deployment/garden/COMPONENT.md) |
| [gcloud](./cloud/gcloud/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `config-list`, [typed contract](./cloud/gcloud/COMPONENT.md) |
| [gemfury](./publishing/gemfury/README.md) | Upload Linux packages to Gemfury using credentials from the host environment. | `upload`, [typed contract](./publishing/gemfury/COMPONENT.md) |
| [gh-artifacts](./artifacts/gh-artifacts/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `upload`, [typed contract](./artifacts/gh-artifacts/COMPONENT.md) |
| [gitlab-artifacts](./artifacts/gitlab-artifacts/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `upload`, [typed contract](./artifacts/gitlab-artifacts/COMPONENT.md) |
| [gitleaks](./security/gitleaks/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `scan-dir`, [typed contract](./security/gitleaks/COMPONENT.md) |
| [grype](./security/grype/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `scan`, [typed contract](./security/grype/COMPONENT.md) |
| [helm](./deployment/helm/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `lint`, [typed contract](./deployment/helm/COMPONENT.md) |
| [infisical](./secrets/infisical/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `run-command`, [typed contract](./secrets/infisical/COMPONENT.md) |
| [jfrog-cli](./artifacts/jfrog-cli/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `upload`, [typed contract](./artifacts/jfrog-cli/COMPONENT.md) |
| [kamal](./deployment/kamal/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `deploy`, [typed contract](./deployment/kamal/COMPONENT.md) |
| [kubectl](./deployment/kubectl/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `apply`, [typed contract](./deployment/kubectl/COMPONENT.md) |
| [meson](./build/meson/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `configure`, [typed contract](./build/meson/COMPONENT.md) |
| [netlify](./deployment/netlify/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `deploy`, [typed contract](./deployment/netlify/COMPONENT.md) |
| [nexus](./artifacts/nexus/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `upload`, [typed contract](./artifacts/nexus/COMPONENT.md) |
| [ninja](./build/ninja/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `build`, [typed contract](./build/ninja/COMPONENT.md) |
| [nix-package](./package-management/nix/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `build`, [typed contract](./package-management/nix/COMPONENT.md) |
| [nix-publish](./publishing/nix-publish/README.md) | Publish Nix flakes to FlakeHub or Flakestry. | `flakehub`, `flakestry`, [typed contract](./publishing/nix-publish/COMPONENT.md) |
| [nx](./build/nx/README.md) | Run workspace targets, affected builds and CI checks. | `run-many`, `affected`, `run-target`, [typed contract](./build/nx/COMPONENT.md) |
| [openbao](./secrets/openbao/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `status`, [typed contract](./secrets/openbao/COMPONENT.md) |
| [opentofu](./infrastructure/opentofu/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `init`, [typed contract](./infrastructure/opentofu/COMPONENT.md) |
| [oras](./artifacts/oras/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `push`, [typed contract](./artifacts/oras/COMPONENT.md) |
| [pgroll](./databases/pgroll/README.md) | Run PostgreSQL schema migrations, backfills, and rollout checks. | `migrate`, [typed contract](./databases/pgroll/COMPONENT.md) |
| [planetscale](./databases/planetscale/README.md) | Manage preview database branches, migrations, and native CLI workflows. | `run`, `branch-create`, [typed contract](./databases/planetscale/COMPONENT.md) |
| [playwright](./testing/playwright/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `setup`, [typed contract](./testing/playwright/COMPONENT.md) |
| [plumber](./security/plumber/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `analyze`, [typed contract](./security/plumber/COMPONENT.md) |
| [podman](./containers/podman/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `build`, [typed contract](./containers/podman/COMPONENT.md) |
| [prettier](./formatting/prettier/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `format`, [typed contract](./formatting/prettier/COMPONENT.md) |
| [prisma](./databases/prisma/README.md) | Validate schemas, generate clients and deploy migrations. | `run`, `version`, `migrate-deploy`, [typed contract](./databases/prisma/COMPONENT.md) |
| [protolint](./linting/protolint/README.md) | Run a native command with literal arguments. | `run`, `version`, `lint`, [typed contract](./linting/protolint/COMPONENT.md) |
| [pulumi](./infrastructure/pulumi/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `preview`, [typed contract](./infrastructure/pulumi/COMPONENT.md) |
| [railpack](./containers/railpack/README.md) | Run a native command with literal arguments. | `run`, `version`, `prepare`, [typed contract](./containers/railpack/COMPONENT.md) |
| [railway](./deployment/railway/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `up`, [typed contract](./deployment/railway/COMPONENT.md) |
| [rclone](./artifacts/rclone/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `copy`, [typed contract](./artifacts/rclone/COMPONENT.md) |
| [render](./deployment/render/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `services`, [typed contract](./deployment/render/COMPONENT.md) |
| [rpmbuild](./packaging/rpmbuild/README.md) | Build packages from a Linux rpmbuild package tree and target architecture. | `build`, `validate`, [typed contract](./packaging/rpmbuild/COMPONENT.md) |
| [ruff](./linting/ruff/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `check`, [typed contract](./linting/ruff/COMPONENT.md) |
| [rustfmt](./formatting/rustfmt/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `format`, [typed contract](./formatting/rustfmt/COMPONENT.md) |
| [sccache](./caching/sccache/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `start-server`, [typed contract](./caching/sccache/COMPONENT.md) |
| [scorecard](./security/scorecard/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `scan`, [typed contract](./security/scorecard/COMPONENT.md) |
| [semgrep](./security/semgrep/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `scan`, [typed contract](./security/semgrep/COMPONENT.md) |
| [setup-actionlint](./setup/actionlint/README.md) | Install and verify actionlint, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/actionlint/COMPONENT.md) |
| [setup-android](./setup/android/README.md) | Install Java and a customizable Android SDK for Linux/macOS CI. | `setup`, [typed contract](./setup/android/COMPONENT.md) |
| [setup-apko](./setup/apko/README.md) | Install and verify apko, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/apko/COMPONENT.md) |
| [setup-argocd](./setup/argocd/README.md) | Install and verify argocd, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/argocd/COMPONENT.md) |
| [setup-artifactory](./setup/artifactory/README.md) | Install and verify artifactory, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/artifactory/COMPONENT.md) |
| [setup-aws](./setup/aws/README.md) | Install and verify aws, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/aws/COMPONENT.md) |
| [setup-azure](./setup/azure/README.md) | Install and verify azure, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/azure/COMPONENT.md) |
| [setup-babashka](./setup/babashka/README.md) | Install and verify babashka, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/babashka/COMPONENT.md) |
| [setup-bazel](./setup/bazel/README.md) | Install and verify bazel, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/bazel/COMPONENT.md) |
| [setup-betterleaks](./setup/betterleaks/README.md) | Install and verify betterleaks, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/betterleaks/COMPONENT.md) |
| [setup-binaryen](./setup/binaryen/README.md) | Install and verify binaryen, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/binaryen/COMPONENT.md) |
| [setup-biome](./setup/biome/README.md) | Install and verify biome, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/biome/COMPONENT.md) |
| [setup-black](./setup/black/README.md) | Install and verify black, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/black/COMPONENT.md) |
| [setup-buf](./setup/buf/README.md) | Install and verify buf, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/buf/COMPONENT.md) |
| [setup-buildkit](./setup/buildkit/README.md) | Install and verify buildkit, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/buildkit/COMPONENT.md) |
| [setup-buildx](./setup/buildx/README.md) | Install and verify buildx, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/buildx/COMPONENT.md) |
| [setup-bun](./setup/bun/README.md) | Install and verify bun, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/bun/COMPONENT.md) |
| [setup-cachix](./setup/cachix/README.md) | Install Cachix and optionally enable a named Nix binary cache. | `setup`, [typed contract](./setup/cachix/COMPONENT.md) |
| [setup-checkov](./setup/checkov/README.md) | Install and verify checkov, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/checkov/COMPONENT.md) |
| [setup-clojure](./setup/clojure/README.md) | Install and verify clojure, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/clojure/COMPONENT.md) |
| [setup-cmake](./setup/cmake/README.md) | Install and verify cmake, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/cmake/COMPONENT.md) |
| [setup-codacy](./setup/codacy/README.md) | Install and verify codacy, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/codacy/COMPONENT.md) |
| [setup-codecov](./setup/codecov/README.md) | Install and verify codecov, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/codecov/COMPONENT.md) |
| [setup-cosign](./setup/cosign/README.md) | Install and verify Cosign and publish PATH. | `setup`, [typed contract](./setup/cosign/COMPONENT.md) |
| [setup-coveralls](./setup/coveralls/README.md) | Install and verify coveralls, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/coveralls/COMPONENT.md) |
| [setup-cypress](./setup/cypress/README.md) | Install and verify cypress, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/cypress/COMPONENT.md) |
| [setup-dagger](./setup/dagger/README.md) | Install and verify Dagger and publish PATH. | `setup`, [typed contract](./setup/dagger/COMPONENT.md) |
| [setup-deno](./setup/deno/README.md) | Install and verify deno, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/deno/COMPONENT.md) |
| [setup-determinate-nix](./setup/determinate-nix/README.md) | Install and verify determinate-nix, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/determinate-nix/COMPONENT.md) |
| [setup-devbox](./setup/devbox/README.md) | Install devbox, optionally install versioned packages, and publish their environment. | `setup`, [typed contract](./setup/devbox/COMPONENT.md) |
| [setup-devenv](./setup/devenv/README.md) | Install and verify devenv, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/devenv/COMPONENT.md) |
| [setup-digitalocean](./setup/digitalocean/README.md) | Install and verify digitalocean, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/digitalocean/COMPONENT.md) |
| [setup-docker](./setup/docker/README.md) | Install and verify docker, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/docker/COMPONENT.md) |
| [setup-doppler](./setup/doppler/README.md) | Install and verify doppler, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/doppler/COMPONENT.md) |
| [setup-dpkg](./setup/dpkg/README.md) | Install and verify dpkg, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/dpkg/COMPONENT.md) |
| [setup-drizzlekit](./setup/drizzlekit/README.md) | Install and verify a versioned Drizzle Kit CLI. | `setup`, [typed contract](./setup/drizzlekit/COMPONENT.md) |
| [setup-elixir](./setup/elixir/README.md) | Install and verify elixir, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/elixir/COMPONENT.md) |
| [setup-erlang](./setup/erlang/README.md) | Install Erlang/OTP with archive or native-package setup and version verification. | `setup`, [typed contract](./setup/erlang/COMPONENT.md) |
| [setup-expo](./setup/expo/README.md) | Install and verify expo, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/expo/COMPONENT.md) |
| [setup-extism](./setup/extism/README.md) | Install and verify extism, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/extism/COMPONENT.md) |
| [setup-extism-cli](./setup/extism-cli/README.md) | Install and verify extism-cli, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/extism-cli/COMPONENT.md) |
| [setup-extism-js](./setup/extism-js/README.md) | Install and verify extism-js, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/extism-js/COMPONENT.md) |
| [setup-extism-py](./setup/extism-py/README.md) | Install and verify extism-py, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/extism-py/COMPONENT.md) |
| [setup-flakehub-push](./setup/flakehub-push/README.md) | Install and verify flakehub-push, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/flakehub-push/COMPONENT.md) |
| [setup-flox](./setup/flox/README.md) | Install flox, optionally install versioned packages, and publish their environment. | `setup`, [typed contract](./setup/flox/COMPONENT.md) |
| [setup-flyctl](./setup/flyctl/README.md) | Install and verify flyctl, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/flyctl/COMPONENT.md) |
| [setup-garden](./setup/garden/README.md) | Install and verify a versioned Garden CLI. | `setup`, [typed contract](./setup/garden/COMPONENT.md) |
| [setup-gcloud](./setup/gcloud/README.md) | Install and verify gcloud, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/gcloud/COMPONENT.md) |
| [setup-gemfury](./setup/gemfury/README.md) | Install and verify gemfury, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/gemfury/COMPONENT.md) |
| [setup-gh](./setup/gh/README.md) | Install the GitHub CLI and publish its executable directory to PATH. | `setup`, [typed contract](./setup/gh/COMPONENT.md) |
| [setup-gh-artifacts](./setup/gh-artifacts/README.md) | Install and verify gh-artifacts, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/gh-artifacts/COMPONENT.md) |
| [setup-gitlab-artifacts](./setup/gitlab-artifacts/README.md) | Install and verify gitlab-artifacts, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/gitlab-artifacts/COMPONENT.md) |
| [setup-gitleaks](./setup/gitleaks/README.md) | Install and verify gitleaks, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/gitleaks/COMPONENT.md) |
| [setup-gleam](./setup/gleam/README.md) | Install and verify gleam, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/gleam/COMPONENT.md) |
| [setup-go](./setup/go/README.md) | Install and verify go, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/go/COMPONENT.md) |
| [setup-grype](./setup/grype/README.md) | Install and verify grype, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/grype/COMPONENT.md) |
| [setup-helm](./setup/helm/README.md) | Install and verify helm, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/helm/COMPONENT.md) |
| [setup-infisical](./setup/infisical/README.md) | Install and verify infisical, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/infisical/COMPONENT.md) |
| [setup-java](./setup/java/README.md) | Install and verify java, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/java/COMPONENT.md) |
| [setup-jfrog-cli](./setup/jfrog-cli/README.md) | Install and verify jfrog-cli, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/jfrog-cli/COMPONENT.md) |
| [setup-kamal](./setup/kamal/README.md) | Install and verify kamal, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/kamal/COMPONENT.md) |
| [setup-kubectl](./setup/kubectl/README.md) | Install and verify kubectl, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/kubectl/COMPONENT.md) |
| [setup-macports](./setup/macports/README.md) | Install native MacPorts and optionally install pipeline dependency ports. | `setup`, [typed contract](./setup/macports/COMPONENT.md) |
| [setup-macports-rs](./setup/macports-rs/README.md) | Install the MacPorts Rust CLI and optionally install pipeline dependency ports. | `setup`, [typed contract](./setup/macports-rs/COMPONENT.md) |
| [setup-meson](./setup/meson/README.md) | Install and verify meson, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/meson/COMPONENT.md) |
| [setup-mise](./setup/mise/README.md) | Install mise, optionally install versioned packages, and publish their environment. | `setup`, [typed contract](./setup/mise/COMPONENT.md) |
| [setup-netlify](./setup/netlify/README.md) | Install and verify netlify, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/netlify/COMPONENT.md) |
| [setup-nexus](./setup/nexus/README.md) | Install and verify nexus, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/nexus/COMPONENT.md) |
| [setup-ninja](./setup/ninja/README.md) | Install and verify ninja, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/ninja/COMPONENT.md) |
| [setup-nix](./setup/nix/README.md) | Install and verify nix, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/nix/COMPONENT.md) |
| [setup-nix-package](./setup/nix-package/README.md) | Install and verify nix-package, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/nix-package/COMPONENT.md) |
| [setup-node](./setup/node/README.md) | Install and verify node, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/node/COMPONENT.md) |
| [setup-nx](./setup/nx/README.md) | Install and verify a selected Nx CLI release. | `setup`, [typed contract](./setup/nx/COMPONENT.md) |
| [setup-openbao](./setup/openbao/README.md) | Install and verify openbao, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/openbao/COMPONENT.md) |
| [setup-opentofu](./setup/opentofu/README.md) | Install and verify opentofu, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/opentofu/COMPONENT.md) |
| [setup-oras](./setup/oras/README.md) | Install and verify oras, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/oras/COMPONENT.md) |
| [setup-php](./setup/php/README.md) | Install a PHP version and isolated versioned CI tools; publish PATH. | `setup`, [typed contract](./setup/php/COMPONENT.md) |
| [setup-pkgx](./setup/pkgx/README.md) | Install pkgx, optionally install versioned packages, and publish their environment. | `setup`, [typed contract](./setup/pkgx/COMPONENT.md) |
| [setup-pkl](./setup/pkl/README.md) | Install and verify pkl, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/pkl/COMPONENT.md) |
| [setup-pgroll](./setup/pgroll/README.md) | Install and verify pgroll and publish PATH. | `setup`, [typed contract](./setup/pgroll/COMPONENT.md) |
| [setup-planetscale](./setup/planetscale/README.md) | Install and verify the PlanetScale CLI and publish PATH. | `setup`, [typed contract](./setup/planetscale/COMPONENT.md) |
| [setup-playwright](./setup/playwright/README.md) | Install and verify playwright, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/playwright/COMPONENT.md) |
| [setup-plumber](./setup/plumber/README.md) | Install and verify plumber, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/plumber/COMPONENT.md) |
| [setup-podman](./setup/podman/README.md) | Install and verify podman, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/podman/COMPONENT.md) |
| [setup-prettier](./setup/prettier/README.md) | Install and verify prettier, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/prettier/COMPONENT.md) |
| [setup-prisma](./setup/prisma/README.md) | Install and verify a versioned Prisma ORM CLI. | `setup`, [typed contract](./setup/prisma/COMPONENT.md) |
| [setup-protolint](./setup/protolint/README.md) | Install and verify protolint, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/protolint/COMPONENT.md) |
| [setup-pulumi](./setup/pulumi/README.md) | Install and verify pulumi, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/pulumi/COMPONENT.md) |
| [setup-purescript](./setup/purescript/README.md) | Install and verify purescript, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/purescript/COMPONENT.md) |
| [setup-railpack](./setup/railpack/README.md) | Install and verify railpack, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/railpack/COMPONENT.md) |
| [setup-railway](./setup/railway/README.md) | Install and verify railway, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/railway/COMPONENT.md) |
| [setup-rclone](./setup/rclone/README.md) | Install and verify rclone, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/rclone/COMPONENT.md) |
| [setup-render](./setup/render/README.md) | Install and verify render, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/render/COMPONENT.md) |
| [setup-rpmbuild](./setup/rpmbuild/README.md) | Install and verify rpmbuild, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/rpmbuild/COMPONENT.md) |
| [setup-ruff](./setup/ruff/README.md) | Install and verify ruff, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/ruff/COMPONENT.md) |
| [setup-rust](./setup/rust/README.md) | Install and verify rust, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/rust/COMPONENT.md) |
| [setup-rustfmt](./setup/rustfmt/README.md) | Install and verify rustfmt, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/rustfmt/COMPONENT.md) |
| [setup-sccache](./setup/sccache/README.md) | Install and verify sccache, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/sccache/COMPONENT.md) |
| [setup-scorecard](./setup/scorecard/README.md) | Install and verify scorecard, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/scorecard/COMPONENT.md) |
| [setup-semgrep](./setup/semgrep/README.md) | Install and verify semgrep, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/semgrep/COMPONENT.md) |
| [setup-shellcheck](./setup/shellcheck/README.md) | Install and verify shellcheck, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/shellcheck/COMPONENT.md) |
| [setup-snyk](./setup/snyk/README.md) | Install and verify snyk, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/snyk/COMPONENT.md) |
| [setup-sonarqube](./setup/sonarqube/README.md) | Install and verify sonarqube, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/sonarqube/COMPONENT.md) |
| [setup-spin](./setup/spin/README.md) | Install and verify a selected Spin release. | `setup`, [typed contract](./setup/spin/COMPONENT.md) |
| [setup-sqlfluff](./setup/sqlfluff/README.md) | Install and verify sqlfluff, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/sqlfluff/COMPONENT.md) |
| [setup-sqruff](./setup/sqruff/README.md) | Install and verify sqruff, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/sqruff/COMPONENT.md) |
| [setup-syft](./setup/syft/README.md) | Install and verify syft, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/syft/COMPONENT.md) |
| [setup-tangled-artifacts](./setup/tangled-artifacts/README.md) | Install and verify tangled-artifacts, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/tangled-artifacts/COMPONENT.md) |
| [setup-terraform](./setup/terraform/README.md) | Install and verify terraform, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/terraform/COMPONENT.md) |
| [setup-terragrunt](./setup/terragrunt/README.md) | Install and verify terragrunt, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/terragrunt/COMPONENT.md) |
| [setup-tg](./setup/tg/README.md) | Install and verify tg, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/tg/COMPONENT.md) |
| [setup-trivy](./setup/trivy/README.md) | Install and verify trivy, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/trivy/COMPONENT.md) |
| [setup-trufflehog](./setup/trufflehog/README.md) | Install and verify trufflehog, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/trufflehog/COMPONENT.md) |
| [setup-turborepo](./setup/turborepo/README.md) | Install and verify turborepo, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/turborepo/COMPONENT.md) |
| [setup-ubicloud](./setup/ubicloud/README.md) | Install and verify ubicloud, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/ubicloud/COMPONENT.md) |
| [setup-uv](./setup/uv/README.md) | Install and verify uv, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/uv/COMPONENT.md) |
| [setup-vault](./setup/vault/README.md) | Install and verify vault, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/vault/COMPONENT.md) |
| [setup-vercel](./setup/vercel/README.md) | Install and verify vercel, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/vercel/COMPONENT.md) |
| [setup-wasmer](./setup/wasmer/README.md) | Install and verify a selected Wasmer release. | `setup`, [typed contract](./setup/wasmer/COMPONENT.md) |
| [setup-wrangler](./setup/wrangler/README.md) | Install and verify wrangler, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/wrangler/COMPONENT.md) |
| [setup-xata](./setup/xata/README.md) | Install and verify the Xata CLI and publish PATH. | `setup`, [typed contract](./setup/xata/COMPONENT.md) |
| [setup-xtp](./setup/xtp/README.md) | Install and verify xtp, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/xtp/COMPONENT.md) |
| [setup-yamllint](./setup/yamllint/README.md) | Install and verify yamllint, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/yamllint/COMPONENT.md) |
| [setup-zig](./setup/zig/README.md) | Install and verify zig, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/zig/COMPONENT.md) |
| [shellcheck](./linting/shellcheck/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `lint`, [typed contract](./linting/shellcheck/COMPONENT.md) |
| [snyk](./security/snyk/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `setup`, [typed contract](./security/snyk/COMPONENT.md) |
| [sonarqube](./code-quality/sonarqube/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `scan`, [typed contract](./code-quality/sonarqube/COMPONENT.md) |
| [spin](./deployment/spin/README.md) | Build Spin apps, publish OCI artifacts and deploy through plugins. | `build`, `registry-push`, `cloud-deploy`, [typed contract](./deployment/spin/COMPONENT.md) |
| [sqlfluff](./linting/sqlfluff/README.md) | Run a native command with literal arguments. | `run`, `version`, `lint`, [typed contract](./linting/sqlfluff/COMPONENT.md) |
| [sqruff](./linting/sqruff/README.md) | Run a native command with literal arguments. | `run`, `version`, `lint`, [typed contract](./linting/sqruff/COMPONENT.md) |
| [syft](./security/syft/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `scan`, [typed contract](./security/syft/COMPONENT.md) |
| [tangled-artifacts](./artifacts/tangled-artifacts/README.md) | Execute arbitrary literal CLI arguments. | `run`, `upload`, [typed contract](./artifacts/tangled-artifacts/COMPONENT.md) |
| [terraform](./infrastructure/terraform/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `init`, [typed contract](./infrastructure/terraform/COMPONENT.md) |
| [terragrunt](./infrastructure/terragrunt/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `hcl-fmt`, [typed contract](./infrastructure/terragrunt/COMPONENT.md) |
| [trivy](./security/trivy/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `filesystem`, [typed contract](./security/trivy/COMPONENT.md) |
| [trufflehog](./security/trufflehog/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `filesystem`, [typed contract](./security/trufflehog/COMPONENT.md) |
| [turborepo](./build/turborepo/README.md) | Run cached tasks, affected builds and workspace pruning. | `run-tasks`, `affected`, `prune`, [typed contract](./build/turborepo/COMPONENT.md) |
| [ubicloud](./cloud/ubicloud/README.md) | Manage cloud resources through all 123 reviewed ubi commands; requires UBI_TOKEN. | `vm-list`, `pg-create`, `kc-kubeconfig`, [typed contract](./cloud/ubicloud/COMPONENT.md) |
| [uv](./package-management/uv/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `sync`, [typed contract](./package-management/uv/COMPONENT.md) |
| [vault](./secrets/vault/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `status`, [typed contract](./secrets/vault/COMPONENT.md) |
| [vercel](./deployment/vercel/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `deploy`, [typed contract](./deployment/vercel/COMPONENT.md) |
| [wasmer](./deployment/wasmer/README.md) | Publish Wasm packages and manage Wasmer Edge deployments. | `publish`, `deploy`, `app-get`, [typed contract](./deployment/wasmer/COMPONENT.md) |
| [wrangler](./deployment/wrangler/README.md) | Run a Wrangler operation with literal arguments. | `run`, `version`, `deploy`, [typed contract](./deployment/wrangler/COMPONENT.md) |
| [xata](./databases/xata/README.md) | Manage preview database branches, migrations, and native CLI workflows. | `run`, `branch-create`, [typed contract](./databases/xata/COMPONENT.md) |
| [yamllint](./linting/yamllint/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `lint`, [typed contract](./linting/yamllint/COMPONENT.md) |

Each module has its own dependencies, build scripts, tests, and documentation.
Source APIs also expose helpers for composition in PureScript pipelines.

## License

All modules are licensed under the [MIT License](./LICENSE).

The vendored component inspection tools retain their [upstream MPL-2.0 license](./lib/component/inspection/LICENSE).
