import '../dependencies/loader.mjs';
import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {fixture as hostFixture} from '../cli/host.mjs';
const profiles=JSON.parse(readFileSync(new URL('../../lib/services/catalog.json',import.meta.url)));
export async function serviceSuite(directory){
 const schema=JSON.parse(readFileSync(new URL('schema.json',directory))),name=schema.name;
 const native=await import(new URL('output/CI.Component/index.js',directory));
 const {Just,Nothing}=await import(new URL('output/Data.Maybe/index.js',directory));
 const p=profiles.find(p=>p.name===name),requirements=JSON.parse(readFileSync(new URL('module-dependencies.json',directory))).requirements;
 const args=fn=>Object.fromEntries(Object.entries(schema.exports[fn].input.properties).map(([key])=>[key,schema.exports[fn].input.required.includes(key)?'/tmp/aws-material':Nothing.value]));
 function fixture(options={}){
  const installed=[],states=new Map(),definitions=[];
  let f;
  globalThis.fluentciSetupDependencies=Object.fromEntries(requirements.map(r=>[r.alias,()=>{installed.push(r.alias);options.install?.(r.alias);} ]));
  f=hostFixture({...options,command:argv=>{
   const custom=options.command?.(argv);if(custom!==undefined)return custom;
   if(argv[0]==='fluentci'&&argv[1]==='services'&&argv[2]==='apply'){
    const list=JSON.parse(argv.at(-1));definitions.push(...list);
    for(const definition of list){
     const ports=Object.fromEntries(definition.ports.map((entry,index)=>{const parts=entry.split(':');return [parts.at(-1)+'/tcp','127.0.0.1:'+(parts.length===2?parts[0]:String(32000+index))];}));
     states.set(definition.name,{name:definition.name,backend:'docker',state:options.state??'ready',ports});
    }
    return options.applyResponse??JSON.stringify({ok:!options.refused,services:[...states.values()],started:list.map(d=>d.name)});
   }
   if(argv[0]==='fluentci'&&argv[1]==='services'&&argv[2]==='status')return options.statusResponse??JSON.stringify([...states.values()]);
   if(argv[0]==='fluentci'&&['stop','restart'].includes(argv[1])){
    const row=states.get(argv[2]);if(!row)throw Error('Unknown service');row.state=argv[1]==='stop'?'stopped':'ready';return row.name+': '+row.state;
   }
   if(argv[0]==='fluentci'&&argv[1]==='logs')return 'bounded native log\n';
   if(argv[0]==='mktemp')return '/tmp/fluentci-aws-image.fixture';
   if(argv[0]==='id')return '1001';
   if(argv[0]==='docker'&&argv[1]==='info')return argv.includes('--format')?'x86_64':'Docker daemon ready';
   return undefined;
  }});
  return {...f,installed,states,definitions};
 }
 test(name+': exposes only typed scalar/CSV args and documented lifecycle functions',()=>{
  for(const key of ['start','stop','restart','status','logs'])assert.ok(schema.exports[key]);
  for(const contract of Object.values(schema.exports))for(const prop of Object.values(contract.input.properties)){
   assert.ok(['string','integer','boolean'].includes(prop.type));assert.ok(prop.description);
  }
 });
 test(name+': start uses native service apply, Docker foreground supervision and real port bindings',()=>{
  const f=fixture();const result=native.start(args('start'))();
  assert.equal(result.state,'ready');assert.equal(result.name,'module-'+name+'-default');assert.ok(result.port>0);assert.ok(result.endpoint.includes('127.0.0.1:'));
  const d=f.definitions[0];assert.equal(d.backend,'docker');assert.equal(d.image,p.image+':'+p.version);assert.deepEqual(d.command,name==='aws-emulator'?['-p','9297']:p.command);
  assert.equal(d.restart,'never');assert.equal(d.max_restarts,0);assert.deepEqual(d.readiness,d.health);assert.ok(d.readiness.type);
  if(p.probe==='http')assert.equal(d.readiness.url,'http://${port:'+p.port+'}'+p.path);
  if(p.probe==='tcp')assert.equal(d.readiness.address,'${port:'+p.port+'}');
  assert.ok(f.calls.some(a=>a[0]==='fluentci'&&a[1]==='services'&&a[2]==='apply'));
  assert.ok(!f.calls.some(a=>a[0]==='docker'&&['run','stop','rm'].includes(a[1])));assert.equal(f.plans.length,0);assert.deepEqual(f.installed,[]);
 });
 if(['http','tcp'].includes(p.probe))test(name+': readiness uses supported explicit port bindings and custom paths',()=>{
  const f=fixture(),mapping=(name==='aws-emulator'?p.port:42000)+':'+p.port;
  native.start({...args('start'),ports:new Just(mapping),readinessPath:new Just('/ci/ready?source=literal'),healthCheck:new Just(false)})();
  const d=f.definitions[0];assert.deepEqual(d.ports,[mapping]);assert.equal(d.health,undefined);
  if(p.probe==='http')assert.equal(d.readiness.url,'http://${port:'+p.port+'}/ci/ready?source=literal');
  else assert.equal(d.readiness.address,'${port:'+p.port+'}');
 });
 test(name+': lifecycle stays scoped, start is idempotent and stop preserves volumes',()=>{
  const f=fixture();native.start({...args('start'),volumes:new Just('test-data:/data')})();native.start({...args('start'),volumes:new Just('test-data:/data')})();
  assert.equal(f.states.size,1);assert.equal(native.status(args('status'))().state,'ready');assert.equal(native.restart(args('restart'))().state,'ready');
  assert.equal(native.logs(args('logs'))(),'bounded native log\n');assert.equal(native.stop(args('stop'))().state,'stopped');assert.equal(native.stop(args('stop'))().port,0);
  assert.ok(f.definitions[0].volumes.includes('test-data:/data'));assert.ok(!f.calls.some(a=>a.includes('down')||a.includes('volume')||a[0]==='rm'));
 });
 test(name+': specific versions and image digests are literal and mutually exclusive',()=>{
  let f=fixture();native.start({...args('start'),version:new Just('test-version')})();assert.equal(f.definitions[0].image,p.image+':test-version');
  const image='registry.example/test@sha256:'+'a'.repeat(64);f=fixture();native.start({...args('start'),image:new Just(image)})();assert.equal(f.definitions[0].image,image);
  f=fixture();assert.throws(()=>native.start({...args('start'),image:new Just(image),version:new Just('1')})());assert.equal(f.calls.length,0);
 });
 test(name+': CSV inputs preserve literal tokens and validate before setup',()=>{
  let f=fixture();native.start({...args('start'),command:new Just('server, "literal,comma", $(touch injected)'),env:new Just('CUSTOM=test'),readinessCommand:new Just('probe,--ready'),dependsOn:Nothing.value})();
  assert.deepEqual(f.definitions[0].command,['server','literal,comma','$(touch injected)']);assert.equal(f.definitions[0].env.CUSTOM,'test');assert.deepEqual(f.definitions[0].readiness.command,['probe','--ready']);
  for(const patch of [{ports:'bad'},{ports:'0'},{ports:p.port+','+p.port},{ports:'99999'},{command:'a,,b'},{env:'BAD KEY=value'},{env:'A=x,A=y'},{dependsOn:'bad/name'},{volumes:'./relative:/data'},{image:'--privileged'},{image:''},{image:'test@sha256:bad'},{version:'bad version'},{restartPolicy:'bad'},{startupTimeoutMs:0},{stopTimeoutMs:0},{maxRestarts:101},{port:-1},{readinessPath:'relative'}]){
   f=fixture();const input={...args('start'),...Object.fromEntries(Object.entries(patch).map(([k,v])=>[k,new Just(v)]))};assert.throws(()=>native.start(input)());assert.equal(f.calls.length,0);assert.equal(f.installed.length,0);
  }
 });
 test(name+': missing prerequisites are installed and rechecked before native startup',()=>{
  const ready=new Set();const f=fixture({install:alias=>ready.add(alias),fail:argv=>requirements.some(r=>!ready.has(r.alias)&&JSON.stringify(argv)===JSON.stringify(r.probe))});
  native.start(args('start'))();assert.deepEqual(f.installed,requirements.map(r=>r.alias));assert.equal(f.definitions.length,1);
 });
 test(name+': unavailable daemon, malformed replies, and failed readiness never return success',()=>{
  for(const options of [{fail:a=>a[0]==='docker'&&a[1]==='info'},{applyResponse:'{'},{applyResponse:'{}'},{applyResponse:'{"ok":"yes","services":[]}'},{applyResponse:'{"ok":true,"services":null}'},{refused:true},{state:'failed'},{state:'running'}]){
   const f=fixture(options);assert.throws(()=>native.start(args('start'))());assert.equal(f.output.length,0);
  }
 });
 test(name+': refuses a non-Docker service with a colliding name before installing or applying',()=>{
  const f=fixture({statusResponse:JSON.stringify([{name:'module-'+name+'-default',state:'stopped',backend:'host',ports:{}}])});
  assert.throws(()=>native.start(args('start'))(),/non-Docker/);assert.equal(f.definitions.length,0);assert.deepEqual(f.installed,[]);
 });
 test(name+': unknown services stay absent and stop is idempotent without Docker',()=>{
  const f=fixture({fail:a=>a[0]==='docker'});assert.equal(native.status(args('status'))().state,'absent');assert.equal(native.stop(args('stop'))().state,'stopped');assert.ok(!f.calls.some(a=>a[0]==='docker'));
 });
 test(name+': foreign names and unsupported OS values cannot mutate services',()=>{
  for(const operation of ['start','stop','restart','status','logs']){
   let f=fixture();assert.throws(()=>native[operation]({...args(operation),name:new Just('unrelated-service')})());assert.equal(f.calls.length,0);
   f=fixture({os:'windows'});assert.throws(()=>native[operation](args(operation))(),/Unsupported/);assert.equal(f.calls.length,0);
  }
 });
 test(name+': log snapshots are bounded and never follow indefinitely',()=>{
  const f=fixture();native.start(args('start'))();native.logs({...args('logs'),tail:new Just(50)})();
  assert.ok(f.calls.some(a=>a[0]==='fluentci'&&a[1]==='logs'&&a.at(-1)==='50'));assert.ok(!f.calls.some(a=>a.includes('--follow')));
  assert.throws(()=>native.logs({...args('logs'),tail:new Just(0)})());
 });
 test(name+': following logs forwards the native flag without changing service lifecycle',()=>{
  const f=fixture();native.start(args('start'))();const before=f.calls.length;
  assert.equal(native.logs({...args('logs'),follow:new Just(true),tail:new Just(20)})(),'bounded native log\n');
  assert.deepEqual(f.calls.slice(before).filter(a=>a[0]==='fluentci'&&a[1]==='logs'),[['fluentci','logs','module-'+name+'-default','--tail','20','--follow']]);
  assert.equal(f.states.get('module-'+name+'-default').state,'ready');assert.equal(f.definitions.length,1);
  assert.ok(!f.calls.slice(before).some(a=>['stop','restart','apply'].includes(a[1])));
  const bad=fixture();assert.throws(()=>native.logs({...args('logs'),follow:new Just('true')})());assert.equal(bad.calls.length,0);
 });
 if(name==='aws-emulator'){
  test('AWS Emulator rejects remapped host ports before setup or host commands',()=>{
   const f=fixture();
   assert.throws(()=>native.start({...args('start'),ports:new Just('42000:'+p.port)})(),/same fixed host and container port/);
   assert.deepEqual(f.calls,[]);assert.deepEqual(f.installed,[]);
  });
  test('AWS Emulator image builder uses official RPMs, native file operations and the correct architecture',()=>{
   const f=fixture();const image=native.build(args('build'))();assert.equal(image,'fluentci/aws-emulator:local');assert.equal(f.plans.length,1);
   const document=JSON.stringify(f.plans[0]);assert.ok(document.includes('downloads.aws.com/aws-emulator'));assert.ok(document.includes('aws-emulator-x86_64.rpm'));assert.ok(document.includes('write_text'));assert.ok(!document.includes('cargo build'));
  });
  test('AWS Emulator validates custom packages before builds and cleans failed post-start checks',()=>{
   let f=fixture();assert.throws(()=>native.build({...args('build'),packageUrl:new Just('https://example.test/pinned.rpm')})());assert.equal(f.calls.length,0);
   f=fixture({fail:a=>a[0]==='curl'&&a.includes('--cacert')});assert.throws(()=>native.start(args('start'))());assert.ok(f.calls.some(a=>a[0]==='fluentci'&&a[1]==='stop'));
  });
 }
}
