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

<!-- generated:language-examples -->
## Compose this module from code

Requires FluentCI **0.17.6 or newer** for generated pipeline bindings. From your
**caller module's directory**, add the dependency:

```sh
fluentci add ubicloud --path /path/to/fluentci-modules/cloud/ubicloud
```

For a published module, use `fluentci add @fluentci.io/ubicloud@VERSION` with an
available version. Commit the caller's manifest and lockfile. FluentCI generates
named bindings from the installed component's WIT; no handwritten FFI or CLI
subprocess is needed. Include generated source directories in the caller's SDK
project. The callee can use a different SDK from the caller.

List virtual machine resources. Requires a nonempty UBI_TOKEN environment variable, including help and version.

Replace the sample organization, paths and identifiers with your own. Configure
credentials through your CI secret provider before running authenticated operations. Optional arguments use the
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
import FluentCI.Modules.Ubicloud as Ubicloud

run :: Effect String
run =
  Flow.pipeline "ubicloud-vm-list"
    # Flow.workdir "."
    # Ubicloud.vmList (Ubicloud.vmListArgs)
    # Flow.map (\result -> result.reportPath)
    # Flow.run
```

### Gleam

```gleam
import fluentci/flow
import fluentci_modules/ubicloud

pub fn run() -> String {
  flow.pipeline("ubicloud-vm-list")
  |> flow.workdir(".")
  |> ubicloud.vm_list(ubicloud.vm_list_args())
  |> flow.map(fn(result) { result.report_path })
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
  alias FluentCI.Modules.Ubicloud

  defplugin run do
    Flow.pipeline("ubicloud-vm-list")
    |> Flow.workdir(".")
    |> Ubicloud.vm_list(%{})
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
            [fluentci-modules.ubicloud :as ubicloud]))

(defn run []
  (-> (flow/pipeline "ubicloud-vm-list")
      (flow/workdir ".")
      (ubicloud/vm-list {})
      flow/run!))
```

### ReScript

```rescript
let run = (): string =>
  Flow.pipeline("ubicloud-vm-list")
  ->Flow.workdir(".")
  ->FluentciModulesUbicloud.vmList(FluentciModulesUbicloud.vmListArgs)
  ->Flow.map(result => result.reportPath)
  ->Flow.run
```

### Python

```python
from fluentci.flow import pipeline
from fluentci_modules import ubicloud


def run() -> str:
    return (
        pipeline("ubicloud-vm-list")
        .workdir(".")
        .pipe(ubicloud.vm_list, {})
        .map(lambda result: result.report_path)
        .run()
    )
```

### TypeScript

```typescript
import * as flow from "./fluentci_modules/flow";
import * as ubicloud from "./fluentci_modules/ubicloud/index";

export function run(): string {
  return flow.pipeline("ubicloud-vm-list")
    .workdir(".")
    .pipe(ubicloud.vmList, {})
    .map(result => result.reportPath)
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
| `run` | Execute additional ubi CLI commands with literal CSV arguments. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `ai_api_key_create` | Create an inference API key. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `ai_api_key_list` | List inference API keys. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `ai_api_key_destroy` | Destroy an inference API key. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `ai_api_key_show` | Show details for an inference API key. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `ai_endpoint_list` | List inference endpoints. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `al_search` | Search project audit log entries in CSV format. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `fw_list` | List firewall resources. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `fw_add_rule` | Add a firewall rule. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `fw_attach_subnet` | Attach a private subnet to a firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `fw_create` | Create a firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `fw_delete_rule` | Remove a firewall rule. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `fw_destroy` | Destroy firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `fw_detach_subnet` | Detach a private subnet from a firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `fw_modify_rule` | Modify a firewall rule. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `fw_rename` | Rename firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `fw_show` | Show details for a firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `fw_update_description` | Update the description for a firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `gh_installation_list` | List GitHub installations. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `gh_installation_list_repositories` | List GitHub repositories for an installation. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `gh_list_cache_entries` | List cache entries for a GitHub repository. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `gh_remove_all_cache_entries` | Remove all cache entries for a GitHub repository. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `gh_remove_cache_entry` | Remove cache entry for a GitHub repository. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `help` | Get command help. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `kc_list` | List Kubernetes cluster resources. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `kc_create_nodepool` | Create a nodepool on a Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `kc_create` | Create a Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `kc_destroy_nodepool` | Destroy a nodepool of a Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `kc_destroy` | Destroy Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `kc_kubeconfig` | Print kubeconfig.yaml for a Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `kc_rename` | Rename Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `kc_resize_nodepool` | Resize a Kubernetes cluster nodepool. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `kc_retire_node` | Retire a worker node from a Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `kc_show` | Show details for a Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `kc_upgrade_nodepool` | Upgrade a nodepool of a Kubernetes cluster to the cluster's version. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `kc_upgrade` | Upgrade a Kubernetes cluster to the next supported version. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `lb_list` | List load balancer resources. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `lb_attach_vm` | Attach a virtual machine to a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `lb_create` | Create a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `lb_destroy` | Destroy load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `lb_detach_vm` | Detach a virtual machine from a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `lb_disable_ssl_certificate` | Disable the SSL certificate for a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `lb_enable_ssl_certificate` | Enable the SSL certificate for a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `lb_rename` | Rename load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `lb_show` | Show details for a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `lb_update` | Update a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `mi_list` | List machine image resources. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `mi_create_version` | Create a new version of a machine image from a stopped VM. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `mi_create` | Create a machine image from a stopped VM. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `mi_destroy_version` | Destroy a non-latest version of a machine image. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `mi_destroy` | Destroy machine image. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `mi_list_versions` | List versions of a machine image. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `mi_rename` | Rename machine image. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `mi_set_latest` | Set the latest version of a machine image. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `mi_show` | Show details for a machine image. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_list` | List PostgreSQL database resources. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_add_bearer_metric_destination` | Add a PostgreSQL metric destination using bearer token authentication. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_add_cert_auth_user` | Add user to list of users authenticating with client certificate authentication. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_add_config_entries` | Add configuration entries to a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_add_firewall_rule` | Add a PostgreSQL firewall rule. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_add_metric_destination` | Add a PostgreSQL metric destination. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_add_otlp_log_destination` | Add an OTLP HTTP log destination to a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_add_pgbouncer_config_entries` | Add pgbouncer configuration entries to a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_add_syslog_log_destination` | Add a syslog (RFC 5424 over TLS) log destination to a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_ca_certificates` | Print CA certificates for a PostgreSQL database (if available). Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_create_backup_credentials` | Create temporary, read-only credentials for downloading PostgreSQL backups. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_create_client_cert_keypair` | Create client certificate keypair with given common name, expiring after a duration of seconds. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_create_read_replica` | Create a read replica for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_create` | Create a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_delete_firewall_rule` | Delete a PostgreSQL firewall rule. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_delete_log_destination` | Delete a PostgreSQL log destination. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_delete_metric_destination` | Delete a PostgreSQL metric destination. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_destroy` | Destroy PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_get_logs` | Fetch logs for a PostgreSQL database in CSV format. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_list_backups` | List backups for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_list_servers` | List servers for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_modify_firewall_rule` | Modify a PostgreSQL firewall rule. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_modify` | Modify a PostgreSQL database cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_pg_dump` | Dump a single PostgreSQL database using `pg_dump`. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_pg_dumpall` | Dump a entire PostgreSQL database cluster using `pg_dumpall`. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_promote_read_replica` | Promote a read replica PostgreSQL database to a primary. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_psql` | Connect to a PostgreSQL database using `psql`. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_recycle` | Request recycle of primary. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_remove_cert_auth_user` | Remove user from list of users authenticating with client certificate authentication. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_remove_config_entries` | Remove configuration entries from a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_remove_pgbouncer_config_entries` | Remove pgbouncer configuration entries from a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_rename` | Rename PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_reset_superuser_password` | Reset the superuser password for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_restart` | Restart a PostgreSQL database cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_restore` | Restore a PostgreSQL database backup to a new database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_set_maintenance_window` | Set the maintenance window for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_show_config` | Show configuration for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_show_default_config` | Show default configuration for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_show_pgbouncer_config` | Show pgbouncer configuration for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_show_upgrade_status` | Show the status of a major version upgrade of the PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_show` | Show details for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `pg_upgrade` | Schedule a major version upgrade of the PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `ps_list` | List private subnet resources. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `ps_connect` | Connect a private subnet to another private subnet. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `ps_create` | Create a private subnet. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `ps_destroy` | Destroy private subnet. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `ps_disconnect` | Disconnect a private subnet from another private subnet. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `ps_rename` | Rename private subnet. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `ps_show` | Show details for a private subnet. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `sk_list` | List SSH public keys. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `sk_create` | Register an SSH public key. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `sk_destroy` | Destroy an SSH public key. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `sk_rename` | Rename an SSH public key. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `sk_show` | Show details for an SSH public key. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `sk_update` | Update an SSH public key. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `version` | Display CLI program version. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `vm_list` | List virtual machine resources. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `vm_create` | Create a virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `vm_destroy` | Destroy virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `vm_rename` | Rename virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `vm_restart` | Restart a virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `vm_scp` | Copy files to or from virtual machine using `scp`. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `vm_serial_log` | Show a virtual machine's serial console log, fetching it if needed. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `vm_set_maintenance_window` | Set the maintenance window for a virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `vm_sftp` | Copy files to or from virtual machine using `sftp`. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `vm_show` | Show details for a virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `vm_ssh` | Connect to a virtual machine using `ssh`. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `vm_start` | Start a virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
| `vm_stop` | Stop a virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version. |
<!-- /generated:language-examples -->
