import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture} from '../../../test/cli/host.mjs';
const plugin=createRequire(import.meta.url)('../dist/plugin.cjs');
const invoke=(name,input,options={})=>{const f=fixture({input:{runDir:'/tmp/pgroll-fixture',...input},...options});plugin[name]();return f;};

test('pgroll: lifecycle commands require no spurious migration file',()=>{
 for(const name of ['init','complete','rollback','status'])assert.deepEqual(invoke(name,{}).plans[0].plan.tasks[0].args,[name]);
});
test('pgroll: directory migrations preserve typed flags and explicit false',()=>{
 const f=invoke('migrate',{directory:'migrations',expectOne:true,complete:false,backfillBatchSize:200,backfillBatchDelay:'10ms',useVersionSchema:false,lockTimeout:0});
 const args=f.plans[0].plan.tasks[0].args;
 for(const token of ['migrate','migrations','--expect-one=true','--complete=false','--backfill-batch-size=200','--backfill-batch-delay=10ms','--use-version-schema=false','--lock-timeout=0'])assert.ok(args.includes(token),token);
 assert.ok(f.calls.some(a=>a[0]==='test'&&a[1]==='-d'&&a.at(-1).endsWith('migrations')));
});
test('pgroll: migration inputs are checked before a plan starts',()=>{
 for(const [name,input,kind] of [['validate',{file:'001.yaml'},'-f'],['start',{file:'001.json'},'-f'],['convert',{file:'input.sql'},'-f'],['migrate',{directory:'migrations'},'-d'],['update',{directory:'migrations'},'-d']]){
  const f=fixture({input:{runDir:'/tmp/missing-pgroll',...input},fail:args=>args[0]==='test'&&args[1]===kind&&args.at(-1)!=='.'});
  assert.throws(plugin[name]);assert.equal(f.plans.length,0);
 }
});
test('pgroll: baseline and empty-file creation run without interactive prompts',()=>{
 assert.deepEqual(invoke('baseline',{baselineVersion:'initial',directory:'new-migrations'}).plans[0].plan.tasks[0].args,['baseline','--yes','initial','new-migrations']);
 assert.deepEqual(invoke('create',{name:'002_accounts',json:true}).plans[0].plan.tasks[0].args,['create','--empty','--name=002_accounts','--json=true']);
 for(const name of ['baseline','pull']){
  const f=invoke(name,{directory:'not-created-yet',...(name==='baseline'?{baselineVersion:'initial'}:{})});
  assert.ok(!f.calls.some(a=>a[0]==='test'&&a[1]==='-d'&&a.at(-1).includes('not-created-yet')));
 }
});
test('pgroll: native credentials remain inherited and CSV tokens remain literal',()=>{
 const f=invoke('run',{arguments:'status,"literal,a",--verbose'},{env:{PGROLL_PG_URL:'postgres://secret@db/app'}});
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['status','literal,a','--verbose']);
 assert.equal(f.plans[0].plan.inherit_env,true);assert.ok(!JSON.stringify(f.plans).includes('postgres://secret'));
 for(const arguments_ of ['status,,--verbose','"bad', ['status']]){
  const bad=fixture({input:{runDir:'/tmp/bad-pgroll',arguments:arguments_}});assert.throws(plugin.run);assert.equal(bad.calls.length,0);
 }
});
test('pgroll: latest lookups expose local directory and optional literal URL',()=>{
 const f=invoke('latest_url',{local:'migrations',connectionString:'postgres://db/app?sslmode=require'});
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['latest','url','--local=migrations','postgres://db/app?sslmode=require']);
});
test('pgroll: failed migrations fail the call',()=>{
 const f=fixture({input:{runDir:'/tmp/failed-pgroll'},outcome:'failed'});assert.throws(plugin.complete,/failed/);assert.equal(f.output.length,0);
});
