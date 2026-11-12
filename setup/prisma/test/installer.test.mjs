import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture} from '../../../test/setup/host.mjs';
const {setup}=createRequire(import.meta.url)('../dist/plugin.cjs');
function host(options={}){
 return fixture('prisma',{...options,input:options.input??{},command:a=>{
  if(a[0]==='which')return '/usr/local/bin/'+a[1];
  if(a[0].endsWith('/prisma')&&a[1]==='--version')return options.actualVersion??'7.8.0';
 }});
}
test('the reviewed default is installed through Bun and verified before PATH publication',()=>{
 for(const os of ['linux','macos']){
  const f=host({os});setup();
  assert.ok(f.calls.some(a=>a[0]==='bun'&&a[1]==='add'&&a.includes('prisma@7.8.0')));
  const result=JSON.parse(f.output[0]);assert.equal(result.version,'7.8.0');
  assert.ok(result.binDir.endsWith('/prisma/7.8.0/bin'));assert.equal(f.updates.length,1);
 }
});
test('an explicit release is preserved as a literal package selector',()=>{
 const f=host({input:{version:'1.2.3'},actualVersion:'1.2.3'});setup();
 assert.ok(f.calls.some(a=>a[0]==='bun'&&a.includes('prisma@1.2.3')));
});
test('wrong versions do not publish successful setup',()=>{
 const f=host({actualVersion:'99.0.0'});assert.throws(setup,/version mismatch/);
 assert.equal(f.updates.length,0);assert.equal(f.output.length,0);
});

test('all BSD hosts are rejected explicitly before installers or native commands',()=>{
 for(const os of ['freebsd','openbsd','netbsd']){
  const f=host({os});assert.throws(setup,/Linux and macOS only/);
  assert.equal(f.calls.length,0);assert.equal(f.updates.length,0);
 }
});
