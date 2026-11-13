import '../../../test/dependencies/loader.mjs';
import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {readFileSync} from 'node:fs';
import {fixture} from '../../../test/cli/host.mjs';
const plugin=createRequire(import.meta.url)('../dist/plugin.cjs');
const component=await import('../output/CI.Component/index.js');
const {Just,Nothing}=await import('../output/Data.Maybe/index.js');
const schema=JSON.parse(readFileSync(new URL('../schema.json',import.meta.url)));
const spec=JSON.parse(readFileSync(new URL('../module-dependencies.json',import.meta.url)));
function invoke(name,input){const f=fixture({input:{runDir:'/tmp/github-artifacts',...input}});plugin[name]();return f;}

test('renamed artifact module retains the matching setup component and native tools',()=>{
 assert.equal(schema.name,'gh-artifacts');
 assert.ok(spec.requirements.some(d=>d.alias==='setup-gh-artifacts'&&d.program==='gh'));
 assert.ok(spec.requirements.some(d=>d.alias==='setup-bun'));
});
test('CSV release files are literal tokens and receive individual file preflight checks',()=>{
 const f=invoke('release_upload',{tag:'v1.0.0',files:' dist/a.zip, "dist/file,one.zip" '});
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['release','upload','v1.0.0','dist/a.zip','dist/file,one.zip']);
 assert.equal(f.plans[0].plan.tasks[0].program,'gh');
 assert.equal(f.calls.filter(a=>a[0]==='test'&&a[1]==='-f').length,2);
});
test('download name and pattern lists retain repeated native options',()=>{
 let f=invoke('download',{runId:'123',name:' build, coverage '});
 assert.ok(f.plans[0].plan.tasks[0].args.includes('--name=build'));
 assert.ok(f.plans[0].plan.tasks[0].args.includes('--name=coverage'));
 f=invoke('release_download',{tag:'v1.0.0',pattern:'*.zip,*.tar.gz'});
 assert.ok(f.plans[0].plan.tasks[0].args.includes('--pattern=*.zip'));
 assert.ok(f.plans[0].plan.tasks[0].args.includes('--pattern=*.tar.gz'));
});
test('malformed lists fail before any setup or native operation',()=>{
 for(const files of [['dist/a.zip'],'dist/a.zip,,dist/b.zip','"bad','']){
  const f=fixture({input:{runDir:'/tmp/bad-artifacts',tag:'v1.0.0',files}});
  assert.throws(plugin.release_upload);assert.equal(f.calls.length,0);assert.equal(f.plans.length,0);
 }
});
test('typed release upload accepts CSV files and artifacts and returns execution paths',()=>{
 const contract=schema.exports.release_upload.input;
 const values={runDir:'/tmp/typed-gh-artifacts',tag:'v1.0.0',files:'dist/a.zip,dist/b.zip'};
 const input=Object.fromEntries(Object.keys(contract.properties).map(key=>[key,contract.required.includes(key)?values[key]:key==='artifacts'?new Just('package=dist/a.zip'):Nothing.value]));
 const f=fixture();const result=component.release_upload(input)();
 assert.equal(result.outcome,'succeeded');assert.equal(result.reportPath,'/tmp/typed-gh-artifacts/result.json');
 assert.equal(f.plans[0].plan.tasks[0].program,'gh');
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['release','upload','v1.0.0','dist/a.zip','dist/b.zip']);
});
