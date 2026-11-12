# Setup component dependencies

Every operation module declares its corresponding `setup-*` module in
`fluentci-module.toml`. Setup modules are installers; they do not depend on
themselves. Android retains its explicit setup-java dependency. The full graph
is recorded in [module-dependencies.json](./module-dependencies.json).

The published functions import actual typed component interfaces. FluentCI
inspects the callee WIT, checks interface compatibility, and composes the setup
components into the published artifact. Relative paths are build-time source
references; users of a published module need no checkout or separate dependency
download. Publish a source module with `fluentci publish --module NAME`, rather
than uploading its uncomposed intermediate `dist/plugin.wasm`.

## Runtime behavior

Normal CLI operations reuse existing tools. After argument, platform, credential,
and input-file checks, a missing native command invokes its setup dependency with
default arguments. The command is probed again before executing the task plan.
An installer failure or a missing command after setup fails the operation.
Explicit `executable` overrides bypass automatic installation. Buildx honors its
explicit `docker` override in the same way. Set up a pinned tool version in an
earlier step when the pipeline requires one; available commands are not replaced.

Command variants select the relevant prerequisites: CTest uses setup-cmake;
Cargo formatting uses setup-rustfmt; Bun adapters have a setup-bun dependency;
GitHub artifact uploads also ensure their client SDK is configured. Offline report
gates need their report runtime, without unnecessarily installing a scanner.
Buildx declares both setup-docker and setup-buildx; Cachix declares setup-nix and
setup-cachix. Nix publishing declares setup-nix, setup-bun, and setup-flakehub-push,
selecting those needed for the operation. Native daemon readiness, credentials,
browser downloads, build inputs, and deployment permissions remain pipeline
responsibilities under each module's documented behavior.

Packaging checks Linux before setup. Gemfury and Cachix preserve credential-based
skipping and validate their upload inputs/cache names before setup. Installers can
change the host environment or leave completed downloads behind if a later task
fails; those side effects are not rolled back. Installation permissions and native
package availability are those of the companion setup module. Configure privileged
or customized installers explicitly in a prior step when defaults cannot work.

## Source builds and tests

Use FluentCI v0.17.3+ for component dependencies. The common build prepares the
declared local dependencies with `fluentci install --frozen-lockfile`, then
compiles the parent. This builds components; it does not execute their installers.
The committed locks describe local source declarations without fabricated remote
artifact hashes. Generated bindings and installed dependency artifacts are ignored.

`generate_module_dependencies.py` maintains manifests, local locks, typed imports,
and the dependency inventory. Component generation keeps public signatures and
return types aligned. CI checks these generated files and the dependency graph,
builds the real imported WIT interfaces, composes each dependency-bearing module
through its CLI help in CI without running installers, and runs host fixtures for missing tools,
available tools, installer errors, post-install availability, overrides, and input
validation. Regression bundles use test-only dependency imports; the published
Wasm uses real native component imports. The opt-in Android live workflow continues
to exercise actual composition and installation on Linux/macOS.
