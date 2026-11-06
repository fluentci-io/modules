# FluentCI Modules

Reusable CI/CD modules written in PureScript and compiled to WebAssembly for
FluentCI. Build containers, package Linux applications, publish artifacts, and
cache Nix build outputs using independently configured modules.

## Modules

All five modules are registered in [fluentci.toml](./fluentci.toml).

| Module | Purpose | WebAssembly functions |
| --- | --- | --- |
| [cachix](./caching/cachix/README.md) | Configure a Cachix cache and upload Nix outputs. | `setup`, `push` |
| [buildx](./containers/buildx/README.md) | Run Docker Buildx with typed command arguments. | `build`, `bake`, `create`, and [other commands](./containers/buildx/OPTIONS.md) |
| [gemfury](./publishing/gemfury/README.md) | Upload existing packages to a Gemfury account. | `upload` |
| [dpkg](./build/dpkg/README.md) | Build `.deb` packages from a validated package root. | `validate`, `build` |
| [rpmbuild](./build/rpmbuild/README.md) | Build `.rpm` packages from a validated RPM tree. | `validate`, `build` |

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

Buildx, dpkg, and rpmbuild accept JSON objects as plugin input. For example,
the dpkg `build` function accepts:

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
invocation; Cachix requires a Nix flake workspace.

## Development

Install Node.js, Spago, the PureScript compiler, and `extism-js`. Build and
test modules from their own directories:

```sh
cd build/dpkg
npm ci
npm run build
npm test
```

Each build produces `dist/plugin.wasm`. Linux integration tests for dpkg and
rpmbuild create and inspect real packages when their native tools are
available; those tests are skipped on other hosts.

Some existing modules need additional development resources: Cachix references
`caching/common`, while Buildx requires schema files absent from this checkout.
Their READMEs describe these prerequisites. Buildx also requires Python 3 for
its generator checks.

See [CONTRIBUTING.md](./CONTRIBUTING.md) for contribution conventions and
verification guidance.

## License

All modules are licensed under the [MIT License](./LICENSE).
