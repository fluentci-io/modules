import '../../../test/dependencies/loader.mjs';
import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {fixture as hostFixture} from '../../../test/cli/host.mjs';
import * as native from '../output/CI.Component/index.js';
import {Just,Nothing} from '../output/Data.Maybe/index.js';
const schema=JSON.parse(readFileSync(new URL('../schema.json',import.meta.url)));
const args=(fn,patch={})=>Object.fromEntries(Object.keys(schema.exports[fn].input.properties).map(key=>[key,Object.hasOwn(patch,key)?(key==='stateDir'?patch[key]:new Just(patch[key])):key==='stateDir'?'/fixture/data':Nothing.value]));
function fixture(options={}){
 const installed=[],definitions=[],states=new Map();let formatted=options.existing??false,f;
 globalThis.fluentciSetupDependencies={'setup-tigerbeetle':input=>{installed.push(input);if(options.installError)throw Error('Installer failed');return {tool:'tigerbeetle',version:input.version,binDir:'/fixture/bin',environment:[]};}};
 f=hostFixture({...options,command:argv=>{
  if(argv[0]==='cat'&&argv[1].startsWith('.fluentci/tigerbeetle/')){
   const task=f.plans.flatMap(p=>p.plan.tasks).findLast(t=>t.file_operation?.op==='write_text');
   if(options.metadata)return JSON.stringify(options.metadata);
   if(!task)throw Error('No ownership metadata');return task.file_operation.text;
  }
  if(argv[0]==='test'&&argv[1]==='-f'){if(!formatted)throw Error('Absent');return '';}
  if(argv[0]==='/fixture/bin/tigerbeetle'&&argv[1]==='format'){formatted=true;return '';}
  if(argv[0]==='mktemp')return '/tmp/fluentci-tigerbeetle.fixture';
  if(argv[0]==='fluentci'&&argv[1]==='services'&&argv[2]==='status')return JSON.stringify([...states.values()]);
  if(argv[0]==='fluentci'&&argv[1]==='services'&&argv[2]==='apply'){
   const data=JSON.parse(argv.at(-1));definitions.push(...data);for(const d of data)states.set(d.name,{name:d.name,backend:d.backend,state:options.state??'ready'});return JSON.stringify({ok:true,services:[...states.values()]});
  }
  if(argv[0]==='fluentci'&&['stop','restart'].includes(argv[1])){states.get(argv[2]).state=argv[1]==='stop'?'stopped':'ready';return '';}
  if(argv[0]==='fluentci'&&argv[1]==='logs')return 'live host logs';
  return undefined;
 }});return {...f,installed,definitions,states};
}
test('TigerBeetle uses the selected prebuilt installer and supervised host service',()=>{
 const f=fixture();const result=native.start(args('start',{version:'0.17.9',port:13000}))();
 assert.deepEqual(f.installed,[{version:'0.17.9'}]);assert.equal(result.backend,'host');assert.equal(result.endpoint,'tigerbeetle://127.0.0.1:13000');
 assert.equal(f.definitions[0].backend,'host');assert.equal(f.definitions[0].command[0],'/fixture/bin/tigerbeetle');assert.equal(f.definitions[0].command.at(-1),'/fixture/data/0_0.tigerbeetle');
 assert.deepEqual(f.definitions[0].readiness,{type:'tcp',address:'127.0.0.1:13000'});assert.ok(f.calls.some(a=>a[1]==='format'));assert.ok(!f.calls.some(a=>['docker','cargo','sh','bash'].includes(a[0])));
});
test('TigerBeetle reuses an unchanged process and preserves existing data across stop/start',()=>{
 const f=fixture({existing:true});native.start(args('start'))();native.start(args('start'))();assert.equal(f.installed.length,1);assert.equal(f.definitions.length,1);
 assert.equal(native.restart(args('restart'))().state,'ready');assert.equal(native.stop(args('stop'))().state,'stopped');assert.equal(native.stop(args('stop'))().port,0);
 native.start(args('start'))();assert.ok(!f.calls.some(a=>a[1]==='format'));assert.ok(!f.calls.some(a=>a[0]==='rm'&&a.includes('/fixture/data')));
});
test('TigerBeetle validates every public input before commands or setup',()=>{
 for(const patch of [{stateDir:'relative'},{stateDir:'/'},{version:'../bad'},{port:0},{cacheGrid:'0MiB'},{extraArgs:'--a,,--b'},{extraArgs:'--addresses=elsewhere'},{name:'foreign'},{startupTimeoutMs:0}]){
  const f=fixture();assert.throws(()=>native.start(args('start',patch))());assert.deepEqual(f.calls,[]);assert.deepEqual(f.installed,[]);
 }
 for(const os of ['freebsd','netbsd','openbsd','windows']){const f=fixture({os});assert.throws(()=>native.start(args('start'))(),/unsupported OS/);assert.deepEqual(f.calls,[]);}
});
test('TigerBeetle failures cannot report readiness and stop only the owned service',()=>{
 let f=fixture({installError:true});assert.throws(()=>native.start(args('start'))(),/Installer failed/);assert.equal(f.definitions.length,0);
 f=fixture({state:'failed'});assert.throws(()=>native.start(args('start'))(),/did not become ready/);assert.ok(f.calls.some(a=>a[0]==='fluentci'&&a[1]==='stop'));
 f=fixture();f.states.set('module-tigerbeetle-default',{name:'module-tigerbeetle-default',backend:'docker',state:'ready'});assert.throws(()=>native.stop(args('stop'))(),/non-host/);assert.equal(f.installed.length,0);
});
test('TigerBeetle log following leaves the background host process running',()=>{
 const f=fixture();native.start(args('start'))();assert.equal(native.logs(args('logs',{follow:true,tail:20}))(),'live host logs');assert.equal(f.states.get('module-tigerbeetle-default').state,'ready');assert.ok(f.calls.some(a=>a[1]==='logs'&&a.at(-1)==='--follow'));
});
