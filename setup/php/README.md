# Setup PHP

Install PHP and versioned CI tools through a typed PureScript Wasm component.
Requires FluentCI v0.17.2+.

```sh
fluentci run setup-php setup --version 8.4 \
  --tools composer:2,phpunit:11,phpstan,php-cs-fixer
fluentci run setup-php setup --version 8.3.15 --tools composer:2.8.5,psalm:5.26.1
fluentci run setup-php setup --version 7.4 --tools none
```

The version and `tool:version` interface takes inspiration from
[shivammathur/setup-php](https://github.com/shivammathur/setup-php). This is a
portable FluentCI module, with no GitHub Actions environment requirement.

## PHP versions and platforms

On Linux/macOS, the module installs mise and uses its explicit
[`vfox:jdx/vfox-php` backend](https://github.com/jdx/vfox-php). Available PHP
versions are fetched dynamically, so there is no hardcoded release allowlist.
Accepts major versions (`8`), minor versions (`8.4`), exact releases (`8.3.15`),
and upstream prerelease tags (`8.6.0RC1`). Omitted version, `latest`, and `stable`
select the latest release available to the backend. A prefix is resolved to an
exact release before installation; the resulting PHP executable is checked using
`PHP_VERSION`. Unavailable releases or mismatches fail clearly. Historical PHP
versions still depend on whether their source can build on the runner's libraries.

The backend compiles official PHP sources. Prepare the compiler and library
prerequisites in its [platform requirements](https://github.com/jdx/vfox-php#requirements):
compiler/Xcode tools, make, autoconf, bison, re2c, pkg-config, and development
libraries such as OpenSSL, libxml2, ICU, curl, and oniguruma. The module checks the
build executables; configure/build errors identify unavailable libraries. This
can take several minutes. Cache the installation prefix to reuse verified builds.
Common PHP extensions come from the backend's default build; this module does not
provide the action's extension, coverage-driver, or php.ini inputs.

Linux/macOS support x86_64 and aarch64. Use `--mise-version` to select the manager
release. `--install-dir` chooses an absolute per-user prefix for the private mise
installation data and tool directories; its default is
`$HOME/.local/share/fluentci/php/SELECTOR`. The mise executable itself is installed
through the shared setup backend. No global mise project configuration is written.

FreeBSD, NetBSD, and OpenBSD use native PHP packages, limited to configured
repository versions. Use `--package-name` for the platform's actual package
selector and `--sudo` for noninteractive elevation if needed. Versioned PHP
executables receive a per-user unversioned shim when necessary. Native packages
require `--install-dir` to be omitted; `--mise-version` is unused on BSD. Package
or tool unavailability fails setup. Windows is unsupported.

## Tools

`--tools` is a comma-separated string, trimmed before validation. Omitted tools
defaults to `composer`; blank or `none` skips this module's tool installation.
The PHP backend may itself supply Composer. There are no JSON array brackets.
Empty entries, duplicate executable names, malformed selectors, and unknown
aliases are rejected before any host command.

| Alias | Composer package / executable |
| --- | --- |
| `composer` | Verified official Composer installer |
| `phpunit` | `phpunit/phpunit` |
| `phpstan` | `phpstan/phpstan` |
| `psalm` | `vimeo/psalm` |
| `php-cs-fixer` | `friendsofphp/php-cs-fixer` |
| `phpcs`, `phpcbf` | `squizlabs/php_codesniffer` |
| `pest` | `pestphp/pest` |
| `rector` | `rector/rector` |
| `infection` | `infection/infection` |
| `deployer` | `deployer/deployer`, executable `dep` |
| `behat` | `behat/behat` |
| `phpspec` | `phpspec/phpspec` |
| `phpmd` | `phpmd/phpmd` |
| `pint` | `laravel/pint` |
| `parallel-lint` | `php-parallel-lint/php-parallel-lint` |

Each supports `name:version`, for example `phpunit:11.5.3` or `phpstan:^2.1`.
Omitted tool versions select a release compatible with the selected PHP via
Composer. You can also supply `vendor/package:version`; its executable must have
the package basename, such as `laravel/pint:1.20.0` providing `pint`. Aliases cover
packages whose executable differs. Unsupported tool/PHP combinations fail;
platform requirements are not ignored.

Composer accepts `latest`, channels `1`, `2`, `2.2`, or an exact release. For
`latest`, PHP older than 7.2.5 uses Composer 2.2 LTS; PHP 7.2.5+ uses Composer 2.
Composer itself requires PHP 5.3.2+; use `--tools none` for older PHP. The installer
is checked against the official SHA-384 signature before execution. Every other
tool gets its own Composer environment, so conflicting tool dependencies do not
share a manifest. Package scripts and plugins are disabled during installation;
tools requiring them need their own explicit project workflow. Every executable
is checked and its version command must succeed before setup publishes PATH.

## Results

Returns typed `tool`, `version`, `bin-dir`, and `environment` values.
`version` is the actual PHP release; `bin-dir` contains `php`. The published PATH
also contains Composer and requested tool executables. Existing setup methods
are reused without publishing an intermediate successful PHP setup. A failed
PHP build, signature check, Composer resolution, or tool verification fails the
call. Completed downloads/installations can remain available for a later retry.
Application dependency manifests are not changed; BSD installations use system packages.

Environment updates apply to subsequent FluentCI host tasks; separate processes
must propagate the returned values. [COMPONENT.md](./COMPONENT.md) describes all
named arguments and return fields. [MIT wrapper license](./LICENSE).

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add setup-php --path /path/to/fluentci-modules/setup/php
```

For a published module, use `fluentci add @fluentci.io/setup-php@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

These examples append `setup` and a native Git check to one pipeline.
Replace sample paths and identifiers with your own. Optional arguments use the
callee's defaults, and public list fields use comma-separated strings. See
[COMPONENT.md](./COMPONENT.md) for argument descriptions and return types.

These examples use the generated composition API and builder chaining in
FluentCI 0.17.6; full cross-SDK compilation and execution coverage is still pending.
See [composition support and limitations](../../docs/COMPOSITION.md).



### PureScript

```purescript
module Main where

import Prelude
import Effect (Effect)
import FluentCI.Flow as Flow
import FluentCI.Modules.SetupPhp as Dependency

run :: Effect String
run =
  Flow.pipeline "ci"
    # Flow.workdir "."
    # Dependency.setup (Dependency.setupArgs)
    # Flow.exec [ "git", "diff", "--exit-code" ]
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/setup_php as dependency

pub fn run() -> String {
  flow.pipeline("ci")
  |> flow.workdir(".")
  |> dependency.setup(dependency.setup_args())
  |> flow.exec("git", ["diff", "--exit-code"])
  |> flow.run
}
```

Use Gleam's JavaScript target for the Wasm guest. BEAM escripts used for repository
automation are separate from component guests.

### Elixir

```elixir
defmodule Main do
  use FluentCI.Plugin
  alias FluentCI.Flow
  alias FluentCI.Modules.SetupPhp, as: Dependency

  defplugin run do
    Flow.pipeline("ci")
    |> Flow.workdir(".")
    |> Dependency.setup(%{})
    |> Flow.exec(["git", "diff", "--exit-code"])
    |> Flow.stdout()
  end
end
```

Elixir compiles this sequence to Rust/Wasm. Its initial Flow API does not yet
provide the typed result callbacks or cleanup combinators of the other examples.

### ClojureScript

```clojure
(ns main.plugin
  (:require [fluentci.flow :as flow]
            [fluentci-modules.setup-php :as dependency]))

(defn run []
  (-> (flow/pipeline "ci")
      (flow/workdir ".")
      (dependency/setup {})
      (flow/exec ["git" "diff" "--exit-code"])
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("ci")
  ->Flow.workdir(".")
  ->FluentciModulesSetupPhp.setup(FluentciModulesSetupPhp.setupArgs)
  ->Flow.exec(["git", "diff", "--exit-code"])
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_php as dependency


def run() -> str:
    return (
        pipeline("ci")
        .workdir(".")
        .pipe(dependency.setup, {})
        .exec("git", "diff", "--exit-code")
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as dependency from "./fluentci_modules/setup-php/index";

export function run(): string {
  return flow.pipeline("ci")
    .workdir(".")
    .pipe(dependency.setup, {})
    .exec(["git", "diff", "--exit-code"])
    .run();
}
```

Python and TypeScript use FluentCI builder chains: `.pipe(module.function, args)`
composes generated module functions with `.workdir`, `.env`, and `.exec`.
Functions return a pipeline carrying their typed result. Use a generated result
callback (`With`/`_with`, or a callback argument in TypeScript/Python) when a later
module needs a preceding result; use Flow's map operation to select a result field.
Execution begins at `run` (or the Elixir plugin terminal), in declared order.

### Exported functions

| Function | Purpose |
| --- | --- |
| `setup` | Install and verify PHP and optional versioned CI tools, then publish their environment. |
<!-- /generated:language-examples -->
