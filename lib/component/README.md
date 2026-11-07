# Native component build and contracts

The repository’s PureScript components share this build toolchain and the
`CI.Contract` support library. Install the pinned tools with
`bun install --cwd lib/component --frozen-lockfile` from the repository root.

`buildModule` compiles fresh PureScript docs/CoreFn and invokes the pinned
FluentCI v0.17.2 inspector with ComponentizeJS. `records.mjs` derives native WIT
record returns from actual compiler types, including nested list records.
Public function comments supply argument descriptions. Unsupported types fail.
The flat input codec avoids deeply recursive Argonaut row dictionaries while
preserving concrete PureScript source signatures and the native WIT boundary.

See [the migration guide](../../docs/COMPONENTS.md). The module support code is
MIT; vendored inspection tooling and runtime WIT preserve the upstream MPL-2.0
license and provenance in their subdirectories.
