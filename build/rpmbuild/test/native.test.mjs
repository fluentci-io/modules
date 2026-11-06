import test from "node:test";
import assert from "node:assert/strict";
import { createRequire } from "node:module";
import { mkdtempSync, mkdirSync, writeFileSync, rmSync, existsSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { spawnSync } from "node:child_process";
import { fixture } from "./host.mjs";

const { build, validate } = createRequire(import.meta.url)("../dist/plugin.cjs");
const available = process.platform === "linux" && ["rpmbuild", "rpmspec", "rpm", "realpath"].every(tool => spawnSync(tool, ["--version"]).status === 0);
function command(program, args) {
  const result = spawnSync(program, args, { encoding: "utf8" });
  assert.equal(result.status, 0, result.stderr);
  return result.stdout.trim();
}
function spec(arch) {
  return `Name: custom-example
Version: 2.3.0
Release: 1
Summary: Generic package fixture
License: MIT
${arch == "noarch" ? "BuildArch: noarch" : ""}
%global _build_id_links none
%global __os_install_post %{nil}

%description
A generic fixture with a project-owned payload.

%prep
%build
%install
mkdir -p "%{buildroot}/usr/share/custom"
cp "%{_sourcedir}/message.txt" "%{buildroot}/usr/share/custom/message.txt"

%files
/usr/share/custom/message.txt
`;
}

test("native RPM builds for x86_64, aarch64, and noarch preserve payload and metadata", { skip: !available }, () => {
  const root = mkdtempSync(join(tmpdir(), "rpm-module-"));
  try {
    for (const [arch, inputArch] of [["x86_64", "amd64"], ["aarch64", "arm64"], ["noarch", "noarch"]]) {
      const directory = join(root, arch);
      mkdirSync(join(directory, "SPECS"), { recursive: true });
      mkdirSync(join(directory, "SOURCES"));
      writeFileSync(join(directory, "SOURCES/message.txt"), "custom payload\n");
      writeFileSync(join(directory, "SPECS/custom.spec"), spec(arch));
      const output = join(root, "dist-" + arch);
      const input = { directory, arch: inputArch, spec: "custom.spec", output };
      fixture({ input, native: true });
      validate();
      assert.equal(existsSync(output), false);
      const f = fixture({ input, native: true });
      build();
      const files = JSON.parse(f.output[0]);
      const file = join(output, arch, `custom-example-2.3.0-1.${arch}.rpm`);
      assert.deepEqual(files, [file]);
      assert.equal(command("rpm", ["--query", "--package", "--queryformat", "%{ARCH}", file]), arch);
      assert.equal(command("rpm", ["--query", "--package", "--queryformat", "%{NAME}", file]), "custom-example");
      assert.equal(command("rpm", ["--query", "--package", "--list", file]), "/usr/share/custom/message.txt");
    }
  } finally { rmSync(root, { recursive: true, force: true }); }
});

test("native RPM validation rejects bad layout, spec syntax, and architecture", { skip: !available }, () => {
  const root = mkdtempSync(join(tmpdir(), "rpm-invalid-"));
  try {
    const directory = join(root, "tree");
    const output = join(root, "out");
    mkdirSync(directory);
    const input = { directory, arch: "aarch64", spec: "custom.spec", output };
    fixture({ input, native: true });
    assert.throws(validate);
    mkdirSync(join(directory, "SPECS"));
    mkdirSync(join(directory, "SOURCES"));
    for (const contents of ["", "invalid spec", spec("x86_64").replace("License: MIT", "License: MIT\nBuildArch: x86_64")]) {
      writeFileSync(join(directory, "SPECS/custom.spec"), contents);
      fixture({ input, native: true });
      assert.throws(validate);
      assert.equal(existsSync(output), false);
    }
    writeFileSync(join(directory, "SPECS/custom.spec"), spec("aarch64"));
    fixture({ input, native: true });
    assert.throws(build); // Missing source file must propagate as a failed build.
    assert.equal(existsSync(join(output, "aarch64/custom-example-2.3.0-1.aarch64.rpm")), false);
  } finally { rmSync(root, { recursive: true, force: true }); }
});
