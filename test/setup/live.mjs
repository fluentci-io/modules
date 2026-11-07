// Opt-in upstream smoke tests. Everything is installed under a temporary HOME;
// Nix installers are excluded because they require system-wide changes.
import test from "node:test";
import assert from "node:assert/strict";
import { createRequire } from "node:module";
import { fileURLToPath } from "node:url";
import { mkdtempSync, mkdirSync, rmSync } from "node:fs";
import { join } from "node:path";
import { tmpdir } from "node:os";
import { spawnSync } from "node:child_process";
import { fixture, versions } from "./host.mjs";

export function runLive(tool, bundle) {
  if (process.env.FLUENTCI_SETUP_LIVE !== "1" || ["nix", "determinate-nix"].includes(tool)) return;
  const { setup } = createRequire(import.meta.url)(fileURLToPath(bundle));
  const supported = ["linux", "darwin"].includes(process.platform);
  const erl = tool !== "elixir" || spawnSync("which", ["erl"]).status === 0;
  test(`${tool}: installs and executes the actual upstream release`, { skip: !supported || !erl }, () => {
    const root = mkdtempSync(join(tmpdir(), "fluentci-setup-live-"));
    try {
      const home = join(root, "home");
      mkdirSync(home);
      const input = { version: tool === "java" ? "21" : tool === "elixir" ? (process.env.FLUENTCI_SETUP_ELIXIR_VERSION ?? "latest") : versions[tool], installDir: join(root, "runtime") };
      const f = fixture(tool, { input, os: process.platform === "darwin" ? "macos" : "linux", arch: process.arch === "arm64" ? "aarch64" : "x86_64",
        native: true, network: true, env: { HOME: home, TMPDIR: root, PATH: process.env.PATH } });
      setup();
      const result = JSON.parse(f.output[0]);
      assert.equal(result.tool, tool);
      assert.match(result.version, /^[0-9]+\./);
    } finally { rmSync(root, { recursive: true, force: true }); }
  });
}
