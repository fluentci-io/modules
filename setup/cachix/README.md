# Setup Cachix

Install and verify Cachix, then optionally configure a named binary cache with
`cachix use`. A typed PureScript Wasm component for FluentCI v0.17.2+.

```sh
fluentci run setup-cachix setup --cache fluentci
fluentci run setup-cachix setup --version latest
fluentci run setup-cachix setup --help
```

`cache` is the **cache name**, such as `fluentci`, rather than a signing key or
access token. After verifying the installed CLI, setup runs that executable’s
`cachix use CACHE` to configure Nix’s substituter and trusted public key. The
name must be a lowercase DNS label of 1–63 letters, digits, or hyphens, without
leading or trailing hyphens. Invalid names fail before installation starts.
Omitting `cache` retains CLI-only setup.

Public caches need no authentication. For a private cache, supply
`CACHIX_AUTH_TOKEN` through the runner’s secret environment before setup. The
module does not put that token in command arguments or the returned environment.
Setup configures cache reads; it does not upload build outputs or install an
automatic upload hook. Use native `cachix push CACHE PATH` for uploads.

On Linux/macOS, setup installs **`nixpkgs#cachix`** into a private Nix profile
under the per-user installation prefix. It requires an existing Nix installation
with flakes support. It does not build Cachix from its upstream GitHub flake.

`version` is checked against the Cachix version provided by the selected nixpkgs
registry entry; `latest` accepts that package’s version. An explicit version
fails if nixpkgs provides a different release. Pin the `nixpkgs` registry entry
to a suitable revision for reproducible installs of a particular package version.
The cache name is independent of the CLI version.
BSD CLI installation uses native packages when available. Configuring a cache
also requires Nix on PATH and permission to update the applicable Nix
configuration; `cachix use` determines the native configuration location. Native
package or configuration failures propagate, and no successful setup environment
is published when cache configuration fails.

Returns `tool`, `version`, `bin-dir`, and `environment`. Environment updates apply
to later tasks in the same host session; separate processes must propagate the
returned PATH. Cachix’s Nix configuration changes persist on the runner.
See [COMPONENT.md](./COMPONENT.md) for all typed arguments and returns.

[Cachix cache configuration](https://docs.cachix.org/getting-started) ·
[MIT License](./LICENSE).
