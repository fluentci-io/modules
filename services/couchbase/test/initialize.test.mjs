import '../../../test/dependencies/loader.mjs';
import test from 'node:test';
import assert from 'node:assert/strict';
import {Just,Nothing} from '../output/Data.Maybe/index.js';
import {readFileSync} from 'node:fs';
import {fixture} from '../../../test/cli/host.mjs';
// Load component imports only after the dependency resolver hook is registered.
const module=await import('../output/CI.Component/index.js');
const schema=JSON.parse(readFileSync(new URL('../schema.json',import.meta.url)));
const args=(fn,patch={})=>Object.fromEntries(Object.keys(schema.exports[fn].input.properties).map(key=>[key,Object.hasOwn(patch,key)?new Just(patch[key]):Nothing.value]));
function host(options={}){
 globalThis.fluentciSetupDependencies={'setup-docker':()=>{},'setup-curl':()=>{}};
 return fixture({...options,command:argv=>{
  if(argv[1]==='services'&&argv[2]==='status')return JSON.stringify([{name:'module-couchbase-default',backend:'docker',state:'ready',ports:{'8091/tcp':'127.0.0.1:32001','11210/tcp':'127.0.0.1:32002'}}]);
  if(argv[0]==='curl'){
   if(argv.at(-1).endsWith('/pools'))return JSON.stringify({pools:options.initialized?[{name:'default'}]:[]});
   if(argv.at(-1).endsWith('/buckets')&&!argv.includes('--data-urlencode'))return JSON.stringify(options.bucket?[{name:'fluentci_test'}]:[]);
   return '{}';
  }
  return undefined;
 }});
}
test('Couchbase initializes a single KV node, preserves existing clusters and buckets',()=>{
 let f=host();assert.equal(module.initialize(args('initialize'))(),'module-couchbase-default');assert.ok(f.calls.some(a=>a.includes('services=kv')&&a.at(-1).endsWith('/clusterInit')));
 f=host({initialized:true});module.initialize(args('initialize'))();assert.ok(!f.calls.some(a=>a.at(-1).endsWith('/clusterInit')));
 f=host();module.create_bucket(args('create_bucket'))();assert.ok(f.calls.some(a=>a.includes('name=fluentci_test')&&a.includes('flushEnabled=0')));
 f=host({bucket:true});module.create_bucket(args('create_bucket'))();assert.ok(!f.calls.some(a=>a.includes('name=fluentci_test')));
});
test('Couchbase advertises actual runner bindings rather than container ports',()=>{
 const f=host();module.configure_network(args('configure_network'))();const call=f.calls.find(a=>a.includes('PUT'));assert.ok(call.includes('hostname=127.0.0.1'));assert.ok(call.includes('mgmt=32001'));assert.ok(call.includes('kv=32002'));
});
test('Couchbase malformed services, quotas and credentials fail before commands',()=>{
 for(const [fn,patch]of [['initialize',{services:'kv,,index'}],['initialize',{services:'unknown'}],['initialize',{services:'kv,kv'}],['initialize',{memoryQuotaMb:1}],['create_bucket',{bucket:'../bad'}],['create_bucket',{ramQuotaMb:1}],['initialize',{username:'bad:user'}]]){
  const f=host();assert.throws(()=>module[fn](args(fn,patch))());assert.deepEqual(f.calls,[]);
 }
});
