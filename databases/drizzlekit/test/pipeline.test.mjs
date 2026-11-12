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
const typed=(name,values)=>Object.fromEntries(Object.keys(schema.exports[name].input.properties).map(key=>[key,key==='runDir'?'/tmp/typed-database':Object.hasOwn(values,key)?new Just(values[key]):Nothing.value]));
function invoke(name,input={}){const f=fixture({input:{runDir:'/tmp/database-plan',...input}});plugin[name]();return f;}

test('CSV extra arguments preserve native order, whitespace and literal metacharacters',()=>{
 const f=invoke('run',{arguments:' migrate, "literal,a", "$(touch injected);x" '});
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['migrate','literal,a','$(touch injected);x']);
 for(const arguments_ of ['migrate,,--help','"unterminated',['migrate'],'migrate,\0']){
  const bad=fixture({input:{runDir:'/tmp/bad-database',arguments:arguments_}});
  assert.throws(plugin.run);assert.equal(bad.calls.length,0);
 }
});
test('config files are checked before a typed setup dependency can mutate the host',()=>{
 let installed=false;
 globalThis.fluentciSetupDependencies={'setup-drizzlekit':()=>{installed=true;}};
 const f=fixture({fail:a=>a[0]==='test'&&a[1]==='-f'});
 assert.throws(()=>component.migrate(typed('migrate',{config:'missing.config.ts'}))());
 assert.equal(installed,false);assert.equal(f.plans.length,0);assert.ok(!f.calls.some(a=>a[0]==='which'));
});
test('failed migrations propagate failure and never return a successful result',()=>{
 const f=fixture({input:{runDir:'/tmp/failed-database'},outcome:'failed'});
 assert.throws(plugin.migrate,/failed/);assert.equal(f.output.length,0);
});
test('native credentials stay inherited rather than being copied into the plan',()=>{
 const secret='postgresql://user:synthetic-secret@db/example';
 const f=fixture({input:{runDir:'/tmp/credential-plan'},env:{DATABASE_URL:secret}});
 plugin.migrate();assert.equal(f.plans[0].plan.inherit_env,true);
 assert.ok(!JSON.stringify(f.plans).includes(secret));
});

test('Drizzle schema pushes never silently enable destructive approval',()=>{
 assert.deepEqual(invoke('push').plans[0].plan.tasks[0].args,['push']);
 assert.deepEqual(invoke('push',{force:true,verbose:true}).plans[0].plan.tasks[0].args,['push','--force','--verbose']);
 assert.deepEqual(invoke('push',{force:false,strict:false}).plans[0].plan.tasks[0].args,['push']);
});
test('custom SQL generation and SQL export use the reviewed native commands',()=>{
 assert.deepEqual(invoke('generate',{name:'add accounts',custom:true}).plans[0].plan.tasks[0].args,['generate','--name=add accounts','--custom']);
 assert.deepEqual(invoke('export_sql',{config:'drizzle.config.ts'}).plans[0].plan.tasks[0].args,['export','--config','drizzle.config.ts']);
});
