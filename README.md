# FluentCI Modules

Reusable CI/CD modules written in PureScript and compiled to native WebAssembly
components for FluentCI **v0.17.3+**. Version 0.2.0 uses named typed arguments
and native return values; see the [migration guide](./docs/COMPONENTS.md). Build containers, package Linux applications, publish artifacts, and
cache Nix build outputs, format and lint sources, manage infrastructure, and
deploy applications using independently configured modules.

Operation modules declare their matching `setup-*` components as typed dependencies.
Missing tools are installed on demand; existing tools and explicit executable overrides
are preserved. See [module dependencies](./docs/MODULE_DEPENDENCIES.md) for publishing
and runtime behavior.

## Usage

Register source modules with the component runtime:

```toml
[[modules]]
name = "gemfury"
version = "0.2.0"
path = "vendor/fluentci-modules/publishing/gemfury"
sdk = "purescript"
runtime = "component"
```

Build packages first, configure credentials in the CI environment, then upload:

```sh
fluentci run gemfury upload --files dist/app.deb,dist/app.rpm
fluentci run dpkg build --directory package --arch arm64 --output dist/app.deb
fluentci run setup-node setup --version 22.14.0
fluentci run cmake build --run-dir .fluentci/build --build-dir build --parallel 2
fluentci run wrangler dry-run --run-dir .fluentci/worker --outdir dist/worker
```

Functions use native named arguments and return typed values. Run
`fluentci run MODULE FUNCTION --help` for types, descriptions, and return values.
The [component guide](./docs/COMPONENTS.md) covers migration from JSON plugin
input, structured results, list arguments, building, and validation.

## Compose modules in code

This pipeline installs Bun, starts PostgreSQL and Redis, checks the application
with Biome, and runs integration tests. It calls four independent modules and
native FluentCI commands in one sequence. The modules are written in PureScript;
your caller can use any SDK below.

Use **FluentCI 0.17.6 or newer**. From your caller module's directory, register
these dependencies (replace `/path/to/fluentci-modules` with your checkout):

```sh
fluentci add setup-bun --path /path/to/fluentci-modules/setup/bun
fluentci add postgres --path /path/to/fluentci-modules/services/postgres
fluentci add redis --path /path/to/fluentci-modules/services/redis
fluentci add biome --path /path/to/fluentci-modules/linting/biome
```

For published versions, use `fluentci add @fluentci.io/MODULE@VERSION` instead.
FluentCI generates the named imports and argument builders used below; no
handwritten FFI or CLI subprocess is needed. Include generated source directories
in your caller's SDK project and commit its manifest and lockfile.

Run from the application checkout, with a working Docker daemon, a Bun lockfile,
Biome configuration, and tests that read `DATABASE_URL` and `REDIS_URL`. This
example uses disposable PostgreSQL credentials and fixed loopback ports
`15432`/`16379`. Use a separate workspace, names, and ports for concurrent jobs.
Service startup waits for readiness. `biome.check` installs its missing CLI through
its setup dependency; its omitted run directory is allocated by the Flow binding.

The `ensuring` callbacks below stop both services even if installation, linting,
or tests fail. Each cleanup is registered separately so one failed stop does not
prevent the other. Elixir's current limitation is explained with its example.
Python and TypeScript use the builder chaining API released in FluentCI 0.17.6.
Full cross-SDK execution verification remains pending. See [support details](docs/COMPOSITION.md).

<details open>
<summary>PureScript</summary>

```purescript
module Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import FluentCI.Flow as Flow
import FluentCI.Modules.SetupBun as Bun
import FluentCI.Modules.Postgres as Postgres
import FluentCI.Modules.Redis as Redis
import FluentCI.Modules.Biome as Biome

run :: Effect String
run =
  Flow.pipeline "integration"
    # Flow.workdir "."
    # Flow.ensuring (void $ Flow.pipeline "cleanup-postgres"
        # Postgres.stop (Postgres.stopArgs { name = Just "module-postgres-ci" })
        # Flow.run)
    # Flow.ensuring (void $ Flow.pipeline "cleanup-redis"
        # Redis.stop (Redis.stopArgs { name = Just "module-redis-ci" })
        # Flow.run)
    # Bun.setup (Bun.setupArgs { version = Just "1.4.3" })
    # Postgres.start (Postgres.startArgs
        { name = Just "module-postgres-ci", version = Just "17-alpine", port = Just 15432 })
    # Redis.start (Redis.startArgs
        { name = Just "module-redis-ci", version = Just "7-alpine", port = Just 16379 })
    # Flow.env "DATABASE_URL" "postgresql://fluentci:fluentci-test@127.0.0.1:15432/fluentci_test"
    # Flow.env "REDIS_URL" "redis://127.0.0.1:16379"
    # Flow.exec [ "bun", "install", "--frozen-lockfile" ]
    # Biome.check Biome.checkArgs
    # Flow.exec [ "bun", "test" ]
    # Flow.run
```

</details>

<details>
<summary>Gleam</summary>

```gleam
import gleam/option.{Some}
import fluentci/flow
import fluentci_modules/setup_bun as bun
import fluentci_modules/postgres
import fluentci_modules/redis
import fluentci_modules/biome

pub fn run() -> String {
  flow.pipeline("integration")
  |> flow.workdir(".")
  |> flow.ensuring(fn() {
    let _ = flow.pipeline("cleanup-postgres")
      |> postgres.stop(postgres.StopArgs(..postgres.stop_args(), name: Some("module-postgres-ci")))
      |> flow.run
    Nil
  })
  |> flow.ensuring(fn() {
    let _ = flow.pipeline("cleanup-redis")
      |> redis.stop(redis.StopArgs(..redis.stop_args(), name: Some("module-redis-ci")))
      |> flow.run
    Nil
  })
  |> bun.setup(bun.SetupArgs(..bun.setup_args(), version: Some("1.4.3")))
  |> postgres.start(postgres.StartArgs(..postgres.start_args(),
    name: Some("module-postgres-ci"), version: Some("17-alpine"), port: Some(15432)))
  |> redis.start(redis.StartArgs(..redis.start_args(),
    name: Some("module-redis-ci"), version: Some("7-alpine"), port: Some(16379)))
  |> flow.env("DATABASE_URL", "postgresql://fluentci:fluentci-test@127.0.0.1:15432/fluentci_test")
  |> flow.env("REDIS_URL", "redis://127.0.0.1:16379")
  |> flow.exec("bun", ["install", "--frozen-lockfile"])
  |> biome.check(biome.check_args())
  |> flow.exec("bun", ["test"])
  |> flow.run
}
```

Use the JavaScript target for the Gleam Wasm guest; BEAM escripts are a separate
repository-automation target. Record constructor names come from the installed
WIT contract; inspect generated bindings if using a different module version.

</details>

<details>
<summary>Elixir</summary>

```elixir
defmodule Main do
  use FluentCI.Plugin
  alias FluentCI.Flow
  alias FluentCI.Modules.{SetupBun, Postgres, Redis, Biome}

  defplugin run do
    Flow.pipeline("integration")
    |> Flow.workdir(".")
    |> SetupBun.setup(%{version: "1.4.3"})
    |> Postgres.start(%{name: "module-postgres-ci", version: "17-alpine", port: 15432})
    |> Redis.start(%{name: "module-redis-ci", version: "7-alpine", port: 16379})
    |> Flow.exec(["bun", "install", "--frozen-lockfile"])
    |> Biome.check(%{})
    |> Flow.env("DATABASE_URL", "postgresql://fluentci:fluentci-test@127.0.0.1:15432/fluentci_test")
    |> Flow.env("REDIS_URL", "redis://127.0.0.1:16379")
    |> Flow.exec(["bun", "test"])
    |> Flow.stdout()
  end

  defplugin stop_redis do
    Flow.pipeline("cleanup-redis")
    |> Redis.stop(%{name: "module-redis-ci"})
    |> Flow.stdout()
  end

  defplugin stop_postgres do
    Flow.pipeline("cleanup-postgres")
    |> Postgres.stop(%{name: "module-postgres-ci"})
    |> Flow.stdout()
  end
end
```

**Elixir requires runner-managed cleanup:** configure both cleanup exports as
independent always-run steps in the same workspace, even if `run` fails. The
current Elixir Flow DSL has no `ensuring`; an ordinary trailing stop operation or
an Elixir `try/after` around DSL construction cannot provide runtime cleanup.

</details>

<details>
<summary>ClojureScript</summary>

```clojure
(ns main.plugin
  (:require [fluentci.flow :as flow]
            [fluentci-modules.setup-bun :as bun]
            [fluentci-modules.postgres :as postgres]
            [fluentci-modules.redis :as redis]
            [fluentci-modules.biome :as biome]))

(defn run []
  (-> (flow/pipeline "integration")
      (flow/workdir ".")
      (flow/ensuring #(-> (flow/pipeline "cleanup-postgres")
                         (postgres/stop {:name "module-postgres-ci"}) flow/run!))
      (flow/ensuring #(-> (flow/pipeline "cleanup-redis")
                         (redis/stop {:name "module-redis-ci"}) flow/run!))
      (bun/setup {:version "1.4.3"})
      (postgres/start {:name "module-postgres-ci" :version "17-alpine" :port 15432})
      (redis/start {:name "module-redis-ci" :version "7-alpine" :port 16379})
      (flow/env "DATABASE_URL" "postgresql://fluentci:fluentci-test@127.0.0.1:15432/fluentci_test")
      (flow/env "REDIS_URL" "redis://127.0.0.1:16379")
      (flow/exec ["bun" "install" "--frozen-lockfile"])
      (biome/check {})
      (flow/exec ["bun" "test"])
      flow/run!))
```

</details>

<details>
<summary>ReScript</summary>

```rescript
module Bun = FluentciModulesSetupBun
module Postgres = FluentciModulesPostgres
module Redis = FluentciModulesRedis
module Biome = FluentciModulesBiome

let run = (): string =>
  Flow.pipeline("integration")
  ->Flow.workdir(".")
  ->Flow.ensuring(() => {
    Flow.pipeline("cleanup-postgres")
    ->Postgres.stop({...Postgres.stopArgs, "name": Some("module-postgres-ci")})
    ->Flow.run->ignore
  })
  ->Flow.ensuring(() => {
    Flow.pipeline("cleanup-redis")
    ->Redis.stop({...Redis.stopArgs, "name": Some("module-redis-ci")})
    ->Flow.run->ignore
  })
  ->Bun.setup({...Bun.setupArgs, "version": Some("1.4.3")})
  ->Postgres.start({...Postgres.startArgs, "name": Some("module-postgres-ci"),
    "version": Some("17-alpine"), "port": Some(15432)})
  ->Redis.start({...Redis.startArgs, "name": Some("module-redis-ci"),
    "version": Some("7-alpine"), "port": Some(16379)})
  ->Flow.env("DATABASE_URL", "postgresql://fluentci:fluentci-test@127.0.0.1:15432/fluentci_test")
  ->Flow.env("REDIS_URL", "redis://127.0.0.1:16379")
  ->Flow.exec(["bun", "install", "--frozen-lockfile"])
  ->Biome.check(Biome.checkArgs)
  ->Flow.exec(["bun", "test"])
  ->Flow.run
```

</details>

<details>
<summary>Python</summary>

```python
from fluentci.flow import pipeline
from fluentci_modules import setup_bun, postgres, redis, biome


def stop_postgres() -> None:
    (pipeline("cleanup-postgres")
     .pipe(postgres.stop, {"name": "module-postgres-ci"})
     .run())


def stop_redis() -> None:
    (pipeline("cleanup-redis")
     .pipe(redis.stop, {"name": "module-redis-ci"})
     .run())


def run() -> str:
    return (
        pipeline("integration")
        .workdir(".")
        .ensuring(stop_postgres)
        .ensuring(stop_redis)
        .pipe(setup_bun.setup, {"version": "1.4.3"})
        .pipe(postgres.start, {
            "name": "module-postgres-ci", "version": "17-alpine", "port": 15432,
        })
        .pipe(redis.start, {
            "name": "module-redis-ci", "version": "7-alpine", "port": 16379,
        })
        .env("DATABASE_URL", "postgresql://fluentci:fluentci-test@127.0.0.1:15432/fluentci_test")
        .env("REDIS_URL", "redis://127.0.0.1:16379")
        .exec("bun", "install", "--frozen-lockfile")
        .pipe(biome.check, {})
        .exec("bun", "test")
        .run()
    )
```

</details>

<details>
<summary>TypeScript</summary>

```typescript
import * as flow from "./fluentci_modules/flow";
import * as bun from "./fluentci_modules/setup-bun/index";
import * as postgres from "./fluentci_modules/postgres/index";
import * as redis from "./fluentci_modules/redis/index";
import * as biome from "./fluentci_modules/biome/index";

export function run(): string {
  return flow.pipeline("integration")
    .workdir(".")
    .ensuring(() => {
      flow.pipeline("cleanup-postgres")
        .pipe(postgres.stop, {name: "module-postgres-ci"})
        .run();
    })
    .ensuring(() => {
      flow.pipeline("cleanup-redis")
        .pipe(redis.stop, {name: "module-redis-ci"})
        .run();
    })
    .pipe(bun.setup, {version: "1.4.3"})
    .pipe(postgres.start, {
      name: "module-postgres-ci", version: "17-alpine", port: 15432,
    })
    .pipe(redis.start, {
      name: "module-redis-ci", version: "7-alpine", port: 16379,
    })
    .env("DATABASE_URL", "postgresql://fluentci:fluentci-test@127.0.0.1:15432/fluentci_test")
    .env("REDIS_URL", "redis://127.0.0.1:16379")
    .exec(["bun", "install", "--frozen-lockfile"])
    .pipe(biome.check, {})
    .exec(["bun", "test"])
    .run();
}
```

</details>

All module calls remain deferred until the terminal operation. The service
versions, names, and ports above are ordinary typed arguments. Other modules can
be inserted the same way; public list arguments such as package selectors remain
comma-separated strings. No module function here launches `fluentci run`.

## Development

Repository automation uses Gleam on BEAM. Compile `scripts/fluentci_modules_ci`
with Erlang/OTP 29.1.2 and Gleam 1.19.2 before using the commands below; see
[the helper guide](scripts/README.md). CI provisions both through published
`setup-erlang` and `setup-gleam` modules.

Install Node.js, Bun, PureScript, and Spago. Initialize the shared component
compiler once, then build/test individual modules:

```sh
bun install --cwd lib/component --frozen-lockfile
npm ci --prefix packaging/dpkg
npm run build --prefix packaging/dpkg
npm test --prefix packaging/dpkg
escript scripts/fluentci_modules_ci validate-wasm packaging/dpkg
```

Every `dist/plugin.wasm` is a native component with embedded typed contracts.
CI checks compiled binary signatures and runs module tests on Linux/macOS;
BSD package routing uses fixtures. See [CI](./.github/README.md),
[CONTRIBUTING.md](./CONTRIBUTING.md), and the [audit](./docs/PIPELINE_AUDIT.md).

## Modules

All modules are registered alphabetically in [fluentci.toml](./fluentci.toml).
See the [pipeline audit](./docs/PIPELINE_AUDIT.md) and [CI integration guide](./docs/PIPELINES.md) for failure, credential, and artifact contracts.

| Module | Purpose | Component functions |
| --- | --- | --- |
| [actionlint](./linting/actionlint/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `lint`, [typed contract](./linting/actionlint/COMPONENT.md) |
| [aerospike](./services/aerospike/README.md) | Run Aerospike with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/aerospike/COMPONENT.md) |
| [apko](./containers/apko/README.md) | Run a native command with literal arguments. | `run`, `version`, `build`, [typed contract](./containers/apko/COMPONENT.md) |
| [arangodb](./services/arangodb/README.md) | Run ArangoDB with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/arangodb/COMPONENT.md) |
| [argocd](./deployment/argocd/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `app-get`, [typed contract](./deployment/argocd/COMPONENT.md) |
| [artifactory](./artifacts/artifactory/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `upload`, [typed contract](./artifacts/artifactory/COMPONENT.md) |
| [aws](./cloud/aws/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `identity`, [typed contract](./cloud/aws/COMPONENT.md) |
| [aws-emulator](./services/aws-emulator/README.md) | Run AWS Emulator with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/aws-emulator/COMPONENT.md) |
| [azure](./cloud/azure/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `account-show`, [typed contract](./cloud/azure/COMPONENT.md) |
| [bazel](./build/bazel/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `build`, [typed contract](./build/bazel/COMPONENT.md) |
| [betterleaks](./security/betterleaks/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `scan-dir`, [typed contract](./security/betterleaks/COMPONENT.md) |
| [biome](./linting/biome/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `check`, [typed contract](./linting/biome/COMPONENT.md) |
| [black](./formatting/black/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `format`, [typed contract](./formatting/black/COMPONENT.md) |
| [buildkit](./containers/buildkit/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `build`, [typed contract](./containers/buildkit/COMPONENT.md) |
| [buildx](./containers/buildx/README.md) | Run Docker Buildx buildx and return execution report paths. | `setup`, `buildx`, `dap`, `debug`, [typed contract](./containers/buildx/COMPONENT.md) |
| [cachix](./caching/cachix/README.md) | Configure a Cachix cache using host credentials. | `setup`, `push`, [typed contract](./caching/cachix/COMPONENT.md) |
| [caddy](./services/caddy/README.md) | Run Caddy with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/caddy/COMPONENT.md) |
| [cassandra](./services/cassandra/README.md) | Run Cassandra with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/cassandra/COMPONENT.md) |
| [checkov](./security/checkov/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `scan`, [typed contract](./security/checkov/COMPONENT.md) |
| [chroma](./services/chroma/README.md) | Run Chroma with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/chroma/COMPONENT.md) |
| [clickhouse](./services/clickhouse/README.md) | Run ClickHouse with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/clickhouse/COMPONENT.md) |
| [cmake](./build/cmake/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `configure`, [typed contract](./build/cmake/COMPONENT.md) |
| [cockroachdb](./services/cockroachdb/README.md) | Run CockroachDB with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/cockroachdb/COMPONENT.md) |
| [codacy](./code-quality/codacy/README.md) | Execute arbitrary literal CLI arguments. | `run`, `help`, `upload`, [typed contract](./code-quality/codacy/COMPONENT.md) |
| [codecov](./code-quality/codecov/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `upload`, [typed contract](./code-quality/codecov/COMPONENT.md) |
| [consul](./services/consul/README.md) | Run Consul with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/consul/COMPONENT.md) |
| [cosign](./security/cosign/README.md) | Sign images and release files; enforce key or keyless signature verification. | `sign`, `sign-blob`, `verify`, `verify-key`, `verify-blob`, `verify-blob-key`, `run`, `version`, [typed contract](./security/cosign/COMPONENT.md) |
| [couchbase](./services/couchbase/README.md) | Run Couchbase with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, `initialize`, `create-bucket`, `configure-network`, [typed contract](./services/couchbase/COMPONENT.md) |
| [couchdb](./services/couchdb/README.md) | Run CouchDB with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/couchdb/COMPONENT.md) |
| [coveralls](./code-quality/coveralls/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `upload`, [typed contract](./code-quality/coveralls/COMPONENT.md) |
| [cratedb](./services/cratedb/README.md) | Run CrateDB with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/cratedb/COMPONENT.md) |
| [cypress](./testing/cypress/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `setup`, [typed contract](./testing/cypress/COMPONENT.md) |
| [databend](./services/databend/README.md) | Run Databend with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/databend/COMPONENT.md) |
| [depot](./containers/depot/README.md) | Build container images with Depot remote builders. | `setup`, `build`, `bake`, [typed contract](./containers/depot/COMPONENT.md) |
| [digitalocean](./cloud/digitalocean/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `account-get`, [typed contract](./cloud/digitalocean/COMPONENT.md) |
| [discord](./notifications/discord/README.md) | Send typed Discord webhook notifications and verify delivery. | `send`, [typed contract](./notifications/discord/COMPONENT.md) |
| [docker](./containers/docker/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `build`, [typed contract](./containers/docker/COMPONENT.md) |
| [doltdb](./services/doltdb/README.md) | Run Dolt with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/doltdb/COMPONENT.md) |
| [doppler](./secrets/doppler/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `run-command`, [typed contract](./secrets/doppler/COMPONENT.md) |
| [dpkg](./packaging/dpkg/README.md) | Build packages from a Linux dpkg package tree and target architecture. | `build`, `validate`, [typed contract](./packaging/dpkg/COMPONENT.md) |
| [dragonfly](./services/dragonfly/README.md) | Run Dragonfly with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/dragonfly/COMPONENT.md) |
| [drizzlekit](./databases/drizzlekit/README.md) | Generate, check and apply SQL migrations. | `run`, `version`, `migrate`, [typed contract](./databases/drizzlekit/COMPONENT.md) |
| [dynamodb](./services/dynamodb/README.md) | Run DynamoDB Local with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/dynamodb/COMPONENT.md) |
| [elasticsearch](./services/elasticsearch/README.md) | Run Elasticsearch with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/elasticsearch/COMPONENT.md) |
| [etcd](./services/etcd/README.md) | Run etcd with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/etcd/COMPONENT.md) |
| [flipt](./deployment/flipt/README.md) | Validate feature flags, evaluate flags, and run Flipt migrations. | `setup`, `validate`, `evaluate`, [typed contract](./deployment/flipt/COMPONENT.md) |
| [floci](./services/floci/README.md) | Run Floci with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/floci/COMPONENT.md) |
| [flyctl](./deployment/flyctl/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `deploy`, [typed contract](./deployment/flyctl/COMPONENT.md) |
| [garden](./deployment/garden/README.md) | Build, deploy, test and clean up Garden project environments. | `run`, `build`, `deploy`, `test`, [typed contract](./deployment/garden/COMPONENT.md) |
| [gcloud](./cloud/gcloud/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `config-list`, [typed contract](./cloud/gcloud/COMPONENT.md) |
| [gemfury](./publishing/gemfury/README.md) | Upload Linux packages to Gemfury using credentials from the host environment. | `upload`, [typed contract](./publishing/gemfury/COMPONENT.md) |
| [gh](./version-control/gh/README.md) | Manage pull requests, releases and GitHub Actions runs through typed GitHub CLI functions. | `setup`, `run`, `version`, [typed contract](./version-control/gh/COMPONENT.md) |
| [gh-artifacts](./artifacts/gh-artifacts/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `upload`, [typed contract](./artifacts/gh-artifacts/COMPONENT.md) |
| [git](./version-control/git/README.md) | Check out source, inspect revisions, create commits and tags, and publish refs with typed Git functions. | `setup`, `run`, `version`, [typed contract](./version-control/git/COMPONENT.md) |
| [gitlab-artifacts](./artifacts/gitlab-artifacts/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `upload`, [typed contract](./artifacts/gitlab-artifacts/COMPONENT.md) |
| [gitleaks](./security/gitleaks/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `scan-dir`, [typed contract](./security/gitleaks/COMPONENT.md) |
| [glab](./version-control/glab/README.md) | Manage merge requests, releases and GitLab CI jobs and pipelines through typed GitLab CLI functions. | `setup`, `run`, `version`, [typed contract](./version-control/glab/COMPONENT.md) |
| [grype](./security/grype/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `scan`, [typed contract](./security/grype/COMPONENT.md) |
| [helm](./deployment/helm/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `lint`, [typed contract](./deployment/helm/COMPONENT.md) |
| [httpbin](./services/httpbin/README.md) | Run httpbin with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/httpbin/COMPONENT.md) |
| [infisical](./secrets/infisical/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `run-command`, [typed contract](./secrets/infisical/COMPONENT.md) |
| [influxdb](./services/influxdb/README.md) | Run InfluxDB with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/influxdb/COMPONENT.md) |
| [jfrog-cli](./artifacts/jfrog-cli/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `upload`, [typed contract](./artifacts/jfrog-cli/COMPONENT.md) |
| [kafka](./services/kafka/README.md) | Run Apache Kafka with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/kafka/COMPONENT.md) |
| [kamal](./deployment/kamal/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `deploy`, [typed contract](./deployment/kamal/COMPONENT.md) |
| [keycloak](./services/keycloak/README.md) | Run Keycloak with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/keycloak/COMPONENT.md) |
| [kubectl](./deployment/kubectl/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `apply`, [typed contract](./deployment/kubectl/COMPONENT.md) |
| [mailcatcher](./services/mailcatcher/README.md) | Run MailCatcher with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/mailcatcher/COMPONENT.md) |
| [mailhog](./services/mailhog/README.md) | Run MailHog with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/mailhog/COMPONENT.md) |
| [mailpit](./services/mailpit/README.md) | Run Mailpit with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/mailpit/COMPONENT.md) |
| [mariadb](./services/mariadb/README.md) | Run MariaDB with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/mariadb/COMPONENT.md) |
| [meson](./build/meson/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `configure`, [typed contract](./build/meson/COMPONENT.md) |
| [microcks](./services/microcks/README.md) | Run Microcks with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/microcks/COMPONENT.md) |
| [mongodb](./services/mongodb/README.md) | Run MongoDB with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/mongodb/COMPONENT.md) |
| [mysql](./services/mysql/README.md) | Run MySQL with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/mysql/COMPONENT.md) |
| [nats](./services/nats/README.md) | Run NATS with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/nats/COMPONENT.md) |
| [neo4j](./services/neo4j/README.md) | Run Neo4j with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/neo4j/COMPONENT.md) |
| [netlify](./deployment/netlify/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `deploy`, [typed contract](./deployment/netlify/COMPONENT.md) |
| [nexus](./artifacts/nexus/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `upload`, [typed contract](./artifacts/nexus/COMPONENT.md) |
| [nginx](./services/nginx/README.md) | Run NGINX with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/nginx/COMPONENT.md) |
| [ninja](./build/ninja/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `build`, [typed contract](./build/ninja/COMPONENT.md) |
| [nix-package](./package-management/nix/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `build`, [typed contract](./package-management/nix/COMPONENT.md) |
| [nix-publish](./publishing/nix-publish/README.md) | Publish Nix flakes to FlakeHub or Flakestry. | `flakehub`, `flakestry`, [typed contract](./publishing/nix-publish/COMPONENT.md) |
| [nx](./build/nx/README.md) | Run workspace targets, affected builds and CI checks. | `run-many`, `affected`, `run-target`, [typed contract](./build/nx/COMPONENT.md) |
| [openbao](./secrets/openbao/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `status`, [typed contract](./secrets/openbao/COMPONENT.md) |
| [openfga](./services/openfga/README.md) | Run OpenFGA with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/openfga/COMPONENT.md) |
| [openldap](./services/openldap/README.md) | Run OpenLDAP with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/openldap/COMPONENT.md) |
| [opentofu](./infrastructure/opentofu/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `init`, [typed contract](./infrastructure/opentofu/COMPONENT.md) |
| [oras](./artifacts/oras/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `push`, [typed contract](./artifacts/oras/COMPONENT.md) |
| [orientdb](./services/orientdb/README.md) | Run OrientDB with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/orientdb/COMPONENT.md) |
| [pgroll](./databases/pgroll/README.md) | Run PostgreSQL schema migrations, backfills, and rollout checks. | `migrate`, [typed contract](./databases/pgroll/COMPONENT.md) |
| [pinecone](./services/pinecone/README.md) | Run Pinecone Local with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/pinecone/COMPONENT.md) |
| [planetscale](./databases/planetscale/README.md) | Manage preview database branches, migrations, and native CLI workflows. | `run`, `branch-create`, [typed contract](./databases/planetscale/COMPONENT.md) |
| [playwright](./testing/playwright/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `setup`, [typed contract](./testing/playwright/COMPONENT.md) |
| [plumber](./security/plumber/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `analyze`, [typed contract](./security/plumber/COMPONENT.md) |
| [podman](./containers/podman/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `build`, [typed contract](./containers/podman/COMPONENT.md) |
| [postgres](./services/postgres/README.md) | Run PostgreSQL with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/postgres/COMPONENT.md) |
| [presto](./services/presto/README.md) | Run Presto with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/presto/COMPONENT.md) |
| [prettier](./formatting/prettier/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `format`, [typed contract](./formatting/prettier/COMPONENT.md) |
| [prisma](./databases/prisma/README.md) | Validate schemas, generate clients and deploy migrations. | `run`, `version`, `migrate-deploy`, [typed contract](./databases/prisma/COMPONENT.md) |
| [protolint](./linting/protolint/README.md) | Run a native command with literal arguments. | `run`, `version`, `lint`, [typed contract](./linting/protolint/COMPONENT.md) |
| [pulumi](./infrastructure/pulumi/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `preview`, [typed contract](./infrastructure/pulumi/COMPONENT.md) |
| [qdrant](./services/qdrant/README.md) | Run Qdrant with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/qdrant/COMPONENT.md) |
| [questdb](./services/questdb/README.md) | Run QuestDB with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/questdb/COMPONENT.md) |
| [rabbitmq](./services/rabbitmq/README.md) | Run RabbitMQ with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/rabbitmq/COMPONENT.md) |
| [railpack](./containers/railpack/README.md) | Run a native command with literal arguments. | `run`, `version`, `prepare`, [typed contract](./containers/railpack/COMPONENT.md) |
| [railway](./deployment/railway/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `up`, [typed contract](./deployment/railway/COMPONENT.md) |
| [ravendb](./services/ravendb/README.md) | Run RavenDB with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/ravendb/COMPONENT.md) |
| [rclone](./artifacts/rclone/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `copy`, [typed contract](./artifacts/rclone/COMPONENT.md) |
| [redis](./services/redis/README.md) | Run Redis with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/redis/COMPONENT.md) |
| [redpanda](./services/redpanda/README.md) | Run Redpanda with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/redpanda/COMPONENT.md) |
| [render](./deployment/render/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `services`, [typed contract](./deployment/render/COMPONENT.md) |
| [rethinkdb](./services/rethinkdb/README.md) | Run RethinkDB with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/rethinkdb/COMPONENT.md) |
| [rpmbuild](./packaging/rpmbuild/README.md) | Build packages from a Linux rpmbuild package tree and target architecture. | `build`, `validate`, [typed contract](./packaging/rpmbuild/COMPONENT.md) |
| [ruff](./linting/ruff/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `check`, [typed contract](./linting/ruff/COMPONENT.md) |
| [rustfmt](./formatting/rustfmt/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `format`, [typed contract](./formatting/rustfmt/COMPONENT.md) |
| [s3mock](./services/s3mock/README.md) | Run S3Mock with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/s3mock/COMPONENT.md) |
| [sccache](./caching/sccache/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `start-server`, [typed contract](./caching/sccache/COMPONENT.md) |
| [scorecard](./security/scorecard/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `scan`, [typed contract](./security/scorecard/COMPONENT.md) |
| [scylladb](./services/scylladb/README.md) | Run ScyllaDB with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/scylladb/COMPONENT.md) |
| [semgrep](./security/semgrep/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `scan`, [typed contract](./security/semgrep/COMPONENT.md) |
| [service-vault](./services/vault/README.md) | Run Vault with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/vault/COMPONENT.md) |
| [setup-actionlint](./setup/actionlint/README.md) | Install and verify actionlint, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/actionlint/COMPONENT.md) |
| [setup-android](./setup/android/README.md) | Install Java and a customizable Android SDK for Linux/macOS CI. | `setup`, [typed contract](./setup/android/COMPONENT.md) |
| [setup-apko](./setup/apko/README.md) | Install and verify apko, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/apko/COMPONENT.md) |
| [setup-argocd](./setup/argocd/README.md) | Install and verify argocd, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/argocd/COMPONENT.md) |
| [setup-artifactory](./setup/artifactory/README.md) | Install and verify artifactory, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/artifactory/COMPONENT.md) |
| [setup-aws](./setup/aws/README.md) | Install and verify aws, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/aws/COMPONENT.md) |
| [setup-azure](./setup/azure/README.md) | Install and verify azure, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/azure/COMPONENT.md) |
| [setup-babashka](./setup/babashka/README.md) | Install and verify babashka, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/babashka/COMPONENT.md) |
| [setup-bazel](./setup/bazel/README.md) | Install and verify bazel, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/bazel/COMPONENT.md) |
| [setup-betterleaks](./setup/betterleaks/README.md) | Install and verify betterleaks, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/betterleaks/COMPONENT.md) |
| [setup-binaryen](./setup/binaryen/README.md) | Install and verify binaryen, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/binaryen/COMPONENT.md) |
| [setup-biome](./setup/biome/README.md) | Install and verify biome, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/biome/COMPONENT.md) |
| [setup-black](./setup/black/README.md) | Install and verify black, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/black/COMPONENT.md) |
| [setup-buf](./setup/buf/README.md) | Install and verify buf, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/buf/COMPONENT.md) |
| [setup-buildkit](./setup/buildkit/README.md) | Install and verify buildkit, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/buildkit/COMPONENT.md) |
| [setup-buildx](./setup/buildx/README.md) | Install and verify buildx, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/buildx/COMPONENT.md) |
| [setup-bun](./setup/bun/README.md) | Install and verify bun, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/bun/COMPONENT.md) |
| [setup-cachix](./setup/cachix/README.md) | Install Cachix and optionally enable a named Nix binary cache. | `setup`, [typed contract](./setup/cachix/COMPONENT.md) |
| [setup-checkov](./setup/checkov/README.md) | Install and verify checkov, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/checkov/COMPONENT.md) |
| [setup-clojure](./setup/clojure/README.md) | Install and verify clojure, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/clojure/COMPONENT.md) |
| [setup-cmake](./setup/cmake/README.md) | Install and verify cmake, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/cmake/COMPONENT.md) |
| [setup-codacy](./setup/codacy/README.md) | Install and verify codacy, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/codacy/COMPONENT.md) |
| [setup-codecov](./setup/codecov/README.md) | Install and verify codecov, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/codecov/COMPONENT.md) |
| [setup-cosign](./setup/cosign/README.md) | Install and verify Cosign and publish PATH. | `setup`, [typed contract](./setup/cosign/COMPONENT.md) |
| [setup-coveralls](./setup/coveralls/README.md) | Install and verify coveralls, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/coveralls/COMPONENT.md) |
| [setup-curl](./setup/curl/README.md) | Install or verify curl through native Linux, macOS and BSD repositories. | `setup`, [typed contract](./setup/curl/COMPONENT.md) |
| [setup-cypress](./setup/cypress/README.md) | Install and verify cypress, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/cypress/COMPONENT.md) |
| [setup-dagger](./setup/dagger/README.md) | Install and verify Dagger and publish PATH. | `setup`, [typed contract](./setup/dagger/COMPONENT.md) |
| [setup-deno](./setup/deno/README.md) | Install and verify deno, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/deno/COMPONENT.md) |
| [setup-depot](./setup/depot/README.md) | Install or reuse a verified Depot CLI. | `setup`, [typed contract](./setup/depot/COMPONENT.md) |
| [setup-determinate-nix](./setup/determinate-nix/README.md) | Install and verify determinate-nix, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/determinate-nix/COMPONENT.md) |
| [setup-devbox](./setup/devbox/README.md) | Install devbox, optionally install versioned packages, and publish their environment. | `setup`, [typed contract](./setup/devbox/COMPONENT.md) |
| [setup-devenv](./setup/devenv/README.md) | Install and verify devenv, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/devenv/COMPONENT.md) |
| [setup-digitalocean](./setup/digitalocean/README.md) | Install and verify digitalocean, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/digitalocean/COMPONENT.md) |
| [setup-docker](./setup/docker/README.md) | Install and verify docker, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/docker/COMPONENT.md) |
| [setup-doppler](./setup/doppler/README.md) | Install and verify doppler, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/doppler/COMPONENT.md) |
| [setup-dpkg](./setup/dpkg/README.md) | Install and verify dpkg, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/dpkg/COMPONENT.md) |
| [setup-drizzlekit](./setup/drizzlekit/README.md) | Install and verify a versioned Drizzle Kit CLI. | `setup`, [typed contract](./setup/drizzlekit/COMPONENT.md) |
| [setup-elixir](./setup/elixir/README.md) | Install and verify elixir, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/elixir/COMPONENT.md) |
| [setup-erlang](./setup/erlang/README.md) | Install Erlang/OTP with archive or native-package setup and version verification. | `setup`, [typed contract](./setup/erlang/COMPONENT.md) |
| [setup-expo](./setup/expo/README.md) | Install and verify expo, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/expo/COMPONENT.md) |
| [setup-extism](./setup/extism/README.md) | Install and verify extism, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/extism/COMPONENT.md) |
| [setup-extism-cli](./setup/extism-cli/README.md) | Install and verify extism-cli, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/extism-cli/COMPONENT.md) |
| [setup-extism-js](./setup/extism-js/README.md) | Install and verify extism-js, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/extism-js/COMPONENT.md) |
| [setup-extism-py](./setup/extism-py/README.md) | Install and verify extism-py, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/extism-py/COMPONENT.md) |
| [setup-flakehub-push](./setup/flakehub-push/README.md) | Install and verify flakehub-push, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/flakehub-push/COMPONENT.md) |
| [setup-flipt](./setup/flipt/README.md) | Install or reuse a verified Flipt CLI. | `setup`, [typed contract](./setup/flipt/COMPONENT.md) |
| [setup-flox](./setup/flox/README.md) | Install flox, optionally install versioned packages, and publish their environment. | `setup`, [typed contract](./setup/flox/COMPONENT.md) |
| [setup-flyctl](./setup/flyctl/README.md) | Install and verify flyctl, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/flyctl/COMPONENT.md) |
| [setup-garden](./setup/garden/README.md) | Install and verify a versioned Garden CLI. | `setup`, [typed contract](./setup/garden/COMPONENT.md) |
| [setup-gcloud](./setup/gcloud/README.md) | Install and verify gcloud, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/gcloud/COMPONENT.md) |
| [setup-gemfury](./setup/gemfury/README.md) | Install and verify gemfury, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/gemfury/COMPONENT.md) |
| [setup-gh](./setup/gh/README.md) | Install the GitHub CLI and publish its executable directory to PATH. | `setup`, [typed contract](./setup/gh/COMPONENT.md) |
| [setup-gh-artifacts](./setup/gh-artifacts/README.md) | Install and verify gh-artifacts, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/gh-artifacts/COMPONENT.md) |
| [setup-git](./setup/git/README.md) | Install or reuse a verified git CLI. | `setup`, [typed contract](./setup/git/COMPONENT.md) |
| [setup-gitlab-artifacts](./setup/gitlab-artifacts/README.md) | Install and verify gitlab-artifacts, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/gitlab-artifacts/COMPONENT.md) |
| [setup-gitleaks](./setup/gitleaks/README.md) | Install and verify gitleaks, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/gitleaks/COMPONENT.md) |
| [setup-glab](./setup/glab/README.md) | Install or reuse a verified glab CLI. | `setup`, [typed contract](./setup/glab/COMPONENT.md) |
| [setup-gleam](./setup/gleam/README.md) | Install and verify gleam, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/gleam/COMPONENT.md) |
| [setup-go](./setup/go/README.md) | Install and verify go, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/go/COMPONENT.md) |
| [setup-grype](./setup/grype/README.md) | Install and verify grype, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/grype/COMPONENT.md) |
| [setup-helm](./setup/helm/README.md) | Install and verify helm, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/helm/COMPONENT.md) |
| [setup-infisical](./setup/infisical/README.md) | Install and verify infisical, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/infisical/COMPONENT.md) |
| [setup-java](./setup/java/README.md) | Install and verify java, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/java/COMPONENT.md) |
| [setup-jfrog-cli](./setup/jfrog-cli/README.md) | Install and verify jfrog-cli, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/jfrog-cli/COMPONENT.md) |
| [setup-kamal](./setup/kamal/README.md) | Install and verify kamal, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/kamal/COMPONENT.md) |
| [setup-kubectl](./setup/kubectl/README.md) | Install and verify kubectl, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/kubectl/COMPONENT.md) |
| [setup-macports](./setup/macports/README.md) | Install native MacPorts and optionally install pipeline dependency ports. | `setup`, [typed contract](./setup/macports/COMPONENT.md) |
| [setup-macports-rs](./setup/macports-rs/README.md) | Install the MacPorts Rust CLI and optionally install pipeline dependency ports. | `setup`, [typed contract](./setup/macports-rs/COMPONENT.md) |
| [setup-meson](./setup/meson/README.md) | Install and verify meson, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/meson/COMPONENT.md) |
| [setup-mise](./setup/mise/README.md) | Install mise, optionally install versioned packages, and publish their environment. | `setup`, [typed contract](./setup/mise/COMPONENT.md) |
| [setup-netlify](./setup/netlify/README.md) | Install and verify netlify, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/netlify/COMPONENT.md) |
| [setup-nexus](./setup/nexus/README.md) | Install and verify nexus, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/nexus/COMPONENT.md) |
| [setup-ninja](./setup/ninja/README.md) | Install and verify ninja, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/ninja/COMPONENT.md) |
| [setup-nix](./setup/nix/README.md) | Install and verify nix, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/nix/COMPONENT.md) |
| [setup-nix-package](./setup/nix-package/README.md) | Install and verify nix-package, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/nix-package/COMPONENT.md) |
| [setup-node](./setup/node/README.md) | Install and verify node, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/node/COMPONENT.md) |
| [setup-nx](./setup/nx/README.md) | Install and verify a selected Nx CLI release. | `setup`, [typed contract](./setup/nx/COMPONENT.md) |
| [setup-openbao](./setup/openbao/README.md) | Install and verify openbao, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/openbao/COMPONENT.md) |
| [setup-opentofu](./setup/opentofu/README.md) | Install and verify opentofu, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/opentofu/COMPONENT.md) |
| [setup-oras](./setup/oras/README.md) | Install and verify oras, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/oras/COMPONENT.md) |
| [setup-pgroll](./setup/pgroll/README.md) | Install and verify pgroll and publish PATH. | `setup`, [typed contract](./setup/pgroll/COMPONENT.md) |
| [setup-php](./setup/php/README.md) | Install a PHP version and isolated versioned CI tools; publish PATH. | `setup`, [typed contract](./setup/php/COMPONENT.md) |
| [setup-pkgx](./setup/pkgx/README.md) | Install pkgx, optionally install versioned packages, and publish their environment. | `setup`, [typed contract](./setup/pkgx/COMPONENT.md) |
| [setup-pkl](./setup/pkl/README.md) | Install and verify pkl, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/pkl/COMPONENT.md) |
| [setup-planetscale](./setup/planetscale/README.md) | Install and verify the PlanetScale CLI and publish PATH. | `setup`, [typed contract](./setup/planetscale/COMPONENT.md) |
| [setup-playwright](./setup/playwright/README.md) | Install and verify playwright, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/playwright/COMPONENT.md) |
| [setup-plumber](./setup/plumber/README.md) | Install and verify plumber, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/plumber/COMPONENT.md) |
| [setup-podman](./setup/podman/README.md) | Install and verify podman, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/podman/COMPONENT.md) |
| [setup-prettier](./setup/prettier/README.md) | Install and verify prettier, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/prettier/COMPONENT.md) |
| [setup-prisma](./setup/prisma/README.md) | Install and verify a versioned Prisma ORM CLI. | `setup`, [typed contract](./setup/prisma/COMPONENT.md) |
| [setup-protolint](./setup/protolint/README.md) | Install and verify protolint, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/protolint/COMPONENT.md) |
| [setup-pulumi](./setup/pulumi/README.md) | Install and verify pulumi, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/pulumi/COMPONENT.md) |
| [setup-purescript](./setup/purescript/README.md) | Install and verify purescript, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/purescript/COMPONENT.md) |
| [setup-railpack](./setup/railpack/README.md) | Install and verify railpack, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/railpack/COMPONENT.md) |
| [setup-railway](./setup/railway/README.md) | Install and verify railway, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/railway/COMPONENT.md) |
| [setup-rclone](./setup/rclone/README.md) | Install and verify rclone, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/rclone/COMPONENT.md) |
| [setup-render](./setup/render/README.md) | Install and verify render, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/render/COMPONENT.md) |
| [setup-rpmbuild](./setup/rpmbuild/README.md) | Install and verify rpmbuild, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/rpmbuild/COMPONENT.md) |
| [setup-ruff](./setup/ruff/README.md) | Install and verify ruff, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/ruff/COMPONENT.md) |
| [setup-rust](./setup/rust/README.md) | Install and verify rust, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/rust/COMPONENT.md) |
| [setup-rustfmt](./setup/rustfmt/README.md) | Install and verify rustfmt, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/rustfmt/COMPONENT.md) |
| [setup-sccache](./setup/sccache/README.md) | Install and verify sccache, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/sccache/COMPONENT.md) |
| [setup-scorecard](./setup/scorecard/README.md) | Install and verify scorecard, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/scorecard/COMPONENT.md) |
| [setup-semgrep](./setup/semgrep/README.md) | Install and verify semgrep, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/semgrep/COMPONENT.md) |
| [setup-shellcheck](./setup/shellcheck/README.md) | Install and verify shellcheck, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/shellcheck/COMPONENT.md) |
| [setup-snyk](./setup/snyk/README.md) | Install and verify snyk, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/snyk/COMPONENT.md) |
| [setup-sonarqube](./setup/sonarqube/README.md) | Install and verify the standalone sonar CLI and publish PATH. | `setup`, [typed contract](./setup/sonarqube/COMPONENT.md) |
| [setup-sonarqube-scanner](./setup/sonarqube-scanner/README.md) | Install and verify SonarScanner CLI and publish PATH. | `setup`, [typed contract](./setup/sonarqube-scanner/COMPONENT.md) |
| [setup-spin](./setup/spin/README.md) | Install and verify a selected Spin release. | `setup`, [typed contract](./setup/spin/COMPONENT.md) |
| [setup-sqlfluff](./setup/sqlfluff/README.md) | Install and verify sqlfluff, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/sqlfluff/COMPONENT.md) |
| [setup-sqruff](./setup/sqruff/README.md) | Install and verify sqruff, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/sqruff/COMPONENT.md) |
| [setup-syft](./setup/syft/README.md) | Install and verify syft, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/syft/COMPONENT.md) |
| [setup-tangled-artifacts](./setup/tangled-artifacts/README.md) | Install and verify tangled-artifacts, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/tangled-artifacts/COMPONENT.md) |
| [setup-terraform](./setup/terraform/README.md) | Install and verify terraform, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/terraform/COMPONENT.md) |
| [setup-terragrunt](./setup/terragrunt/README.md) | Install and verify terragrunt, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/terragrunt/COMPONENT.md) |
| [setup-tg](./setup/tg/README.md) | Install and verify tg, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/tg/COMPONENT.md) |
| [setup-tigerbeetle](./setup/tigerbeetle/README.md) | Install a verified prebuilt TigerBeetle release and publish its environment. | `setup`, [typed contract](./setup/tigerbeetle/COMPONENT.md) |
| [setup-trivy](./setup/trivy/README.md) | Install and verify trivy, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/trivy/COMPONENT.md) |
| [setup-trufflehog](./setup/trufflehog/README.md) | Install and verify trufflehog, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/trufflehog/COMPONENT.md) |
| [setup-turborepo](./setup/turborepo/README.md) | Install and verify turborepo, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/turborepo/COMPONENT.md) |
| [setup-ubicloud](./setup/ubicloud/README.md) | Install and verify ubicloud, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/ubicloud/COMPONENT.md) |
| [setup-uv](./setup/uv/README.md) | Install and verify uv, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/uv/COMPONENT.md) |
| [setup-vault](./setup/vault/README.md) | Install and verify vault, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/vault/COMPONENT.md) |
| [setup-vercel](./setup/vercel/README.md) | Install and verify vercel, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/vercel/COMPONENT.md) |
| [setup-wasmer](./setup/wasmer/README.md) | Install and verify a selected Wasmer release. | `setup`, [typed contract](./setup/wasmer/COMPONENT.md) |
| [setup-wrangler](./setup/wrangler/README.md) | Install and verify wrangler, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/wrangler/COMPONENT.md) |
| [setup-xata](./setup/xata/README.md) | Install and verify the Xata CLI and publish PATH. | `setup`, [typed contract](./setup/xata/COMPONENT.md) |
| [setup-xtp](./setup/xtp/README.md) | Install and verify xtp, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/xtp/COMPONENT.md) |
| [setup-yamllint](./setup/yamllint/README.md) | Install and verify yamllint, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/yamllint/COMPONENT.md) |
| [setup-zig](./setup/zig/README.md) | Install and verify zig, select its version, and publish its environment for subsequent tasks. | `setup`, [typed contract](./setup/zig/COMPONENT.md) |
| [shellcheck](./linting/shellcheck/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `lint`, [typed contract](./linting/shellcheck/COMPONENT.md) |
| [slack](./notifications/slack/README.md) | Send typed Slack incoming-webhook notifications and threaded replies. | `send`, [typed contract](./notifications/slack/COMPONENT.md) |
| [smocker](./services/smocker/README.md) | Run Smocker with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/smocker/COMPONENT.md) |
| [snyk](./security/snyk/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `setup`, [typed contract](./security/snyk/COMPONENT.md) |
| [solr](./services/solr/README.md) | Run Apache Solr with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/solr/COMPONENT.md) |
| [sonarqube](./code-quality/sonarqube/README.md) | Run SonarQube CLI analysis, quality gates, APIs, architecture, and integrations. | 49 functions, [typed contract](./code-quality/sonarqube/COMPONENT.md) |
| [sonarqube-scanner](./code-quality/sonarqube-scanner/README.md) | Submit full-project SonarScanner analysis and optionally wait for the quality gate. | `run`, `version`, `scan`, [typed contract](./code-quality/sonarqube-scanner/COMPONENT.md) |
| [spin](./deployment/spin/README.md) | Build Spin apps, publish OCI artifacts and deploy through plugins. | `build`, `registry-push`, `cloud-deploy`, [typed contract](./deployment/spin/COMPONENT.md) |
| [sqlfluff](./linting/sqlfluff/README.md) | Run a native command with literal arguments. | `run`, `version`, `lint`, [typed contract](./linting/sqlfluff/COMPONENT.md) |
| [sqruff](./linting/sqruff/README.md) | Run a native command with literal arguments. | `run`, `version`, `lint`, [typed contract](./linting/sqruff/COMPONENT.md) |
| [stripe-mock](./services/stripe-mock/README.md) | Run Stripe Mock with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/stripe-mock/COMPONENT.md) |
| [surrealdb](./services/surrealdb/README.md) | Run SurrealDB with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/surrealdb/COMPONENT.md) |
| [syft](./security/syft/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `scan`, [typed contract](./security/syft/COMPONENT.md) |
| [tangled-artifacts](./artifacts/tangled-artifacts/README.md) | Execute arbitrary literal CLI arguments. | `run`, `upload`, [typed contract](./artifacts/tangled-artifacts/COMPONENT.md) |
| [telegram](./notifications/telegram/README.md) | Send typed Telegram bot notifications with formatting and delivery options. | `send`, [typed contract](./notifications/telegram/COMPONENT.md) |
| [temporal](./services/temporal/README.md) | Run Temporal with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/temporal/COMPONENT.md) |
| [terraform](./infrastructure/terraform/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `init`, [typed contract](./infrastructure/terraform/COMPONENT.md) |
| [terragrunt](./infrastructure/terragrunt/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `hcl-fmt`, [typed contract](./infrastructure/terragrunt/COMPONENT.md) |
| [tidb](./services/tidb/README.md) | Run TiDB with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/tidb/COMPONENT.md) |
| [tigerbeetle](./services/tigerbeetle/README.md) | Run TigerBeetle with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/tigerbeetle/COMPONENT.md) |
| [timeplus](./services/timeplus/README.md) | Run Timeplus with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/timeplus/COMPONENT.md) |
| [timescale](./services/timescale/README.md) | Run TimescaleDB with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/timescale/COMPONENT.md) |
| [trino](./services/trino/README.md) | Run Trino with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/trino/COMPONENT.md) |
| [trivy](./security/trivy/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `filesystem`, [typed contract](./security/trivy/COMPONENT.md) |
| [trufflehog](./security/trufflehog/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `filesystem`, [typed contract](./security/trufflehog/COMPONENT.md) |
| [turborepo](./build/turborepo/README.md) | Run cached tasks, affected builds and workspace pruning. | `run-tasks`, `affected`, `prune`, [typed contract](./build/turborepo/COMPONENT.md) |
| [typesense](./services/typesense/README.md) | Run Typesense with native service readiness and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/typesense/COMPONENT.md) |
| [ubicloud](./cloud/ubicloud/README.md) | Manage cloud resources through all 123 reviewed ubi commands; requires UBI_TOKEN. | `vm-list`, `pg-create`, `kc-kubeconfig`, [typed contract](./cloud/ubicloud/COMPONENT.md) |
| [uv](./package-management/uv/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `sync`, [typed contract](./package-management/uv/COMPONENT.md) |
| [valkey](./services/valkey/README.md) | Run Valkey with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/valkey/COMPONENT.md) |
| [vault](./secrets/vault/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `status`, [typed contract](./secrets/vault/COMPONENT.md) |
| [vercel](./deployment/vercel/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `deploy`, [typed contract](./deployment/vercel/COMPONENT.md) |
| [wasmer](./deployment/wasmer/README.md) | Publish Wasm packages and manage Wasmer Edge deployments. | `publish`, `deploy`, `app-get`, [typed contract](./deployment/wasmer/COMPONENT.md) |
| [weaviate](./services/weaviate/README.md) | Run Weaviate with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/weaviate/COMPONENT.md) |
| [wiremock](./services/wiremock/README.md) | Run WireMock with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/wiremock/COMPONENT.md) |
| [wrangler](./deployment/wrangler/README.md) | Run a Wrangler operation with literal arguments. | `run`, `version`, `deploy`, [typed contract](./deployment/wrangler/COMPONENT.md) |
| [xata](./databases/xata/README.md) | Manage preview database branches, migrations, and native CLI workflows. | `run`, `branch-create`, [typed contract](./databases/xata/COMPONENT.md) |
| [yamllint](./linting/yamllint/README.md) | Execute arbitrary literal CLI arguments. | `run`, `version`, `lint`, [typed contract](./linting/yamllint/COMPONENT.md) |
| [yugabytedb](./services/yugabytedb/README.md) | Run YugabyteDB with native readiness, logs and lifecycle. | `start`, `stop`, `restart`, `status`, `logs`, [typed contract](./services/yugabytedb/COMPONENT.md) |

Each module has its own dependencies, build scripts, tests, and documentation.
Source APIs also expose helpers for composition in PureScript pipelines.

## License

All modules are licensed under the [MIT License](./LICENSE).

The vendored component inspection tools retain their [upstream MPL-2.0 license](./lib/component/inspection/LICENSE).
