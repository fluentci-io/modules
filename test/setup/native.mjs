import test from "node:test";
import assert from "node:assert/strict";
import { createRequire } from "node:module";
import { fileURLToPath } from "node:url";
import { spawnSync } from "node:child_process";
import { mkdtempSync, mkdirSync, writeFileSync, chmodSync, rmSync, existsSync } from "node:fs";
import { join } from "node:path";
import { tmpdir } from "node:os";
import { fixture, versions, versionText } from "./host.mjs";
import { createHash } from "node:crypto";
import { readFileSync } from "node:fs";

function command(program, args, cwd) {
  const result = spawnSync(program, args, { cwd, encoding: "utf8" });
  assert.equal(result.status, 0, `${program}: ${result.stderr}`);
}
function executable(path, text, stderr = false) {
  mkdirSync(join(path, ".."), { recursive: true });
  writeFileSync(path, `#!/bin/sh\ncat ${stderr ? ">&2 " : ""}<<'VERSION'\n${text}\nVERSION\n`);
  chmodSync(path, 0o755);
}
export function runNative(tool, bundle) {
  if (["nix", "determinate-nix"].includes(tool)) return;
  const { setup } = createRequire(import.meta.url)(fileURLToPath(bundle));
  const needed = ["tar", "which", ...(["bun", "deno", "elixir"].includes(tool) ? ["zip", "unzip"] : [])];
  const available = ["linux", "darwin"].includes(process.platform) && needed.every(name => spawnSync("which", [name]).status === 0);
  if (process.env.FLUENTCI_REQUIRE_NATIVE_TESTS === "1" && !available) throw new Error(`${tool}: native setup test tools are missing`);
  test(`${tool}: real filesystem installation, verification, environment publication, and archive reuse`, { skip: !available }, () => {
    const root = mkdtempSync(join(tmpdir(), "fluentci-setup-native-"));
    try {
      const os = process.platform === "darwin" ? "macos" : "linux";
      const arch = process.arch === "arm64" ? "aarch64" : "x86_64";
      const payload = join(root, "contents");
      const artifact = join(root, ["bun", "deno", "elixir"].includes(tool) ? "artifact.zip" : "artifact.tar.gz");
      const installDir = join(root, "installed tool ' literal");
      const home = join(root, "home");
      mkdirSync(home);
      mkdirSync(payload);
      let relative, layout;
      if (tool === "rust") {
        const source = join(root, "rustc");
        executable(source, versionText("rust"));
        writeFileSync(artifact, `#!/bin/sh\nset -eu\nmkdir -p "$CARGO_HOME/bin" "$RUSTUP_HOME"\ncp '${source}' "$CARGO_HOME/bin/rustc"\ncp '${source}' "$CARGO_HOME/bin/cargo"\n`);
      } else {
        if (tool === "bun") {
          layout = `bun-${os === "macos" ? "darwin" : "linux"}-${arch === "aarch64" ? "aarch64" : "x64"}`;
          relative = layout + "/bun";
        } else if (tool === "deno") relative = "deno";
        else if (tool === "elixir") relative = "bin/elixir";
        else if (tool === "gleam") relative = "gleam";
        else if (tool === "java") relative = "release/" + (os === "macos" ? "Contents/Home/" : "") + "bin/java";
        else if (tool === "zig") relative = "release/zig";
        else relative = "release/bin/" + tool;
        executable(join(payload, relative), versionText(tool), tool === "java");
        if (["bun", "deno", "elixir"].includes(tool)) command("zip", ["-qr", artifact, "."], payload);
        else command("tar", ["-czf", artifact, "-C", payload, "."], root);
        // tar-root strips a single top-level component; avoid a leading ./ entry.
        if (!["bun", "deno", "elixir", "gleam"].includes(tool)) command("tar", ["-czf", artifact, "-C", payload, "release"], root);
      }
      const config = { version: tool === "java" ? "21" : versions[tool], installDir: installDir + "/" };
      const options = { input: config, os, arch, artifact, native: true, fakeErlang: tool === "elixir", env: { HOME: home, TMPDIR: root } };
      if (tool === "zig") options.digest = createHash("sha256").update(readFileSync(artifact)).digest("hex");
      const f = fixture(tool, options);
      setup();
      const result = JSON.parse(f.output[0]);
      assert.equal(result.version, versions[tool]);
      assert.ok(existsSync(result.binDir));
      if (tool === "bun") assert.ok(existsSync(join(result.binDir, "bunx")));
      assert.equal(f.environment.PATH, result.environment.PATH);
      assert.ok(f.calls.some(args => args[0] === "rm"));
      if (tool !== "rust") {
        const again = fixture(tool, options);
        setup();
        assert.equal(again.calls.some(args => args[0] === "curl" && args.includes("--output")), false);
      }
    } finally { rmSync(root, { recursive: true, force: true }); }
  });
}
