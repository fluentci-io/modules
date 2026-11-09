# Xata CLI command coverage

Reviewed upstream source: [src/app.ts](https://github.com/xataio/cli/blob/12634d3bee4d1872cd6ec226fccd8b24cccdb339/src/app.ts).

Each group function forwards every nested command and native flag through its CSV `arguments` string.
`run` provides root-level access to aliases, global flags, and features added by newer CLI versions.

| Native root command | Component function |
| --- | --- |
| `skill` | `skill` |
| `init` | `init` |
| `onboard` | `onboard` |
| `auth` | `auth` |
| `organization` | `organization` |
| `project` | `project` |
| `branch` | `branch` |
| `keys` | `keys` |
| `roll` | `roll` |
| `clone` | `clone` |
| `stream` | `stream` |
| `status` | `status` |
| `version` | `version` |
| `licenses` | `licenses` |
| `checkout` | `checkout` |
| `scratch` | `scratch` |
| `console` | `console` |
| `upgrade` | `upgrade` |
| `completions` | `completions` |

Named pipeline helpers are listed in [COMPONENT.md](./COMPONENT.md).
