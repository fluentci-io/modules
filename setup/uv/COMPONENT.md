# setup-uv component functions

Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `setup`

Install and verify uv, optionally configure a Python version and isolated tools, and publish their environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `version` | `string` | no | Tool release or supported channel to install; omitted values use the documented default. |
| `install-dir` | `string` | no | Absolute per-user installation prefix; omit for native package installations. |
| `package-name` | `string` | no | Native package or port selector overriding the default repository package name. |
| `sudo` | `boolean` | no | Use noninteractive sudo for native package or system installation; defaults to false. |
| `python-version` | `string` | no | Optional Python release or interpreter selector such as 3.13 or cpython-3.13.1; omit to retain uv-only setup. BSD selects an existing matching interpreter without downloads. |
| `tools` | `string` | no | Comma-separated Python CLI packages with optional single native version constraints, such as ruff==0.12.0,httpie. Blank or omitted values install no tools. |

Returns `Contract.SetupResult`.
