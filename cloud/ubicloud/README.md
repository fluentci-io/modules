# Ubicloud

Manage Ubicloud resources through typed PureScript CI/CD functions. This component exposes all **123 executable commands** in the reviewed upstream CLI source, plus the `run` escape hatch. Requires FluentCI v0.17.3+.

**`UBI_TOKEN` is required for every function, including `help` and `version`.** Set it to the project's Ubicloud personal access token through your CI secret store. Missing or blank values fail before setup, host commands or API operations. Optionally set `UBI_URL` for a different compatible API server. The token is inherited by `ubi`; it is not a module argument or copied into the task plan.

```sh
# UBI_TOKEN must already be provided by the runner's secret configuration.
fluentci run ubicloud help --run-dir /tmp/ubi-help-1 --recursive --usage
fluentci run ubicloud version --run-dir /tmp/ubi-version-1
fluentci run ubicloud vm-list --run-dir /tmp/ubi-vms-1 --location eu-central-h1 --fields name,id,ip4 --no-headers
fluentci run ubicloud vm-create --run-dir /tmp/ubi-create-1 --resource eu-central-h1/ci-worker --public-key ci-ssh-key --size standard-2
fluentci run ubicloud vm-show --run-dir /tmp/ubi-show-1 --resource eu-central-h1/ci-worker
fluentci run ubicloud fw-add-rule --run-dir /tmp/ubi-firewall-1 --resource eu-central-h1/ci-firewall --cidr 10.0.0.0/8 --start-port 443 --end-port 443
fluentci run ubicloud kc-kubeconfig --run-dir /tmp/ubi-kubeconfig-1 --resource eu-central-h1/ci-cluster
fluentci run ubicloud pg-list --run-dir /tmp/ubi-pg-1 --fields name,id,version
fluentci run ubicloud pg-add-config-entries --run-dir /tmp/ubi-config-1 --resource eu-central-h1/ci-database --entries work_mem=64MB,max_connections=100
fluentci run ubicloud vm-ssh --run-dir /tmp/ubi-ssh-1 --resource eu-central-h1/ci-worker --arguments=-o,BatchMode=yes,--,uname,-a
fluentci run ubicloud vm-destroy --run-dir /tmp/ubi-cleanup-1 --resource eu-central-h1/ci-worker --confirm ci-worker
```

See [COMMANDS.md](./COMMANDS.md) for the full command inventory and upstream source links, [COMPONENT.md](./COMPONENT.md) for every typed argument and return value, and [OPTIONS.md](./OPTIONS.md) for native argument mappings. Functions use native group prefixes (`vm-*`, `pg-*`, `kc-*`, `fw-*`, `ps-*`, `lb-*`, `mi-*`, `sk-*`, `ai-*`, `al-*` and `gh-*`). CLI function/flag names use kebab-case; PureScript exports use underscores.

`--resource` occupies the native reference position: `vm-show --resource eu-central-h1/ci-worker` invokes `ubi vm eu-central-h1/ci-worker show`. Creation commands generally require `location/new-name`; existing resources accept their native ID or reference. SSH keys use a key name/ID and GitHub commands use the installation/repository references shown in the contract. Resource references and operands remain literal tokens, including shell metacharacters.

All list arguments are comma-separated strings. `--fields name,id` becomes one `--fields=name,id` token. `--entries work_mem=64MB,max_connections=100` becomes separate positional KEY=VALUE entries. PostgreSQL configuration and tag options become single native comma-delimited flag values. Whitespace is trimmed, malformed CSV, empty entries, invalid assignments, NUL characters, and positional options disguised as resource names are rejected before host commands. Blank optional lists preserve native behavior. Quote an entry using CSV double quotes when a token itself contains commas; native parsers may still apply their own comma syntax. Public `run.arguments` and `artifacts` now use CSV strings instead of JSON arrays.

`--force` and `--confirm` are explicit native controls; the module never approves destruction automatically. Asynchronous resource operations retain native behavior: successful submission does not mean a VM, database or Kubernetes upgrade is ready. Follow with the appropriate `show`, status or log operation and your pipeline's polling policy.

The module declares [setup-ubicloud](../../setup/ubicloud/README.md) as a typed component dependency. It installs a missing `ubi` after token validation, reuses an available CLI, and preserves explicit executable overrides. Run setup first to select an exact CLI release. Publishing composes this dependency so consumers do not need repository-relative source paths. See [module dependencies](../../docs/MODULE_DEPENDENCIES.md).

VM SSH/SCP/SFTP operations require the corresponding local OpenSSH tools. PostgreSQL `pg-psql`, `pg-pg-dump`, and `pg-pg-dumpall` require local PostgreSQL client binaries; the upstream server requires ubi 1.1.0+ for these password-protected connections. Forward native client options through CSV `--arguments`; SCP uses `--client-arguments` to place options before its source and destination. For noninteractive pipelines configure SSH host verification/authentication and provide a batch file or explicit SQL command as appropriate. Each command remains bounded by `--timeout-ms`.

Each function returns typed `outcome`, `run-dir`, `report-path`, `stdout-path` and `stderr-path`. Read native resource tables, IDs, kubeconfig, certificates or SQL output from the returned stdout file; they are not falsely decoded as a universal resource schema. Each call requires a fresh `--run-dir`. Native failures, cancellations and timeouts fail the module call. Use comma-separated `--artifacts NAME=PATH` to collect native output files.

Some upstream operations require a password, bearer token or HTTP headers as positional operands. Those explicit operands can appear in native argv and the module's execution reports. Kubeconfig, API key creation, database credentials and connection output can also contain secrets. Protect run directories and restrict log/artifact access; the inherited `UBI_TOKEN` itself is not copied into plans.

Command availability and allowed values are server-defined. Coverage is pinned to the source revision in [upstream-commands.json](./upstream-commands.json); the official quickstart documents a smaller subset. Use `help --recursive` to inspect your server, and `run --arguments=vm,list` for server extensions beyond this reviewed inventory. The module does not invoke a live API during its fixture tests.

[Official CLI quickstart](https://www.ubicloud.com/docs/quick-start/cli) · [Upstream client](https://github.com/ubicloud/cli) · [MIT wrapper license](./LICENSE).
