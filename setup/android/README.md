# Setup Android

Install Java and a configurable Android SDK through a typed PureScript Wasm
component. Requires FluentCI v0.17.3+.

```sh
fluentci run setup-android setup --api-levels 36 --build-tools-versions 36.0.0
fluentci run setup-android setup --java-version 25 --sdk-root /opt/android-sdk \
  --packages 'platform-tools,emulator' --api-levels 35,36 \
  --ndk-versions 27.2.12479018 --cmake-versions 3.22.1 \
  --system-images 'system-images;android-36;google_apis;arm64-v8a'
```

## Java dependency and platforms

The module declares a local `setup-java` dependency in
[fluentci-module.toml](./fluentci-module.toml) and calls its typed component
interface. The default is Java **21**. `--java-version` is forwarded to that
module, including supported major or exact releases. Select a Java version
compatible with your chosen SDK tools; an incompatible JVM fails normally.
FluentCI composes the dependency for execution and publishing, so a published
Android component includes its Java setup dependency.

Only **Linux and macOS** are supported. Other systems fail explicitly with
`Unsupported Android SDK OS: NAME. Supported OS: linux, macos` before Java or SDK
installation. Google's pinned archives support Linux x86_64 and macOS x86_64 or
aarch64. Other architectures get a separate unsupported-architecture error.
This installs SDK packages; it does not start an emulator or create an AVD.

## Publishing

Publish from the repository checkout containing both module directories:

```sh
fluentci publish --module setup-android
```

The relative `../java` reference is resolved at build time. FluentCI validates the
actual WIT interfaces and composes Java setup into the published Wasm component.
Consumers need neither this repository nor a separate setup-java component
download; runtime JDK/SDK downloads still occur as configured. Publish the source
module through FluentCI so composition runs; the raw intermediate
`dist/plugin.wasm` from the SDK build still contains a dependency import.
Copying just `setup/android` to another repository requires updating its source
dependency to a valid local, Git, or registry source first.

## SDK customization

All public lists are comma-separated strings. Entries are trimmed and validated
before installation. Shell-quote SDK package IDs containing semicolons. No JSON
array syntax or shell expansion is used.

| Argument | Behavior |
| --- | --- |
| `sdk-root` | Absolute SDK root. Default: `$HOME/.local/share/fluentci/android-sdk/BUILD`. |
| `packages` | Native SDK package IDs, including any repository platform, tool, NDK, CMake, add-on, or image. Default: `platform-tools`; blank installs none through this field. |
| `api-levels` | Versions such as `35,36` or preview names; installs `platforms;android-VALUE`. |
| `build-tools-versions` | Revisions such as `35.0.0,36.0.0`. |
| `ndk-versions` | Side-by-side NDK revisions. The first sets `ANDROID_NDK_HOME`. |
| `cmake-versions` | SDK CMake revisions. |
| `system-images` | Full package IDs such as `system-images;android-36;google_apis;arm64-v8a`. |
| `package-file` | Existing file containing newline-separated package IDs, without quotes. |
| `channel` | `0` stable (default), `1` beta, `2` dev, or `3` canary. |
| `accept-licenses` | Default `true`: run license acceptance and installation noninteractively. False uses existing licenses and closed stdin. |
| `proxy-type`, `proxy-host`, `proxy-port` | Configure an `http` or `socks` SDK repository proxy; supply all three. |
| `sdk-manager-args` | Additional literal option/value tokens, for example `--sdk-manager-args=--verbose`. Root, package-file, and operation changes use their dedicated arguments instead. |

Named package lists are combined and deduplicated with `packages` and any package
file. Blank optional lists contribute nothing; empty entries between commas fail
before installation. `packages` exposes native SDK IDs beyond the convenience
arguments. Native package availability, host compatibility, and SDK constraints
remain enforced. After installation, every requested package must appear in
`sdkmanager --list_installed`; skipped packages or missing licenses fail setup
even if the installer returned zero.

## Command-line tools bootstrap

The default `--version 15859902` identifies the Google command-line tools archive
build, independently of Java, API levels, and package revisions. Official ZIP
URLs and SHA-256 digests are pinned for each supported platform from
[Google's download table](https://developer.android.com/studio#command-line-tools-only).
The archive is verified before extraction into `cmdline-tools/latest`, then
`sdkmanager --version` is checked. Google currently deprecates `sdkmanager` in
favor of its Android CLI; this module uses the SDK command-line-tools interface
for package setup, including versioned installations.

For a mirror or another command-line tools build, supply `--archive-url` over
HTTPS and its exact lowercase `--archive-sha256`, plus `--version` as the build's
cache identifier. Nondefault builds require both archive arguments. A managed
cached bootstrap is reused only when its archive receipt matches. An unmanaged
or differently bootstrapped `cmdline-tools/latest` is preserved and rejected;
choose another SDK root. Failed extraction removes only the destination newly
claimed by that invocation. Existing SDK packages are retained.

The host needs curl, unzip, mkdir, cp, rm, cat, sh, mktemp, and test. Noninteractive
license acceptance additionally uses bash and yes. `setup-java` supplies its own
runtime installation prerequisites. Java installation runs first and may remain
configured if later Android setup fails; the module returns and publishes Android
environment values only after complete SDK verification.

## Results and CI verification

Returns typed `tool`, `version`, `bin-dir`, `environment`, `sdk-root`,
`java-version`, and `command-line-tools-build`. `version` is the final reported
SDK manager revision; the archive build is returned separately. Environment values
include `JAVA_HOME`, `ANDROID_HOME`, `ANDROID_SDK_ROOT`, and PATH for command-line
tools, platform-tools, emulator, and explicitly named build-tools/CMake versions.
Separate processes must propagate the returned environment. No project manifest,
Gradle properties, shell startup file, or system Java default is rewritten by
this module. SDK and Java downloads can remain after failure for retry.

Fixture tests check typed dependency forwarding, native arguments, cache behavior,
checksums, unsupported platforms, package verification, and failure propagation.
The opt-in [live end-to-end test](./test/e2e.test.mjs) invokes the actual composed
component, installs Java 21 and SDK packages, runs Java/sdkmanager/adb/aapt2,
checks API/build-tools outputs, verifies a Java 25 override and cached SDK reuse,
and confirms native installation failures propagate. It runs on the existing
Linux/macOS scheduled/manual [smoke workflow](../../.github/workflows/setup-smoke.yml),
without adding runners to ordinary push checks. Standard module CI runs fixtures.

For an authorized live CI run:

```sh
npm ci
npm run build
FLUENTCI_ANDROID_E2E=1 node --test test/e2e.test.mjs
```

The build prepares the source Java component using `fluentci install --frozen-lockfile`.
It does not execute Java or SDK installers. Dependency bindings and installed
artifacts are generated and ignored; the local-source lock contains no fabricated
remote checksums. Published artifacts are composed by FluentCI from actual WIT
interfaces. Test-only dependency bridges are used solely by regression bundles.

[COMPONENT.md](./COMPONENT.md) documents every named argument and return type.
[SDK manager reference](https://developer.android.com/tools/sdkmanager) ·
[MIT wrapper license](./LICENSE). Google SDK packages retain their own licenses.
