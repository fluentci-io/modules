# Background test services

Every service exposes typed PureScript start, stop, restart, status and logs
functions backed by FluentCI's native workspace service manager. Docker is the
default backend; FluentCI supervises its foreground process and owned container.
TigerBeetle uses the native host backend and a verified prebuilt binary.
There is no docker run -d, legacy asService provider, or external process manager.

Service modules require **FluentCI v0.17.4 or newer**. Dynamic port placeholders
resolve to the complete loopback address (`127.0.0.1:PORT`). HTTP probes use
`http://${port:CONTAINER}/path`; TCP probes use `${port:CONTAINER}`. Version
0.17.4 validates HTTP URLs after placeholder substitution.

```sh
fluentci run redis start --version 7-alpine
fluentci run redis status
fluentci run redis logs --tail 50
fluentci run redis logs --tail 50 --follow true
fluentci run redis restart
fluentci run redis stop
```

Start waits for the configured readiness probe, returns the allocated loopback
ports, and reuses an unchanged running definition. Stop is idempotent and targets
only the module's named service; the native manager also stops its dependents.
Restart reuses the existing definition. Changing image/version, mounts, ports or
configuration requires stopping first. Logs return bounded snapshots by default. Set --follow true to stream new output
until interrupted; interrupting the log viewer leaves the service running.

The native shorthand `fluentci logs module-redis-default -f` follows the same
service in the current workspace. Module arguments use the named `--follow true`
option. A follow call stays attached and does not return a snapshot while active;
use the default snapshot mode in CI steps that must finish.

Names default to module-TOOL-default. Custom names must start with module-TOOL-.
Use the same project workspace and name across calls. Services span calls, so CI
must stop manually started services in cleanup/finally steps. Native
fluentci services run --service NAME -- COMMAND provides leased test execution;
a service manually started with these modules still needs an explicit stop.

Docker must be installed and its daemon reachable. Missing Docker CLI tools use
the typed setup-docker dependency, while status/logs/stop do not install anything.
Linux and macOS Docker Desktop/VM environments can expose the returned loopback
ports directly. BSD requires a suitable daemon and forwarding its loopback-bound
ports to the caller. Image architecture support remains an upstream constraint;
older images may require Docker emulation.

--version selects a Docker tag. --image selects a full reference, including a
sha256 digest; the two options are mutually exclusive. Image defaults are listed
in each module README. Pin an exact version or digest for reproducible pipelines.
Ports usually default to dynamically allocated loopback host ports. Kafka,
Redpanda, Aerospike and Floci use explicit primary ports and publish that port in
advertised client addresses. AWS Emulator requires identical host/container ports.
TigerBeetle uses an explicit native host port and caller-owned data directory. --port fixes the primary
host port; --ports configures comma-separated CONTAINER or HOST:CONTAINER mappings.
Only TCP mappings are supported by the native manager. Each module returns name,
state, backend, host, primary port, endpoint and all container/host port bindings.
An absent/stopped service has no active endpoint or stale port bindings.

All list inputs are CSV strings: ports, volumes, env KEY=VALUE, command tokens,
depends-on names, and readiness-command tokens. Whitespace is trimmed, blank
optional lists keep defaults, and empty entries are rejected before setup.
CSV double quotes preserve literal commas. No public input requires JSON objects
or arrays. Commands are literal argv without shell expansion. Override env and
readiness-command together when an application probe depends on changed settings.

Data is disposable by default. --volumes accepts anonymous /CONTAINER paths,
named-volume:/CONTAINER paths, and absolute-host:/CONTAINER[:ro|rw] bindings.
Explicit named/bind data is preserved by stop; deleting it is a separate user
operation. Database profiles use documented synthetic test credentials, not
production secrets. Environment overrides are included in the manager definition,
so use disposable test configuration values.

AWS Emulator is the official aws/aws-emulator project. It has a dedicated build
function for its official RPM, fixed matched host/container ports, and caller-owned
TLS/credential material. See its README rather than treating it as a public
prebuilt image or a different AWS emulator.

CI's dedicated Services E2E workflow builds and composes all real Wasm modules,
checks readiness and connectivity, proves idempotent start and real restart,
reads bounded logs, verifies Redis log streaming and interruption without stopping
the service, stops every service, and verifies named-volume preservation.

Component compilation slots follow detected host CPU capacity. BEAM scheduling
supports up to 32 workers; heavyweight compilation respects the CPU limit and
optional COMPONENT_BUILD_CONCURRENCY override. Dependency preparation and
composition are serialized to protect shared build directories. Service lifecycle
checks remain sequential on one Ubuntu runner to limit memory use.

## Available services

| Module | Default image/binary | Primary port | Readiness |
| --- | --- | --- | --- |
| [Aerospike](./aerospike/README.md) | `aerospike/aerospike-server:latest` | `3000` | tcp |
| [ArangoDB](./arangodb/README.md) | `arangodb:3.12` | `8529` | tcp |
| [AWS Emulator](./aws-emulator/README.md) | `fluentci/aws-emulator:local` | `9297` | tcp |
| [Caddy](./caddy/README.md) | `caddy:2-alpine` | `80` | http `/` |
| [Cassandra](./cassandra/README.md) | `cassandra:5.0` | `9042` | exec |
| [Chroma](./chroma/README.md) | `chromadb/chroma:1.5.3` | `8000` | http `/api/v2/heartbeat` |
| [ClickHouse](./clickhouse/README.md) | `clickhouse/clickhouse-server:25.8` | `8123` | http `/ping` |
| [CockroachDB](./cockroachdb/README.md) | `cockroachdb/cockroach:v25.4.0` | `26257` | tcp |
| [Consul](./consul/README.md) | `hashicorp/consul:1.21` | `8500` | http `/v1/operator/raft/configuration` |
| [Couchbase](./couchbase/README.md) | `couchbase:community-7.6.2` | `8091` | http `/pools` |
| [CouchDB](./couchdb/README.md) | `couchdb:3` | `5984` | http `/_up` |
| [CrateDB](./cratedb/README.md) | `crate:latest` | `4200` | http `/` |
| [Databend](./databend/README.md) | `datafuselabs/databend:latest` | `8000` | tcp |
| [Dolt](./doltdb/README.md) | `dolthub/dolt-sql-server:latest` | `3306` | tcp |
| [Dragonfly](./dragonfly/README.md) | `ghcr.io/dragonflydb/dragonfly:v2.0.2` | `6379` | tcp |
| [DynamoDB Local](./dynamodb/README.md) | `amazon/dynamodb-local:latest` | `8000` | tcp |
| [Elasticsearch](./elasticsearch/README.md) | `docker.elastic.co/elasticsearch/elasticsearch:8.15.0` | `9200` | http `/_cluster/health?wait_for_status=yellow&timeout=1s` |
| [etcd](./etcd/README.md) | `quay.io/coreos/etcd:v3.6.5` | `2379` | http `/health` |
| [Floci](./floci/README.md) | `floci/floci:latest` | `4566` | http `/_localstack/health` |
| [httpbin](./httpbin/README.md) | `ghcr.io/mccutchen/go-httpbin:latest` | `8080` | http `/status/200` |
| [InfluxDB](./influxdb/README.md) | `influxdb:2.7` | `8086` | exec |
| [Apache Kafka](./kafka/README.md) | `apache/kafka:4.1.0` | `9092` | tcp |
| [Keycloak](./keycloak/README.md) | `quay.io/keycloak/keycloak:26.8.2` | `8080` | http `/realms/master` |
| [MailCatcher](./mailcatcher/README.md) | `sj26/mailcatcher:latest` | `1025` | tcp |
| [MailHog](./mailhog/README.md) | `mailhog/mailhog:v1.0.1` | `1025` | tcp |
| [Mailpit](./mailpit/README.md) | `axllent/mailpit:latest` | `1025` | tcp |
| [MariaDB](./mariadb/README.md) | `mariadb:11.4` | `3306` | tcp |
| [Microcks](./microcks/README.md) | `quay.io/microcks/microcks-uber:latest-native` | `8080` | http `/api/health` |
| [MongoDB](./mongodb/README.md) | `mongo:8.0` | `27017` | tcp |
| [MySQL](./mysql/README.md) | `mysql:8.4` | `3306` | tcp |
| [NATS](./nats/README.md) | `nats:2-alpine` | `4222` | tcp |
| [Neo4j](./neo4j/README.md) | `neo4j:5-community` | `7474` | http `/` |
| [NGINX](./nginx/README.md) | `nginx:1.28-alpine` | `80` | http `/` |
| [OpenFGA](./openfga/README.md) | `openfga/openfga:latest` | `8080` | http `/healthz` |
| [OpenLDAP](./openldap/README.md) | `osixia/openldap:1.5.0` | `389` | tcp |
| [OrientDB](./orientdb/README.md) | `orientdb:3.2` | `2480` | tcp |
| [Pinecone Local](./pinecone/README.md) | `ghcr.io/pinecone-io/pinecone-local:latest` | `5080` | tcp |
| [PostgreSQL](./postgres/README.md) | `postgres:17-alpine` | `5432` | exec |
| [Presto](./presto/README.md) | `prestodb/presto:latest` | `8080` | http `/v1/info` |
| [Qdrant](./qdrant/README.md) | `qdrant/qdrant:latest` | `6333` | http `/readyz` |
| [QuestDB](./questdb/README.md) | `questdb/questdb:10.2.0` | `9000` | http `/status` |
| [RabbitMQ](./rabbitmq/README.md) | `rabbitmq:4-management` | `5672` | tcp |
| [RavenDB](./ravendb/README.md) | `ravendb/ravendb:latest` | `8080` | http `/setup/alive` |
| [Redis](./redis/README.md) | `redis:7-alpine` | `6379` | exec |
| [Redpanda](./redpanda/README.md) | `docker.redpanda.com/redpandadata/redpanda:latest` | `9092` | tcp |
| [RethinkDB](./rethinkdb/README.md) | `rethinkdb:2.4` | `28015` | tcp |
| [S3Mock](./s3mock/README.md) | `adobe/s3mock:latest` | `9090` | tcp |
| [ScyllaDB](./scylladb/README.md) | `scylladb/scylla:6.2.3` | `9042` | tcp |
| [Vault](./vault/README.md) | `hashicorp/vault:1.20` | `8200` | http `/v1/sys/health` |
| [Smocker](./smocker/README.md) | `ghcr.io/smocker-dev/smocker:latest` | `8081` | http `/version` |
| [Apache Solr](./solr/README.md) | `solr:9-slim` | `8983` | http `/solr/fluentci/admin/ping` |
| [Stripe Mock](./stripe-mock/README.md) | `stripe/stripe-mock:latest` | `12111` | tcp |
| [SurrealDB](./surrealdb/README.md) | `surrealdb/surrealdb:v2.3.10` | `8000` | http `/health` |
| [Temporal](./temporal/README.md) | `temporalio/temporal:latest` | `7233` | tcp |
| [TiDB](./tidb/README.md) | `pingcap/tidb:v8.5.4` | `4000` | tcp |
| [TigerBeetle](./tigerbeetle/README.md) | `native TigerBeetle 0.17.9` | `3000` | tcp |
| [Timeplus](./timeplus/README.md) | `d.timeplus.com/timeplus-io/proton:latest` | `3218` | http `/proton/info` |
| [TimescaleDB](./timescale/README.md) | `timescale/timescaledb:latest-pg17` | `5432` | tcp |
| [Trino](./trino/README.md) | `trinodb/trino:484` | `8080` | http `/v1/info` |
| [Typesense](./typesense/README.md) | `typesense/typesense:29.0` | `8108` | http `/health` |
| [Valkey](./valkey/README.md) | `valkey/valkey:8-alpine` | `6379` | tcp |
| [Weaviate](./weaviate/README.md) | `cr.weaviate.io/semitechnologies/weaviate:1.31.4` | `8080` | http `/v1/.well-known/ready` |
| [WireMock](./wiremock/README.md) | `wiremock/wiremock:3.13.2` | `8080` | http `/__admin/health` |
| [YugabyteDB](./yugabytedb/README.md) | `yugabytedb/yugabyte:2026.1.3.0-b100` | `5433` | tcp |
