import ci/common as c
import ci/data as d
import ci/files as f
import ci/native
import gleam/bit_array
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import gleam/uri

pub fn https(value: String) -> Result(Nil, String) {
  use parsed <- result.try(
    uri.parse(value) |> result.map_error(fn(_) { "Invalid HTTPS URL" }),
  )
  use _ <- result.try(c.require(
    string.starts_with(value, "https://")
      && parsed.userinfo == None
      && !string.contains(value, "\n")
      && !string.contains(value, "\r"),
    "Downloads require HTTPS without credentials",
  ))
  c.require(
    case parsed.host {
      Some(host) -> host != ""
      None -> False
    },
    "Download URL has no host",
  )
}

pub fn verified(
  url: String,
  digest: String,
  destination: String,
) -> Result(String, String) {
  verified_with_fetch(url, digest, destination, fn(temporary) {
    c.stream(
      "curl",
      [
        "--fail",
        "--location",
        "--silent",
        "--show-error",
        "--proto",
        "=https",
        "--proto-redir",
        "=https",
        "--retry",
        "3",
        "--max-time",
        "120",
        "--max-filesize",
        "134217728",
        "--output",
        temporary,
        url,
      ],
      native.cwd(),
    )
  })
}

pub fn verified_with_fetch(
  url: String,
  digest: String,
  destination: String,
  fetch: fn(String) -> Result(Nil, String),
) -> Result(String, String) {
  use _ <- result.try(https(url))
  use _ <- result.try(c.require(
    string.length(digest) == 64 && c.ascii(digest, "0123456789abcdef"),
    "Missing SHA-256",
  ))
  case c.file_hash(destination) == Ok(digest) {
    True -> Ok(destination)
    False -> {
      use _ <- result.try(native.mkdir(f.parent(destination)))
      let temporary = destination <> "." <> native.nonce()
      let downloaded = {
        use _ <- result.try(fetch(temporary))
        use _ <- result.try(c.require(
          native.size(temporary) <= 134_217_728,
          "Setup artifact exceeds the download size limit",
        ))
        use actual <- result.try(c.file_hash(temporary))
        use _ <- result.try(c.require(
          actual == digest,
          "SHA-256 mismatch: " <> url,
        ))
        native.rename(temporary, destination)
      }
      let _ = native.remove(temporary)
      use _ <- result.try(downloaded)
      Ok(destination)
    }
  }
}

pub fn host() -> Result(String, String) {
  let os = case native.platform() {
    "darwin" -> "macos"
    "linux" -> "linux"
    other -> other
  }
  use arch <- result.try(
    case
      string.starts_with(native.architecture(), "aarch64")
      || string.starts_with(native.architecture(), "arm64")
    {
      True -> Ok("aarch64")
      False ->
        case
          string.starts_with(native.architecture(), "x86_64")
          || string.starts_with(native.architecture(), "amd64")
        {
          True -> Ok("x86_64")
          False ->
            Error("Unsupported CI architecture: " <> native.architecture())
        }
    },
  )
  use _ <- result.try(c.require(
    list.contains(["linux", "macos"], os),
    "CI supports Linux/macOS",
  ))
  Ok(os <> "-" <> arch)
}

pub fn cli(config: d.Value, cache: String) -> Result(String, String) {
  use target <- result.try(host())
  let asset = d.get(d.get(config, "assets"), target)
  let directory = cache <> "/cli/" <> d.s(config, "version")
  use archive <- result.try(verified(
    d.s(asset, "url"),
    d.s(asset, "sha256"),
    directory <> "/release.tar.gz",
  ))
  use entries <- result.try(native.archive_entries(archive))
  let binaries =
    list.filter(entries, fn(entry) {
      entry.1 == "regular"
      && list.last(string.split(entry.0, "/")) == Ok("fluentci")
    })
  use name <- result.try(case binaries {
    [entry] -> Ok(entry.0)
    _ -> Error("CLI archive must contain exactly one regular fluentci binary")
  })
  use bytes <- result.try(native.archive_member(archive, name))
  let binary = directory <> "/bin/fluentci"
  use _ <- result.try(native.mkdir(directory <> "/bin"))
  use _ <- result.try(native.write(binary, bytes))
  use _ <- result.try(native.chmod(binary, 493))
  Ok(binary)
}

pub fn package(
  registry: d.Value,
  definition: d.Value,
) -> Result(d.Value, String) {
  let url =
    d.s(registry, "url")
    <> "/xrpc/io.fluentci.registry.getPackage?author="
    <> uri.percent_encode(d.s(registry, "publisher"))
    <> "&name="
    <> uri.percent_encode(d.s(definition, "name"))
    <> "&version="
    <> uri.percent_encode(d.s(definition, "version"))
  use _ <- result.try(https(url))
  use response <- result.try(c.run(
    "curl",
    [
      "--fail",
      "--location",
      "--silent",
      "--show-error",
      "--proto",
      "=https",
      "--proto-redir",
      "=https",
      "--max-time",
      "60",
      "--max-filesize",
      "2097152",
      url,
    ],
    native.cwd(),
  ))
  use json <- result.try(d.parse(response))
  let package = d.get(json, "package")
  use _ <- result.try(validate_package(registry, definition, package))
  Ok(package)
}

pub fn artifact(
  registry: d.Value,
  definition: d.Value,
  cache: String,
) -> Result(String, String) {
  use package <- result.try(package(registry, definition))
  use path <- result.try(verified(
    d.s(package, "url"),
    d.s(package, "sha256"),
    cache <> "/components/" <> d.s(package, "sha256") <> ".wasm",
  ))
  use bytes <- result.try(native.read(path))
  c.require(
    bit_array.byte_size(bytes) <= 67_108_864
      && bit_array.slice(bytes, 0, 8) == Ok(<<0, 97, 115, 109, 13, 0, 1, 0>>),
    "Expected a native Wasm component",
  )
  |> result.map(fn(_) { path })
}

pub fn validate_package(
  registry: d.Value,
  definition: d.Value,
  package: d.Value,
) -> Result(Nil, String) {
  use _ <- result.try(c.require(
    d.s(package, "name") == d.s(definition, "name")
      && d.s(package, "version") == d.s(definition, "version")
      && d.s(package, "author") == d.s(registry, "publisherDid"),
    "Registry publisher/name/version mismatch",
  ))
  use _ <- result.try(https(d.s(package, "url")))
  c.require(
    string.length(d.s(package, "sha256")) == 64
      && c.ascii(d.s(package, "sha256"), "0123456789abcdef"),
    "Registry did not return a valid artifact checksum",
  )
}
