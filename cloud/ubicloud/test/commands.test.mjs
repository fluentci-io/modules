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
const inventory=JSON.parse(readFileSync(new URL('../upstream-commands.json',import.meta.url)));
const catalog=JSON.parse(readFileSync(new URL('../../../lib/cli/catalog.json',import.meta.url)));
const tool=catalog.find(tool=>tool.name==='ubicloud');
function invoke(name,input={},options={}){
 const f=fixture({input:{runDir:'/tmp/ubi-fixture',...input},...options});plugin[name]();return f;
}
const argv=(name,input)=>invoke(name,input).plans[0].plan.tasks[0].args;
const required=command=>Object.fromEntries(command.fields.filter(f=>f.required).map(f=>[f.key,f.sample]));
const typed=(name,values)=>Object.fromEntries(Object.keys(schema.exports[name].input.properties).map(key=>[key,key==='runDir'?'/tmp/ubi-typed':schema.exports[name].input.required.includes(key)?values[key]:Object.hasOwn(values,key)?new Just(values[key]):Nothing.value]));

test('every reviewed upstream executable command has a typed named export',()=>{
 assert.equal(inventory.commands.length,123);
 const names=['run',...inventory.commands.map(command=>command.function)].sort();
 assert.deepEqual(Object.keys(plugin).sort(),names);
 assert.deepEqual(Object.keys(component).sort(),names);
 assert.deepEqual(Object.keys(schema.exports).sort(),names);
 assert.equal(new Set(inventory.commands.map(command=>command.source)).size,123);
});
test('resource references precede native post commands at every group depth',()=>{
 for(const record of inventory.commands.filter(command=>command.resourceBeforeCommand)){
  const command=tool.commands.find(command=>command.name===record.function);
  const input={...required(command),resource:'literal-resource'};
  const args=argv(record.function,input);
  const expected=[...record.args];expected.splice(-1,0,'literal-resource');
  assert.deepEqual(args.slice(0,expected.length),expected,record.function);
 }
 assert.deepEqual(argv('ai_api_key_show',{resource:'ak123'}),['ai','api-key','ak123','show']);
 assert.deepEqual(argv('gh_installation_list_repositories',{resource:'my-installation'}),['gh','installation','my-installation','list-repositories']);
});
test('VM creation, listing and lifecycle use named arguments without approving destruction',()=>{
 assert.deepEqual(argv('vm_create',{resource:'eu-central-h1/build',publicKey:'ci-key',size:'standard-2',ipv6Only:true}),['vm','eu-central-h1/build','create','--ipv6-only','--size=standard-2','ci-key']);
 assert.deepEqual(argv('vm_list',{fields:'name, id,ip4',location:'eu-central-h1',noHeaders:true}),['vm','list','--fields=name,id,ip4','--location=eu-central-h1','--no-headers']);
 assert.deepEqual(argv('vm_destroy',{resource:'eu-central-h1/build'}),['vm','eu-central-h1/build','destroy']);
 assert.deepEqual(argv('vm_destroy',{resource:'eu-central-h1/build',confirm:'build'}),['--confirm=build','vm','eu-central-h1/build','destroy']);
 assert.deepEqual(argv('vm_destroy',{resource:'eu-central-h1/build',force:true}),['vm','eu-central-h1/build','destroy','--force']);
});
test('firewall, load balancer, nodepool and private-subnet operands preserve native ordering',()=>{
 assert.deepEqual(argv('fw_add_rule',{resource:'eu-central-h1/fw',cidr:'10.0.0.0/8',startPort:0,endPort:443,protocol:'tcp'}),['fw','eu-central-h1/fw','add-rule','--start-port=0','--end-port=443','--protocol=tcp','10.0.0.0/8']);
 assert.deepEqual(argv('lb_update',{resource:'eu-central-h1/lb',algorithm:'round_robin',sourcePort:443,destinationPort:8080,healthCheckEndpoint:'/health',certificateEnabled:false,vms:'vm-a, vm-b'}),['lb','eu-central-h1/lb','update','round_robin','443','8080','/health','false','vm-a','vm-b']);
 assert.deepEqual(argv('kc_resize_nodepool',{resource:'eu-central-h1/cluster',nodepool:'workers',count:3}),['kc','eu-central-h1/cluster','resize-nodepool','workers','3']);
 assert.deepEqual(argv('ps_connect',{resource:'eu-central-h1/one',subnet:'two'}),['ps','eu-central-h1/one','connect','two']);
});
test('PostgreSQL configurations use CSV flags or positional assignments as required',()=>{
 assert.deepEqual(argv('pg_create',{resource:'eu-central-h1/db',pgConfig:'work_mem=64MB, max_connections=100',tags:'team=ci,env=test'}),['pg','eu-central-h1/db','create','--pg-config=work_mem=64MB,max_connections=100','--tags=team=ci,env=test']);
 assert.deepEqual(argv('pg_add_config_entries',{resource:'eu-central-h1/db',entries:'work_mem=64MB, max_connections=100'}),['pg','eu-central-h1/db','add-config-entries','work_mem=64MB','max_connections=100']);
 assert.deepEqual(argv('pg_set_maintenance_window',{resource:'eu-central-h1/db',startHour:0,days:'mon, wed,fri'}),['pg','eu-central-h1/db','set-maintenance-window','--days=mon,wed,fri','0']);
 assert.deepEqual(argv('pg_add_syslog_log_destination',{resource:'eu-central-h1/db',name:'logs',host:'log.example',port:6514,structuredData:'meta/env=ci,meta/team=platform'}),['pg','eu-central-h1/db','add-syslog-log-destination','logs','log.example','6514','meta/env=ci','meta/team=platform']);
});
test('SSH, SCP and PostgreSQL client overrides precede their native client command',()=>{
 assert.deepEqual(argv('vm_ssh',{resource:'eu-central-h1/build',ipv4:true,user:'runner',arguments:'-o,BatchMode=yes,--,uname,-a'}),['vm','eu-central-h1/build','--ip4','--user','runner','ssh','-o','BatchMode=yes','--','uname','-a']);
 assert.deepEqual(argv('vm_scp',{resource:'eu-central-h1/build',source:'artifact.tar.gz',destination:':artifact.tar.gz',clientArguments:'-q,-P,22'}),['vm','eu-central-h1/build','scp','-q','-P','22','artifact.tar.gz',':artifact.tar.gz']);
 assert.deepEqual(argv('pg_pg_dump',{resource:'eu-central-h1/db',database:'app',username:'reader',arguments:'--format=custom,--file,dump.backup'}),['pg','eu-central-h1/db','--dbname=app','--username=reader','pg_dump','--format=custom','--file','dump.backup']);
});
test('all functions require UBI_TOKEN before any setup, native command or API operation',()=>{
 let installed=false;globalThis.fluentciSetupDependencies={'setup-ubicloud':()=>{installed=true;}};
 for(const command of tool.commands)for(const token of [undefined,'','   ']){
  const f=fixture({input:{runDir:'/tmp/ubi-token-required',...required(command)},env:{UBI_TOKEN:token}});
  assert.throws(plugin[command.name],/UBI_TOKEN/,command.name);
  assert.equal(f.calls.length,0);assert.equal(f.plans.length,0);assert.equal(installed,false);
 }
});
test('invalid resource references, CSV lists and configuration assignments fail before host commands',()=>{
 for(const [name,input]of [['vm_show',{resource:'--force'}],['vm_list',{fields:'name,,id'}],['vm_list',{fields:['name']}],['run',{arguments:['vm','list']}],['pg_add_config_entries',{resource:'eu-central-h1/db',entries:'not-an-assignment'}],['pg_create',{resource:'eu-central-h1/db',pgConfig:'bad key=value'}],['pg_create',{resource:'eu-central-h1/db',pgConfig:'key=value,,other=x'}]]){
  const f=fixture({input:{runDir:'/tmp/ubi-invalid',...input}});assert.throws(plugin[name]);assert.equal(f.calls.length,0);
 }
 assert.deepEqual(argv('vm_list',{fields:''}),['vm','list']);
});
test('typed named commands use setup-ubicloud and return report and native output paths',()=>{
 let available=false;globalThis.fluentciSetupDependencies={'setup-ubicloud':()=>{available=true;}};
 const f=fixture({fail:a=>a[0]==='which'&&a[1]==='ubi'&&!available,env:{UBI_TOKEN:'synthetic-ubi-token'}});
 const result=component.vm_show(typed('vm_show',{resource:'eu-central-h1/build',fields:'name,id'}))();
 assert.equal(available,true);assert.equal(result.outcome,'succeeded');assert.equal(result.reportPath,'/tmp/ubi-typed/result.json');
 assert.deepEqual(f.plans[0].plan.tasks[0].args,['vm','eu-central-h1/build','show','--fields=name,id']);
 assert.equal(f.plans[0].plan.inherit_env,true);assert.ok(!JSON.stringify(f.plans).includes('synthetic-ubi-token'));
});
test('native failures do not publish successful resource operations',()=>{
 const f=fixture({input:{runDir:'/tmp/ubi-failed',resource:'eu-central-h1/build'},outcome:'failed'});
 assert.throws(plugin.vm_restart,/failed/);assert.equal(f.output.length,0);
});
