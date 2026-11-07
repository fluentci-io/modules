# Contributing

Contributions to FluentCI Modules should keep modules reusable, independently
buildable, and documented. Read the target module's README and source before
making changes.

## Set up a module

Install Node.js, Spago, the PureScript compiler, and `extism-js`. Run commands
from the module directory; there is no root npm workspace:

```sh
cd publishing/gemfury
npm ci
npm run build
npm test
```

Build before testing because tests load compiled PureScript or a bundled
plugin. Each build produces `dist/plugin.wasm`. Buildx additionally requires
Python 3 and the schema resources described in its README. Cachix currently
references a local `fluentci-ci-common` package at `caching/common`; provide
that dependency before building it.

## Module conventions

- Place modules under the appropriate category, such as `build/`,
  `containers/`, `caching/`, or `publishing/`.
- Write module behavior in PureScript and expose WebAssembly entry points
  through `entry.mjs` and the matching `main` declarations in `imports.d.ts`.
- Include a README, MIT `LICENSE`, package manifests and lockfiles, Spago
  configuration and lockfile, build script, tests, and `.gitignore`.
- Register new modules in the root `fluentci.toml` with a unique name,
  version, source path, and `sdk = "purescript"`. Update the root README's
  module table as well.
- Keep module metadata, paths, payloads, and configuration generic. Avoid
  embedding a particular application's binary name or release layout.
- Validate configuration before changing files or publishing artifacts.
  Check host OS restrictions and required external tools where applicable.
- Pass external commands as literal argument arrays through the FluentCI
  host API. Keep credentials in environment variables or secret stores,
  rather than interpolating their values into commands or logs.
- Document entry points, input types, required tools, environment variables,
  output paths, platform restrictions, and failure behavior.

Keep generated build output and installed dependencies out of Git, including
`dist/`, `output/`, `.spago/`, and `node_modules/`. Never commit credentials or
local environment files such as `.envrc`.

The setup modules share the checked-in `lib/setup` package and the fixtures
in `test/setup`. Rebuild every setup module after changing that shared library,
then run their tests. See [the setup guide](./setup/README.md) for OS coverage
and optional upstream smoke tests. Keep new module registrations alphabetized
by name in `fluentci.toml`.

## Verification

Run the affected module's build and tests. Add tests for meaningful changes
to behavior, including validation failures and native command failures.
Stub-host tests should exercise compiled code and avoid real credentials,
uploads, or package installation.

The dpkg and rpmbuild modules are Linux-only. Their native integration tests
run when the required packaging tools are installed and otherwise skip.
For packaging changes, run those tests on Linux and confirm they actually
execute, then inspect the generated package metadata and payload. Selecting
a target architecture does not provide a cross-compiler.

For Buildx, edit `buildx-options.json` and regenerate using `python3 generate.py`
rather than editing generated command sources or `OPTIONS.md` directly.
Generation requires the schema resources listed in the module README;
`python3 generate.py --check` checks generated files without rewriting them.

Before submitting, check for whitespace errors:

```sh
git diff --check
```

For documentation-only changes, verify examples against the source and check
local links. Include any skipped checks and the reason in your pull request.

## Commits and pull requests

Use focused conventional commits, for example:

```text
feat(dpkg): support an additional architecture alias
fix(gemfury): preserve literal package filenames
docs: document module setup
chore(modules): register a new module
```

Keep unrelated changes in separate commits. Pull requests should explain the
problem, resulting behavior, and validation performed. Describe any changes
to entry points, configuration, or supported platforms so users can migrate.

## License

Contributions are made under the repository's [MIT License](./LICENSE).
Keep module license files and package license metadata consistent with it.
