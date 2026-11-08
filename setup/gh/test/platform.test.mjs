import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture} from '../../../test/setup/host.mjs';
const {setup}=createRequire(import.meta.url)('../dist/plugin.cjs');
for(const os of ['linux','macos'])for(const arch of ['x86_64','aarch64'])test(`${os}/${arch}: uses the official matching archive and extraction format`,()=>{
 const platform=os==='macos'?'macOS':'linux',cpu=arch==='aarch64'?'arm64':'amd64';
 const asset=`gh_2.103.3_${platform}_${cpu}.${os==='macos'?'zip':'tar.gz'}`;
 const f=fixture('gh',{os,arch,input:{version:'2.103.3'},command:args=>{
  if(args[0]==='which')return '/usr/local/bin/'+args[1];
  if(args[0]==='curl'&&!args.includes('--output'))return JSON.stringify({tag_name:'v2.103.3',assets:[{name:asset,browser_download_url:'https://github.com/cli/cli/releases/download/v2.103.3/'+asset}]});
  if(args[0]==='find')return args[1]+'/gh/bin/gh';
  if(args[0].endsWith('/gh')&&args[1]==='--version')return 'gh version 2.103.3\n';
 }});
 setup();assert.equal(JSON.parse(f.output[0]).version,'2.103.3');assert.ok(f.calls.some(a=>a[0]==='curl'&&a.includes('--output')&&a.at(-1).endsWith(asset)));assert.ok(f.calls.some(a=>a[0]===(os==='macos'?'unzip':'tar')));
});

for(const os of ['freebsd','netbsd','openbsd'])test(`${os}: rejects a custom prefix even when gh is already installed`,()=>{
 const f=fixture('gh',{os,existing:true,input:{installDir:'/tmp/unsupported-prefix'}});assert.throws(setup,/system prefix/);assert.equal(f.calls.length,0);assert.equal(f.output.length,0);
});
