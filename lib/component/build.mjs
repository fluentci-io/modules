import { build } from 'esbuild';
import { mkdir, readFile } from 'node:fs/promises';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';
import { buildPlugin } from './inspection/index.mjs';

export async function buildModule(root=process.cwd(),options={}) {
  let manifest='';
  try {manifest=await readFile(resolve(root,'fluentci-module.toml'),'utf8');} catch(error){if(error.code!=='ENOENT')throw error;}
  if(/^\[dependencies\]\s*$/m.test(manifest)) {
    const prepared=spawnSync('fluentci',['install','--frozen-lockfile'],{cwd:root,stdio:'inherit'});
    if(prepared.error)throw prepared.error;
    if(prepared.status!==0)throw Error('Could not prepare typed setup dependencies');
  }
  const result=spawnSync('spago',['build'],{cwd:root,stdio:'inherit'});
  if(result.error)throw result.error;
  if(result.status!==0)throw Error('PureScript compilation failed');
  await mkdir(resolve(root,'dist'),{recursive:true});
  // Private CJS bundles retain the existing host regression suites. The published
  // plugin.wasm is always a native component built from the typed public entry.
  const bridge=fileURLToPath(new URL('../../test/dependencies/mock.mjs',import.meta.url));
  const regressionDependency={name:'regression-component-dependencies',setup(builder){
    builder.onResolve({filter:/^fluentci:dependency\//},({path})=>({path:path.slice('fluentci:dependency/'.length),namespace:'setup-regression'}));
    builder.onLoad({filter:/.*/,namespace:'setup-regression'},({path})=>({contents:`import {invoke} from ${JSON.stringify(bridge)};export const setup=args=>invoke(${JSON.stringify(path)},args);`,loader:'js',resolveDir:dirname(bridge)}));
  }};
  for(const [entry,output] of [['legacy-entry.mjs','plugin.cjs'],['entry.mjs','component.cjs']]) {
    await build({entryPoints:[resolve(root,entry)],outfile:resolve(root,'dist',output),bundle:true,format:'cjs',platform:'neutral',target:'es2020',logOverride:{'import-is-undefined':'error'},plugins:[...(options.regressionPlugins??[]),regressionDependency]});
  }
  await buildPlugin({sdk:'purescript',runtime:'component',root});
}
