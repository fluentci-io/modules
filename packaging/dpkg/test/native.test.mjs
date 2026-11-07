import test from "node:test";
import assert from "node:assert/strict";
import { createRequire } from "node:module";
import { mkdtempSync, mkdirSync, writeFileSync, readFileSync, rmSync, chmodSync, existsSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { spawnSync } from "node:child_process";
import { fixture } from "./host.mjs";

const { build, validate } = createRequire(import.meta.url)("../dist/plugin.cjs");
const available = process.platform === "linux" && ["dpkg-deb", "dpkg", "realpath"].every(tool => spawnSync(tool, ["--version"]).status === 0);
if (process.env.FLUENTCI_REQUIRE_NATIVE_TESTS === "1" && process.platform === "linux" && !available) throw new Error("Native Linux packaging tests require their build tools");

function command(program, args) {
  const result = spawnSync(program, args, { encoding: "utf8" });
  assert.equal(result.status, 0, result.stderr);
  return result.stdout.trim();
}

test("native Debian builds for amd64, arm64, and all preserve payload and metadata", { skip: !available }, () => {
  const root = mkdtempSync(join(tmpdir(), "dpkg-module-"));
  try {
    for (const [arch, inputArch] of [["amd64", "x86_64"], ["arm64", "aarch64"], ["all", "all"]]) {
      const directory = join(root, "package " + arch);
      const output = join(root, "dist", `custom_${arch}.deb`);
      mkdirSync(join(directory, "DEBIAN"), { recursive: true });
      mkdirSync(join(directory, "usr/share/custom"), { recursive: true });
      writeFileSync(join(directory, "usr/share/custom/message.txt"), "custom payload\n");
      writeFileSync(join(directory, "DEBIAN/control"), `Package: custom-example\nVersion: 2.3.0\nArchitecture: ${arch}\nMaintainer: Example <example@example.org>\nDescription: A generic fixture\n`);
      const input = { directory, arch: inputArch, output };
      fixture({ input, native: true });
      validate();
      assert.equal(existsSync(output), false);
      const f = fixture({ input, native: true });
      build();
      assert.deepEqual(JSON.parse(f.output[0]), [output]);
      assert.equal(command("dpkg-deb", ["--field", output, "Architecture"]), arch);
      assert.equal(command("dpkg-deb", ["--field", output, "Package"]), "custom-example");
      const extracted = join(root, "extract-" + arch);
      command("dpkg-deb", ["--extract", output, extracted]);
      assert.equal(readFileSync(join(extracted, "usr/share/custom/message.txt"), "utf8"), "custom payload\n");
      assert.match(command("dpkg-deb", ["--contents", output]), /root\/root/);
    }
  } finally { rmSync(root, { recursive: true, force: true }); }
});

test("native Debian validation rejects bad layouts, metadata, and mismatched architecture", { skip: !available }, () => {
  const root = mkdtempSync(join(tmpdir(), "dpkg-invalid-"));
  try {
    const output = join(root, "out.deb");
    const directory = join(root, "pkg");
    mkdirSync(directory);
    fixture({ input: { directory, arch: "arm64", output }, native: true });
    assert.throws(validate);
    mkdirSync(join(directory, "DEBIAN"));
    const control = join(directory, "DEBIAN/control");
    for (const text of ["", "Package: example\n", "Package: custom-example\nVersion: invalid version\nArchitecture: arm64\nMaintainer: Example\nDescription: Example\n", "Package: custom-example\nVersion: 1.0\nArchitecture: amd64\nMaintainer: Example\nDescription: Example\n"]) {
      writeFileSync(control, text);
      fixture({ input: { directory, arch: "arm64", output }, native: true });
      assert.throws(validate);
      assert.equal(existsSync(output), false);
    }
    writeFileSync(control, "Package: custom-example\nVersion: 1.0\nArchitecture: arm64\nMaintainer: Example\nDescription: Example\n");
    writeFileSync(join(directory, "DEBIAN/postinst"), "#!/bin/sh\nexit 0\n");
    chmodSync(join(directory, "DEBIAN/postinst"), 0o644);
    fixture({ input: { directory, arch: "arm64", output }, native: true });
    assert.throws(build); // dpkg-deb's native maintainer-script permission checks.
    assert.equal(existsSync(output), false);
  } finally { rmSync(root, { recursive: true, force: true }); }
});
