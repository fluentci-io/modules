# InfluxDB service

Run a background InfluxDB test service through FluentCI's native workspace
service manager and Docker backend. Typed PureScript Wasm component; requires
FluentCI **v0.17.4+**, with the native services apply/status lifecycle API.

```sh
fluentci run influxdb start --version 2.7
fluentci run influxdb status
fluentci run influxdb logs --tail 50
fluentci run influxdb logs --tail 50 --follow true
fluentci run influxdb restart
fluentci run influxdb stop
```

For live logs, use `logs --follow true`. Press Ctrl-C to stop following; the
background service keeps running. The native shorthand is
`fluentci logs module-influxdb-default -f` in the same project workspace.

## Default profile

- Image: `influxdb:2.7`.
- Primary container port: `8086`; exposed TCP ports: `8086`.
- Readiness: `exec: influx bucket list --org fluentci --token fluentci-test-token`; startup deadline: `60000` ms.
- Native recurring health check uses the same probe by default.
- Name: `module-influxdb-default`; custom names must start with `module-influxdb-`.

When overriding initialization org/token, supply matching readinessCommand values.

Default environment values are disposable CI fixtures:

- `DOCKER_INFLUXDB_INIT_MODE=setup`
- `DOCKER_INFLUXDB_INIT_USERNAME=fluentci`
- `DOCKER_INFLUXDB_INIT_PASSWORD=fluentci-test-password`
- `DOCKER_INFLUXDB_INIT_ORG=fluentci`
- `DOCKER_INFLUXDB_INIT_BUCKET=fluentci_test`
- `DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=fluentci-test-token`

## Typed configuration and lifecycle

--version selects the image tag. --image accepts a complete image/digest reference;
do not combine them. Start waits for readiness and returns name, state, backend,
host, primary port, endpoint and every container/host port binding. Dynamic ports
are returned as allocated; do not assume the host port equals the container port.
Restart uses the saved native definition. Reconfiguration requires stop first.
Repeated unchanged start reuses the service, and repeated stop is safe. Stop also
affects native dependents, while explicit bind/named volume data is preserved.

Use project to select the same workspace across calls. Docker must be installed
and its daemon and loopback port bindings accessible to the caller. Readiness,
Docker/image, manager and health failures propagate without successful startup.
Use cleanup/finally to stop manually started services after tests.

Public list inputs are comma-separated strings. env uses KEY=VALUE entries;
ports use CONTAINER or HOST:CONTAINER; volumes use /CONTAINER or
SOURCE:/CONTAINER[:ro|rw]. Optional blank lists retain defaults. Empty entries,
invalid selectors and duplicate mappings are rejected before installation.
CSV double quotes preserve commas within a literal token. command and
readiness-command remain foreground literal argv, without shell expansion.



See [COMPONENT.md](./COMPONENT.md) for every named argument, description and native
return, [the shared service guide](../README.md) for platform/data/lifecycle
semantics, and the [upstream reference](https://docs.influxdata.com/influxdb/v2/install/use-docker-compose/).

## Development

Mocked unit/contract tests run in normal module CI. The dedicated Services E2E
workflow builds every real component, starts/reuses/restarts/stops it through the
native manager, and checks real protocol connectivity sequentially on one runner.
No services or images are run by the source generators. License: MIT.
