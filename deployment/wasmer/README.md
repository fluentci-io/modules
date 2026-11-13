# Wasmer

Publish WebAssembly packages, deploy Wasmer Edge applications, inspect deployments and logs, and promote application versions through typed PureScript CI/CD functions. Requires FluentCI v0.17.3+.

```sh
fluentci run setup-wasmer setup --version 7.5.0
fluentci run wasmer validate --run-dir /tmp/wasmer-validate-1 --file dist/app.wasm
fluentci run wasmer publish --run-dir /tmp/wasmer-publish-1 --directory package --namespace example --name app --package-version 1.0.0 --wait container
fluentci run wasmer deploy --run-dir /tmp/wasmer-deploy-1 --path app.yaml --owner example --name ci-app --publish-package
fluentci run wasmer app-get --run-dir /tmp/wasmer-app-1 --app example/ci-app --format json
fluentci run wasmer app-logs --run-dir /tmp/wasmer-logs-1 --app example/ci-app --streams stdout,stderr --max 100
fluentci run wasmer version-activate --run-dir /tmp/wasmer-promote-1 --version-id dav_unique_version_id
```

Set `WASMER_TOKEN` from the CI secret store for registry and Edge operations, or provision native Wasmer credentials before invoking them. Credentials remain inherited and are not public token arguments. Build Wasm and prepare `wasmer.toml`/`app.yaml` using the project's toolchains before publishing/deploying. Setup installs the CLI only. Named flags target Wasmer 7.5.0; [COMMANDS.md](./COMMANDS.md), [COMPONENT.md](./COMPONENT.md) and [OPTIONS.md](./OPTIONS.md) describe coverage, typed contracts and flag mappings.

`publish` and `deploy` pass `--non-interactive`. They fail when required owner/app configuration is missing instead of starting a login or configuration prompt. File and directory inputs marked in the contract are checked before setup or execution. Native Wasmer rejects conflicting `--dir`/`--path` selections. `--no-default` can stage a version without activating it, while `version-activate` requires a unique version ID rather than a human-readable version name. `--no-wait` returns before reachability checks finish. `app-delete` requires an explicit app reference and is destructive; native Wasmer deletes without an interactive confirmation in a headless environment.

The component declares [setup-wasmer](../../setup/wasmer/README.md) as a typed dependency. Missing CLIs are installed automatically; available tools are reused. To pin a version run setup first. An explicit `--executable` bypasses automatic setup. Publishing composes dependencies so consumers need no repository-relative source paths.

Public lists use comma-separated strings; `--streams stdout,stderr` repeats the native stream option. Whitespace is trimmed and malformed CSV, empty entries and NUL characters are rejected before host commands. `run --arguments=app,list` and optional `--arguments` on named functions expose additional native features without shell expansion. Native server validation still applies.

Every call requires a fresh `--run-dir`. Failures and timeouts propagate as module errors. Success returns typed `outcome`, `run-dir`, `report-path`, `stdout-path` and `stderr-path`; native JSON or tables are read from the stdout file. Collect files with CSV `--artifacts NAME=PATH`. Logs do not watch unless requested; use a bounded `--timeout-ms` for streaming. Protect logs and reports containing application environment or secret data.

[Official Edge CLI reference](https://docs.wasmer.io/edge/cli/) · [Registry publishing](https://docs.wasmer.io/registry/cli/) · [MIT wrapper license](./LICENSE).
