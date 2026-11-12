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

test('Turbo task, filter and cache selectors retain native flag semantics',()=>{
 const f=invoke('run_tasks',{tasks:'build, test,lint',filters:'web...,!docs',cache:'local:rw, remote:r',concurrency:'50%',summarize:true});
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['run','--filter=web...','--filter=!docs','--concurrency=50%','--cache=local:rw,remote:r','--summarize','--ui=stream','build','test','lint']);
 assert.equal(f.plans[0].plan.tasks[0].env.CI,'true');
});
test('dry runs and affected builds use native plan and selection commands',()=>{
 assert.deepEqual(invoke('dry_run',{tasks:'build,test'}).plans[0].plan.tasks[0].args,['run','--dry=json','--ui=stream','build','test']);
 assert.deepEqual(invoke('affected',{tasks:'build'}).plans[0].plan.tasks[0].args,['run','--affected','--ui=stream','build']);
});
test('CSV filtering and task flags remain literal, including embedded commas and shell syntax',()=>{
 const f=invoke('run_tasks',{tasks:'test',filters:'"./{apps,packages}/*"',arguments:'--,--name,"literal,a",$(touch injected)'});
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['run','--filter=./{apps,packages}/*','--ui=stream','test','--','--name','literal,a','$(touch injected)']);
});
test('invalid task lists and malformed CSV fail before any host commands',()=>{
 for(const tasks of ['', ' ', 'build,,test', 'build,', ['build'], '--force', '"bad', 'build,te\0st']){
  const f=fixture({input:{runDir:'/tmp/bad-turbo-tasks',tasks}});assert.throws(plugin.run_tasks);assert.equal(f.calls.length,0);
 }
 assert.deepEqual(invoke('run_tasks',{tasks:'build',filters:'  ',cache:''}).plans[0].plan.tasks[0].args,['run','--ui=stream','build']);
});
test('workspace pruning can create a new Docker-oriented output directory',()=>{
 const f=invoke('prune',{package:'web',docker:true,outDir:'new-output',useGitignore:false});
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['prune','--docker','--out-dir=new-output','--use-gitignore=false','web']);
 assert.ok(!f.calls.some(a=>a[0]==='test'&&a[1]==='-d'&&a.at(-1).includes('new-output')));
});
test('typed Turbo execution reuses setup-turborepo and never requires setup-turbo',()=>{
 let available=false;globalThis.fluentciSetupDependencies={'setup-turborepo':()=>{available=true;}};
 const f=fixture({fail:a=>a[0]==='which'&&a[1]==='turbo'&&!available});
 const result=component.run_tasks(typed('run_tasks',{tasks:'build,test'}))();
 assert.equal(available,true);assert.equal(result.outcome,'succeeded');assert.equal(f.plans[0].plan.tasks[0].program,'turbo');
 assert.equal(result.stdoutPath,'/tmp/monorepo-typed/turborepo.stdout');
});
test('failed tasks fail the module even when the native continue policy is enabled',()=>{
 const secret='synthetic-turbo-token';
 const f=fixture({input:{runDir:'/tmp/turbo-failed',tasks:'test',continueMode:'always'},env:{TURBO_TOKEN:secret},outcome:'failed'});
 assert.throws(plugin.run_tasks,/failed/);assert.equal(f.output.length,0);
 assert.equal(f.plans[0].plan.inherit_env,true);assert.ok(!JSON.stringify(f.plans).includes(secret));
});
