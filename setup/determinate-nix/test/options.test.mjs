import test from "node:test";
import assert from "node:assert/strict";
import { createRequire } from "node:module";
import { fixture } from "../../../test/setup/host.mjs";
const { setup } = createRequire(import.meta.url)("../dist/plugin.cjs");
test("passes trusted users and custom settings as literal installer arguments", () => {
  for (const os of ["linux", "macos"]) {
    const f = fixture("determinate-nix", { os, input: { sudo: true, trustedUsers: ["runner", "root", "runner"], extraConf: ["max-jobs = auto", "accept-flake-config = true"] } });
    setup();
    const args = f.calls.find(a => a[0] === "sudo" && a.includes("install"));
    assert.deepEqual(args.slice(-6), ["--extra-conf", "max-jobs = auto", "--extra-conf", "accept-flake-config = true", "--extra-conf", "trusted-users = root runner"]);
  }
});
test("invalid settings and wildcard trust fail before commands", () => {
  for (const input of [{ trustedUsers: ["*"] }, { trustedUsers: ["runner\nroot"] }, { extraConf: ["max-jobs = 1\ntrusted-users = *"] }, { extraConf: ["!include unknown.conf"] }]) {
    const f = fixture("determinate-nix", { input }); assert.throws(setup); assert.deepEqual(f.calls, []);
  }
});
test("existing installs reject unapplied settings", () => {
  const f = fixture("determinate-nix", { existing: true, input: { trustedUsers: ["runner"] } });
  assert.throws(setup, /already installed/);
  assert.ok(!f.calls.some(a => a[0] === "curl" && a.includes("--output")));
});
