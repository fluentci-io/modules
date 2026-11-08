# Setup mise

Install and verify mise, then optionally install versioned packages for a
CI/CD pipeline. Implemented as a typed PureScript Wasm component for FluentCI
v0.17.2+.

```sh
fluentci run setup-mise setup --version latest \
  --packages node@22.14.0,python@3.12.9
fluentci run setup-mise setup --help
```

`version` selects the **mise release**. `packages` is an optional comma-separated string of
native package selectors, each carrying its own version. Omitting it or passing
a blank value installs only the manager and preserves the existing behavior.
Whitespace around selectors is trimmed; empty entries between commas are rejected.
Package/version availability depends on the manager’s registry and platform;
missing versions and failed installs fail the setup call.

Use mise selectors such as `node@22.14.0`, `python@3.12.9`, or
`npm:prettier@3.5.3`. Setup invokes `mise install` with the list, then reads
`mise env --json` for those selectors. It exports the selected tools’ PATH and
environment without changing global mise configuration or running `mise use`.
Mise may also read the current project’s trusted configuration; its environment
settings and hooks remain governed by native mise behavior. Supply only trusted
project configuration and backends.

Linux/macOS install the versioned upstream CLI. BSD uses native repositories
when available; each mise backend independently determines its OS/tool support.

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
[upstream package syntax](https://mise.jdx.dev/cli/install.html), and [MIT License](./LICENSE).
