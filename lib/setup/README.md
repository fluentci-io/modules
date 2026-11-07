# Shared setup library

PureScript implementation shared by the [runtime setup modules](../../setup/README.md).
This is a local Spago library, not a separately registered WebAssembly module.

- `CI.Setup` dispatches installers; generated `CI.Component` functions expose
  typed argument records and native setup-result records.
- `CI.Setup.Types` validates configuration and host support.
- `CI.Setup.Archive` resolves upstream releases and installs runtime archives.
- `CI.Setup.BSD` installs native packages and activates package-owned executables.
- `CI.Setup.Installer` handles rustup and the two Nix installers.
- `CI.Setup.Host` wraps host execution, verification, temporary files, and
  environment publication.

Build a module under `setup/` to compile this library. Tests in
[`test/setup`](../../test/setup) are run by each module's `npm test` command.
When changing shared code, rebuild and test all setup modules so their bundled
plugins include the change.

Use the FluentCI SDK's literal argument API for host commands. The SDK's
`FluentCI.Plugin.Internal.Imports.set_envs` import publishes verified setup
environment variables because the high-level plugin API does not expose a
setter. Keep this wire payload an array of `[key, value]` pairs.

## License

[MIT](./LICENSE).
