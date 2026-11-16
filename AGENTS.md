# Public list arguments

- All new or updated public module list arguments must accept comma-separated
  strings, such as `--components rustfmt,clippy` or `--packages git,cmake`.
- Do not require JSON array brackets (`[]`) for list arguments in CLI calls,
  public typed contracts, schemas, help, or documentation examples.
- Trim whitespace around entries and validate each value before host commands.
  Preserve documented behavior for omitted or blank optional lists; reject empty
  entries between commas and malformed values.
- Decode to internal arrays when needed, and pass values as literal native
  command arguments. Keep generated contracts, docs, and regression tests aligned.

# Local execution

- Do not run builds, tests, FluentCI plugins, installers, or VMs locally unless
  the user explicitly authorizes it. Leave runtime verification to CI.

# Module registry and generated documentation

- When adding, removing, or renaming a module, update
  `docs/PIPELINE_AUDIT.md` in the same change. Keep its module count, registry
  order, paths, and public function inventory aligned with `fluentci.toml` and
  the module's exports.
- Include all affected generated files, dependency locks, catalogs, and README
  inventories in the change; do not leave regeneration drift for CI to discover.
- Respect the local execution restriction above. When generators cannot be run,
  mirror their output with static edits and inspect consistency; leave generator
  checks and runtime verification to CI.
