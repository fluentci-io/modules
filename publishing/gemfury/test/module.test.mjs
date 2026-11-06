import test from "node:test";
import assert from "node:assert/strict";
import { createRequire } from "node:module";
import { mkdtempSync, mkdirSync, writeFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { fixture } from "./host.mjs";
import { uploadFiles } from "../output/CI.Gemfury/index.js";

const { upload } = createRequire(import.meta.url)("../dist/plugin.cjs");
const environment = {
  FURY_ACCOUNT: "my-repo", FURY_USER: "publisher", FURY_TOKEN: "test-only-token",
};
const curlCalls = f => f.calls.filter(args => args[0] === "curl");

test("missing or blank tokens skip both entry points before reading input or running commands", () => {
  for (const env of [{}, { FURY_TOKEN: "" }, { FURY_TOKEN: " \n" }]) {
    const f = fixture(env);
    upload();
    uploadFiles([])();
    assert.equal(f.output.length, 2);
    assert.match(f.output[0], /Skipping Gemfury/);
    assert.deepEqual(f.calls, []);
  }
});

test("uploads arbitrary package names, formats and architectures without release configuration", () => {
  for (const path of ["dist/widget_1.2.0_armhf.deb", "other-tool-9.0-1.s390x.rpm", "dist/custom.pkg"]) {
    const f = fixture(environment, { input: path });
    upload();
    assert.deepEqual(f.calls.slice(0, 3), [["test", "-f", path], ["test", "-r", path], ["test", "-s", path]]);
    const [args] = curlCalls(f);
    assert.ok(args.includes(`package=@"${path}"`));
    assert.ok(args.includes("https://push.fury.io/my-repo/"));
    assert.ok(args.includes("%FURY_USER"));
    assert.ok(args.includes("%FURY_TOKEN"));
    assert.ok(args.includes("{{FURY_USER}}:{{FURY_TOKEN}}"));
    assert.ok(!JSON.stringify(f.calls).includes(environment.FURY_TOKEN));
    assert.ok(!f.calls.some(args => ["sh", "bash"].includes(args[0])));
  }
});

test("FURY_PACKAGE is a fallback and literal CLI input takes precedence", () => {
  const env = { ...environment, FURY_PACKAGE: "fallback.deb" };
  const fallback = fixture(env);
  upload();
  assert.ok(curlCalls(fallback)[0].includes('package=@"fallback.deb"'));
  const explicit = fixture(env, { input: " path with spaces.rpm " });
  upload();
  assert.ok(curlCalls(explicit)[0].includes('package=@" path with spaces.rpm "'));
});

test("batch API checks every file before uploading any and stops after upload failures", () => {
  const paths = ["one.deb", "two.rpm", "three.deb"];
  const f = fixture(environment);
  uploadFiles(paths)();
  assert.equal(f.calls.slice(0, 9).filter(args => args[0] === "test").length, 9);
  assert.equal(curlCalls(f).length, 3);
  const missing = fixture(environment, { fail: args => args[0] === "test" && args.at(-1) === "two.rpm" });
  assert.throws(uploadFiles(paths), /Injected command failure/);
  assert.equal(curlCalls(missing).length, 0);
  const failed = fixture(environment, { fail: args => args[0] === "curl" });
  assert.throws(uploadFiles(paths), /Injected command failure/);
  assert.equal(curlCalls(failed).length, 1);
});

test("invalid input and missing credentials fail before commands", () => {
  for (const paths of [[], [""], ["  "], ["bad\0.deb"], ["bad\n.deb"], ["bad\r.deb"], ["ok.deb", ""]]) {
    const f = fixture(environment);
    assert.throws(uploadFiles(paths));
    assert.deepEqual(f.calls, []);
  }
  for (const key of ["FURY_USER", "FURY_ACCOUNT"]) {
    const env = { ...environment };
    delete env[key];
    const f = fixture(env);
    assert.throws(uploadFiles(["widget.deb"]), new RegExp(key));
    assert.deepEqual(f.calls, []);
  }
  const f = fixture(environment);
  assert.throws(upload, /FURY_PACKAGE/);
  assert.deepEqual(f.calls, []);
  for (const bad of [{ FURY_ACCOUNT: "../other" }, { FURY_USER: "user:password" }]) {
    const invalid = fixture({ ...environment, ...bad });
    assert.throws(uploadFiles(["widget.deb"]), /Invalid Gemfury/);
    assert.deepEqual(invalid.calls, []);
  }
});

test("multipart filenames escape quotes and backslashes while preserving literal shell characters", () => {
  const path = 'dist/a"b\\c,semi;colon\' $(touch injected).deb';
  const f = fixture(environment, { input: path });
  upload();
  assert.equal(f.calls[0][2], path);
  const form = curlCalls(f)[0].find(arg => arg.startsWith("package=@"));
  assert.equal(form, 'package=@"' + path.replaceAll("\\", "\\\\").replaceAll('"', '\\"') + '"');
});

test("a file named dash is uploaded as a file rather than curl stdin", () => {
  const f = fixture(environment, { input: "-" });
  upload();
  assert.deepEqual(f.calls[0], ["test", "-f", "-"]);
  assert.ok(curlCalls(f)[0].includes('package=@"./-"'));
});

test("native preflight rejects missing, empty and directory paths before network requests", () => {
  const root = mkdtempSync(join(tmpdir(), "gemfury-preflight-"));
  try {
    const valid = join(root, "custom package.deb");
    const empty = join(root, "empty.rpm");
    const directory = join(root, "directory.deb");
    writeFileSync(valid, "package fixture");
    writeFileSync(empty, "");
    mkdirSync(directory);
    for (const invalid of [join(root, "missing.deb"), empty, directory]) {
      const f = fixture(environment, { nativePreflight: true });
      assert.throws(uploadFiles([valid, invalid]), /preflight failed/);
      assert.equal(curlCalls(f).length, 0);
    }
    const f = fixture(environment, { nativePreflight: true });
    uploadFiles([valid])();
    assert.equal(curlCalls(f).length, 1);
  } finally {
    rmSync(root, { recursive: true, force: true });
  }
});
