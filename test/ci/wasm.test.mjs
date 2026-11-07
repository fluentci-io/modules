import test from "node:test";
import assert from "node:assert/strict";
import { mkdtemp, writeFile, mkdir, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { validateWasm } from "../../scripts/validate_wasm.mjs";

function wasm(name, memory = true) {
  const text = value => [value.length, ...Buffer.from(value)];
  const section = (id, values) => [id, values.length, ...values];
  return Buffer.from([0, 97, 115, 109, 1, 0, 0, 0,
    ...section(1, [1, 96, 0, 1, 127]), ...section(3, [1, 0]),
    ...section(5, [1, 0, 1]),
    ...section(7, [memory ? 2 : 1, ...(memory ? [...text("memory"), 2, 0] : []), ...text(name), 0, 0]),
    ...section(10, [1, 4, 0, 65, 0, 11])]);
}
async function fixture(t, bytes) {
  const root = await mkdtemp(join(tmpdir(), "fluentci-ci-wasm-"));
  t.after(() => rm(root, { recursive: true, force: true }));
  await mkdir(join(root, "dist"));
  await writeFile(join(root, "entry.mjs"), 'export { setup } from "./output/Main/index.js";');
  await writeFile(join(root, "dist/plugin.wasm"), bytes);
  return root;
}
test("accepts a compiled guest with the declared export and memory", async t => {
  assert.deepEqual(await validateWasm(await fixture(t, wasm("setup"))), ["setup"]);
});
test("rejects missing or unexpected guest entry points", async t => {
  await assert.rejects(validateWasm(await fixture(t, wasm("other"))), /exports differ/);
});
test("rejects invalid WebAssembly", async t => {
  await assert.rejects(validateWasm(await fixture(t, Buffer.from("invalid"))), WebAssembly.CompileError);
});
test("requires exported guest memory", async t => {
  await assert.rejects(validateWasm(await fixture(t, wasm("setup", false))), /memory/);
});
