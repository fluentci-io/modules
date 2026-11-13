import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture} from '../../../test/setup/host.mjs';
const tool='spin';
const {setup}=createRequire(import.meta.url)('../dist/plugin.cjs');
function host(options={}){
 const os=options.os??'linux',arch=options.arch??'x86_64';
 const asset=`spin-v4.3.0-${options.alpine?'static-linux':os}-${arch==='aarch64'?'aarch64':'amd64'}.tar.gz`;
 const available=options.missingAsset?'other-architecture.tar.gz':asset;
 return fixture(tool,{os,arch,existing:options.existing,input:{version:options.requested??'4.3.0'},command:a=>{
  if(a[0]==='which')return '/usr/local/bin/'+a[1];
  if(a[0]==='sh'&&a[3]==='fluentci-probe-exists'&&a[4]==='/etc/alpine-release')return options.alpine?'yes':'';
  if(a[0]==='curl'&&!a.includes('--output'))return JSON.stringify({tag_name:'v4.3.0',assets:[{name:available,browser_download_url:'https://github.com/fixture/releases/v4.3.0/'+available,digest:options.digest??'sha256:'+'a'.repeat(64)}]});
  if(a[0]==='find')return '/home/test/.local/share/fluentci/spin/4.3.0/payload/bin/spin';
  if(a[0].endsWith('/spin')&&a[1]==='--version')return tool+' '+(options.actualVersion??'4.3.0');
 }});
}

test('linux/x86_64: selects the exact official archive and preserves payload layout',()=>{
 const f=host({os:'linux',arch:'x86_64'});setup();
 assert.ok(f.calls.some(a=>a[0]==='curl'&&a.includes('--output')&&a.at(-1).endsWith('/spin-v4.3.0-linux-amd64.tar.gz')));
 assert.ok(f.calls.some(a=>a[0]==='ln'&&a[1]==='-s'&&a[2].includes('/payload/')));
 assert.equal(JSON.parse(f.output[0]).version,'4.3.0');assert.equal(f.updates.length,1);
});
test('linux/aarch64: selects the exact official archive and preserves payload layout',()=>{
 const f=host({os:'linux',arch:'aarch64'});setup();
 assert.ok(f.calls.some(a=>a[0]==='curl'&&a.includes('--output')&&a.at(-1).endsWith('/spin-v4.3.0-linux-aarch64.tar.gz')));
 assert.ok(f.calls.some(a=>a[0]==='ln'&&a[1]==='-s'&&a[2].includes('/payload/')));
 assert.equal(JSON.parse(f.output[0]).version,'4.3.0');assert.equal(f.updates.length,1);
});
test('macos/x86_64: selects the exact official archive and preserves payload layout',()=>{
 const f=host({os:'macos',arch:'x86_64'});setup();
 assert.ok(f.calls.some(a=>a[0]==='curl'&&a.includes('--output')&&a.at(-1).endsWith('/spin-v4.3.0-macos-amd64.tar.gz')));
 assert.ok(f.calls.some(a=>a[0]==='ln'&&a[1]==='-s'&&a[2].includes('/payload/')));
 assert.equal(JSON.parse(f.output[0]).version,'4.3.0');assert.equal(f.updates.length,1);
});
test('macos/aarch64: selects the exact official archive and preserves payload layout',()=>{
 const f=host({os:'macos',arch:'aarch64'});setup();
 assert.ok(f.calls.some(a=>a[0]==='curl'&&a.includes('--output')&&a.at(-1).endsWith('/spin-v4.3.0-macos-aarch64.tar.gz')));
 assert.ok(f.calls.some(a=>a[0]==='ln'&&a[1]==='-s'&&a[2].includes('/payload/')));
 assert.equal(JSON.parse(f.output[0]).version,'4.3.0');assert.equal(f.updates.length,1);
});
test('missing archives, corrupt downloads and incorrect versions never activate setup',()=>{
 for(const options of [{missingAsset:true},{digest:'sha256:'+'b'.repeat(64)},{actualVersion:'99.0.0'}]){
  const f=host(options);assert.throws(setup);assert.equal(f.updates.length,0);assert.equal(f.output.length,0);
 }
});
test('latest resolves to a concrete release and cached installations are verified without downloads',()=>{
 const f=host({requested:'latest',existing:true});setup();
 assert.ok(!f.calls.some(a=>a[0]==='curl'&&a.includes('--output')));assert.equal(f.updates.length,1);
});
test('Alpine selects static archives on both supported CPU architectures',()=>{
 for(const arch of ['x86_64','aarch64']){
  const f=host({alpine:true,arch});setup();
  assert.ok(f.calls.some(a=>a[0]==='curl'&&a.includes('--output')&&a.at(-1).includes('-static-linux-')));
 }
});
