# AWS Emulator service

Run a background AWS Emulator test service through FluentCI's native workspace
service manager and Docker backend. Typed PureScript Wasm component; requires
FluentCI **v0.17.4+**, with the native services apply/status lifecycle API.

```sh
fluentci run aws-emulator start --state-dir /tmp/aws-emulator-material --image fluentci/aws-emulator:ci
fluentci run aws-emulator status
fluentci run aws-emulator logs --tail 50
fluentci run aws-emulator logs --tail 50 --follow true
fluentci run aws-emulator restart
fluentci run aws-emulator stop
```

For live logs, use `logs --follow true`. Press Ctrl-C to stop following; the
background service keeps running. The native shorthand is
`fluentci logs module-aws-emulator-default -f` in the same project workspace.

## Default profile

- Image: `fluentci/aws-emulator:local` (locally built, not a published image).
- Primary container port: `9297`; exposed TCP ports: `9297`.
- Readiness: `exec: HTTPS health verified with the generated CA`; startup deadline: `180000` ms.
- Native recurring health check uses the same probe by default.
- Name: `module-aws-emulator-default`; custom names must start with `module-aws-emulator-`.

Official aws/aws-emulator. Run build first or provide a prebuilt image. stateDir is required; host and container ports match. Generated credentials and TLS material remain in the caller-owned bind directory.

Default environment values are disposable CI fixtures:

- `EMULATOR_TELEMETRY=off`

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


## Official AWS Emulator image and SDK configuration

AWS does not publish a prebuilt Docker image. The build function installs the
[official AWS Emulator RPM](https://docs.aws.amazon.com/emulator/latest/userguide/getting-started-docker.html)
into Amazon Linux 2023, selecting the daemon's x86_64/aarch64 architecture. It uses
JSON-form Dockerfile instructions, not a source build or a shell-script pipeline.
The returned image tag can be passed directly to start. A custom package-url must
include package-sha256; Docker verifies that checksum during ADD. The default RPM
URL follows AWS's latest LTS distribution. Image file ownership matches the caller
so the generated private files are readable through the bind mount.

```sh
fluentci run aws-emulator build --image fluentci/aws-emulator:ci
fluentci run aws-emulator start --image fluentci/aws-emulator:ci --state-dir /tmp/aws-emulator-material --port 9297
```

state-dir is required and must be absolute. The same nonzero port is used inside
and outside the container. A second instance needs both a distinct module name
and a distinct port/material directory. Do not use random port zero for AWS.
Readiness includes checking the generated files and an HTTPS request to the native
/__admin/health endpoint using its CA, without disabling certificate verification.

The generated SDK material lives below STATE_DIR/PORT. Configure test processes
using AWS_ENDPOINT_URL=https://127.0.0.1:PORT, AWS_SHARED_CREDENTIALS_FILE pointing
to emulator_credentials, AWS_CONFIG_FILE pointing to config, and AWS_CA_BUNDLE
pointing to ca.pem. Set AWS_EC2_METADATA_DISABLED=true and
AWS_DISABLE_HOST_PREFIX_INJECTION=true. Clear credential environment variables
that take precedence over the generated files. SDKs with separate trust settings
need their documented CA option. See [AWS SDK configuration](https://docs.aws.amazon.com/emulator/latest/userguide/point-sdk-to-emulator.html).
Stop preserves the caller-owned directory; the emulator itself removes per-run
credential material on shutdown. Telemetry is disabled by this CI profile.


See [COMPONENT.md](./COMPONENT.md) for every named argument, description and native
return, [the shared service guide](../README.md) for platform/data/lifecycle
semantics, and the [upstream reference](https://github.com/aws/aws-emulator).

## Development

Mocked unit/contract tests run in normal module CI. The dedicated Services E2E
workflow builds every real component, starts/reuses/restarts/stops it through the
native manager, and checks real protocol connectivity sequentially on one runner.
No services or images are run by the source generators. License: MIT.

Default readiness and recurring health use curl inside the owned container to
verify HTTPS `/__admin/health` with its generated CA. A published TCP port alone
is insufficient because Docker may accept connections before emulator startup.
The image built by this module installs `curl-minimal`; compatible prebuilt
images must provide curl and use `/home/emulator` for generated SDK material.
