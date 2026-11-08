import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {createRequire} from 'node:module';
import {fixture} from '../setup/host.mjs';

export async function packageSuite(tool, directory) {
 const {setup}=createRequire(import.meta.url)(new URL('dist/plugin.cjs',directory).pathname);
 const {substitute}=await import(new URL('output/CI.Setup.Tools/index.js',directory));
 const definition=JSON.parse(readFileSync(new URL('../../lib/setup/tools.json',import.meta.url))).find(t=>t.name===tool);
 const packages=tool==='pkgx'?['nodejs.org@22.14.0','python.org=3.12.9']:tool==='mise'?['node@22.14.0','npm:prettier@3.5.3']:['nodejs@22.14.0','python3@3.12.9'];
 const packagePath='/tools/node/bin:/usr/bin:/bin';
 const project="/tmp/project ' literal";
 function host(options={}) {
  return fixture(tool,{existing:true,os:options.os??'linux',input:{version:'1.2.3',packages,...options.input},command:args=>{
   if(options.fail?.(args))throw Error('Package fixture failure');
   if(args[0]==='which')return '/usr/local/bin/'+args[1];
   if(args[0]==='curl'&&!args.includes('--output'))return JSON.stringify({tag_name:definition.tagPrefix+'1.2.3',assets:[{name:substitute({os:'linux',arch:'x86_64'})('1.2.3')(definition.asset),browser_download_url:'https://github.com/fixture/tool.tar.gz',digest:null}]});
   if(args[0]==='sh'&&args[3]==='fluentci-probe-exists'&&(args[4].endsWith('/devbox.json')||args[4].endsWith('/.flox')))return options.projectExists?'yes\n':'';
   if(args[0]==='sh'&&args[3]==='fluentci-package-project')return project;
   if(args[0].endsWith('/'+tool)){
    if(args[1]==='version'||args[1]==='--version')return tool+' 1.2.3';
    if(tool==='mise'&&args[1]==='env')return options.environment??JSON.stringify({PATH:packagePath,JAVA_HOME:'/tools/java'});
    if(tool==='pkgx'&&args[1]==='--json')return JSON.stringify({env:{PATH:['/tools/node/bin']},runtime_env:{'nodejs.org':{NODE_EXTRA_CA_CERTS:'{{prefix}}/cert.pem'}}});
    if(args.includes('-c'))return options.environment??('PATH\0'+packagePath+'\0'+(tool==='pkgx'?'NODE_EXTRA_CA_CERTS\0/tools/cert.pem\0':''));
   }
   return undefined;
  }});
 }
 test(tool+': installs exact package selectors and publishes usable executable paths',()=>{
  const f=host({input:['devbox','flox'].includes(tool)?{project}:{}});setup();
  const result=JSON.parse(f.output[0]);assert.equal(result.version,'1.2.3');
  assert.ok(f.environment.PATH.includes('/tools/node/bin'));assert.ok(f.environment.PATH.includes(result.binDir));assert.ok(f.environment.PATH.includes('/usr/bin'));
  const invocation=f.calls.find(a=>a[0].endsWith('/'+tool)&&a.includes(tool==='pkgx'?'--json':tool==='devbox'?'add':'install'));
  assert.ok(invocation);for(const selector of packages)assert.ok(invocation.includes(tool==='pkgx'?'+'+selector:selector));
  if(tool==='pkgx')assert.equal(f.environment.NODE_EXTRA_CA_CERTS,'/tools/cert.pem');
  if(tool==='mise')assert.equal(f.environment.JAVA_HOME,'/tools/java');
  if(tool==='flox')assert.ok(f.calls.some(a=>a.includes('--no-start-services')));
  if(['devbox','flox'].includes(tool))assert.ok(f.calls.some(a=>a.includes('init')&&a.includes(project)));
 });
 test(tool+': rejects malformed package input before any host command',()=>{
  for(const value of [null,'node@22',[42],[''],['--help'],['+node'],['node@'],['node\n@22'],['node;id'],['$(touch injected)'],['node @22']]){
   const f=host({input:{packages:value}});assert.throws(setup);assert.equal(f.calls.length,0);assert.equal(f.updates.length,0);
  }
  if(['devbox','flox'].includes(tool))for(const project of ['', '  ', 'bad\npath', 42]){const f=host({input:{project}});assert.throws(setup);assert.equal(f.calls.length,0);}
 });
 test(tool+': package or environment failure never publishes successful setup',()=>{
  const f=host({fail:args=>args[0].endsWith('/'+tool)&&!['version','--version'].includes(args[1])});
  assert.throws(setup);assert.equal(f.output.length,0);assert.equal(f.updates.length,0);
  for(const environment of [tool==='mise'?'{}':'',tool==='mise'?'not JSON':'BAD-NAME\0value\0']){const h=host({environment});assert.throws(setup);assert.equal(h.updates.length,0);}
 });
 test(tool+': empty lists keep CLI-only setup behavior',()=>{
  const f=host({input:{packages:[]}});setup();assert.equal(f.output.length,1);
  assert.ok(!f.calls.some(a=>['install','add','env','init','activate','--json'].includes(a[1])||a[1]==='--yes'));
 });
 if(['devbox','flox'].includes(tool))test(tool+': reuses an existing project without reinitializing it',()=>{
  const f=host({projectExists:true});setup();assert.ok(!f.calls.some(a=>a[1]==='init'));
 });
 if(tool==='devbox')test('devbox: missing Nix fails before a manager download or project update',()=>{
  const f=host({fail:args=>args[0]==='which'&&args[1]==='nix'});assert.throws(setup,/nix/);
  assert.ok(!f.calls.some(a=>a[0]==='curl'||a[0].endsWith('/devbox')));assert.equal(f.updates.length,0);
 });
 if(tool!=='mise')test(tool+': rejects package environments on BSD before mutations',()=>{
  for(const os of ['freebsd','netbsd','openbsd']){const f=host({os});assert.throws(setup,/Linux and macOS/);assert.equal(f.calls.length,0);}
 });
 test(tool+': typed component accepts a package list and returns its environment',async()=>{
  const native=await import(new URL('output/CI.Component/index.js',directory));
  const {Just,Nothing}=await import(new URL('output/Data.Maybe/index.js',directory));
  const properties=JSON.parse(readFileSync(new URL('schema.json',directory))).exports.setup.input.properties;
  const args=Object.fromEntries(Object.keys(properties).map(key=>[key,Nothing.value]));args.version=new Just('1.2.3');args.packages=new Just(packages);
  host();const result=native.setup(args)();assert.ok(result.environment.some(v=>v.name==='PATH'&&v.value.includes('/tools/node/bin')));
 });
}
