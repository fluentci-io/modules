import { build } from 'esbuild';
import { mkdir } from 'node:fs/promises';
import { resolve } from 'node:path';
import { spawnSync } from 'node:child_process';
import { buildPlugin } from './inspection/index.mjs';

export async function buildModule(root=process.cwd()) {
  const result=spawnSync('spago',['build'],{cwd:root,stdio:'inherit'});
  if(result.error)throw result.error;
  if(result.status!==0)throw Error('PureScript compilation failed');
  await mkdir(resolve(root,'dist'),{recursive:true});
  // Private CJS bundles retain the existing host regression suites. The published
  // plugin.wasm is always a native component built from the typed public entry.
  for(const [entry,output] of [['legacy-entry.mjs','plugin.cjs'],['entry.mjs','component.cjs']]) {
    await build({entryPoints:[resolve(root,entry)],outfile:resolve(root,'dist',output),bundle:true,format:'cjs',platform:'neutral',target:'es2020'});
  }
  await buildPlugin({sdk:'purescript',runtime:'component',root});
}
