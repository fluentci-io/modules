# setup-android component functions

Requires FluentCI v0.17.3 or newer. The compiler derives native WIT signatures
and embedded help from these typed PureScript functions. Optional arguments may be omitted.

## `setup`

Install Java (21 by default) through setup-java, verify Android command-line tools, install selected SDK packages, and publish their environment.

| Argument | Type | Required | Description |
| --- | --- | --- | --- |
| `version` | `string` | no | Pinned Google command-line tools archive build ID; nondefault builds require archiveUrl and archiveSha256. Default: "15859902". |
| `java-version` | `string` | no | Java release or supported selector forwarded to the typed setup-java dependency; defaults to Java 21. Default: "21". |
| `sdk-root` | `string` | no | Absolute SDK root; defaults to a per-user directory keyed by the command-line tools build. |
| `packages` | `string` | no | Comma-separated native Android SDK package IDs, such as platform-tools,platforms;android-36,build-tools;36.0.0. Blank installs no packages through this field. Default: "platform-tools". |
| `api-levels` | `string` | no | Comma-separated API levels or preview names; installs platforms;android-VALUE for each entry. |
| `build-tools-versions` | `string` | no | Comma-separated Android build-tools revisions to install and add to PATH. |
| `ndk-versions` | `string` | no | Comma-separated side-by-side NDK revisions to install; ANDROID_NDK_HOME selects the first. |
| `cmake-versions` | `string` | no | Comma-separated SDK CMake revisions to install and add to PATH. |
| `system-images` | `string` | no | Comma-separated complete system-image package IDs; no emulator or virtual device is started. |
| `package-file` | `string` | no | Existing file of newline-separated SDK package IDs, passed to sdkmanager. |
| `channel` | `integer` | no | Highest SDK repository channel to include: 0 stable, 1 beta, 2 dev, or 3 canary. Default: 0. |
| `accept-licenses` | `boolean` | no | Accept SDK licenses noninteractively. False uses existing licenses and closed stdin; missing licenses fail installation. Default: true. |
| `proxy-type` | `string` | no | SDK proxy protocol: http or socks; requires proxyHost and proxyPort. |
| `proxy-host` | `string` | no | SDK repository proxy hostname or IP address. |
| `proxy-port` | `integer` | no | SDK proxy port from 1 to 65535 when a proxy is enabled. |
| `sdk-manager-args` | `string` | no | Additional literal sdkmanager option/value tokens as comma-separated text; cannot change the managed operation or SDK root. |
| `archive-url` | `string` | no | Optional HTTPS command-line tools ZIP URL for mirrors or alternate builds; requires archiveSha256. |
| `archive-sha256` | `string` | no | Lowercase SHA-256 of the alternate ZIP. Default Google downloads use pinned platform checksums. |

Returns `{ tool :: String, version :: String, binDir :: String, environment :: Array Contract.Variable, sdkRoot :: String, javaVersion :: String, commandLineToolsBuild :: String }`.
