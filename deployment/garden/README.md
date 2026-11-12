# Garden

Build, deploy and test Garden projects in CI/CD using a PureScript typed Wasm component for FluentCI v0.17.3+.

```sh
fluentci run setup-garden setup --version 0.14.20
fluentci run garden build --project . --run-dir /tmp/garden-build-1 --environment pr-123.ci --names api,worker
fluentci run garden deploy --project . --run-dir /tmp/garden-deploy-1 --environment pr-123.ci --variables imageTag=abc123 --disable-port-forwards
fluentci run garden test --project . --run-dir /tmp/garden-tests-1 --environment pr-123.ci --names '*integration*' --force
fluentci run garden workflow --project . --run-dir /tmp/garden-workflow-1 --environment ci --name release
fluentci run garden status --project . --run-dir /tmp/garden-status-1 --environment pr-123.ci --output json
fluentci run garden cleanup-deploy --project . --run-dir /tmp/garden-cleanup-1 --environment pr-123.ci --names api,worker
```

Functions cover `build`, `deploy`, `test`, `run-actions`, `workflow`, `status`, `outputs`, `graph`, `config`, `publish`, `logs`, `cleanup-deploy`, `cleanup-namespace`, `version`, and `run`. The named contract targets Garden Cedar 0.14. Use `run --arguments get,actions,--output=json` or a named function's optional `--arguments` for additional native features. See [COMPONENT.md](./COMPONENT.md) for argument descriptions and typed returns, and [OPTIONS.md](./OPTIONS.md) for native flag mappings.

All public list arguments accept comma-separated strings. `--names api,worker` becomes two literal positional tokens; wildcards are passed to Garden without shell expansion. `--skip api,worker` and `--modules backend,frontend` repeat the native option. Variable overrides use `--variables imageTag=abc123,replicas=2`; entries must be KEY=VALUE, with alphanumeric, underscore, dash or dot keys. Optional blank lists preserve Garden's default selection. Empty entries between commas, malformed CSV, NUL characters, malformed assignments and positional option injection are rejected before host commands. CSV double quotes can enclose entries containing commas, but Garden's own list parsing still applies; use project configuration for complex structured values.

The module declares [setup-garden](../../setup/garden/README.md) as a typed dependency. It installs a missing CLI automatically, preserving an existing CLI. Set an explicit `--executable` to use a custom installation and bypass setup, or run setup first to pin the version. Published components compose the dependency; consumers do not need the repository's relative paths. See [module dependencies](../../docs/MODULE_DEPENDENCIES.md).

Run from a checkout containing a Garden project with its environments and providers configured. The CLI installation does not provision a Kubernetes cluster, Docker daemon, registry credentials or provider infrastructure. Supply the prerequisites required by the project's providers. Set `GARDEN_AUTH_TOKEN` for Garden Cloud-connected projects and use native credential files/environment variables for Kubernetes and cloud providers; tokens are not module arguments. Explicit variable arguments appear in execution reports, so keep secrets in environment-backed project configuration. Native logs and resolved outputs may contain sensitive data.

Environment selection uses Garden's `NAMESPACE.ENVIRONMENT` syntax. `--yes` is opt-in and approves protected production operations. `--force` and `--force-build` are also opt-in. Tests reuse Garden's cache unless forced. Cleanup without names targets all eligible deployments; namespace cleanup affects the whole selected project environment. `--skip-dependencies` assumes dependencies are already prepared. Logs do not follow unless requested; bound long-running operations with `--timeout-ms` and use a scoped service lifecycle when needed.

Each invocation requires a fresh `--run-dir`. Native failures, including failed builds and tests, fail the module call. A successful call returns typed `outcome`, `run-dir`, `report-path`, `stdout-path` and `stderr-path`. `--output json` writes Garden's structured result into the returned stdout file; it does not change the module's return type. Collect generated outputs with comma-separated `--artifacts NAME=PATH` declarations.

[Official CLI reference](https://docs.garden.io/reference/commands) · [MIT wrapper license](./LICENSE).
