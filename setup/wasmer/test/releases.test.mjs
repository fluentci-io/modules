import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture} from '../../../test/setup/host.mjs';
const tool='wasmer';
const {setup}=createRequire(import.meta.url)('../dist/plugin.cjs');
function host(options={}){
 const os=options.os??'linux',arch=options.arch??'x86_64';
 const asset=`wasmer-${os==='macos'?'darwin':'linux'}-${arch==='aarch64'?(os==='macos'?'arm64':'aarch64'):'amd64'}.tar.gz`;
 const available=options.missingAsset?'other-architecture.tar.gz':asset;
 return fixture(tool,{os,arch,existing:options.existing,input:{version:options.requested??'7.5.0'},command:a=>{
  if(a[0]==='which')return '/usr/local/bin/'+a[1];
  if(a[0]==='sh'&&a[3]==='fluentci-probe-exists'&&a[4]==='/etc/alpine-release')return options.alpine?'yes':'';
  if(a[0]==='curl'&&!a.includes('--output'))return JSON.stringify({tag_name:'v7.5.0',assets:[{name:available,browser_download_url:'https://github.com/fixture/releases/v7.5.0/'+available,digest:options.digest??'sha256:'+'a'.repeat(64)}]});
  if(a[0]==='find')return '/home/test/.local/share/fluentci/wasmer/7.5.0/payload/bin/wasmer';
  if(a[0].endsWith('/wasmer')&&a[1]==='--version')return tool+' '+(options.actualVersion??'7.5.0');
 }});
}

test('linux/x86_64: selects the exact official archive and preserves payload layout',()=>{
 const f=host({os:'linux',arch:'x86_64'});setup();
 assert.ok(f.calls.some(a=>a[0]==='curl'&&a.includes('--output')&&a.at(-1).endsWith('/wasmer-linux-amd64.tar.gz')));
 assert.ok(f.calls.some(a=>a[0]==='ln'&&a[1]==='-s'&&a[2].includes('/payload/')));
 assert.equal(JSON.parse(f.output[0]).version,'7.5.0');assert.equal(f.updates.length,1);
});
test('linux/aarch64: selects the exact official archive and preserves payload layout',()=>{
 const f=host({os:'linux',arch:'aarch64'});setup();
 assert.ok(f.calls.some(a=>a[0]==='curl'&&a.includes('--output')&&a.at(-1).endsWith('/wasmer-linux-aarch64.tar.gz')));
 assert.ok(f.calls.some(a=>a[0]==='ln'&&a[1]==='-s'&&a[2].includes('/payload/')));
 assert.equal(JSON.parse(f.output[0]).version,'7.5.0');assert.equal(f.updates.length,1);
});
test('macos/aarch64: selects the exact official archive and preserves payload layout',()=>{
 const f=host({os:'macos',arch:'aarch64'});setup();
 assert.ok(f.calls.some(a=>a[0]==='curl'&&a.includes('--output')&&a.at(-1).endsWith('/wasmer-darwin-arm64.tar.gz')));
 assert.ok(f.calls.some(a=>a[0]==='ln'&&a[1]==='-s'&&a[2].includes('/payload/')));
 assert.equal(JSON.parse(f.output[0]).version,'7.5.0');assert.equal(f.updates.length,1);
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
test('a release missing an Intel macOS archive fails instead of substituting another CPU',()=>{
 const f=host({os:'macos',arch:'x86_64',missingAsset:true});
 assert.throws(setup,/No official wasmer asset/);assert.equal(f.updates.length,0);
});
