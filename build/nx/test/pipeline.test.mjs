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
function invoke(name,input={}){const f=fixture({input:{runDir:'/tmp/monorepo-plan',...input}});plugin[name]();return f;}
const typed=(name,values)=>Object.fromEntries(Object.keys(schema.exports[name].input.properties).map(key=>[key,key==='runDir'?'/tmp/monorepo-typed':schema.exports[name].input.required.includes(key)?values[key]:Object.hasOwn(values,key)?new Just(values[key]):Nothing.value]));

test('multi-target execution uses one native comma-delimited option per list',()=>{
 const f=invoke('run_many',{targets:'build, test,lint',projects:'app,shared-*',exclude:'legacy-*,*-e2e',parallel:4});
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['run-many','--targets=build,test,lint','--projects=app,shared-*','--parallel=4','--exclude=legacy-*,*-e2e','--outputStyle=static']);
 assert.equal(f.plans[0].plan.tasks[0].env.NX_DAEMON,'false');
 assert.equal(f.plans[0].plan.tasks[0].env.CI,'true');
});
test('affected tasks preserve explicit revisions and deleted changed paths',()=>{
 const f=invoke('affected',{targets:'build,test',base:'origin/main',head:'HEAD',files:'deleted.ts,src/app.ts'});
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['affected','--targets=build,test','--base=origin/main','--head=HEAD','--files=deleted.ts,src/app.ts','--outputStyle=static']);
 assert.ok(!f.calls.some(a=>a[0]==='test'&&a[1]==='-f'));
});
test('invalid and blank required target lists fail before native setup or host commands',()=>{
 for(const targets of ['', ' ', 'build,,test', 'build,', ['build'], '"bad', 'build,te\0st']){
  const f=fixture({input:{runDir:'/tmp/bad-nx-targets',targets}});assert.throws(plugin.run_many);assert.equal(f.calls.length,0);
 }
 for(const value of ['', '  ']){
  const f=invoke('run_many',{targets:'build',projects:value,exclude:value});
  assert.deepEqual(f.plans[0].plan.tasks[0].args,['run-many','--targets=build','--outputStyle=static']);
 }
});
test('inspection writes JSON or graph files without starting a browser',()=>{
 assert.deepEqual(invoke('show_projects',{projects:'app,lib',withTargets:'build,test'}).plans[0].plan.tasks[0].args,['show','projects','--json','--projects=app,lib','--withTarget=build,test']);
 assert.deepEqual(invoke('graph',{file:'new-graph.json'}).plans[0].plan.tasks[0].args,['graph','--open=false','--file=new-graph.json']);
});
test('typed Nx tasks use setup-nx when unavailable and retain local executable overrides',()=>{
 let available=false;globalThis.fluentciSetupDependencies={'setup-nx':()=>{available=true;}};
 let f=fixture({fail:a=>a[0]==='which'&&a[1]==='nx'&&!available});
 const result=component.run_many(typed('run_many',{targets:'build,test',projects:'app,lib'}))();
 assert.equal(available,true);assert.equal(result.outcome,'succeeded');assert.equal(result.reportPath,'/tmp/monorepo-typed/result.json');
 assert.ok(f.plans[0].plan.tasks[0].args.includes('--targets=build,test'));
 globalThis.fluentciSetupDependencies={'setup-nx':()=>{throw Error('Unexpected installation');}};
 f=fixture();component.run_many(typed('run_many',{targets:'build',executable:'./node_modules/.bin/nx'}))();
 assert.equal(f.plans[0].plan.tasks[0].program,'./node_modules/.bin/nx');
});
test('task failures and cache controls keep native CI semantics and credentials inherited',()=>{
 assert.ok(!invoke('run_many',{targets:'build'}).plans[0].plan.tasks[0].args.includes('--skipNxCache'));
 assert.deepEqual(invoke('run_target',{target:'app:build:production',skipCache:true,skipRemoteCache:true,bail:true}).plans[0].plan.tasks[0].args,['run','--outputStyle=static','--skipNxCache','--skipRemoteCache','--nxBail','app:build:production']);
 const secret='synthetic-nx-cloud-token';
 const f=fixture({input:{runDir:'/tmp/nx-failed',targets:'test'},env:{NX_CLOUD_ACCESS_TOKEN:secret},outcome:'failed'});
 assert.throws(plugin.run_many,/failed/);assert.equal(f.output.length,0);assert.equal(f.plans[0].plan.inherit_env,true);
 assert.ok(!JSON.stringify(f.plans).includes(secret));
});
