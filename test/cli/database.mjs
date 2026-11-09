import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {createRequire} from 'node:module';
import {fixture} from './host.mjs';

const reference=JSON.parse(readFileSync(new URL('./database-tools.json',import.meta.url)));
const catalog=JSON.parse(readFileSync(new URL('../../lib/cli/catalog.json',import.meta.url)));
export async function databaseSuite(name,directory) {
 const plugin=createRequire(import.meta.url)(new URL('dist/plugin.cjs',directory).pathname);
 const tool=catalog.find(tool=>tool.name===name);
 test(name+': every reviewed upstream root command is accessible as a pipeline function',()=>{
  for(const root of reference[name].commands) {
   const command=tool.commands.find(command=>command.args.length===1&&command.args[0]===root);
   assert.ok(command,root+' is not exposed');
   const f=fixture({input:{runDir:'/tmp/group-run',arguments:'--help'}});plugin[command.name]();
   assert.deepEqual(f.plans[0].plan.tasks[0].args,[root,'--help']);
  }
 });
 test(name+': quoted CSV preserves commas, quotes, whitespace, and shell syntax literally',()=>{
  const f=fixture({input:{runDir:'/tmp/csv-run',arguments:'sql,"select a,b from t where value=""x""","literal $(touch injected); 世界"'}});plugin.run();
  assert.deepEqual(f.plans[0].plan.tasks[0].args,['sql','select a,b from t where value="x"','literal $(touch injected); 世界']);
 });
 test(name+': malformed CSV and JSON lists fail before any host command',()=>{
  for(const arguments_ of ['',',help','help,','help,,version','"unterminated','"quoted"junk','a"b',['version'],null]) {
   const f=fixture({input:{runDir:'/tmp/bad-csv',arguments:arguments_}});
   assert.throws(plugin.run);assert.equal(f.calls.length,0);assert.equal(f.plans.length,0);
  }
 });
 test(name+': credentials remain inherited rather than serialized in execution plans',()=>{
  const f=fixture({input:{runDir:'/tmp/auth-run',arguments:'version'},env:{XATA_API_KEY:'fixture-secret',PLANETSCALE_SERVICE_TOKEN:'fixture-secret'}});plugin.run();
  assert.equal(f.plans[0].plan.inherit_env,true);assert.ok(!JSON.stringify(f.plans).includes('fixture-secret'));
 });
 test(name+': typed artifact declarations also use CSV strings',async()=>{
  const native=await import(new URL('output/CI.Component/index.js',directory));
  const {Just,Nothing}=await import(new URL('output/Data.Maybe/index.js',directory));
  const f=fixture();
  const result=native.run({project:Nothing.value,runDir:'/tmp/native-csv',executable:Nothing.value,timeoutMs:Nothing.value,artifacts:new Just('"schema=out/schema,preview.sql"'),arguments:'version'})();
  assert.equal(result.outcome,'succeeded');assert.ok(JSON.stringify(f.plans).includes('out/schema,preview.sql'));
 });
 if(name==='planetscale')test('PlanetScale named operations put resource flags after positional operands',()=>{
  const f=fixture({input:{runDir:'/tmp/branch-create',database:'app',branch:'pr-123',organization:'team',wait:true}});plugin.branch_create();
  assert.deepEqual(f.plans[0].plan.tasks[0].args,['branch','create','app','pr-123','--org=team','--wait']);
 });
 if(name==='xata')test('Xata migrations validate the local migration file before executing',()=>{
  const f=fixture({input:{runDir:'/tmp/migrate',migrationFile:'001.json'},fail:args=>args[0]==='test'&&args[1]==='-f'});
  assert.throws(plugin.migration_start);assert.equal(f.plans.length,0);
 });
}
