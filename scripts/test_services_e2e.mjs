// CI-only real component and native service-manager end-to-end verification.
import assert from 'node:assert/strict';
import {readFileSync,writeFileSync,mkdirSync,mkdtempSync,appendFileSync,existsSync,realpathSync,rmSync} from 'node:fs';
import {tmpdir} from 'node:os';
import {join,resolve} from 'node:path';
import {fileURLToPath} from 'node:url';
import {spawnSync} from 'node:child_process';
import net from 'node:net';
import https from 'node:https';
const root=fileURLToPath(new URL('../',import.meta.url));
const profiles=JSON.parse(readFileSync(join(root,'lib/services/catalog.json')));
const logDir=resolve(process.env.SERVICE_LOG_DIR??join(tmpdir(),'fluentci-service-e2e-logs'));
mkdirSync(logDir,{recursive:true});
const workspace=realpathSync(mkdtempSync(join(tmpdir(),'fluentci-services-e2e-')));
writeFileSync(join(workspace,'fluentci.toml'),'# Dedicated native service e2e workspace\n');
const runId=(process.env.GITHUB_RUN_ID??String(process.pid)).replace(/[^A-Za-z0-9_-]/g,'');
const failures=[];
let active;
function command(argv,{cwd=root,timeout=900000,allowFailure=false}={}){
 const result=spawnSync(argv[0],argv.slice(1),{cwd,encoding:'utf8',timeout,maxBuffer:64*1024*1024,env:process.env});
 const file=join(logDir,(active??'bootstrap')+'.log');
 appendFileSync(file,'\n$ '+argv.map(a=>JSON.stringify(a)).join(' ')+'\n'+(result.stdout??'')+(result.stderr??''));
 if(!allowFailure&&(result.error||result.status!==0))throw Error(`${argv[0]} failed (${result.error?.message??result.status}); inspect ${file}`);
 return result;
}
function nativeValue(output){
 const starts=[0];
 for(let index=0;index<output.length;index++)if(output[index]==='\n')starts.push(index+1);
 for(const index of starts.reverse()){
  try{return JSON.parse(output.slice(index));}catch{}
 }
 throw Error('Native component did not return a JSON value');
}
function camel(value){
 if(Array.isArray(value))return value.map(camel);
 if(value&&typeof value==='object')return Object.fromEntries(Object.entries(value).map(([key,item])=>[key.replace(/-([a-z])/g,(_m,c)=>c.toUpperCase()),camel(item)]));
 return value;
}
function invoke(profile,operation,fields={}){
 const argv=['fluentci','run','.',operation,'--project',workspace];
 for(const [key,value]of Object.entries(fields))argv.push('--'+key.replace(/[A-Z]/g,c=>'-'+c.toLowerCase())+'='+String(value));
 return camel(nativeValue(command(argv,{cwd:join(root,'services',profile.name),timeout:operation==='build'?2100000:720000}).stdout));
}
function containers(name){
 const output=command(['docker','ps','--all','--filter','label=io.fluentci.managed=true','--format','{{.ID}} {{.Names}}']).stdout;
 return output.split('\n').filter(line=>line.includes('-'+name+'-')).map(line=>line.split(' ')[0]);
}
function connect(port,request,expected){
 return new Promise((resolvePromise,reject)=>{
  const socket=net.connect({host:'127.0.0.1',port});let data='';
  socket.setTimeout(10000,()=>socket.destroy(Error('Connection timeout')));
  socket.once('error',reject);socket.once('connect',()=>{if(!expected){socket.end();resolvePromise();}else if(request)socket.write(request);});
  socket.on('data',chunk=>{data+=chunk.toString();if(expected.test(data)){socket.end();resolvePromise();}});
  socket.once('close',()=>{if(expected&&!expected.test(data))reject(Error('Unexpected service protocol response: '+data.slice(0,200)));});
 });
}
async function http(url,options={}){
 const response=await fetch(url,{...options,signal:AbortSignal.timeout(10000)});
 assert.equal(response.status,200,url);return response.text();
}
async function connectivity(profile,result,stateDir){
 for(const binding of result.ports){assert.ok(binding.port>0);assert.equal(binding.address,'127.0.0.1:'+binding.port);await connect(binding.port);}
 if(profile.name==='redis')await connect(result.port,'PING\r\n',/PONG/);
 if(['mailpit','mailhog','mailcatcher'].includes(profile.name)){
  await connect(result.port,null,/220/);
  const web=result.ports.find(p=>p.containerPort!==1025);await http('http://127.0.0.1:'+web.port+'/');
 }
 if(profile.probe==='http')await http(result.endpoint+profile.path);
 if(profile.name==='stripe-mock')await http(result.endpoint+'/v1/charges',{headers:{authorization:'Bearer sk_test_123'}});
 if(profile.name==='consul')assert.notEqual(JSON.parse(await http(result.endpoint+'/v1/status/leader')),'');
 if(profile.name==='aws-emulator'){
  const material=join(stateDir,String(result.port));
  for(const file of ['ca.pem','emulator_credentials','config'])assert.ok(existsSync(join(material,file)),file);
  await new Promise((resolvePromise,reject)=>{
   https.get(result.endpoint+'/__admin/health',{ca:readFileSync(join(material,'ca.pem')),timeout:10000},response=>{
    response.resume();response.on('end',()=>{try{assert.equal(response.statusCode,200);resolvePromise();}catch(error){reject(error);}});
   }).on('error',reject).on('timeout',function(){this.destroy(Error('AWS TLS health timeout'));});
  });
 }
}
try{
 command(['fluentci','services','apply','--help']);command(['docker','info']);
 // Build each real Wasm source module and type-check/compose its setup dependency.
 for(const profile of profiles){
  active=profile.name;console.log('Building service component '+active);
  const cwd=join(root,'services',active);
  command(['npm','ci'],{cwd});command(['npm','run','build'],{cwd,timeout:1200000});command(['npm','test'],{cwd});
  command(['node',join(root,'scripts/validate_wasm.mjs'),cwd]);command(['fluentci','run','.','--help'],{cwd});
 }
 for(const profile of profiles){
  active=profile.name;console.log('E2E '+active);
  const name='module-'+profile.name+'-e2e-'+runId;
  const stateDir=join(workspace,'aws-material');const volume='fluentci-services-e2e-'+runId;
  const fields={name,startupTimeoutMs:600000,stopTimeoutMs:10000};let image;
  try{
   if(profile.name==='aws-emulator'){
    image='fluentci/aws-emulator:e2e-'+runId;
    assert.equal(invoke(profile,'build',{image}),image);fields.image=image;fields.stateDir=stateDir;
   }else fields.version=profile.version;
   if(profile.name==='redis')fields.volumes=volume+':/data';
   const started=invoke(profile,'start',fields);assert.equal(started.name,name);assert.equal(started.state,'ready');
   const first=containers(name);assert.equal(first.length,1,'one owned container');
   const same=invoke(profile,'start',fields);assert.equal(same.port,started.port);assert.deepEqual(containers(name),first,'idempotent start must reuse the same container');
   await connectivity(profile,started,stateDir);
   assert.equal(invoke(profile,'status',{name}).state,'ready');
   const logs=invoke(profile,'logs',{name,tail:20});assert.equal(typeof logs,'string');
   const restarted=invoke(profile,'restart',{name});assert.equal(restarted.state,'ready');assert.notDeepEqual(containers(name),first,'restart must replace the container');
   await connectivity(profile,restarted,stateDir);
   assert.equal(invoke(profile,'stop',{name}).state,'stopped');assert.equal(invoke(profile,'stop',{name}).state,'stopped');assert.equal(invoke(profile,'status',{name}).port,0);assert.deepEqual(containers(name),[]);
   if(profile.name==='redis')command(['docker','volume','inspect',volume]);
   console.log(active+' passed');
  }catch(error){failures.push(active);console.error(active+': '+error.message);}
  finally{
   try{invoke(profile,'logs',{name,tail:100});}catch{}
   try{invoke(profile,'stop',{name});}catch(error){failures.push(active+' cleanup');console.error(error.message);}
   if(profile.name==='redis')command(['docker','volume','rm',volume],{allowFailure:true});
   // Only release the exact image used by this test after its owned service stopped.
   command(['docker','image','rm',image??profile.image+':'+profile.version],{allowFailure:true});
  }
 }
}finally{
 command(['fluentci','down'],{cwd:workspace,allowFailure:true});
 // Save only logs/status from the isolated manager, never generated AWS credentials.
 const status=command(['fluentci','services','status','--json'],{cwd:workspace,allowFailure:true});writeFileSync(join(logDir,'final-status.json'),status.stdout??'');
 rmSync(workspace,{recursive:true,force:true});
}
assert.deepEqual(failures,[],'Every service must pass E2E and cleanup');
console.log(profiles.length+' service modules passed real Wasm/native manager E2E');
