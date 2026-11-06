import test from "node:test";
import assert from "node:assert/strict";
import { createRequire } from "node:module";
import { fixture } from "./host.mjs";

const { build, validate } = createRequire(import.meta.url)("../dist/plugin.cjs");
const isDeb = new URL("..", import.meta.url).pathname.includes("/dpkg/");
const config = isDeb
  ? { directory: "/workspace/package", arch: "aarch64", output: "/workspace/dist/tool.deb" }
  : { directory: "/workspace/rpmbuild", arch: "arm64", spec: "tool.spec", output: "/workspace/dist/rpm" };
const builds = f => f.calls.filter(args => args[0] === (isDeb ? "dpkg-deb" : "rpmbuild") && args.includes(isDeb ? "--build" : "-bb"));
const mutates = f => f.calls.some(args => args[0] === "mkdir") || builds(f).length > 0;

test("rejects non-Linux hosts before checking tools or touching the directory", () => {
  for (const os of ["macos", "windows", "freebsd"]) {
    for (const entry of [build, validate]) {
      const f = fixture({ os, input: config });
      assert.throws(entry, /Linux host/);
      assert.deepEqual(f.calls, []);
    }
  }
});

test("checks the required packaging tools before any filesystem operations", () => {
  const tools = isDeb ? ["dpkg-deb", "dpkg", "realpath"] : ["rpmbuild", "rpmspec", "rpm", "realpath"];
  for (const tool of tools) {
    const f = fixture({ input: config, fail: args => args[0] === tool && args[1] === "--version" });
    assert.throws(build, new RegExp("unavailable: " + tool));
    assert.ok(f.calls.every(args => args[1] === "--version"));
  }
});

test("validates the layout and architecture without creating directories or packages", () => {
  const f = fixture({ input: config });
  validate();
  assert.equal(mutates(f), false);
  assert.ok(f.calls.some(args => args[0] === "test" && args[1] === "-d"));
});

test("builds a generic package and returns absolute artifact paths", () => {
  const f = fixture({ input: config });
  build();
  assert.equal(builds(f).length, 1);
  const files = JSON.parse(f.output[0]);
  assert.deepEqual(files, isDeb ? [config.output] : [config.output + "/aarch64/custom-tool-2.3.0-1.aarch64.rpm"]);
  if (isDeb) {
    assert.ok(builds(f)[0].includes("--root-owner-group"));
  } else {
    const args = builds(f)[0];
    assert.equal(args[args.indexOf("--target") + 1], "aarch64");
    assert.ok(args.includes("_topdir " + config.directory));
  }
  assert.ok(!f.calls.some(args => ["sh", "bash"].includes(args[0])));
});

test("rejects malformed JSON, unknown arguments, invalid types, paths, and architecture", () => {
  const bad = ["{", [], {}, { ...config, extra: true }, { ...config, arch: 123 },
    { ...config, directory: "" }, { ...config, directory: "bad\0path" },
    { ...config, arch: "" }, { ...config, arch: "aarch64;false" },
    { ...config, output: "bad\npath" }];
  if (isDeb) bad.push({ ...config, output: "tool.rpm" }, { ...config, output: config.directory + "/nested.deb" });
  else bad.push({ ...config, spec: "../tool.spec" }, { ...config, spec: "tool.txt" },
    { ...config, output: config.directory + "/SOURCES" }, { ...config, directory: "/tmp/a%macro" });
  for (const input of bad) {
    const f = fixture({ input });
    assert.throws(build, undefined, JSON.stringify(input));
    assert.equal(mutates(f), false);
  }
});

test("rejects missing layout components and metadata before building", () => {
  const suffixes = isDeb ? ["/DEBIAN", "/DEBIAN/control"] : ["/SPECS", "/SOURCES", "/SPECS/tool.spec"];
  for (const suffix of suffixes) {
    const f = fixture({ input: config, fail: args => args[0] === "test" && args.at(-1).endsWith(suffix) });
    assert.throws(build, /Injected command failure/);
    assert.equal(mutates(f), false);
  }
  const mismatch = fixture({ input: config, ...(isDeb
    ? { control: "Package: widget\nVersion: 1.0\nArchitecture: amd64\nMaintainer: Example\nDescription: Example\n" }
    : { metadata: "x86_64\twidget-1.0-1.x86_64.rpm\n" }) });
  assert.throws(build, /architecture mismatch/);
  assert.equal(mutates(mismatch), false);
});

test("native build errors and post-build architecture mismatches propagate", () => {
  const f = fixture({ input: config, fail: args => args.includes(isDeb ? "--build" : "-bb") });
  assert.throws(build, /Injected command failure/);
  assert.equal(f.output.length, 0);
  const wrongArch = fixture({ input: config, builtArch: "wrong" });
  assert.throws(build, /architecture mismatch/);
  assert.equal(wrongArch.output.length, 0);
});

if (isDeb) {
  test("rejects missing, duplicate, empty, and multi-paragraph Debian metadata", () => {
    for (const control of ["Package: widget\n", "Package: widget\nPackage: duplicate\n", "Package: \n", "Package: widget\n\nPackage: two\n"]) {
      const f = fixture({ input: config, control });
      assert.throws(validate, /DEBIAN\/control/);
      assert.equal(mutates(f), false);
    }
  });
  test("preserves literal whitespace and shell characters in Debian paths", () => {
    const directory = "/workspace/a ' $(echo injected)";
    const f = fixture({ input: { ...config, directory } });
    build();
    assert.ok(builds(f)[0].includes(directory));
  });
} else {
  test("rejects empty metadata, duplicate output names, and traversal in RPM metadata", () => {
    for (const metadata of ["", "invalid", "aarch64\t../../escape.rpm\n", "aarch64\ttool.rpm\naarch64\ttool.rpm\n"]) {
      const f = fixture({ input: config, metadata });
      assert.throws(build);
      assert.equal(mutates(f), false);
    }
  });
  test("supports multiple binary packages in one spec", () => {
    const f = fixture({ input: config, metadata: "aarch64\twidget-1.0-1.aarch64.rpm\naarch64\twidget-data-1.0-1.aarch64.rpm\n" });
    build();
    assert.equal(JSON.parse(f.output[0]).length, 2);
  });
}
