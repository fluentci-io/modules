import test from 'node:test';
import assert from 'node:assert/strict';
import {mkdtemp,writeFile,mkdir,rm} from 'node:fs/promises';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {createHash} from 'node:crypto';
import {parse} from '../../lib/component/node_modules/@bytecodealliance/jco/dist/api.js';
import {annotate} from '../../lib/component/inspection/wasm.mjs';
import {validateWasm} from '../../scripts/validate_wasm.mjs';

async function fixture(t,{name='setup',description='Return the fixture value.',returnType='s32',schemaType='integer',core=false}={}) {
 const root=await mkdtemp(join(tmpdir(),'fluentci-component-validator-'));t.after(()=>rm(root,{recursive:true,force:true}));await mkdir(join(root,'dist'));
 const bytes=core?Buffer.from(await parse('(module)')):Buffer.from(await parse(`(component (core module $m (func (export "f") (result i32) i32.const 1)) (core instance $i (instantiate $m)) (func $f (result s32) (canon lift (core func $i "f"))) (export "${name}" (func $f)))`));
 const functions=[{name,description,inputFormat:'wit',args:[],returnType}];const wasm=core?bytes:annotate(bytes,functions);
 await writeFile(join(root,'entry.mjs'),'export { setup } from "./output/CI.Component/index.js";');
 await writeFile(join(root,'schema.json'),JSON.stringify({exports:{setup:{input:{type:'object',properties:{},required:[]},output:{type:schemaType}}}}));
 await writeFile(join(root,'dist/plugin.wasm'),wasm);await writeFile(join(root,'dist/fluentci.metadata.json'),JSON.stringify({sha256:createHash('sha256').update(wasm).digest('hex'),functions}));return root;
}
test('accepts a native component with matching typed public exports',async t=>assert.deepEqual(await validateWasm(await fixture(t)),['setup']));
test('rejects core Extism modules',async t=>await assert.rejects(validateWasm(await fixture(t,{core:true})),/native WebAssembly component/));
test('rejects native exports differing from entrypoint declarations',async t=>await assert.rejects(validateWasm(await fixture(t,{name:'other'})),/exports differ/));
test('requires function descriptions',async t=>await assert.rejects(validateWasm(await fixture(t,{description:''})),/description/));
test('checks actual native return types',async t=>await assert.rejects(validateWasm(await fixture(t,{schemaType:'string'})),/type differs/));
