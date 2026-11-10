import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture} from '../../../test/setup/host.mjs';
const {setup}=createRequire(import.meta.url)('../dist/plugin.cjs');
function host(os,arch,options={}){
 const asset=`pgroll.${os}.${arch==='aarch64'?'arm64':'amd64'}`;
 return fixture('pgroll',{os,arch,input:{version:'0.16.3'},...options,command:args=>{
  if(args[0]==='curl'&&!args.includes('--output'))return JSON.stringify({tag_name:'v0.16.3',assets:[{name:options.asset??asset,browser_download_url:'https://github.com/xataio/pgroll/releases/download/v0.16.3/'+asset,digest:options.digest??'sha256:'+'a'.repeat(64)}]});
  if(args[0].endsWith('/pgroll')&&args[1]==='--version')return 'pgroll version '+(options.actualVersion??'0.16.3');
 }});
}
for(const os of ['linux','macos'])for(const arch of ['x86_64','aarch64'])test(`${os}/${arch}: selects and verifies the official standalone pgroll binary`,()=>{
 const f=host(os,arch);setup();assert.equal(JSON.parse(f.output[0]).version,'0.16.3');
 assert.ok(f.calls.some(a=>a[0]==='curl'&&!a.includes('--output')&&a.at(-1).endsWith('/tags/v0.16.3')));
 assert.ok(f.calls.some(a=>a[0]==='curl'&&a.includes('--output')&&a.at(-1).endsWith(`pgroll.${os}.${arch==='aarch64'?'arm64':'amd64'}`)));
 assert.ok(!f.calls.some(a=>['tar','unzip','go','bun','npm'].includes(a[0])));
});
test('missing assets, corrupt downloads, and wrong versions never activate setup',()=>{
 for(const options of [{asset:'pgroll.win.amd64.exe'},{digest:'sha256:'+'b'.repeat(64)},{actualVersion:'0.17.0'}]){
  const f=host('linux','x86_64',options);assert.throws(setup);assert.equal(f.updates.length,0);assert.equal(f.output.length,0);
 }
});
