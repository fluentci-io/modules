import test from "node:test";
import assert from "node:assert/strict";
import { createRequire } from "node:module";
import { fixture, versionText, versions } from "../../../test/setup/host.mjs";
import { runLive } from "../../../test/setup/live.mjs";

const { setup } = createRequire(import.meta.url)("../dist/plugin.cjs");
const config = { version: "0.15.16", nodeVersion: "22.14.0", bunVersion: "1.2.3", spagoVersion: "1.0.5", npmVersion: "10.9.2" };
function host(input = config, options = {}) {
  return fixture("purescript", { input, ...options, command(args) {
    if ((args[0] === "pkg" && args[1] === "info") || args[0] === "pkg_info") {
      const name = args.at(-1).includes("node") ? "node" : args.at(-1).includes("bun") ? "bun" : "purs";
      const prefix = options.os === "netbsd" ? "/usr/pkg" : "/usr/local";
      return `${prefix}/bin/${name}\n`;
    }
    if (args[1] === "--version") {
      if (args[0].endsWith("/node")) return versionText("node");
      if (args[0].endsWith("/bun")) return versionText("bun");
      if (args[0].endsWith("/purs")) return versionText("purescript", options.compilerVersion);
      if (args[0].endsWith("/spago")) return "1.0.5";
      if (args[0].endsWith("/npm")) return "10.9.2";
    }
    return undefined;
  } });
}
test("sets up pinned Node, Bun, npm, PureScript, and Spago on Linux and macOS", () => {
  for (const os of ["linux", "macos"]) {
    const f = host(config, { os });
    setup();
    const result = JSON.parse(f.output[0]);
    assert.equal(result.version, "0.15.16");
    assert.equal(result.nodeVersion, versions.node);
    assert.equal(result.bunVersion, versions.bun);
    assert.equal(result.spagoVersion, "1.0.5");
    assert.equal(result.npmVersion, "10.9.2");
    assert.ok(f.calls.some(args => args.includes("purescript@0.15.16") && args.includes("spago@1.0.5")));
    assert.ok(result.environment.PATH.includes("/node_modules/.bin:"));
  }
});
test("uses native compiler packages and portable npm on all BSD hosts", () => {
  for (const os of ["freebsd", "openbsd", "netbsd"]) {
    const f = host(config, { os });
    setup();
    const result = JSON.parse(f.output[0]);
    assert.equal(result.version, "0.15.16");
    assert.ok(f.calls.some(args => args.includes("spago@1.0.5")));
    assert.equal(f.calls.some(args => args.includes("purescript@0.15.16")), false);
    assert.ok(f.calls.some(args => args.includes(os === "freebsd" ? "hs-purescript-0.15.16" : "purescript-0.15.16")));
  }
});
test("supports CLI compiler versions and default configuration", () => {
  for (const input of ["0.15.16", ""]) {
    const f = host(input);
    setup();
    assert.equal(JSON.parse(f.output[0]).tool, "purescript");
  }
});
test("rejects bad options before starting any installer", () => {
  for (const input of [{ unknown: true }, { version: "../bad" }, { bunVersion: "--help" }, { spagoVersion: null }, { sudo: "yes" }, { npmVersion: "latest" }, { npmVersion: "10..2" }, { npmVersion: "10.2." }, { installDir: "/" }, { installDir: "/tmp/../" }]) {
    const f = host(input);
    assert.throws(setup);
    assert.deepEqual(f.calls, []);
  }
});
test("rejects unsupported OS before starting dependencies", () => {
  const f = host(config, { os: "windows" });
  assert.throws(setup, /Unsupported/);
  assert.deepEqual(f.calls, []);
});
test("a compiler version mismatch prevents reporting a working toolchain", () => {
  const f = host(config, { compilerVersion: "0.15.15" });
  assert.throws(setup, /version mismatch/);
  assert.deepEqual(f.output, []);
});
test("propagates npm failures and cleans the bootstrap directory", () => {
  const f = host(config, { fail: args => args.includes("spago@1.0.5") });
  assert.throws(setup, /Injected command failure/);
  assert.deepEqual(f.output, []);
  assert.ok(f.calls.some(args => args[0] === "rm"));
});
runLive("purescript", new URL("../dist/plugin.cjs", import.meta.url));
