import test from "node:test";
import assert from "node:assert/strict";
import { createRequire } from "node:module";
import { fixture } from "../../../test/setup/host.mjs";
const { setup } = createRequire(import.meta.url)("../dist/plugin.cjs");
test("installs components, targets, and profile for the selected toolchain", () => {
  const f = fixture("rust", { input: { toolchain: "1.85.0", components: " rustfmt , clippy , rustfmt ", targets: " wasm32-wasip2 , wasm32-unknown-unknown , wasm32-wasip2 ", profile: "default" } });
  setup();
  assert.ok(f.calls.some(a => a.includes("--profile") && a[a.indexOf("--profile") + 1] === "default"));
  assert.deepEqual(f.calls.find(a => a[1] === "component").slice(1), ["component", "add", "--toolchain", "1.85.0", "rustfmt", "clippy"]);
  assert.deepEqual(f.calls.find(a => a[1] === "target").slice(1), ["target", "add", "--toolchain", "1.85.0", "wasm32-wasip2", "wasm32-unknown-unknown"]);
  assert.equal(JSON.parse(f.output[0]).environment.RUSTUP_TOOLCHAIN, "1.85.0");
});
test("invalid and conflicting options fail before commands", () => {
  for (const input of [{ toolchain: "--help" }, { toolchain: "nightly", version: "stable" }, { components: "--help" }, { targets: "../escape" }, { components: ["rustfmt"] }, { targets: ["wasm32-wasip2"] }, { components: null }, { targets: null }, { components: 42 }, { targets: {} }, { components: "rustfmt,,clippy" }, { targets: ",wasm32-wasip2" }, { targets: "wasm32-wasip2," }, { components: "rustfmt;id" }, { profile: "unknown" }]) {
    const f = fixture("rust", { input }); assert.throws(setup); assert.deepEqual(f.calls, []);
  }
  const f = fixture("rust", { os: "openbsd", input: { components: "rustfmt" } });
  assert.throws(setup, /rustup/); assert.deepEqual(f.calls, []);
});
test("component installation failure never activates environment", () => {
  const f = fixture("rust", { input: { components: "rustfmt" }, fail: a => a[1] === "component" });
  assert.throws(setup, /Injected command failure/); assert.deepEqual(f.output, []); assert.equal(f.environment.PATH, "/usr/bin:/bin");
});
test("blank lists retain the default component and target behavior", () => {
  for (const input of [{}, { components: "", targets: "" }, { components: "  ", targets: "  " }]) {
    const f = fixture("rust", { input }); setup();
    assert.ok(!f.calls.some(a => a[1] === "component" || a[1] === "target"));
    assert.equal(f.output.length, 1);
  }
});
test("typed component accepts comma-separated components and targets", async () => {
  const native = await import("../output/CI.Component/index.js");
  const { Just, Nothing } = await import("../output/Data.Maybe/index.js");
  const f = fixture("rust");
  const result = native.setup({
    version: Nothing.value, installDir: Nothing.value, packageName: Nothing.value,
    sudo: Nothing.value, toolchain: new Just("1.85.0"),
    components: new Just("rustfmt,clippy"), targets: new Just("wasm32-wasip2,wasm32-unknown-unknown"),
    profile: Nothing.value,
  })();
  assert.equal(result.tool, "rust");
  assert.deepEqual(f.calls.find(a => a[1] === "component").slice(1), ["component", "add", "--toolchain", "1.85.0", "rustfmt", "clippy"]);
  assert.deepEqual(f.calls.find(a => a[1] === "target").slice(1), ["target", "add", "--toolchain", "1.85.0", "wasm32-wasip2", "wasm32-unknown-unknown"]);
});
