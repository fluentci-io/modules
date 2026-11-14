import ci/common as c
import ci/data as d
import ci/download
import ci/files as f
import ci/native
import gleam/list
import gleam/result
import gleam/string

pub fn run(
  root: String,
  directory: String,
  names: List(String),
) -> Result(Nil, String) {
  use records <- result.try(f.json(root <> "/test/cli/security-tools.json"))
  use host <- result.try(download.host())
  let target =
    host
    |> string.replace("macos", "darwin")
    |> string.replace("x86_64", "amd64")
    |> string.replace("aarch64", "arm64")
  use _ <- result.try(native.mkdir(directory))
  c.all(names, fn(name) {
    use _ <- result.try(c.require(
      list.contains(["betterleaks", "gitleaks", "syft"], name),
      "Unknown security fixture tool",
    ))
    let release = d.get(records, name)
    let source = d.get(d.get(release, "platforms"), target)
    c.with_temp("fluentci-security-", fn(temp) {
      use archive <- result.try(download.verified(
        d.s(source, "url"),
        d.s(source, "sha256"),
        temp <> "/release.tar.gz",
      ))
      use entries <- result.try(native.archive_entries(archive))
      use _ <- result.try(c.require(
        list.any(entries, fn(e) { e.0 == name && e.1 == "regular" }),
        "Expected a regular binary: " <> name,
      ))
      use bytes <- result.try(native.archive_member(archive, name))
      use _ <- result.try(native.write(directory <> "/" <> name, bytes))
      use _ <- result.try(native.chmod(directory <> "/" <> name, 493))
      let _ =
        native.stdout(
          "Installed " <> name <> " " <> d.s(release, "version") <> "\n",
        )
      Ok(Nil)
    })
  })
}
