# Setup Flox

Install and verify Flox, then optionally install versioned packages for a
CI/CD pipeline. Implemented as a typed PureScript Wasm component for FluentCI
v0.17.2+.

```sh
fluentci run setup-flox setup --version latest \
  --packages '["nodejs@22.14.0","python3@3.12.9"]' --project .
fluentci run setup-flox setup --help
```

`version` selects the **Flox release**. `packages` is an optional list of
native package selectors, each carrying its own version. Omitting the list or
passing `[]` installs only the manager and preserves the existing behavior.
Package/version availability depends on the manager’s registry and platform;
missing versions and failed installs fail the setup call.

`packages` accepts Flox catalog selectors such as `nodejs@22` or
`python3@3.12.9`. `project` selects an existing directory (default `.`). Setup
initializes an empty `fluentci` environment if `.flox` is absent, without automatic
language detection, then installs the requested packages. Existing environments
are reused and their other packages are retained. This updates the local Flox
manifest and lockfile; preserve them for reproducibility.

Setup exports the activated executable PATH without starting services. Activation
may run the project’s native hooks; use trusted environment definitions. Use
`flox activate --dir PROJECT -- CMD` when a command needs the complete native
activation environment, hooks, or shell state.

Package environments support Linux/macOS. CLI-only BSD setup still uses native
repositories when available; supplying `packages` on BSD fails before mutation.
The Flox CLI uses native packages: macOS needs the official Homebrew formula,
and Linux needs a configured repository providing Flox or an existing official
installation. Requested CLI releases must be available in that source.

The return type remains `tool`, `version`, `bin-dir`, and `environment` (a list
of `{name, value}` records). `bin-dir` identifies the manager; use the returned
**environment PATH** to include requested package executables. Updates apply to
later tasks in the same host session. Separate processes must propagate the
returned environment. No successful environment is published if installation or
environment discovery fails; already installed files or project updates may remain.

For upstream archive installations, `install-dir` selects an absolute per-user
manager prefix. Native packages use the system prefix; omit `install-dir`, use
`package-name` for a native manager package selector, and `sudo` when needed.
These manager installation options do not change package versions in `packages`.

See [COMPONENT.md](./COMPONENT.md) for every typed argument and return,
[upstream package syntax](https://flox.dev/docs/man/flox-install), and [MIT License](./LICENSE).
