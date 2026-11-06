# Docker Buildx for FluentCI

Run Docker Buildx commands through FluentCI using typed arguments and native
execution plans. The module is written in PureScript and compiled to
WebAssembly. Docker arguments are passed directly without shell parsing.

## Usage

Install FluentCI and Docker with the Buildx plugin. Build commands need access
to a running Docker daemon or a configured remote builder. Authenticate with
your registry before pushing images.

Each WebAssembly export accepts a JSON object as plugin input. For example,
invoke the `build` export with:

```json
{
  "project": "/path/to/project",
  "runDir": "/tmp/buildx-build-001",
  "context": ".",
  "file": "Dockerfile",
  "tag": ["example/app:latest"],
  "platform": ["linux/amd64", "linux/arm64"],
  "push": true
}
```

Use a fresh `runDir` for every invocation. The module executes one Docker task
and returns the contents of `runDir/result.json` as its output. Failed runs
raise an error pointing to that report.

## Arguments

| Common argument | Default | Meaning |
| --- | --- | --- |
| `project` | `.` | Docker command working directory. |
| `runDir` | Required | Fresh directory for FluentCI execution reports. |
| `docker` | `docker` | Docker executable name or path. |
| `timeoutMs` | `900000` | Positive task timeout in milliseconds. |
| `experimental` | `false` | Sets `BUILDX_EXPERIMENTAL` to `1` when true, otherwise `0`. |

Docker options use camelCase field names, such as `buildArg`, `cacheFrom`, and
`noCache`. Repeatable flags take arrays of strings; booleans take JSON booleans.
Omitted flags retain Docker defaults, while an explicit `false` emits
`--flag=false`. Byte sizes and durations are strings, such as `2g` and `30s`.
The `--type` option is named `type_`.

Unknown fields and incorrectly typed values are rejected. The task inherits
the host environment, including Docker configuration and registry credentials.
Interactive stdin is not forwarded; use file options where available.

## Commands

Exports include `build`, `bake`, `create`, `inspect`, `ls`, `use`, `stop`,
`rm`, `du`, `prune`, and `version`. Nested commands use underscores, such as
`imagetools_create`, `history_ls`, and `debug_build`.

See [the complete command and argument reference](./OPTIONS.md) for all
exports, positional fields, inherited flags, and experimental options. The
reference is generated from the committed [Buildx option snapshot](./buildx-options.json);
your Docker installation must support the commands and flags you select.

## Compose in PureScript

`Buildx.Commands` exposes argument constructors and functions that return
`Either String Plan.Plan`. Construct a plan, then execute it with its runtime
configuration:

```purescript
module Main where

import Prelude
import Buildx as Buildx
import Buildx.Commands as Commands
import Data.Either (either)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)

build :: Effect String
build = do
  let args = (Commands.buildArgs "." "/tmp/buildx-local-001")
        { tag = Just [ "example/app:dev" ]
        , load = Just true
        }
  plan <- either throw pure (Commands.build args)
  Buildx.execute (Commands.runtimeBuild args) plan
```

## Development

Install Node.js, Python 3, Spago, the PureScript compiler, and `extism-js`.

```sh
npm ci
npm run build
npm test
```

The build checks generated files, compiles PureScript, and produces
`dist/plugin.wasm`. Tests check typed options and execution plans without
launching Docker. Generation requires the repository's `schema/plugins.json`,
and tests require `schema/generated/buildx.json`. These files are not currently
included in this checkout.

To regenerate command types, exports, the plugin index, and `OPTIONS.md` after changing
the option snapshot, run `python3 generate.py`. Supply `schema/plugins.json`
first. Generated files identify themselves in their headers.

## License

[MIT](./LICENSE).
