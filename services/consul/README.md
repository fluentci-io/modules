# Consul service

Run a background Consul test service through FluentCI's native workspace
service manager and Docker backend. Typed PureScript Wasm component; requires
FluentCI with the native services apply/status lifecycle API.

```sh
fluentci run consul start --version 1.21
fluentci run consul status
fluentci run consul logs --tail 50
fluentci run consul restart
fluentci run consul stop
```

## Default profile

- Image: `hashicorp/consul:1.21`.
- Primary container port: `8500`; exposed TCP ports: `8500`.
- Readiness: `exec: consul operator raft list-peers`; startup deadline: `60000` ms.
- Native recurring health check uses the same probe by default.
- Name: `module-consul-default`; custom names must start with `module-consul-`.



Default environment values are disposable CI fixtures:

No environment overrides are required by default.

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
semantics, and the [upstream reference](https://developer.hashicorp.com/consul/docs/run/cloud-deployments/docker).

## Development

Mocked unit/contract tests run in normal module CI. The dedicated Services E2E
workflow builds every real component, starts/reuses/restarts/stops it through the
native manager, and checks real protocol connectivity sequentially on one runner.
No services or images are run by the source generators. License: MIT.
