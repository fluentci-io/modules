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

// Exercise the public typed component, whose list inputs must be CSV strings.
async function typedSetup() {
  const native = await import("../output/CI.Component/index.js");
  const { Just, Nothing } = await import("../output/Data.Maybe/index.js");
  return values => native.setup({
    version: Nothing.value, installDir: Nothing.value, packageName: Nothing.value,
    sudo: Nothing.value, init: Nothing.value,
    trustedUsers: Nothing.value, extraConf: Nothing.value,
    ...Object.fromEntries(Object.entries(values).map(([key, value]) => [key, new Just(value)])),
  })();
}
test("typed CSV settings are trimmed, quoted commas stay literal, and root remains trusted", async () => {
  const invoke = await typedSetup();
  for (const os of ["linux", "macos"]) {
    const f = fixture("determinate-nix", { os });
    const result = invoke({ sudo: true, trustedUsers: " runner , @builders , runner ", extraConf: ' max-jobs = auto ,"extra-platforms = a,b",literal = $(never-run)' });
    const args = f.calls.find(a => a[0] === "sudo" && a.includes("install"));
    assert.deepEqual(args.slice(-8), ["--extra-conf", "max-jobs = auto", "--extra-conf", "extra-platforms = a,b", "--extra-conf", "literal = $(never-run)", "--extra-conf", "trusted-users = root runner @builders"]);
    assert.equal(result.tool, "determinate-nix");
    assert.equal(result.binDir, "/nix/var/nix/profiles/default/bin");
    assert.ok(Array.isArray(result.environment));
  }
});
test("typed malformed lists and invalid settings fail before host commands", async () => {
  const invoke = await typedSetup();
  for (const values of [
    { trustedUsers: "runner,,root" }, { trustedUsers: "runner," },
    { trustedUsers: '*' }, { trustedUsers: '"runner' },
    { trustedUsers: 'runner\nroot' }, { trustedUsers: ["runner"] },
    { extraConf: "max-jobs = auto,,sandbox = true" },
    { extraConf: '"max-jobs = auto' }, { extraConf: "!include file.conf" },
    { extraConf: 'max-jobs = 1\ntrusted-users = *' },
  ]) {
    const f = fixture("determinate-nix");
    assert.throws(() => invoke(values));
    assert.deepEqual(f.calls, []);
    assert.deepEqual(f.updates, []);
  }
});
test("omitted and blank typed lists add no installer configuration", async () => {
  const invoke = await typedSetup();
  for (const values of [{}, { trustedUsers: "", extraConf: " " }]) {
    const f = fixture("determinate-nix");
    invoke(values);
    assert.ok(!f.calls.some(args => args.includes("--extra-conf")));
  }
});
