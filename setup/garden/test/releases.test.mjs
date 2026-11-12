import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture} from '../../../test/setup/host.mjs';
const {setup}=createRequire(import.meta.url)('../dist/plugin.cjs');
function host(options={}){
 const os=options.os??'linux',arch=options.arch??'x86_64',version=options.version??'0.14.20';
 const asset=`garden-${version}-${options.alpine?'alpine':os}-${arch==='aarch64'?'arm64':'amd64'}.tar.gz`;
 const expected=options.missingAsset?'wrong-asset.tar.gz':asset;
 const root='https://github.com/garden-io/garden/releases/download/'+version+'/';
 return fixture('garden',{os,arch,existing:options.existing,actualDigest:options.actualDigest,input:{version:options.requested??version},command:a=>{
  if(a[0]==='which')return '/usr/local/bin/'+a[1];
  if(a[0]==='sh'&&a[3]==='fluentci-probe-exists'&&a[4]==='/etc/alpine-release')return options.alpine?'yes':'';
  if(a[0]==='curl'&&!a.includes('--output')){
   if(a.at(-1).endsWith('.sha256'))return options.checksum??'a'.repeat(64)+'  '+asset;
   return JSON.stringify({tag_name:version,assets:[{name:expected,browser_download_url:root+expected,digest:options.fallback?null:options.digest??'sha256:'+'a'.repeat(64)},...(options.fallback&&!options.noChecksum?[{name:expected+'.sha256',browser_download_url:root+expected+'.sha256',digest:null}]:[])]});
  }
  if(a[0]==='find')return '/home/test/.local/share/fluentci/garden/'+version+'/payload/'+(options.alpine?'alpine':os)+'-'+(arch==='aarch64'?'arm64':'amd64')+'/garden';
  if(a[0].endsWith('/garden')&&a[1]==='--version')return 'garden version '+(options.actualVersion??version);
 }});
}
for(const os of ['linux','macos'])for(const arch of ['x86_64','aarch64'])test(`${os}/${arch}: exact official archive is verified and its adjacent resources are retained`,()=>{
 const f=host({os,arch});setup();
 const asset=`garden-0.14.20-${os}-${arch==='aarch64'?'arm64':'amd64'}.tar.gz`;
 assert.ok(f.calls.some(a=>a[0]==='curl'&&a.includes('--output')&&a.at(-1).endsWith('/'+asset)));
 assert.ok(f.calls.some(a=>a[0]==='ln'&&a[1]==='-s'&&a[2].includes('/payload/'+os+'-')));
 assert.ok(!f.calls.some(a=>a[0]==='cp'));assert.equal(f.updates.length,1);
 assert.equal(JSON.parse(f.output[0]).version,'0.14.20');
});
test('Alpine chooses the musl archive and latest resolves to a concrete release directory',()=>{
 const f=host({alpine:true,requested:'latest'});setup();
 assert.ok(f.calls.some(a=>a[0]==='curl'&&a.includes('--output')&&a.at(-1).endsWith('/garden-0.14.20-alpine-amd64.tar.gz')));
 assert.ok(JSON.parse(f.output[0]).binDir.includes('/garden/0.14.20/bin'));
});
test('adjacent release checksum files are used when GitHub digest metadata is unavailable',()=>{
 const f=host({fallback:true});setup();
 assert.ok(f.calls.some(a=>a[0]==='curl'&&a.at(-1).endsWith('.tar.gz.sha256')));
});
test('unavailable archives, missing or invalid checksums and wrong versions do not publish setup',()=>{
 for(const options of [{missingAsset:true},{fallback:true,noChecksum:true},{fallback:true,checksum:'not-a-digest'},{digest:'sha256:'},{digest:'sha256:'+'b'.repeat(64)},{actualVersion:'99.0.0'}]){
  const f=host(options);assert.throws(setup);assert.equal(f.output.length,0);assert.equal(f.updates.length,0);
 }
});
test('a verified managed installation is reused without downloading an archive',()=>{
 const f=host({existing:true});setup();
 assert.ok(!f.calls.some(a=>a[0]==='curl'&&a.includes('--output')));
 assert.equal(f.updates.length,1);
});
