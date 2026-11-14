// CI-only real component and native service-manager end-to-end verification.
import assert from 'node:assert/strict';
import {readFileSync,writeFileSync,mkdirSync,mkdtempSync,appendFileSync,existsSync,realpathSync,rmSync} from 'node:fs';
import {tmpdir} from 'node:os';
import {join,resolve} from 'node:path';
import {fileURLToPath} from 'node:url';
import {execFile,spawn,spawnSync} from 'node:child_process';
import net from 'node:net';
import https from 'node:https';
import {runBuildPool,serviceInvocation,serviceOutput} from './services_e2e_helpers.mjs';
const root=fileURLToPath(new URL('../',import.meta.url));
const profiles=JSON.parse(readFileSync(join(root,'lib/services/catalog.json')));
const buildConcurrency=Number(process.env.SERVICE_BUILD_CONCURRENCY??4);
assert.ok(Number.isInteger(buildConcurrency)&&buildConcurrency>=1&&buildConcurrency<=4,'SERVICE_BUILD_CONCURRENCY must be an integer from 1 to 4');
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
 if(!allowFailure&&(result.error||result.status!==0)){
  console.error(((result.stdout??'')+(result.stderr??'')).split('\n').slice(-100).join('\n'));
  throw Error(`${argv.slice(0,3).join(' ')} failed (${result.error?.message??result.status??result.signal}); inspect ${file}`);
 }
 return result;
}
function buildCommand(argv,{cwd,logName,timeout=900000}){
 const file=join(logDir,logName+'.log');
 appendFileSync(file,'\n$ '+argv.map(a=>JSON.stringify(a)).join(' ')+'\n');
 return new Promise((resolvePromise,reject)=>{
  execFile(argv[0],argv.slice(1),{cwd,encoding:'utf8',timeout,maxBuffer:64*1024*1024,env:process.env},(error,stdout,stderr)=>{
   const output=(stdout??'')+(stderr??'');appendFileSync(file,output);
   if(error){
    console.error(logName+': '+output.split('\n').slice(-100).join('\n'));
    reject(Error(`${logName}: ${argv.slice(0,3).join(' ')} failed (${error.message}); inspect ${file}`));
   }else resolvePromise();
  });
 });
}
async function buildServices(){
 // Setup dependencies share source/output directories. Keep their builds and
 // composition serial while independent service compilation runs in parallel.
 console.log('Building service components with concurrency '+buildConcurrency);
 const failed=await runBuildPool(profiles,buildConcurrency,async(profile,serial)=>{
   const cwd=join(root,'services',profile.name);
   const options={cwd,logName:profile.name};
   console.log('Building service component '+profile.name);
   try{
    await buildCommand(['npm','ci'],options);
    await serial(()=>buildCommand(['fluentci','install','--frozen-lockfile'],{...options,timeout:1200000}));
    // Use the same builder as each build.mjs; interfaces are already prepared.
    const source=`import {buildModule} from ${JSON.stringify(new URL('../lib/component/build.mjs',import.meta.url).href)}; await buildModule(process.cwd(),{prepareDependencies:false});`;
    await buildCommand(['node','--input-type=module','--eval',source],{...options,timeout:1200000});
    await buildCommand(['npm','test'],options);
    await buildCommand(['node',join(root,'scripts/validate_wasm.mjs'),cwd],options);
    await serial(()=>buildCommand(['fluentci','run',profile.name,'--help'],{cwd:root,logName:profile.name,timeout:1200000}));
    console.log('Built service component '+profile.name);
   }catch(error){console.error(error.message);throw error;}
 });
 assert.deepEqual(failed.map(({item})=>item.name),[],'Every service component must build before starting E2E');
}
function camel(value){
 if(Array.isArray(value))return value.map(camel);
 if(value&&typeof value==='object')return Object.fromEntries(Object.entries(value).map(([key,item])=>[key.replace(/-([a-z])/g,(_m,c)=>c.toUpperCase()),camel(item)]));
 return value;
}
function invoke(profile,operation,fields={}){
 const argv=serviceInvocation(profile.name,operation,workspace,fields);
 const output=command(argv,{cwd:root,timeout:operation==='build'?2100000:1200000}).stdout;
 try{return camel(serviceOutput(operation,output));}
 catch(error){throw Error(`${profile.name} ${operation}: ${error.message}; inspect ${join(logDir,profile.name+'.log')}`);}
}
async function verifyFollow(profile,name){
 // Exercise the real component stream, then interrupt only its viewer process group.
 const argv=serviceInvocation(profile.name,'logs',workspace,{name,tail:100,follow:true});
 const child=spawn(argv[0],argv.slice(1),{cwd:root,env:process.env,detached:true,stdio:['ignore','pipe','pipe']});
 let output='',interrupted=false,interruptTimer,deadline,killTimer;
 const signal=value=>{if(child.pid)try{process.kill(-child.pid,value);}catch(error){if(error.code!=='ESRCH')throw error;}};
 try{
  await new Promise((resolvePromise,reject)=>{
   const record=chunk=>{
    const text=chunk.toString();appendFileSync(join(logDir,profile.name+'.log'),text);output=(output+text).slice(-65536);
    if(!interruptTimer&&/Ready to accept connections/i.test(output))interruptTimer=setTimeout(()=>{
     interrupted=true;signal('SIGINT');
     killTimer=setTimeout(()=>{signal('SIGKILL');reject(Error('Follow viewer did not exit after interruption'));},10000);
    },300);
   };
   child.stdout.on('data',record);child.stderr.on('data',record);
   child.once('error',reject);
   child.once('close',(code,termination)=>interrupted?resolvePromise():reject(Error(`Follow exited before interruption (${code??termination}): ${output}`)));
   deadline=setTimeout(()=>reject(Error('Follow did not stream Redis readiness logs within 90 seconds')),90000);
  });
 }finally{
  clearTimeout(interruptTimer);clearTimeout(deadline);clearTimeout(killTimer);signal('SIGKILL');
 }
 assert.equal(invoke(profile,'status',{name}).state,'ready','interrupting the viewer must leave the service running');
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
 await buildServices();
 for(const profile of profiles){
  active=profile.name;console.log('E2E '+active);
  const name='module-'+profile.name+'-e2e-'+runId;
  const stateDir=join(workspace,'aws-material');const volume='fluentci-services-e2e-'+runId;
  const fields={name,startupTimeoutMs:600000,stopTimeoutMs:10000};let image,startAttempted=false;
  try{
   if(profile.name==='aws-emulator'){
    image='fluentci/aws-emulator:e2e-'+runId;
    assert.equal(invoke(profile,'build',{image}),image);fields.image=image;fields.stateDir=stateDir;
   }else fields.version=profile.version;
   if(profile.name==='redis')fields.volumes=volume+':/data';
   startAttempted=true;
   const started=invoke(profile,'start',fields);assert.equal(started.name,name);assert.equal(started.state,'ready');
   const first=containers(name);assert.equal(first.length,1,'one owned container');
   const same=invoke(profile,'start',fields);assert.equal(same.port,started.port);assert.deepEqual(containers(name),first,'idempotent start must reuse the same container');
   await connectivity(profile,started,stateDir);
   assert.equal(invoke(profile,'status',{name}).state,'ready');
   const logs=invoke(profile,'logs',{name,tail:20});assert.equal(typeof logs,'string');
   if(profile.name==='redis'){
    await verifyFollow(profile,name);assert.deepEqual(containers(name),first,'following logs must preserve the owned container');
   }
   const restarted=invoke(profile,'restart',{name});assert.equal(restarted.state,'ready');assert.notDeepEqual(containers(name),first,'restart must replace the container');
   await connectivity(profile,restarted,stateDir);
   assert.equal(invoke(profile,'stop',{name}).state,'stopped');assert.equal(invoke(profile,'stop',{name}).state,'stopped');assert.equal(invoke(profile,'status',{name}).port,0);assert.deepEqual(containers(name),[]);
   if(profile.name==='redis')command(['docker','volume','inspect',volume]);
   console.log(active+' passed');
  }catch(error){failures.push(active);console.error(active+': '+error.message);}
  finally{
   if(startAttempted){
    try{invoke(profile,'logs',{name,tail:100});}catch{}
    try{invoke(profile,'stop',{name});}catch(error){failures.push(active+' cleanup');console.error(error.message);}
   }
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
