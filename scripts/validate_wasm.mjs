#!/usr/bin/env node
import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import { resolve } from "node:path";
import { pathToFileURL } from "node:url";

export async function validateWasm(directory) {
  const source = await readFile(resolve(directory, "entry.mjs"), "utf8");
  const match = source.match(/export\s*\{([^}]+)\}/);
  assert.ok(match, "Missing entry point declarations");
  const expected = match[1].split(",").map(name => name.trim()).filter(Boolean).sort();
  const bytes = await readFile(resolve(directory, "dist/plugin.wasm"));
  const module = await WebAssembly.compile(bytes);
  const exports = WebAssembly.Module.exports(module);
  const actual = exports.filter(item => item.kind === "function" && !item.name.startsWith("_")).map(item => item.name).sort();
  assert.deepEqual(actual, expected, "WASM public exports differ from entry.mjs");
  assert.ok(exports.some(item => item.kind === "memory" && item.name === "memory"), "Plugin has no exported memory");
  return expected;
}

if (process.argv[1] && import.meta.url === pathToFileURL(resolve(process.argv[1])).href) {
  try {
    assert.equal(process.argv.length, 3, "Usage: node scripts/validate_wasm.mjs MODULE_DIRECTORY");
    const exports = await validateWasm(process.argv[2]);
    console.log(`Validated ${process.argv[2]}: ${exports.length} WASM entry point(s).`);
  } catch (error) {
    console.error(error.message);
    process.exitCode = 1;
  }
}
