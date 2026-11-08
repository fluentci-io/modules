import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture} from '../../../test/setup/host.mjs';
const {setup}=createRequire(import.meta.url)('../dist/plugin.cjs');

for(const arch of ['x86_64','aarch64'])test(`verifies ${arch} release checksum and links portindex`,()=>{
 const asset=`port-${arch}-apple-darwin.tar.gz`;
 const f=fixture('macports-rs',{os:'macos',arch,input:{version:'0.1.4'},command:args=>{
  if(args[0]==='curl'&&!args.includes('--output')){
   if(args.at(-1).endsWith('.sha256'))return 'a'.repeat(64)+'  '+asset;
   return JSON.stringify({tag_name:'v0.1.4',assets:[{name:asset,browser_download_url:'https://github.com/tsirysndr/macports-rs/releases/download/v0.1.4/'+asset},{name:asset+'.sha256',browser_download_url:'https://github.com/tsirysndr/macports-rs/releases/download/v0.1.4/'+asset+'.sha256'}]});
  }
  if(args[0]==='find')return args[1]+'/port';
  if(args[0].endsWith('/port')&&args[1]==='--version')return 'port-rs 0.1.4';
 }});
 setup();assert.equal(JSON.parse(f.output[0]).version,'0.1.4');
 assert.ok(f.calls.some(a=>a[0]==='ln'&&a[2]==='port'&&a[3].endsWith('/bin/portindex')));
});
test('fails before installation when upstream provides no checksum',()=>{
 const f=fixture('macports-rs',{os:'macos',input:{version:'0.1.4'},command:args=>{
  if(args[0]==='curl'&&!args.includes('--output'))return JSON.stringify({tag_name:'v0.1.4',assets:[{name:'port-x86_64-apple-darwin.tar.gz',browser_download_url:'https://github.com/fixture/port.tar.gz'}]});
 }});
 assert.throws(setup,/checksum/);assert.ok(!f.calls.some(a=>a[0]==='mkdir'));assert.equal(f.updates.length,0);
});
