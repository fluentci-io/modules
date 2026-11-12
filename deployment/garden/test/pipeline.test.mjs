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
const typed=(name,values)=>Object.fromEntries(Object.keys(schema.exports[name].input.properties).map(key=>[key,key==='runDir'?'/tmp/garden-typed':Object.hasOwn(values,key)?new Just(values[key]):Nothing.value]));
function invoke(name,input={}){const f=fixture({input:{runDir:'/tmp/garden-plan',...input}});plugin[name]();return f;}

test('environment, variable overrides and action lists preserve literal argv ordering',()=>{
 const f=invoke('deploy',{environment:'pr-42.ci',variables:'imageTag=abc123,replicas=2',names:' api, worker ',skip:'frontend,old-*',disablePortForwards:true});
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['--env=pr-42.ci','--var=imageTag=abc123','--var=replicas=2','deploy','--skip=frontend','--skip=old-*','--disable-port-forwards','api','worker']);
});
test('malformed CSV, positional flags and invalid variable assignments fail before host commands',()=>{
 for(const input of [{names:'api,,worker'},{names:['api']},{names:'--force'},{variables:'imageTag'},{variables:'=value'},{variables:'bad key=value'},{variables:'key=value,,other=x'},{variables:['key=value']},{variables:'key=bad\0value'}]){
  const f=fixture({input:{runDir:'/tmp/garden-invalid',...input}});
  assert.throws(plugin.deploy);assert.equal(f.calls.length,0);assert.equal(f.plans.length,0);
 }
});
test('blank optional lists preserve all-action behavior, and native templates stay literal',()=>{
 assert.deepEqual(invoke('build',{names:' ',variables:''}).plans[0].plan.tasks[0].args,['build']);
 const tag='release-${build.hash}';
 assert.deepEqual(invoke('publish',{names:'api',tag}).plans[0].plan.tasks[0].args,['publish','--tag='+tag,'api']);
 assert.deepEqual(invoke('test',{names:'*integration*,*lint',force:true}).plans[0].plan.tasks[0].args,['test','--force','*integration*','*lint']);
});
test('confirmation, forced cleanup and streaming are never enabled implicitly',()=>{
 for(const name of ['deploy','cleanup_deploy','cleanup_namespace','logs']){
  const args=invoke(name).plans[0].plan.tasks[0].args;
  for(const flag of ['--yes','--force','--follow'])assert.ok(!args.includes(flag));
 }
 assert.deepEqual(invoke('cleanup_deploy',{environment:'pr-42.ci',names:'api',force:true,yes:true}).plans[0].plan.tasks[0].args,['--env=pr-42.ci','cleanup','deploy','--yes','--force','api']);
});
test('typed deploy installs its setup dependency and returns execution paths',()=>{
 let installed=false;
 globalThis.fluentciSetupDependencies={'setup-garden':()=>{installed=true;}};
 const f=fixture({fail:a=>a[0]==='which'&&a[1]==='garden'&&!installed});
 const result=component.deploy(typed('deploy',{environment:'ci',names:'api,worker',output:'json'}))();
 assert.equal(installed,true);assert.equal(result.outcome,'succeeded');
 assert.equal(result.reportPath,'/tmp/garden-typed/result.json');assert.equal(result.stdoutPath,'/tmp/garden-typed/garden.stdout');
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['--env=ci','--output=json','deploy','api','worker']);
});
test('malformed typed variables cannot invoke setup or native plans',()=>{
 let installed=false;globalThis.fluentciSetupDependencies={'setup-garden':()=>{installed=true;}};
 const f=fixture();assert.throws(()=>component.deploy(typed('deploy',{variables:'broken-assignment'}))());
 assert.equal(installed,false);assert.equal(f.calls.length,0);assert.equal(f.plans.length,0);
});
test('failed builds, deployments and tests propagate failure without exposing credentials in plans',()=>{
 for(const name of ['build','deploy','test']){
  const secret='synthetic-garden-token';
  const f=fixture({input:{runDir:'/tmp/garden-failure'},env:{GARDEN_AUTH_TOKEN:secret},outcome:'failed'});
  assert.throws(plugin[name],/failed/);assert.equal(f.output.length,0);
  assert.equal(f.plans[0].plan.inherit_env,true);assert.ok(!JSON.stringify(f.plans).includes(secret));
 }
});
