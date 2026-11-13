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
const typed=values=>Object.fromEntries(Object.keys(schema.exports.deploy.input.properties).map(key=>[key,key==='runDir'?'/tmp/wasmer-typed':Object.hasOwn(values,key)?new Just(values[key]):Nothing.value]));
function invoke(name,input={}){const f=fixture({input:{runDir:'/tmp/wasmer-fixture',...input}});plugin[name]();return f;}

test('publish and deploy use reviewed flags and never start interactive configuration',()=>{
 let f=invoke('publish',{directory:'package',namespace:'example',name:'app',packageVersion:'1.0.0',wait:'container'});
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['publish','--non-interactive','--namespace=example','--name=app','--version=1.0.0','--wait=container','package']);
 f=invoke('deploy',{path:'app.yaml',owner:'example',name:'ci-app',publishPackage:true,noDefault:true});
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['deploy','--non-interactive','--path','app.yaml','--owner=example','--name=ci-app','--publish-package','--no-default','--format=json']);
});
test('a missing input file stops typed setup and remote deployment',()=>{
 let installed=false;globalThis.fluentciSetupDependencies={'setup-wasmer':()=>{installed=true;}};
 const f=fixture({fail:a=>a[0]==='test'&&a[1]==='-f'});
 assert.throws(()=>component.deploy(typed({path:'missing.yaml'}))());
 assert.equal(installed,false);assert.equal(f.plans.length,0);
});
test('stream lists become repeated native flags and malformed CSV fails early',()=>{
 const f=invoke('app_logs',{app:'example/app',streams:'stdout, stderr'});
 assert.ok(f.plans[0].plan.tasks[0].args.includes('--streams=stdout'));
 assert.ok(f.plans[0].plan.tasks[0].args.includes('--streams=stderr'));
 for(const streams of ['stdout,,stderr',['stdout'],'"bad']){
  const bad=fixture({input:{runDir:'/tmp/bad-wasmer-streams',streams}});
  assert.throws(plugin.app_logs);assert.equal(bad.calls.length,0);
 }
});
test('typed deployment installs Wasmer when missing and returns native execution paths',()=>{
 let available=false;globalThis.fluentciSetupDependencies={'setup-wasmer':()=>{available=true;}};
 const f=fixture({fail:a=>a[0]==='which'&&a[1]==='wasmer'&&!available,env:{WASMER_TOKEN:'synthetic-wasmer-token'}});
 const result=component.deploy(typed({owner:'example',name:'app'}))();
 assert.equal(available,true);assert.equal(result.outcome,'succeeded');assert.equal(result.reportPath,'/tmp/wasmer-typed/result.json');
 assert.equal(f.plans[0].plan.inherit_env,true);assert.ok(!JSON.stringify(f.plans).includes('synthetic-wasmer-token'));
});
test('deletion requires an explicit app and activation requires a unique version operand',()=>{
 const f=fixture({input:{runDir:'/tmp/missing-wasmer-app'}});assert.throws(plugin.app_delete);assert.equal(f.calls.length,0);
 assert.deepEqual(invoke('version_activate',{versionId:'dav_unique'}).plans[0].plan.tasks[0].args,['app','version','activate','--format=json','dav_unique']);
});
test('failed publication and deployment do not report success',()=>{
 for(const name of ['publish','deploy']){
  const f=fixture({input:{runDir:'/tmp/wasmer-failure'},outcome:'failed'});
  assert.throws(plugin[name],/failed/);assert.equal(f.output.length,0);
 }
});
