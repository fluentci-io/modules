import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture} from '../../../test/setup/host.mjs';
const {setup}=createRequire(import.meta.url)('../dist/plugin.cjs');

function install(options={}) {
 const system=options.system??'15.6.1';
 const platform=system.startsWith('10.')?system.split('.').slice(0,2).join('.'):system.split('.')[0];
 const name=`MacPorts-2.12.7-${platform}-Fixture.pkg`;
 return fixture('macports',{os:'macos',input:{version:'2.12.7',sudo:true,...options.input},...options,command:args=>{
  if(options.fail?.(args))throw Error('Injected failure');
  if(args[0]==='sw_vers')return system;
  if(args[0]==='id')return options.uid??'501';
  if(args[0]==='curl'&&!args.includes('--output'))return JSON.stringify({tag_name:'v2.12.7',assets:options.assets??[{name,browser_download_url:'https://github.com/macports/macports-base/releases/download/v2.12.7/'+name,digest:'sha256:'+'a'.repeat(64)}]});
  if(args[0]==='/opt/local/bin/port')return options.versionOutput??'Version: 2.12.7';
 }});
}
for(const system of ['10.15.7','14.7.2','15.6.1','26.1'])test(`selects the signed native installer for macOS ${system}`,()=>{
 const f=install({system});setup();assert.equal(JSON.parse(f.output[0]).version,'2.12.7');
 assert.ok(f.calls.some(a=>a[0]==='pkgutil'&&a[1]==='--check-signature'));
 assert.ok(f.calls.some(a=>a[0]==='sudo'&&a[1]==='-n'&&a[2]==='installer'));
 assert.equal(f.environment.PATH.split(':')[0],'/opt/local/bin');
});
test('reuses only a verified native MacPorts installation',()=>{
 const f=install({existing:true});setup();assert.ok(!f.calls.some(a=>a[0]==='installer'||a[0]==='sudo'));
 install({existing:true,versionOutput:'Version: 2.12.6'});assert.throws(setup,/mismatch/);
});
test('rejects unsupported hosts and prefix overrides before mutation',()=>{
 for(const os of ['linux','freebsd','openbsd','netbsd']){const f=install({os});assert.throws(setup,/macOS-only/);assert.equal(f.calls.length,0);}
 for(const input of [{version:'../escape'},{installDir:'/tmp/macports'},{packageName:'macports'}]){const f=install({input});assert.throws(setup);assert.equal(f.calls.length,0);}
});
test('requires explicit privileges and verified matching package metadata',()=>{
 for(const options of [{input:{version:'2.12.7'}},{assets:[]},{actualDigest:'b'.repeat(64)},{fail:a=>a[0]==='pkgutil'},{fail:a=>a[0]==='sudo'}]){
  const f=install(options);assert.throws(setup);assert.equal(f.updates.length,0);assert.equal(f.output.length,0);
 }
 const f=install({uid:'0',input:{version:'2.12.7'}});setup();assert.ok(f.calls.some(a=>a[0]==='installer'));assert.ok(!f.calls.some(a=>a[0]==='sudo'));
});
