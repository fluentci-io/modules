import { runSuite } from "../../../test/setup/suite.mjs";
runSuite("pkl", new URL("../dist/plugin.cjs", import.meta.url));
import { runNative } from "../../../test/setup/native.mjs";
runNative("pkl", new URL("../dist/plugin.cjs", import.meta.url));
import { runLive } from "../../../test/setup/live.mjs";
runLive("pkl", new URL("../dist/plugin.cjs", import.meta.url));

import assert from "node:assert/strict";
import test from "node:test";
import { createRequire } from "node:module";
import { fixture } from "../../../test/setup/host.mjs";
const { setup } = createRequire(import.meta.url)("../dist/plugin.cjs");

test("pkl: selects native and Java release assets for each host/libc", () => {
  for (const [os, arch, libc, asset] of [
    ["linux", "x86_64", "gnu", "pkl-linux-amd64"],
    ["linux", "aarch64", "gnu", "pkl-linux-aarch64"],
    ["linux", "x86_64", "musl", "pkl-alpine-linux-amd64"],
    ["macos", "aarch64", "auto", "pkl-macos-aarch64"],
    ["macos", "x86_64", "auto", "jpkl"],
    ["linux", "aarch64", "musl", "jpkl"],
  ]) {
    const f=fixture("pkl",{os,arch,input:{version:"0.33.0",libc}});
    setup();
    assert.ok(f.calls.some(args=>args[0]==="curl"&&args.includes("--output")&&args.at(-1).endsWith('/0.33.0/'+asset)));
    assert.equal(f.calls.some(args=>args[0]==="java"&&args[1]==="-version"),asset==="jpkl");
    assert.ok(!f.calls.some(args=>["tar","unzip"].includes(args[0])));
  }
});

test("pkl: rejects missing or old Java and macOS musl before download", () => {
  for (const fail of [args=>args[0]==="which"&&args[1]==="java",undefined]) {
    const f=fixture("pkl",{os:"macos",arch:"x86_64",input:{version:"0.33.0"},fail,
      command:args=>!fail&&args[0]==="java"?'openjdk version "11.0.1"':undefined});
    assert.throws(setup,/Java 17|Required setup tool/);
    assert.ok(!f.calls.some(args=>args.includes("--output")));
  }
  fixture("pkl",{os:"macos",input:{libc:"musl"}});
  assert.throws(setup,/Linux-only/);
});
