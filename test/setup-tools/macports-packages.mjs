import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {createRequire} from 'node:module';
import {fixture} from '../setup/host.mjs';

export async function macPortsPackageSuite(tool,directory) {
 const {setup}=createRequire(import.meta.url)(new URL('dist/plugin.cjs',directory).pathname);
 const version=tool==='macports'?'2.12.7':'0.1.4';
 function host(options={}) {
  return fixture(tool,{os:options.os??'macos',existing:options.existing??true,input:{version,packages:'git,cmake,python312',...options.input},command:args=>{
   if(options.fail?.(args))throw Error('Port package install failed');
   if(args[0]==='sw_vers')return '15.6.1';
   if(args[0]==='find')return args[1]+'/port';
   if(args[0]==='curl'&&!args.includes('--output'))return JSON.stringify({tag_name:'v'+version,assets:[{name:'port-x86_64-apple-darwin.tar.gz',browser_download_url:'https://github.com/tsirysndr/macports-rs/releases/download/v'+version+'/port-x86_64-apple-darwin.tar.gz',digest:'sha256:'+'a'.repeat(64)}]});
   if(args[0].endsWith('/port')&&['version','--version'].includes(args[1]))return 'port '+version;
   return undefined;
  }});
 }
 for(const sudo of [false,true])test(`${tool}: installs comma-separated ports with sudo=${sudo} and exports package PATH`,()=>{
  const f=host({input:{sudo,packages:' git , cmake , python312 '}});setup();
  const result=JSON.parse(f.output[0]);const executable=result.binDir+'/port';
  const expected=[...(sudo?['sudo','-n']:[]),executable,'-N','install','git','cmake','python312'];
  assert.ok(f.calls.some(args=>JSON.stringify(args)===JSON.stringify(expected)));
  const paths=result.environment.PATH.split(':');
  assert.equal(paths[0],result.binDir);assert.ok(paths.includes('/opt/local/bin'));assert.ok(paths.includes('/opt/local/sbin'));
  assert.equal(f.environment.PATH,result.environment.PATH);
  assert.equal(f.updates.length,1,'only the final environment should be published');
  if(sudo)assert.ok(!f.calls.some(args=>args[0]==='sudo'&&!args.includes('install')));
 });
 if(tool==='macports-rs')test('macports-rs: fresh CLI installation stays unprivileged when packages use sudo',()=>{
  const f=host({existing:false,input:{sudo:true,installDir:'/tmp/port-rs-tool'}});setup();
  const privileged=f.calls.filter(args=>args[0]==='sudo');
  assert.deepEqual(privileged,[['sudo','-n','/tmp/port-rs-tool/bin/port','-N','install','git','cmake','python312']]);
  assert.ok(f.calls.some(args=>args[0]==='curl'&&args.includes('--output')));
  assert.equal(f.updates.length,1);
 });
 test(tool+': rejects invalid package strings before any host command',()=>{
  for(const packages of [null,[],['git'],42,'git,,cmake','git,','--help','git;id','git @1.0','git@1.0','./Portfile','../port','git\ncmake']) {
   const f=host({input:{packages}});assert.throws(setup);assert.equal(f.calls.length,0);assert.equal(f.updates.length,0);
  }
 });
 test(tool+': blank package strings preserve CLI-only setup',()=>{
  for(const packages of ['', '  ']) {
   const f=host({input:{packages}});setup();
   assert.ok(!f.calls.some(args=>args.includes('-N')&&args.includes('install')));
   assert.equal(f.output.length,1);
  }
 });
 test(tool+': permission and port-install errors fail without publishing the setup environment',()=>{
  for(const sudo of [false,true]) {
   const f=host({input:{sudo},fail:args=>args.includes('-N')&&args.includes('install')});
   const before={...f.environment};assert.throws(setup,/Port package install failed/);
   assert.equal(f.output.length,0);assert.equal(f.updates.length,0);assert.deepEqual(f.environment,before);
  }
 });
 test(tool+': rejects package installs on other operating systems before host commands',()=>{
  for(const os of ['linux','freebsd','netbsd','openbsd']){const f=host({os});assert.throws(setup,/macOS-only/);assert.equal(f.calls.length,0);}
 });
 test(tool+': typed component accepts comma-separated ports',async()=>{
  const native=await import(new URL('output/CI.Component/index.js',directory));
  const {Just,Nothing}=await import(new URL('output/Data.Maybe/index.js',directory));
  const properties=JSON.parse(readFileSync(new URL('schema.json',directory))).exports.setup.input.properties;
  const args=Object.fromEntries(Object.keys(properties).map(key=>[key,Nothing.value]));
  args.version=new Just(version);args.packages=new Just('git,cmake');
  const f=host();const result=native.setup(args)();
  assert.ok(f.calls.some(args=>args.includes('install')&&args.includes('git')&&args.includes('cmake')));
  assert.ok(result.environment.some(variable=>variable.name==='PATH'&&variable.value.includes('/opt/local/sbin')));
 });
}
