# FluentCI Modules

Reusable CI/CD modules written in PureScript and compiled to WebAssembly for
FluentCI. Build containers, package Linux applications, publish artifacts, and
cache Nix build outputs, format and lint sources, manage infrastructure, and
deploy applications using independently configured modules.

## Modules

All modules are registered in [fluentci.toml](./fluentci.toml).

| Module | Purpose | WebAssembly functions |
| --- | --- | --- |
| [actionlint](./linting/actionlint/README.md) | Run Actionlint commands with validated JSON inputs. | `run`, `version`, `lint`, [all commands](./linting/actionlint/OPTIONS.md) |
| [argocd](./deployment/argocd/README.md) | Run Argo CD commands with validated JSON inputs. | `run`, `version`, `app_get`, `app_sync`, [all commands](./deployment/argocd/OPTIONS.md) |
| [aws](./cloud/aws/README.md) | Run AWS commands with validated JSON inputs. | `run`, `version`, `identity`, `s3_cp`, [all commands](./cloud/aws/OPTIONS.md) |
| [azure](./cloud/azure/README.md) | Run Azure commands with validated JSON inputs. | `run`, `version`, `account_show`, `group_deploy`, [all commands](./cloud/azure/OPTIONS.md) |
| [betterleaks](./security/betterleaks/README.md) | Scan secrets with Betterleaks 1.x and redacted reports. | `scan_dir`, `scan_git`, `version`, [all commands](./security/betterleaks/OPTIONS.md) |
| [biome](./linting/biome/README.md) | Run Biome commands with validated JSON inputs. | `run`, `version`, `check`, `lint`, [all commands](./linting/biome/OPTIONS.md) |
| [black](./formatting/black/README.md) | Run Black commands with validated JSON inputs. | `run`, `version`, `format`, `check`, [all commands](./formatting/black/OPTIONS.md) |
| [buildkit](./containers/buildkit/README.md) | Run BuildKit commands with validated JSON inputs. | `run`, `version`, `build`, `prune`, [all commands](./containers/buildkit/OPTIONS.md) |
| [buildx](./containers/buildx/README.md) | Run Docker Buildx with typed command arguments. | `build`, `bake`, `create`, and [other commands](./containers/buildx/OPTIONS.md) |
| [bun](./setup/bun/README.md) | Install Bun and select a version. | `setup` |
| [cachix](./caching/cachix/README.md) | Configure a Cachix cache and upload Nix outputs. | `setup`, `push` |
| [checkov](./security/checkov/README.md) | Run Checkov through validated native CLI commands. | `run`, `version`, `scan`, [all commands](./security/checkov/OPTIONS.md) |
| [codacy](./code-quality/codacy/README.md) | Run Codacy through validated native CLI commands. | `run`, `help`, `upload`, [all commands](./code-quality/codacy/OPTIONS.md) |
| [codecov](./code-quality/codecov/README.md) | Run Codecov through validated native CLI commands. | `run`, `version`, `upload`, [all commands](./code-quality/codecov/OPTIONS.md) |
| [coveralls](./code-quality/coveralls/README.md) | Run Coveralls through validated native CLI commands. | `run`, `version`, `upload`, `done`, [all commands](./code-quality/coveralls/OPTIONS.md) |
| [cypress](./testing/cypress/README.md) | Run Cypress tests and install browser binaries. | `run`, `version`, `test`, `install`, [all commands](./testing/cypress/OPTIONS.md) |
| [deno](./setup/deno/README.md) | Install Deno and select a version. | `setup` |
| [determinate-nix](./setup/determinate-nix/README.md) | Install Determinate Nix and select a version. | `setup` |
| [digitalocean](./cloud/digitalocean/README.md) | Run DigitalOcean commands with validated JSON inputs. | `run`, `version`, `account_get`, `droplets_list`, [all commands](./cloud/digitalocean/OPTIONS.md) |
| [docker](./containers/docker/README.md) | Run Docker commands with validated JSON inputs. | `run`, `version`, `build`, `pull`, [all commands](./containers/docker/OPTIONS.md) |
| [doppler](./secrets/doppler/README.md) | Manage Doppler secrets through the native CLI. | `run`, `version`, `run_command`, `names`, [all commands](./secrets/doppler/OPTIONS.md) |
| [dpkg](./packaging/dpkg/README.md) | Build `.deb` packages from a validated package root. | `validate`, `build` |
| [elixir](./setup/elixir/README.md) | Install Elixir and select a version. | `setup` |
| [flyctl](./deployment/flyctl/README.md) | Run Fly.io commands with validated JSON inputs. | `run`, `version`, `deploy`, `status`, [all commands](./deployment/flyctl/OPTIONS.md) |
| [gcloud](./cloud/gcloud/README.md) | Run Google Cloud commands with validated JSON inputs. | `run`, `version`, `config_list`, `run_deploy`, [all commands](./cloud/gcloud/OPTIONS.md) |
| [gemfury](./publishing/gemfury/README.md) | Upload existing packages to a Gemfury account. | `upload` |
| [gitleaks](./security/gitleaks/README.md) | Run Gitleaks through validated native CLI commands. | `run`, `version`, `scan_dir`, `scan_git`, [all commands](./security/gitleaks/OPTIONS.md) |
| [gleam](./setup/gleam/README.md) | Install Gleam and select a version. | `setup` |
| [go](./setup/go/README.md) | Install Go and select a version. | `setup` |
| [grype](./security/grype/README.md) | Run Grype through validated native CLI commands. | `run`, `version`, `scan`, `db_update`, [all commands](./security/grype/OPTIONS.md) |
| [helm](./deployment/helm/README.md) | Run Helm commands with validated JSON inputs. | `run`, `version`, `lint`, `template`, [all commands](./deployment/helm/OPTIONS.md) |
| [infisical](./secrets/infisical/README.md) | Manage Infisical secrets through the native CLI. | `run`, `version`, `run_command`, [all commands](./secrets/infisical/OPTIONS.md) |
| [java](./setup/java/README.md) | Install Java and select a version. | `setup` |
| [kamal](./deployment/kamal/README.md) | Run Kamal commands with validated JSON inputs. | `run`, `version`, `deploy`, `setup`, [all commands](./deployment/kamal/OPTIONS.md) |
| [kubectl](./deployment/kubectl/README.md) | Run Kubectl commands with validated JSON inputs. | `run`, `version`, `apply`, `get`, [all commands](./deployment/kubectl/OPTIONS.md) |
| [netlify](./deployment/netlify/README.md) | Run Netlify commands with validated JSON inputs. | `run`, `version`, `deploy`, `build`, [all commands](./deployment/netlify/OPTIONS.md) |
| [nix](./setup/nix/README.md) | Install Nix and select a version. | `setup` |
| [nix-package](./package-management/nix/README.md) | Run Nix packages commands with validated JSON inputs. | `run`, `version`, `build`, `eval`, [all commands](./package-management/nix/OPTIONS.md) |
| [node](./setup/node/README.md) | Install Node.js and select a version. | `setup` |
| [openbao](./secrets/openbao/README.md) | Manage OpenBao secrets through the native CLI. | `run`, `version`, `status`, `kv_list`, [all commands](./secrets/openbao/OPTIONS.md) |
| [opentofu](./infrastructure/opentofu/README.md) | Run OpenTofu commands with validated JSON inputs. | `run`, `version`, `init`, `validate`, [all commands](./infrastructure/opentofu/OPTIONS.md) |
| [pkl](./setup/pkl/README.md) | Install Pkl and select a version. | `setup` |
| [playwright](./testing/playwright/README.md) | Run Playwright tests and install browser binaries. | `run`, `version`, `test`, `list`, [all commands](./testing/playwright/OPTIONS.md) |
| [podman](./containers/podman/README.md) | Run Podman commands with validated JSON inputs. | `run`, `version`, `build`, `pull`, [all commands](./containers/podman/OPTIONS.md) |
| [prettier](./formatting/prettier/README.md) | Run Prettier commands with validated JSON inputs. | `run`, `version`, `format`, `check`, [all commands](./formatting/prettier/OPTIONS.md) |
| [pulumi](./infrastructure/pulumi/README.md) | Run Pulumi commands with validated JSON inputs. | `run`, `version`, `preview`, `up`, [all commands](./infrastructure/pulumi/OPTIONS.md) |
| [purescript](./setup/purescript/README.md) | Install Node, Bun, npm, PureScript, and Spago. | `setup` |
| [railway](./deployment/railway/README.md) | Run Railway commands with validated JSON inputs. | `run`, `version`, `up`, `status`, [all commands](./deployment/railway/OPTIONS.md) |
| [render](./deployment/render/README.md) | Run Render commands with validated JSON inputs. | `run`, `version`, `services`, `deploy`, [all commands](./deployment/render/OPTIONS.md) |
| [rpmbuild](./packaging/rpmbuild/README.md) | Build `.rpm` packages from a validated RPM tree. | `validate`, `build` |
| [ruff](./linting/ruff/README.md) | Run Ruff commands with validated JSON inputs. | `run`, `version`, `check`, `format`, [all commands](./linting/ruff/OPTIONS.md) |
| [rust](./setup/rust/README.md) | Install Rust and select a version. | `setup` |
| [rustfmt](./formatting/rustfmt/README.md) | Run Rustfmt commands with validated JSON inputs. | `run`, `version`, `format`, `check`, [all commands](./formatting/rustfmt/OPTIONS.md) |
| [scorecard](./security/scorecard/README.md) | Run OpenSSF Scorecard through validated native CLI commands. | `run`, `version`, `scan`, `scan_local`, [all commands](./security/scorecard/OPTIONS.md) |
| [semgrep](./security/semgrep/README.md) | Run Semgrep through validated native CLI commands. | `run`, `version`, `scan`, `ci`, [all commands](./security/semgrep/OPTIONS.md) |
| [shellcheck](./linting/shellcheck/README.md) | Run ShellCheck commands with validated JSON inputs. | `run`, `version`, `lint`, [all commands](./linting/shellcheck/OPTIONS.md) |
| [snyk](./security/snyk/README.md) | Run Snyk through validated native CLI commands. | `run`, `version`, `setup`, `test`, [all commands](./security/snyk/OPTIONS.md) |
| [sonarqube](./code-quality/sonarqube/README.md) | Run SonarQube through validated native CLI commands. | `run`, `version`, `scan`, [all commands](./code-quality/sonarqube/OPTIONS.md) |
| [syft](./security/syft/README.md) | Run Syft through validated native CLI commands. | `run`, `version`, `scan`, `convert`, [all commands](./security/syft/OPTIONS.md) |
| [terraform](./infrastructure/terraform/README.md) | Run Terraform commands with validated JSON inputs. | `run`, `version`, `init`, `validate`, [all commands](./infrastructure/terraform/OPTIONS.md) |
| [terragrunt](./infrastructure/terragrunt/README.md) | Run Terragrunt commands with validated JSON inputs. | `run`, `version`, `hcl_fmt`, `init`, [all commands](./infrastructure/terragrunt/OPTIONS.md) |
| [trivy](./security/trivy/README.md) | Run Trivy through validated native CLI commands. | `run`, `version`, `filesystem`, `image`, [all commands](./security/trivy/OPTIONS.md) |
| [trufflehog](./security/trufflehog/README.md) | Run TruffleHog through validated native CLI commands. | `run`, `version`, `filesystem`, `git`, [all commands](./security/trufflehog/OPTIONS.md) |
| [ubicloud](./cloud/ubicloud/README.md) | Run Ubicloud commands with validated JSON inputs. | `run`, `help`, [all commands](./cloud/ubicloud/OPTIONS.md) |
| [uv](./package-management/uv/README.md) | Manage Python dependencies and build or publish distributions. | `sync`, `lock`, `run_command`, [all commands](./package-management/uv/OPTIONS.md) |
| [vault](./secrets/vault/README.md) | Manage Vault secrets through the native CLI. | `run`, `version`, `status`, `kv_list`, [all commands](./secrets/vault/OPTIONS.md) |
| [vercel](./deployment/vercel/README.md) | Run Vercel commands with validated JSON inputs. | `run`, `version`, `deploy`, `build`, [all commands](./deployment/vercel/OPTIONS.md) |
| [yamllint](./linting/yamllint/README.md) | Run Yamllint commands with validated JSON inputs. | `run`, `version`, `lint`, [all commands](./linting/yamllint/OPTIONS.md) |
| [zig](./setup/zig/README.md) | Install Zig and select a version. | `setup` |

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
