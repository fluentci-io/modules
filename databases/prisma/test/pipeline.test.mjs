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
 globalThis.fluentciSetupDependencies={'setup-prisma':()=>{installed=true;}};
 const f=fixture({fail:a=>a[0]==='test'&&a[1]==='-f'});
 assert.throws(()=>component.migrate_deploy(typed('migrate_deploy',{config:'missing.config.ts'}))());
 assert.equal(installed,false);assert.equal(f.plans.length,0);assert.ok(!f.calls.some(a=>a[0]==='which'));
});
test('failed migrations propagate failure and never return a successful result',()=>{
 const f=fixture({input:{runDir:'/tmp/failed-database'},outcome:'failed'});
 assert.throws(plugin.migrate_deploy,/failed/);assert.equal(f.output.length,0);
});
test('native credentials stay inherited rather than being copied into the plan',()=>{
 const secret='postgresql://user:synthetic-secret@db/example';
 const f=fixture({input:{runDir:'/tmp/credential-plan'},env:{DATABASE_URL:secret}});
 plugin.migrate_deploy();assert.equal(f.plans[0].plan.inherit_env,true);
 assert.ok(!JSON.stringify(f.plans).includes(secret));
});

test('generator lists repeat native flags and reject malformed CSV before commands',()=>{
 const f=invoke('generate',{generators:' client, reporting '});
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['generate','--generator=client','--generator=reporting']);
 for(const generators of ['client,,reporting','client,','"bad',['client']]){
  const bad=fixture({input:{runDir:'/tmp/bad-generators',generators}});
  assert.throws(plugin.generate);assert.equal(bad.calls.length,0);
 }
 for(const generators of ['', '   '])assert.deepEqual(invoke('generate',{generators}).plans[0].plan.tasks[0].args,['generate']);
});
test('typed client generation forwards CSV generator names and returns execution paths',()=>{
 const f=fixture();
 const result=component.generate(typed('generate',{generators:'client,reporting',config:'prisma.config.ts'}))();
 assert.equal(result.outcome,'succeeded');assert.equal(result.reportPath,'/tmp/typed-database/result.json');
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['generate','--config','prisma.config.ts','--generator=client','--generator=reporting']);
 assert.equal(f.output.length,0);
});
test('deployment never enables data loss, reset or development migration commands',()=>{
 assert.deepEqual(invoke('migrate_deploy').plans[0].plan.tasks[0].args,['migrate','deploy']);
 assert.deepEqual(invoke('db_push').plans[0].plan.tasks[0].args,['db','push']);
 assert.deepEqual(invoke('db_push',{acceptDataLoss:true,forceReset:true}).plans[0].plan.tasks[0].args,['db','push','--accept-data-loss','--force-reset']);
 assert.deepEqual(invoke('format',{check:true}).plans[0].plan.tasks[0].args,['format','--check']);
});
test('SQL execution requires an existing script before a plan starts',()=>{
 const f=fixture({input:{runDir:'/tmp/missing-script',file:'missing.sql'},fail:a=>a[0]==='test'&&a[1]==='-f'});
 assert.throws(plugin.db_execute);assert.equal(f.plans.length,0);
});
test('diffs support Prisma 7 config datasources and CI drift exit behavior',()=>{
 assert.deepEqual(invoke('migrate_diff',{fromConfigDatasource:true,toSchema:'prisma/schema.prisma',script:true,exitCode:true}).plans[0].plan.tasks[0].args,['migrate','diff','--from-config-datasource','--to-schema','prisma/schema.prisma','--script','--exit-code']);
});
