# Ubicloud command coverage

All 123 executable upstream commands at [`cb7a521f29f8`](https://github.com/ubicloud/ubicloud/tree/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands) have named functions. The `run` export provides literal CSV access to server extensions. Group-only command routers are accessed through `help`; they are not executable resource operations.

**UBI_TOKEN is required for every command, including help and version.**

| Function | Native command prefix | Upstream definition |
| --- | --- | --- |
| `ai-api-key-create` | `ubi ai api-key create` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/ai/api-key/create.rb) |
| `ai-api-key-list` | `ubi ai api-key list` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/ai/api-key/list.rb) |
| `ai-api-key-destroy` | `ubi ai api-key <resource> destroy` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/ai/api-key/post/destroy.rb) |
| `ai-api-key-show` | `ubi ai api-key <resource> show` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/ai/api-key/post/show.rb) |
| `ai-endpoint-list` | `ubi ai endpoint list` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/ai/endpoint/list.rb) |
| `al-search` | `ubi al search` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/al/search.rb) |
| `fw-list` | `ubi fw list` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/fw/list.rb) |
| `fw-add-rule` | `ubi fw <resource> add-rule` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/fw/post/add-rule.rb) |
| `fw-attach-subnet` | `ubi fw <resource> attach-subnet` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/fw/post/attach-subnet.rb) |
| `fw-create` | `ubi fw <resource> create` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/fw/post/create.rb) |
| `fw-delete-rule` | `ubi fw <resource> delete-rule` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/fw/post/delete-rule.rb) |
| `fw-destroy` | `ubi fw <resource> destroy` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/fw/post/destroy.rb) |
| `fw-detach-subnet` | `ubi fw <resource> detach-subnet` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/fw/post/detach-subnet.rb) |
| `fw-modify-rule` | `ubi fw <resource> modify-rule` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/fw/post/modify-rule.rb) |
| `fw-rename` | `ubi fw <resource> rename` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/fw/post/rename.rb) |
| `fw-show` | `ubi fw <resource> show` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/fw/post/show.rb) |
| `fw-update-description` | `ubi fw <resource> update-description` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/fw/post/update-description.rb) |
| `gh-installation-list` | `ubi gh installation list` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/gh/installation/list.rb) |
| `gh-installation-list-repositories` | `ubi gh installation <resource> list-repositories` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/gh/installation/post/list-repositories.rb) |
| `gh-list-cache-entries` | `ubi gh <resource> list-cache-entries` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/gh/post/list-cache-entries.rb) |
| `gh-remove-all-cache-entries` | `ubi gh <resource> remove-all-cache-entries` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/gh/post/remove-all-cache-entries.rb) |
| `gh-remove-cache-entry` | `ubi gh <resource> remove-cache-entry` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/gh/post/remove-cache-entry.rb) |
| `help` | `ubi help` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/help.rb) |
| `kc-list` | `ubi kc list` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/kc/list.rb) |
| `kc-create-nodepool` | `ubi kc <resource> create-nodepool` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/kc/post/create-nodepool.rb) |
| `kc-create` | `ubi kc <resource> create` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/kc/post/create.rb) |
| `kc-destroy-nodepool` | `ubi kc <resource> destroy-nodepool` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/kc/post/destroy-nodepool.rb) |
| `kc-destroy` | `ubi kc <resource> destroy` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/kc/post/destroy.rb) |
| `kc-kubeconfig` | `ubi kc <resource> kubeconfig` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/kc/post/kubeconfig.rb) |
| `kc-rename` | `ubi kc <resource> rename` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/kc/post/rename.rb) |
| `kc-resize-nodepool` | `ubi kc <resource> resize-nodepool` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/kc/post/resize-nodepool.rb) |
| `kc-retire-node` | `ubi kc <resource> retire-node` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/kc/post/retire-node.rb) |
| `kc-show` | `ubi kc <resource> show` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/kc/post/show.rb) |
| `kc-upgrade-nodepool` | `ubi kc <resource> upgrade-nodepool` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/kc/post/upgrade-nodepool.rb) |
| `kc-upgrade` | `ubi kc <resource> upgrade` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/kc/post/upgrade.rb) |
| `lb-list` | `ubi lb list` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/lb/list.rb) |
| `lb-attach-vm` | `ubi lb <resource> attach-vm` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/lb/post/attach-vm.rb) |
| `lb-create` | `ubi lb <resource> create` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/lb/post/create.rb) |
| `lb-destroy` | `ubi lb <resource> destroy` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/lb/post/destroy.rb) |
| `lb-detach-vm` | `ubi lb <resource> detach-vm` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/lb/post/detach-vm.rb) |
| `lb-disable-ssl-certificate` | `ubi lb <resource> disable-ssl-certificate` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/lb/post/disable-ssl-certificate.rb) |
| `lb-enable-ssl-certificate` | `ubi lb <resource> enable-ssl-certificate` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/lb/post/enable-ssl-certificate.rb) |
| `lb-rename` | `ubi lb <resource> rename` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/lb/post/rename.rb) |
| `lb-show` | `ubi lb <resource> show` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/lb/post/show.rb) |
| `lb-update` | `ubi lb <resource> update` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/lb/post/update.rb) |
| `mi-list` | `ubi mi list` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/mi/list.rb) |
| `mi-create-version` | `ubi mi <resource> create-version` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/mi/post/create-version.rb) |
| `mi-create` | `ubi mi <resource> create` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/mi/post/create.rb) |
| `mi-destroy-version` | `ubi mi <resource> destroy-version` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/mi/post/destroy-version.rb) |
| `mi-destroy` | `ubi mi <resource> destroy` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/mi/post/destroy.rb) |
| `mi-list-versions` | `ubi mi <resource> list-versions` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/mi/post/list-versions.rb) |
| `mi-rename` | `ubi mi <resource> rename` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/mi/post/rename.rb) |
| `mi-set-latest` | `ubi mi <resource> set-latest` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/mi/post/set-latest.rb) |
| `mi-show` | `ubi mi <resource> show` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/mi/post/show.rb) |
| `pg-list` | `ubi pg list` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/list.rb) |
| `pg-add-bearer-metric-destination` | `ubi pg <resource> add-bearer-metric-destination` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/add-bearer-metric-destination.rb) |
| `pg-add-cert-auth-user` | `ubi pg <resource> add-cert-auth-user` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/add-cert-auth-user.rb) |
| `pg-add-config-entries` | `ubi pg <resource> add-config-entries` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/add-config-entries.rb) |
| `pg-add-firewall-rule` | `ubi pg <resource> add-firewall-rule` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/add-firewall-rule.rb) |
| `pg-add-metric-destination` | `ubi pg <resource> add-metric-destination` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/add-metric-destination.rb) |
| `pg-add-otlp-log-destination` | `ubi pg <resource> add-otlp-log-destination` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/add-otlp-log-destination.rb) |
| `pg-add-pgbouncer-config-entries` | `ubi pg <resource> add-pgbouncer-config-entries` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/add-pgbouncer-config-entries.rb) |
| `pg-add-syslog-log-destination` | `ubi pg <resource> add-syslog-log-destination` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/add-syslog-log-destination.rb) |
| `pg-ca-certificates` | `ubi pg <resource> ca-certificates` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/ca-certificates.rb) |
| `pg-create-backup-credentials` | `ubi pg <resource> create-backup-credentials` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/create-backup-credentials.rb) |
| `pg-create-client-cert-keypair` | `ubi pg <resource> create-client-cert-keypair` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/create-client-cert-keypair.rb) |
| `pg-create-read-replica` | `ubi pg <resource> create-read-replica` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/create-read-replica.rb) |
| `pg-create` | `ubi pg <resource> create` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/create.rb) |
| `pg-delete-firewall-rule` | `ubi pg <resource> delete-firewall-rule` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/delete-firewall-rule.rb) |
| `pg-delete-log-destination` | `ubi pg <resource> delete-log-destination` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/delete-log-destination.rb) |
| `pg-delete-metric-destination` | `ubi pg <resource> delete-metric-destination` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/delete-metric-destination.rb) |
| `pg-destroy` | `ubi pg <resource> destroy` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/destroy.rb) |
| `pg-get-logs` | `ubi pg <resource> get-logs` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/get-logs.rb) |
| `pg-list-backups` | `ubi pg <resource> list-backups` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/list-backups.rb) |
| `pg-list-servers` | `ubi pg <resource> list-servers` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/list-servers.rb) |
| `pg-modify-firewall-rule` | `ubi pg <resource> modify-firewall-rule` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/modify-firewall-rule.rb) |
| `pg-modify` | `ubi pg <resource> modify` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/modify.rb) |
| `pg-pg-dump` | `ubi pg <resource> pg_dump` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/pg_dump.rb) |
| `pg-pg-dumpall` | `ubi pg <resource> pg_dumpall` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/pg_dumpall.rb) |
| `pg-promote-read-replica` | `ubi pg <resource> promote-read-replica` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/promote-read-replica.rb) |
| `pg-psql` | `ubi pg <resource> psql` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/psql.rb) |
| `pg-recycle` | `ubi pg <resource> recycle` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/recycle.rb) |
| `pg-remove-cert-auth-user` | `ubi pg <resource> remove-cert-auth-user` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/remove-cert-auth-user.rb) |
| `pg-remove-config-entries` | `ubi pg <resource> remove-config-entries` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/remove-config-entries.rb) |
| `pg-remove-pgbouncer-config-entries` | `ubi pg <resource> remove-pgbouncer-config-entries` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/remove-pgbouncer-config-entries.rb) |
| `pg-rename` | `ubi pg <resource> rename` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/rename.rb) |
| `pg-reset-superuser-password` | `ubi pg <resource> reset-superuser-password` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/reset-superuser-password.rb) |
| `pg-restart` | `ubi pg <resource> restart` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/restart.rb) |
| `pg-restore` | `ubi pg <resource> restore` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/restore.rb) |
| `pg-set-maintenance-window` | `ubi pg <resource> set-maintenance-window` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/set-maintenance-window.rb) |
| `pg-show-config` | `ubi pg <resource> show-config` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/show-config.rb) |
| `pg-show-default-config` | `ubi pg <resource> show-default-config` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/show-default-config.rb) |
| `pg-show-pgbouncer-config` | `ubi pg <resource> show-pgbouncer-config` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/show-pgbouncer-config.rb) |
| `pg-show-upgrade-status` | `ubi pg <resource> show-upgrade-status` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/show-upgrade-status.rb) |
| `pg-show` | `ubi pg <resource> show` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/show.rb) |
| `pg-upgrade` | `ubi pg <resource> upgrade` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/pg/post/upgrade.rb) |
| `ps-list` | `ubi ps list` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/ps/list.rb) |
| `ps-connect` | `ubi ps <resource> connect` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/ps/post/connect.rb) |
| `ps-create` | `ubi ps <resource> create` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/ps/post/create.rb) |
| `ps-destroy` | `ubi ps <resource> destroy` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/ps/post/destroy.rb) |
| `ps-disconnect` | `ubi ps <resource> disconnect` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/ps/post/disconnect.rb) |
| `ps-rename` | `ubi ps <resource> rename` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/ps/post/rename.rb) |
| `ps-show` | `ubi ps <resource> show` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/ps/post/show.rb) |
| `sk-list` | `ubi sk list` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/sk/list.rb) |
| `sk-create` | `ubi sk <resource> create` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/sk/post/create.rb) |
| `sk-destroy` | `ubi sk <resource> destroy` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/sk/post/destroy.rb) |
| `sk-rename` | `ubi sk <resource> rename` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/sk/post/rename.rb) |
| `sk-show` | `ubi sk <resource> show` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/sk/post/show.rb) |
| `sk-update` | `ubi sk <resource> update` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/sk/post/update.rb) |
| `version` | `ubi version` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/version.rb) |
| `vm-list` | `ubi vm list` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/vm/list.rb) |
| `vm-create` | `ubi vm <resource> create` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/vm/post/create.rb) |
| `vm-destroy` | `ubi vm <resource> destroy` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/vm/post/destroy.rb) |
| `vm-rename` | `ubi vm <resource> rename` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/vm/post/rename.rb) |
| `vm-restart` | `ubi vm <resource> restart` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/vm/post/restart.rb) |
| `vm-scp` | `ubi vm <resource> scp` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/vm/post/scp.rb) |
| `vm-serial-log` | `ubi vm <resource> serial-log` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/vm/post/serial-log.rb) |
| `vm-set-maintenance-window` | `ubi vm <resource> set-maintenance-window` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/vm/post/set-maintenance-window.rb) |
| `vm-sftp` | `ubi vm <resource> sftp` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/vm/post/sftp.rb) |
| `vm-show` | `ubi vm <resource> show` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/vm/post/show.rb) |
| `vm-ssh` | `ubi vm <resource> ssh` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/vm/post/ssh.rb) |
| `vm-start` | `ubi vm <resource> start` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/vm/post/start.rb) |
| `vm-stop` | `ubi vm <resource> stop` | [source](https://github.com/ubicloud/ubicloud/blob/cb7a521f29f81cc66bd4112d67fff3f33cad33bc/cli-commands/vm/post/stop.rb) |

Named arguments, including operands after these prefixes, are detailed in [COMPONENT.md](./COMPONENT.md) and [OPTIONS.md](./OPTIONS.md). API responses and native client behavior remain upstream-defined.
