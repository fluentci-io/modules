import test from "node:test";
import assert from "node:assert/strict";
import { createRequire } from "node:module";
import { fileURLToPath } from "node:url";
import { fixture, versions } from "./host.mjs";

export function runSuite(tool, bundle) {
  const { setup } = createRequire(import.meta.url)(fileURLToPath(bundle));
  const nix = ["nix", "determinate-nix"].includes(tool);
  const pinned = tool === "java" ? "21" : tool === "determinate-nix" ? "3.24.2" : versions[tool];
  const config = { version: pinned };
  test(`${tool}: installs and verifies a selected version on Linux and macOS`, () => {
    for (const os of ["linux", "macos", "darwin"]) {
      const f = fixture(tool, { input: config, os });
      setup();
      const result = JSON.parse(f.output[0]);
      assert.equal(result.tool, tool);
      assert.equal(result.version, versions[tool]);
      assert.ok(result.environment.PATH.startsWith(result.binDir + ":"));
      assert.equal(f.environment.PATH, result.environment.PATH);
      assert.ok(f.calls.some(args => args[0] === "curl" && args.includes("--output")));
      if (tool === "java") assert.ok(result.environment.JAVA_HOME);
      if (tool === "rust") {
        assert.ok(result.environment.CARGO_HOME);
        assert.ok(result.environment.RUSTUP_HOME);
        assert.equal(result.environment.RUSTUP_TOOLCHAIN, pinned);
      }
    }
  });
  test(`${tool}: handles all BSD hosts with native packages or the Nix OS restriction`, () => {
    for (const os of ["freebsd", "openbsd", "netbsd"]) {
      const f = fixture(tool, { input: config, os });
      if (nix) {
        assert.throws(setup, /Linux and macOS only/);
        assert.deepEqual(f.calls, []);
      } else {
        setup();
        assert.equal(JSON.parse(f.output[0]).version, versions[tool]);
        assert.equal(f.calls.some(args => args[0] === "curl"), false);
        const program = { freebsd: "pkg", openbsd: "pkg_add", netbsd: "pkgin" }[os];
        assert.ok(f.calls.some(args => args[0] === program && (args.includes("install") || args.includes("-I"))));
      }
    }
  });
  test(`${tool}: maps desktop CPU aliases to upstream assets`, () => {
    for (const arch of ["x86_64", "aarch64", "amd64", "arm64"]) {
      const f = fixture(tool, { input: config, arch });
      setup();
      assert.equal(JSON.parse(f.output[0]).tool, tool);
    }
  });
  test(`${tool}: accepts defaults and a plain version token`, () => {
    for (const input of ["", pinned]) {
      const f = fixture(tool, { input });
      setup();
      assert.equal(JSON.parse(f.output[0]).tool, tool);
    }
  });
  test(`${tool}: rejects unsupported operating systems and architecture before commands`, () => {
    for (const options of [{ os: "windows" }, { os: "solaris" }, { arch: "mips" }]) {
      const f = fixture(tool, { input: config, ...options });
      assert.throws(setup, /Unsupported|architecture/);
      assert.deepEqual(f.calls, []);
    }
  });
  test(`${tool}: rejects invalid inputs before host mutation`, () => {
    for (const input of ["{", { unknown: true }, { version: "../escape" }, { version: ".." }, { version: "." }, { version: "--help" }, { version: 1 }, { version: null }, { installDir: "/tmp/../" }, { sudo: "yes" }, { installDir: "/" }, { installDir: "relative" }, { installDir: "/tmp/bad\npath" }, { packageName: "--force" }, { packageName: "file:/tmp/tool" }, { packageName: "tool;false" }]) {
      const f = fixture(tool, { input });
      assert.throws(setup, undefined, JSON.stringify(input));
      assert.deepEqual(f.calls, []);
      assert.deepEqual(f.updates, []);
    }
  });
  test(`${tool}: missing dependencies and failed installs propagate without success output`, () => {
    const missing = fixture(tool, { input: config, fail: args => args[0] === "which" });
    assert.throws(setup, /Required setup tool/);
    assert.deepEqual(missing.output, []);
    const failed = fixture(tool, { input: config, fail: args => args[0] === "curl" && args.includes("--output") });
    assert.throws(setup, /Injected command failure/);
    assert.deepEqual(failed.output, []);
    assert.ok(failed.calls.some(args => args[0] === "rm" && args.at(-1).includes("fluentci-setup.")));
  });
  if (!nix) {
    test(`${tool}: BSD supports explicit package selectors and noninteractive privilege elevation`, () => {
      const f = fixture(tool, { os: "freebsd", input: { ...config, packageName: "custom-tool-1.0", sudo: true } });
      setup();
      assert.ok(f.calls.some(args => args[0] === "sudo" && args[1] === "-n" && args.includes("custom-tool-1.0")));
      const failed = fixture(tool, { os: "netbsd", input: config, fail: args => args[0] === "pkgin" });
      assert.throws(setup, /repository.*packageName/);
    });
    test(`${tool}: a mismatched installed version does not report success`, () => {
      const f = fixture(tool, { input: config, actualVersion: "0.0.1" });
      assert.throws(setup, /version mismatch/);
      assert.deepEqual(f.output, []);
    });
  }
  if (!["rust", "nix", "determinate-nix"].includes(tool)) {
    test(`${tool}: preserves literal installation paths and reuses a verified install`, () => {
      const installDir = "/tmp/a ' $(touch injected)";
      const f = fixture(tool, { input: { ...config, installDir }, existing: true });
      setup();
      assert.equal(f.calls.some(args => args[0] === "curl" && args.includes("--output")), false);
      assert.ok(f.calls.some(args => args[0].startsWith(installDir + "/")));
    });
  }
  if (tool === "go") test("go: BSD activates versioned package binaries through per-user shims", () => {
    const f = fixture(tool, { os: "freebsd", input: { ...config, packageName: "go124" }, listing: "/usr/local/bin/go124\n/usr/local/bin/gofmt124\n" });
    setup();
    const result = JSON.parse(f.output[0]);
    assert.ok(result.binDir.includes("/.local/share/fluentci/go/"));
    assert.ok(f.calls.some(args => args[0] === "ln" && args[2] === "/usr/local/bin/go124"));
    assert.ok(result.environment.GOROOT);
  });
  if (tool === "elixir") test("elixir: rejects an incompatible installed Erlang/OTP", () => {
    const f = fixture(tool, { input: { ...config, otpVersion: "26" } });
    assert.throws(setup, /OTP mismatch/);
    assert.equal(f.calls.some(args => args[0] === "curl" && args.includes("--output")), false);
  });
  if (tool === "zig") test("zig: rejects corrupted archives before extraction", () => {
    const f = fixture(tool, { input: config, actualDigest: "b".repeat(64) });
    assert.throws(setup, /SHA-256 mismatch/);
    assert.equal(f.calls.some(args => args[0] === "tar"), false);
  });
  if (tool === "bun") test("bun: resolves Linux musl baseline archive names", () => {
    const f = fixture(tool, { input: { ...config, libc: "musl", baseline: true } });
    setup();
    assert.ok(f.calls.some(args => args.at(-1).endsWith("bun-linux-x64-musl-baseline.zip")));
  });
  if (tool === "java") test("java: selects a complete release including its build number", () => {
    const f = fixture(tool, { input: { version: "21.0.5+11" } });
    setup();
    assert.ok(f.calls.some(args => args.at(-1).includes("/version/jdk-21.0.5+11/")));
  });
  if (tool === "node") test("node: LTS selection skips newer non-LTS releases", () => {
    const f = fixture(tool, { input: "lts", responses: { "https://nodejs.org/dist/index.json": JSON.stringify([{ version: "v24.0.0", lts: false }, { version: "v22.14.0", lts: "Jod" }]) } });
    setup();
    assert.equal(JSON.parse(f.output[0]).version, "22.14.0");
  });
  if (tool === "rust") test("rust: selects dated nightly toolchains and verifies the channel", () => {
    const f = fixture(tool, { input: "nightly-2025-01-01", actualVersion: "1.86.0-nightly" });
    setup();
    assert.ok(f.calls.some(args => args.includes("nightly-2025-01-01")));
    fixture(tool, { input: "nightly-2025-01-01" });
    assert.throws(setup, /requested channel/);
  });
  if (nix) test(`${tool}: rejects an existing installation of the other Nix distribution`, () => {
    const f = fixture(tool, { input: config, existing: true, versionOutput: tool === "nix" ? "nix (Determinate Nix 3.2.0) 2.28.0" : "nix (Nix) 2.26.0" });
    assert.throws(setup, /different distribution/);
    assert.equal(f.calls.some(args => args[0] === "curl" && args.includes("--output")), false);
  });
  if (tool === "determinate-nix") test("determinate-nix: verifies the pinned installer version", () => {
    fixture(tool, { input: config, installerVersion: "3.24.1" });
    assert.throws(setup, /version mismatch/);
  });
  if (tool === "nix") test("nix: supports Linux single-user mode and rejects it on macOS", () => {
    const f = fixture(tool, { input: { ...config, daemon: false } });
    setup();
    assert.ok(f.calls.some(args => args[0] === "sh" && args.includes("--no-daemon")));
    fixture(tool, { input: { ...config, daemon: false }, os: "macos" });
    assert.throws(setup, /daemon mode/);
  });
  if (tool === "determinate-nix") test("determinate-nix: supports init=none for Linux containers", () => {
    const f = fixture(tool, { input: { ...config, init: "none" } });
    setup();
    assert.ok(f.calls.some(args => args[0] === "sh" && args.includes("none")));
    assert.ok(f.calls.some(args => args.at(-1).endsWith("/tag/v" + pinned)));
  });
}
