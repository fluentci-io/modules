# Flipt

Typed PureScript WebAssembly component for Flipt v2 feature-flag pipeline operations.
Requires FluentCI v0.17.3+.

```sh
fluentci run flipt setup --version latest
fluentci run flipt validate --run-dir /tmp/flipt-validate-001 --work-dir flags --files features.yaml --format json
fluentci run flipt evaluate --run-dir /tmp/flipt-evaluate-001 --flag-key checkout --address http://localhost:8080 --entity-id ci --context tier=enterprise,region=eu
fluentci run flipt migrate --run-dir /tmp/flipt-migrate-001 --config flipt.yml
fluentci run flipt license-check --run-dir /tmp/flipt-license-001 --config flipt.yml
fluentci run flipt run --run-dir /tmp/flipt-help-001 --arguments server,--help
```

Every operation checks setup first, including explicit executable overrides. Usable
installed tools skip installation; missing tools use the typed
[setup-flipt](../../setup/flipt/README.md) dependency and are checked again before execution.
The exported setup function forwards version/install-dir/package-name/sudo options,
returns tool, version, bin-dir and environment, and verifies explicit versions.
Official per-user installs use version/install-dir; omit package-name and sudo.
Linux/macOS x86_64/aarch64 are supported; other hosts fail before installation.

Validation fails on findings by default and accepts only positive issue-exit-code
values. Evaluation runs once, never implicitly entering watch mode. A successfully
returned flag value is an evaluation result, not an assertion that the flag is enabled;
inspect the execution stdout when making a deployment decision. Migrate runs v2
analytics database migrations and can change its configured database.
Server configuration and inherited environment supply the native server settings.
The evaluate CLI's authenticated mode requires its native token option; it is
available through extra-args/run, whose argument values are recorded in reports.
Do not put sensitive credentials in these recorded argument fields.

All lists use comma-separated strings, with whitespace trimmed and empty entries
rejected before setup. CSV double quotes preserve commas inside one token.
No public argument requires a JSON object or array. Tokens are passed literally,
without shell expansion. Blank optional lists retain the native defaults.

The typed exports target the [current v2 CLI](https://docs.flipt.io/v2/cli/overview).
Flipt v1-only import/export and bundle commands remain available through run when
an explicit v1 release is installed. Interactive configuration/license wizards
and foreground server lifecycle commands are intentionally available through run,
rather than being silently invoked during setup.

Each invocation needs a fresh run-dir. The return contains outcome, run-dir and
report/log paths. Native failures, setup errors, timeout and transport failures
propagate. See [COMPONENT.md](./COMPONENT.md) for every typed argument and return and
[OPTIONS.md](./OPTIONS.md) for native flag mappings. Function and argument descriptions
are derived from the PureScript source and embedded in the Wasm component.

CI runs the mocked installer, typed argument, setup dependency, and command-plan
regression suites. License: MIT.
