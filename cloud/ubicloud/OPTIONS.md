# Ubicloud module arguments

Generated from [the CLI catalog](../../lib/cli/catalog.json).

Every export requires a fresh `runDir`. Common fields are `project` (default `.`),
`executable` (the CLI program or path), `timeoutMs` (default `900000`), and
`artifacts` is a comma-separated NAME=PATH string in the public component contract.

## `run`

Execute additional ubi CLI commands with literal CSV arguments. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Required |

## `ai_api_key_create`

Create an inference API key. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `ai_api_key_list`

List inference API keys. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `noHeaders` | `boolean` | `--no-headers` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `ai_api_key_destroy`

Destroy an inference API key. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before destroy)` | Required |
| `confirm` | `string` | `--confirm=<value>` (global) | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `ai_api_key_show`

Show details for an inference API key. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before show)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `ai_endpoint_list`

List inference endpoints. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `fields` | `string (CSV)` | `--fields=<comma-separated values>` | Omitted |
| `noHeaders` | `boolean` | `--no-headers` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `al_search`

Search project audit log entries in CSV format. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `noHeaders` | `boolean` | `--no-headers` | Omitted |
| `action` | `string` | `--action=<value>` | Omitted |
| `end` | `string` | `--end=<value>` | Omitted |
| `object` | `string` | `--object=<value>` | Omitted |
| `subject` | `string` | `--subject=<value>` | Omitted |
| `limit` | `integer` | `--limit=<value>` | Omitted |
| `paginationKey` | `string` | `--pagination-key=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `fw_list`

List firewall resources. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `fields` | `string (CSV)` | `--fields=<comma-separated values>` | Omitted |
| `location` | `string` | `--location=<value>` | Omitted |
| `noHeaders` | `boolean` | `--no-headers` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `fw_add_rule`

Add a firewall rule. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before add-rule)` | Required |
| `startPort` | `integer` | `--start-port=<value>` | Omitted |
| `endPort` | `integer` | `--end-port=<value>` | Omitted |
| `protocol` | `string` | `--protocol=<value>` | Omitted |
| `description` | `string` | `--description=<value>` | Omitted |
| `cidr` | `string` | `<cidr>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `fw_attach_subnet`

Attach a private subnet to a firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before attach-subnet)` | Required |
| `subnet` | `string` | `<subnet>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `fw_create`

Create a firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before create)` | Required |
| `description` | `string` | `--description=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `fw_delete_rule`

Remove a firewall rule. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before delete-rule)` | Required |
| `ruleId` | `string` | `<ruleId>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `fw_destroy`

Destroy firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before destroy)` | Required |
| `confirm` | `string` | `--confirm=<value>` (global) | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `fw_detach_subnet`

Detach a private subnet from a firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before detach-subnet)` | Required |
| `subnet` | `string` | `<subnet>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `fw_modify_rule`

Modify a firewall rule. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before modify-rule)` | Required |
| `cidr` | `string` | `--cidr=<value>` | Omitted |
| `startPort` | `integer` | `--start-port=<value>` | Omitted |
| `endPort` | `integer` | `--end-port=<value>` | Omitted |
| `protocol` | `string` | `--protocol=<value>` | Omitted |
| `description` | `string` | `--description=<value>` | Omitted |
| `ruleId` | `string` | `<ruleId>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `fw_rename`

Rename firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before rename)` | Required |
| `name` | `string` | `<name>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `fw_show`

Show details for a firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before show)` | Required |
| `fields` | `string (CSV)` | `--fields=<comma-separated values>` | Omitted |
| `nicFields` | `string (CSV)` | `--nic-fields=<comma-separated values>` | Omitted |
| `privSubnetFields` | `string (CSV)` | `--priv-subnet-fields=<comma-separated values>` | Omitted |
| `ruleFields` | `string (CSV)` | `--rule-fields=<comma-separated values>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `fw_update_description`

Update the description for a firewall. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before update-description)` | Required |
| `description` | `string` | `<description>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `gh_installation_list`

List GitHub installations. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `noHeaders` | `boolean` | `--no-headers` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `gh_installation_list_repositories`

List GitHub repositories for an installation. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before list-repositories)` | Required |
| `noHeaders` | `boolean` | `--no-headers` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `gh_list_cache_entries`

List cache entries for a GitHub repository. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before list-cache-entries)` | Required |
| `noHeaders` | `boolean` | `--no-headers` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `gh_remove_all_cache_entries`

Remove all cache entries for a GitHub repository. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before remove-all-cache-entries)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `gh_remove_cache_entry`

Remove cache entry for a GitHub repository. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before remove-cache-entry)` | Required |
| `cacheEntryId` | `string` | `<cacheEntryId>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `help`

Get command help. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `recursive` | `boolean` | `--recursive` | Omitted |
| `usage` | `boolean` | `--usage` | Omitted |
| `command` | `string (CSV)` | `<command>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `kc_list`

List Kubernetes cluster resources. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `fields` | `string (CSV)` | `--fields=<comma-separated values>` | Omitted |
| `location` | `string` | `--location=<value>` | Omitted |
| `noHeaders` | `boolean` | `--no-headers` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `kc_create_nodepool`

Create a nodepool on a Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before create-nodepool)` | Required |
| `name` | `string` | `<name>` | Required |
| `size` | `string` | `<size>` | Required |
| `count` | `integer` | `<count>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `kc_create`

Create a Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before create)` | Required |
| `version` | `string` | `--version=<value>` | Omitted |
| `cpNodeCount` | `integer` | `--cp-node-count=<value>` | Omitted |
| `workerNodeCount` | `integer` | `--worker-node-count=<value>` | Omitted |
| `workerSize` | `string` | `--worker-size=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `kc_destroy_nodepool`

Destroy a nodepool of a Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before destroy-nodepool)` | Required |
| `confirm` | `string` | `--confirm=<value>` (global) | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `nodepool` | `string` | `<nodepool>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `kc_destroy`

Destroy Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before destroy)` | Required |
| `confirm` | `string` | `--confirm=<value>` (global) | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `kc_kubeconfig`

Print kubeconfig.yaml for a Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before kubeconfig)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `kc_rename`

Rename Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before rename)` | Required |
| `name` | `string` | `<name>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `kc_resize_nodepool`

Resize a Kubernetes cluster nodepool. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before resize-nodepool)` | Required |
| `nodepool` | `string` | `<nodepool>` | Required |
| `count` | `integer` | `<count>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `kc_retire_node`

Retire a worker node from a Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before retire-node)` | Required |
| `node` | `string` | `<node>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `kc_show`

Show details for a Kubernetes cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before show)` | Required |
| `fields` | `string (CSV)` | `--fields=<comma-separated values>` | Omitted |
| `nodepoolFields` | `string (CSV)` | `--nodepool-fields=<comma-separated values>` | Omitted |
| `vmFields` | `string (CSV)` | `--vm-fields=<comma-separated values>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `kc_upgrade_nodepool`

Upgrade a nodepool of a Kubernetes cluster to the cluster's version. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before upgrade-nodepool)` | Required |
| `nodepool` | `string` | `<nodepool>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `kc_upgrade`

Upgrade a Kubernetes cluster to the next supported version. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before upgrade)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `lb_list`

List load balancer resources. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `fields` | `string (CSV)` | `--fields=<comma-separated values>` | Omitted |
| `location` | `string` | `--location=<value>` | Omitted |
| `noHeaders` | `boolean` | `--no-headers` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `lb_attach_vm`

Attach a virtual machine to a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before attach-vm)` | Required |
| `vm` | `string` | `<vm>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `lb_create`

Create a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before create)` | Required |
| `algorithm` | `string` | `--algorithm=<value>` | Omitted |
| `checkEndpoint` | `string` | `--check-endpoint=<value>` | Omitted |
| `checkProtocol` | `string` | `--check-protocol=<value>` | Omitted |
| `stack` | `string` | `--stack=<value>` | Omitted |
| `certEnabled` | `string` | `--cert-enabled=<value>` | Omitted |
| `subnet` | `string` | `<subnet>` | Required |
| `sourcePort` | `integer` | `<sourcePort>` | Required |
| `destinationPort` | `integer` | `<destinationPort>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `lb_destroy`

Destroy load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before destroy)` | Required |
| `confirm` | `string` | `--confirm=<value>` (global) | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `lb_detach_vm`

Detach a virtual machine from a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before detach-vm)` | Required |
| `vm` | `string` | `<vm>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `lb_disable_ssl_certificate`

Disable the SSL certificate for a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before disable-ssl-certificate)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `lb_enable_ssl_certificate`

Enable the SSL certificate for a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before enable-ssl-certificate)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `lb_rename`

Rename load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before rename)` | Required |
| `name` | `string` | `<name>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `lb_show`

Show details for a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before show)` | Required |
| `fields` | `string (CSV)` | `--fields=<comma-separated values>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `lb_update`

Update a load balancer. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before update)` | Required |
| `algorithm` | `string` | `<algorithm>` | Required |
| `sourcePort` | `integer` | `<sourcePort>` | Required |
| `destinationPort` | `integer` | `<destinationPort>` | Required |
| `healthCheckEndpoint` | `string` | `<healthCheckEndpoint>` | Required |
| `certificateEnabled` | `boolean` | `<value>` | Required |
| `vms` | `string (CSV)` | `<vms>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `mi_list`

List machine image resources. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `fields` | `string (CSV)` | `--fields=<comma-separated values>` | Omitted |
| `location` | `string` | `--location=<value>` | Omitted |
| `noHeaders` | `boolean` | `--no-headers` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `mi_create_version`

Create a new version of a machine image from a stopped VM. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before create-version)` | Required |
| `version` | `string` | `--version=<value>` | Omitted |
| `destroySource` | `boolean` | `--destroy-source` | Omitted |
| `vm` | `string` | `<vm>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `mi_create`

Create a machine image from a stopped VM. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before create)` | Required |
| `version` | `string` | `--version=<value>` | Omitted |
| `destroySource` | `boolean` | `--destroy-source` | Omitted |
| `vm` | `string` | `<vm>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `mi_destroy_version`

Destroy a non-latest version of a machine image. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before destroy-version)` | Required |
| `confirm` | `string` | `--confirm=<value>` (global) | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `version` | `string` | `<version>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `mi_destroy`

Destroy machine image. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before destroy)` | Required |
| `confirm` | `string` | `--confirm=<value>` (global) | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `mi_list_versions`

List versions of a machine image. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before list-versions)` | Required |
| `fields` | `string (CSV)` | `--fields=<comma-separated values>` | Omitted |
| `noHeaders` | `boolean` | `--no-headers` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `mi_rename`

Rename machine image. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before rename)` | Required |
| `name` | `string` | `<name>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `mi_set_latest`

Set the latest version of a machine image. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before set-latest)` | Required |
| `version` | `string` | `<version>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `mi_show`

Show details for a machine image. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before show)` | Required |
| `fields` | `string (CSV)` | `--fields=<comma-separated values>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_list`

List PostgreSQL database resources. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `fields` | `string (CSV)` | `--fields=<comma-separated values>` | Omitted |
| `location` | `string` | `--location=<value>` | Omitted |
| `noHeaders` | `boolean` | `--no-headers` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_add_bearer_metric_destination`

Add a PostgreSQL metric destination using bearer token authentication. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before add-bearer-metric-destination)` | Required |
| `url` | `string` | `<url>` | Required |
| `token` | `string` | `<token>` | Required |
| `headers` | `string (CSV)` | `<headers>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_add_cert_auth_user`

Add user to list of users authenticating with client certificate authentication. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before add-cert-auth-user)` | Required |
| `name` | `string` | `<name>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_add_config_entries`

Add configuration entries to a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before add-config-entries)` | Required |
| `entries` | `string (CSV)` | `<entries>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_add_firewall_rule`

Add a PostgreSQL firewall rule. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before add-firewall-rule)` | Required |
| `description` | `string` | `--description=<value>` | Omitted |
| `cidr` | `string` | `<cidr>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_add_metric_destination`

Add a PostgreSQL metric destination. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before add-metric-destination)` | Required |
| `username` | `string` | `<username>` | Required |
| `password` | `string` | `<password>` | Required |
| `url` | `string` | `<url>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_add_otlp_log_destination`

Add an OTLP HTTP log destination to a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before add-otlp-log-destination)` | Required |
| `name` | `string` | `<name>` | Required |
| `url` | `string` | `<url>` | Required |
| `headers` | `string (CSV)` | `<headers>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_add_pgbouncer_config_entries`

Add pgbouncer configuration entries to a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before add-pgbouncer-config-entries)` | Required |
| `entries` | `string (CSV)` | `<entries>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_add_syslog_log_destination`

Add a syslog (RFC 5424 over TLS) log destination to a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before add-syslog-log-destination)` | Required |
| `name` | `string` | `<name>` | Required |
| `host` | `string` | `<host>` | Required |
| `port` | `integer` | `<port>` | Omitted |
| `structuredData` | `string (CSV)` | `<structuredData>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_ca_certificates`

Print CA certificates for a PostgreSQL database (if available). Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before ca-certificates)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_create_backup_credentials`

Create temporary, read-only credentials for downloading PostgreSQL backups. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before create-backup-credentials)` | Required |
| `format` | `string (table, env, json)` | `--format=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_create_client_cert_keypair`

Create client certificate keypair with given common name, expiring after a duration of seconds. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before create-client-cert-keypair)` | Required |
| `commonName` | `string` | `<commonName>` | Required |
| `duration` | `integer` | `<duration>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_create_read_replica`

Create a read replica for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before create-read-replica)` | Required |
| `pgConfig` | `string (CSV)` | `--pg-config=<comma-separated values>` | Omitted |
| `pgbouncerConfig` | `string (CSV)` | `--pgbouncer-config=<comma-separated values>` | Omitted |
| `tags` | `string (CSV)` | `--tags=<comma-separated values>` | Omitted |
| `name` | `string` | `<name>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_create`

Create a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before create)` | Required |
| `flavor` | `string` | `--flavor=<value>` | Omitted |
| `haType` | `string` | `--ha-type=<value>` | Omitted |
| `size` | `string` | `--size=<value>` | Omitted |
| `storageSize` | `string` | `--storage-size=<value>` | Omitted |
| `version` | `string` | `--version=<value>` | Omitted |
| `pgConfig` | `string (CSV)` | `--pg-config=<comma-separated values>` | Omitted |
| `pgbouncerConfig` | `string (CSV)` | `--pgbouncer-config=<comma-separated values>` | Omitted |
| `tags` | `string (CSV)` | `--tags=<comma-separated values>` | Omitted |
| `restrictByDefault` | `boolean` | `--restrict-by-default` | Omitted |
| `privateSubnetName` | `string` | `--private-subnet-name=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_delete_firewall_rule`

Delete a PostgreSQL firewall rule. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before delete-firewall-rule)` | Required |
| `ruleId` | `string` | `<ruleId>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_delete_log_destination`

Delete a PostgreSQL log destination. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before delete-log-destination)` | Required |
| `destinationId` | `string` | `<destinationId>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_delete_metric_destination`

Delete a PostgreSQL metric destination. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before delete-metric-destination)` | Required |
| `destinationId` | `string` | `<destinationId>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_destroy`

Destroy PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before destroy)` | Required |
| `confirm` | `string` | `--confirm=<value>` (global) | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_get_logs`

Fetch logs for a PostgreSQL database in CSV format. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before get-logs)` | Required |
| `start` | `string` | `--start=<value>` | Omitted |
| `end` | `string` | `--end=<value>` | Omitted |
| `streamName` | `string` | `--stream-name=<value>` | Omitted |
| `serverRole` | `string` | `--server-role=<value>` | Omitted |
| `severityLevel` | `string` | `--severity-level=<value>` | Omitted |
| `queryPattern` | `string` | `--query-pattern=<value>` | Omitted |
| `maxLogLines` | `integer` | `--max-log-lines=<value>` | Omitted |
| `paginationKey` | `string` | `--pagination-key=<value>` | Omitted |
| `noHeaders` | `boolean` | `--no-headers` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_list_backups`

List backups for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before list-backups)` | Required |
| `noHeaders` | `boolean` | `--no-headers` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_list_servers`

List servers for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before list-servers)` | Required |
| `noHeaders` | `boolean` | `--no-headers` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_modify_firewall_rule`

Modify a PostgreSQL firewall rule. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before modify-firewall-rule)` | Required |
| `cidr` | `string` | `--cidr=<value>` | Omitted |
| `description` | `string` | `--description=<value>` | Omitted |
| `ruleId` | `string` | `<ruleId>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_modify`

Modify a PostgreSQL database cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before modify)` | Required |
| `haType` | `string` | `--ha-type=<value>` | Omitted |
| `size` | `string` | `--size=<value>` | Omitted |
| `storageSize` | `string` | `--storage-size=<value>` | Omitted |
| `tags` | `string (CSV)` | `--tags=<comma-separated values>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_pg_dump`

Dump a single PostgreSQL database using `pg_dump`. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before pg_dump)` | Required |
| `database` | `string` | `--dbname=<value> (before pg_dump)` | Omitted |
| `username` | `string` | `--username=<value> (before pg_dump)` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_pg_dumpall`

Dump a entire PostgreSQL database cluster using `pg_dumpall`. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before pg_dumpall)` | Required |
| `database` | `string` | `--dbname=<value> (before pg_dumpall)` | Omitted |
| `username` | `string` | `--username=<value> (before pg_dumpall)` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_promote_read_replica`

Promote a read replica PostgreSQL database to a primary. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before promote-read-replica)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_psql`

Connect to a PostgreSQL database using `psql`. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before psql)` | Required |
| `database` | `string` | `--dbname=<value> (before psql)` | Omitted |
| `username` | `string` | `--username=<value> (before psql)` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_recycle`

Request recycle of primary. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before recycle)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_remove_cert_auth_user`

Remove user from list of users authenticating with client certificate authentication. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before remove-cert-auth-user)` | Required |
| `name` | `string` | `<name>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_remove_config_entries`

Remove configuration entries from a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before remove-config-entries)` | Required |
| `keys` | `string (CSV)` | `<keys>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_remove_pgbouncer_config_entries`

Remove pgbouncer configuration entries from a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before remove-pgbouncer-config-entries)` | Required |
| `keys` | `string (CSV)` | `<keys>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_rename`

Rename PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before rename)` | Required |
| `name` | `string` | `<name>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_reset_superuser_password`

Reset the superuser password for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before reset-superuser-password)` | Required |
| `password` | `string` | `<password>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_restart`

Restart a PostgreSQL database cluster. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before restart)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_restore`

Restore a PostgreSQL database backup to a new database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before restore)` | Required |
| `pgConfig` | `string (CSV)` | `--pg-config=<comma-separated values>` | Omitted |
| `pgbouncerConfig` | `string (CSV)` | `--pgbouncer-config=<comma-separated values>` | Omitted |
| `tags` | `string (CSV)` | `--tags=<comma-separated values>` | Omitted |
| `name` | `string` | `<name>` | Required |
| `restoreTime` | `string` | `<restoreTime>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_set_maintenance_window`

Set the maintenance window for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before set-maintenance-window)` | Required |
| `days` | `string (CSV)` | `--days=<comma-separated values>` | Omitted |
| `startHour` | `integer` | `<startHour>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_show_config`

Show configuration for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before show-config)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_show_default_config`

Show default configuration for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before show-default-config)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_show_pgbouncer_config`

Show pgbouncer configuration for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before show-pgbouncer-config)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_show_upgrade_status`

Show the status of a major version upgrade of the PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before show-upgrade-status)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_show`

Show details for a PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before show)` | Required |
| `fields` | `string (CSV)` | `--fields=<comma-separated values>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `pg_upgrade`

Schedule a major version upgrade of the PostgreSQL database. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before upgrade)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `ps_list`

List private subnet resources. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `fields` | `string (CSV)` | `--fields=<comma-separated values>` | Omitted |
| `location` | `string` | `--location=<value>` | Omitted |
| `noHeaders` | `boolean` | `--no-headers` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `ps_connect`

Connect a private subnet to another private subnet. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before connect)` | Required |
| `subnet` | `string` | `<subnet>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `ps_create`

Create a private subnet. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before create)` | Required |
| `firewallId` | `string` | `--firewall-id=<value>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `ps_destroy`

Destroy private subnet. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before destroy)` | Required |
| `confirm` | `string` | `--confirm=<value>` (global) | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `ps_disconnect`

Disconnect a private subnet from another private subnet. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before disconnect)` | Required |
| `subnet` | `string` | `<subnet>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `ps_rename`

Rename private subnet. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before rename)` | Required |
| `name` | `string` | `<name>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `ps_show`

Show details for a private subnet. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before show)` | Required |
| `fields` | `string (CSV)` | `--fields=<comma-separated values>` | Omitted |
| `nicFields` | `string (CSV)` | `--nic-fields=<comma-separated values>` | Omitted |
| `ruleFields` | `string (CSV)` | `--rule-fields=<comma-separated values>` | Omitted |
| `firewallFields` | `string (CSV)` | `--firewall-fields=<comma-separated values>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `sk_list`

List SSH public keys. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `noHeaders` | `boolean` | `--no-headers` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `sk_create`

Register an SSH public key. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before create)` | Required |
| `publicKey` | `string` | `<publicKey>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `sk_destroy`

Destroy an SSH public key. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before destroy)` | Required |
| `confirm` | `string` | `--confirm=<value>` (global) | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `sk_rename`

Rename an SSH public key. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before rename)` | Required |
| `name` | `string` | `<name>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `sk_show`

Show details for an SSH public key. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before show)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `sk_update`

Update an SSH public key. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before update)` | Required |
| `publicKey` | `string` | `<publicKey>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `version`

Display CLI program version. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |

## `vm_list`

List virtual machine resources. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `fields` | `string (CSV)` | `--fields=<comma-separated values>` | Omitted |
| `location` | `string` | `--location=<value>` | Omitted |
| `noHeaders` | `boolean` | `--no-headers` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `vm_create`

Create a virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before create)` | Required |
| `ipv6Only` | `boolean` | `--ipv6-only` | Omitted |
| `bootImage` | `string` | `--boot-image=<value>` | Omitted |
| `initScript` | `string` | `--init-script=<value>` | Omitted |
| `privateSubnetId` | `string` | `--private-subnet-id=<value>` | Omitted |
| `size` | `string` | `--size=<value>` | Omitted |
| `storageSize` | `string` | `--storage-size=<value>` | Omitted |
| `unixUser` | `string` | `--unix-user=<value>` | Omitted |
| `publicKey` | `string` | `<publicKey>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `vm_destroy`

Destroy virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before destroy)` | Required |
| `confirm` | `string` | `--confirm=<value>` (global) | Omitted |
| `force` | `boolean` | `--force` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `vm_rename`

Rename virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before rename)` | Required |
| `name` | `string` | `<name>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `vm_restart`

Restart a virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before restart)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `vm_scp`

Copy files to or from virtual machine using `scp`. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before scp)` | Required |
| `ipv4` | `boolean` | `--ip4 (before scp)` | Omitted |
| `ipv6` | `boolean` | `--ip6 (before scp)` | Omitted |
| `user` | `string` | `--user <value> (before scp)` | Omitted |
| `source` | `string` | `<source>` | Required |
| `destination` | `string` | `<destination>` | Required |
| `clientArguments` | `string (CSV)` | `<clientArguments>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `vm_serial_log`

Show a virtual machine's serial console log, fetching it if needed. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before serial-log)` | Required |
| `refresh` | `boolean` | `--refresh` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `vm_set_maintenance_window`

Set the maintenance window for a virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before set-maintenance-window)` | Required |
| `startHour` | `integer` | `<startHour>` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `vm_sftp`

Copy files to or from virtual machine using `sftp`. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before sftp)` | Required |
| `ipv4` | `boolean` | `--ip4 (before sftp)` | Omitted |
| `ipv6` | `boolean` | `--ip6 (before sftp)` | Omitted |
| `user` | `string` | `--user <value> (before sftp)` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `vm_show`

Show details for a virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before show)` | Required |
| `fields` | `string (CSV)` | `--fields=<comma-separated values>` | Omitted |
| `ruleFields` | `string (CSV)` | `--rule-fields=<comma-separated values>` | Omitted |
| `firewallFields` | `string (CSV)` | `--firewall-fields=<comma-separated values>` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `vm_ssh`

Connect to a virtual machine using `ssh`. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before ssh)` | Required |
| `ipv4` | `boolean` | `--ip4 (before ssh)` | Omitted |
| `ipv6` | `boolean` | `--ip6 (before ssh)` | Omitted |
| `user` | `string` | `--user <value> (before ssh)` | Omitted |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `vm_start`

Start a virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before start)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |

## `vm_stop`

Stop a virtual machine. Requires a nonempty UBI_TOKEN environment variable, including help and version.

| Field | Type | CLI argument | Default / required |
| --- | --- | --- | --- |
| `resource` | `string` | `<resource> (before stop)` | Required |
| `arguments` | `string (CSV)` | `<arguments>` | Omitted |
