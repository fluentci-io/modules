# Setup pkgx

Install and verify pkgx, then optionally install versioned packages for a
CI/CD pipeline. Implemented as a typed PureScript Wasm component for FluentCI
v0.17.2+.

```sh
fluentci run setup-pkgx setup --version latest \
  --packages nodejs.org@22.14.0,python.org=3.12.9
fluentci run setup-pkgx setup --help
```

`version` selects the **pkgx release**. `packages` is an optional comma-separated string of
native package selectors, each carrying its own version. Omitting it or passing
a blank value installs only the manager and preserves the existing behavior.
Whitespace around selectors is trimmed; empty entries between commas are rejected.
Package/version availability depends on the manager’s registry and platform;
missing versions and failed installs fail the setup call.

Use fully qualified pkgx names where possible: `nodejs.org@22` selects the
22.x family; `python.org=3.12.9` requests an exact release. Selectors must not
include the leading `+`; the module adds it when invoking pkgx. Packages and
their dependencies are downloaded to pkgx’s store. Their executable, library,
and package-specific runtime variables are exported for subsequent host tasks.
The module uses pkgx’s JSON metadata and native execution environment; it does
not modify shell startup files or install packages into a system prefix.

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
[upstream package syntax](https://docs.pkgx.sh/pkgx/pkgx), and [MIT License](./LICENSE).
