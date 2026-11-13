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
const typed=(name,values)=>Object.fromEntries(Object.keys(schema.exports[name].input.properties).map(key=>[key,key==='runDir'?'/tmp/spin-typed':schema.exports[name].input.required.includes(key)?values[key]:Object.hasOwn(values,key)?new Just(values[key]):Nothing.value]));
function invoke(name,input={},options={}){const f=fixture({input:{runDir:'/tmp/spin-fixture',...input},...options});plugin[name]();return f;}

test('component and annotation lists preserve literal native flags and explicit false composition',()=>{
 let f=invoke('build',{from:'spin.toml',components:'api, worker'});
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['build','--from=spin.toml','--component-id=api','--component-id=worker']);
 f=invoke('registry_push',{reference:'ghcr.io/example/app:1.0.0',compose:false,annotations:'org.opencontainers.image.revision=abc123,stage=ci'});
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['registry','push','--compose=false','--annotation=org.opencontainers.image.revision=abc123','--annotation=stage=ci','ghcr.io/example/app:1.0.0']);
});
test('plugin install versions and approval are explicit, and native deploy alias remains configurable',()=>{
 let f=invoke('plugins_install',{name:'cloud',pluginVersion:'0.15.0',yes:true});
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['plugins','install','--version=0.15.0','--yes','cloud']);
 assert.ok(!invoke('plugins_install',{name:'cloud'}).plans[0].plan.tasks[0].args.includes('--yes'));
 f=invoke('deploy',{arguments:'--from,spin.toml'},{env:{SPIN_DEPLOY_PLUGIN:'example-plugin'}});
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['deploy','--from','spin.toml']);
 assert.equal(f.environment.SPIN_DEPLOY_PLUGIN,'example-plugin');
});
test('cloud login uses token authentication and cloud deploy maps readiness and CSV values',()=>{
 assert.deepEqual(invoke('cloud_login').plans[0].plan.tasks[0].args,['cloud','login','--auth-method=token']);
 assert.deepEqual(invoke('cloud_deploy',{from:'spin.toml',readinessTimeout:0,variables:'stage=ci,revision=abc',keyValues:'key=value',links:'sqlite:db=ci-db'}).plans[0].plan.tasks[0].args,['cloud','deploy','--from=spin.toml','--readiness-timeout=0','--variable=stage=ci','--variable=revision=abc','--key-value=key=value','--link=sqlite:db=ci-db']);
});
test('invalid CSV and assignments are rejected before setup or host commands',()=>{
 for(const input of [{annotations:'broken'},{annotations:'key=value,,other=x'},{annotations:['key=value']}]){
  const f=fixture({input:{runDir:'/tmp/spin-invalid',reference:'ghcr.io/example/app:1',...input}});
  assert.throws(plugin.registry_push);assert.equal(f.calls.length,0);
 }
 const f=invoke('build',{components:''});assert.deepEqual(f.plans[0].plan.tasks[0].args,['build']);
});
test('typed OCI publishing installs Spin and leaves credentials inherited',()=>{
 let available=false;globalThis.fluentciSetupDependencies={'setup-spin':()=>{available=true;}};
 const f=fixture({fail:a=>a[0]==='which'&&a[1]==='spin'&&!available,env:{SPIN_AUTH_TOKEN:'synthetic-spin-token'}});
 const result=component.registry_push(typed('registry_push',{reference:'ghcr.io/example/app:1'}))();
 assert.equal(available,true);assert.equal(result.outcome,'succeeded');assert.equal(result.reportPath,'/tmp/spin-typed/result.json');
 assert.equal(f.plans[0].plan.inherit_env,true);assert.ok(!JSON.stringify(f.plans).includes('synthetic-spin-token'));
});
test('missing plugins, failed builds and failed registry pushes cannot return success',()=>{
 for(const [name,input]of [['cloud_deploy',{}],['build',{}],['registry_push',{reference:'ghcr.io/example/app:1'}]]){
  const f=fixture({input:{runDir:'/tmp/spin-failure',...input},outcome:'failed'});
  assert.throws(plugin[name],/failed/);assert.equal(f.output.length,0);
 }
});
