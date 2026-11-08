# Setup Devbox

Install and verify Devbox, then optionally install versioned packages for a
CI/CD pipeline. Implemented as a typed PureScript Wasm component for FluentCI
v0.17.2+.

```sh
fluentci run setup-devbox setup --version latest \
  --packages nodejs@22.14.0,python3@3.12.9 --project .
fluentci run setup-devbox setup --help
```

`version` selects the **Devbox release**. `packages` is an optional comma-separated string of
native package selectors, each carrying its own version. Omitting it or passing
a blank value installs only the manager and preserves the existing behavior.
Whitespace around selectors is trimmed; empty entries between commas are rejected.
Package/version availability depends on the manager’s registry and platform;
missing versions and failed installs fail the setup call.

`packages` accepts Devbox selectors such as `nodejs@22` or
`python3@3.12.9`. Nix must already be installed and available on PATH; use
`setup-nix` first. Setup fails before installing the CLI if Nix is missing and
packages were requested. It never starts an interactive Nix installer.

`project` selects an existing project directory (default `.`). Setup initializes
`devbox.json` if missing, adds the requested packages, and installs the resulting
environment. This updates the project’s manifest and lockfile; existing packages
are retained. Commit `devbox.lock` for reproducibility. The activated executable
PATH is exported for later host tasks. Use `devbox run --config PROJECT -- CMD`
when commands also need the full native environment and hooks.

Package environments support Linux/macOS. CLI-only BSD setup still uses native
repositories when available; supplying `packages` on BSD fails before mutation.

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
[upstream package syntax](https://github.com/jetify-com/devbox/blob/main/internal/boxcli/add.go), and [MIT License](./LICENSE).
