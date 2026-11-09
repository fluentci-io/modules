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
