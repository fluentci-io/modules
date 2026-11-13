# Setup SonarQube CLI

Install the standalone **`sonar` CLI**, verify its version, and publish PATH for
later CI/CD steps. Native Wasm component written in PureScript; requires FluentCI
v0.17.3+. For `sonar-scanner`, use
[setup-sonarqube-scanner](../sonarqube-scanner/README.md).

```sh
fluentci run setup-sonarqube setup --version latest
fluentci run setup-sonarqube setup --version 1.12.0
fluentci run setup-sonarqube setup --version 1.12.0.17622
fluentci run setup-sonarqube setup --help
```

## Platforms and installation

Supports Linux x86-64/ARM64 and macOS ARM64. BSD, Windows, and native Intel macOS
installations fail explicitly. This follows the vendor's standalone binary
platforms; the installer does not silently substitute SonarScanner or enable Rosetta.

`latest` resolves the vendor's `stable.version` to a concrete CDN release ID.
Three-part versions resolve against the latest 100 GitHub releases; for an older
release, pass its full four-part ID. Exact IDs need no release-discovery request.
Downloads come directly from `binaries.sonarsource.com` over HTTPS, using `.bin`
with the vendor's `.exe` fallback for older Linux/macOS builds. The vendor does
not supply a checksum through this installation contract; no checksum is invented.
The installed banner must match the selected semantic version. A banner omits
its CDN build ID, so verification checks the three-part version.

Installations live under `~/.local/share/fluentci/sonarqube/<release-id>` unless
`installDir` is supplied. Existing installations are verified before reuse;
failed new installations are cleaned up and never publish PATH. Java is not
required to install this standalone CLI. `sudo` and `packageName` are unsupported.
The install requires curl and standard filesystem utilities and does not execute
the vendor's shell installer or change shell profiles.

## Returned environment

Returns `tool`, `version`, `binDir`, and `environment` (name/value records).
Environment changes apply to subsequent tasks in the same host session. Separate
shell sessions must apply the returned PATH themselves. Analysis engines or other
native subcommands may download additional resources when first used.

For CI authentication, set `SONARQUBE_CLI_TOKEN` with `SONARQUBE_CLI_ORG` (Cloud)
or `SONARQUBE_CLI_SERVER` (Server). Setup installs the CLI without logging in.

See [COMPONENT.md](./COMPONENT.md), the
[official CLI](https://www.sonarsource.com/sonarqube/cli/), and [MIT License](./LICENSE).
