import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture} from '../../../test/setup/host.mjs';
const {setup}=createRequire(import.meta.url)('../dist/plugin.cjs');
function host(options={}){
 const version=options.version??'24.0.6';
 return fixture('nx',{input:{...(options.version?{version}:{}),...options.input},os:options.os??'linux',command:a=>{
  if(a[0]==='which')return '/usr/local/bin/'+a[1];
  if(a[0].endsWith('/nx')&&a[1]==='--version')return options.versionText??`Nx Version:\n- Local: v22.1.0\n- Global: v${version}`;
 }});
}
test('Linux/macOS install the pinned CLI through Bun and publish the verified global version',()=>{
 for(const os of ['linux','macos']){
  const f=host({os});setup();
  assert.ok(f.calls.some(a=>a[0]==='bun'&&a.includes('nx@24.0.6')));
  const result=JSON.parse(f.output[0]);assert.equal(result.version,'24.0.6');assert.equal(f.updates.length,1);
 }
});
test('explicit versions remain literal package selectors',()=>{
 const f=host({version:'23.0.0'});setup();assert.ok(f.calls.some(a=>a[0]==='bun'&&a.includes('nx@23.0.0')));
});
test('a matching local workspace version cannot conceal a wrong installed global version',()=>{
 const f=host({versionText:'Nx Version:\n- Local: v24.0.6\n- Global: v99.0.0'});
 assert.throws(setup,/version mismatch/);assert.equal(f.updates.length,0);assert.equal(f.output.length,0);
});
test('native package version output can be verified without a global version line',()=>{
 const f=host({os:'freebsd',versionText:'24.0.6'});setup();
 assert.ok(f.calls.some(a=>a[0]==='pkg'));assert.equal(JSON.parse(f.output[0]).version,'24.0.6');
});
