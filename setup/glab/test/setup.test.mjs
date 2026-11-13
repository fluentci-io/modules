import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture as hostFixture} from '../../../test/setup/host.mjs';
const plugin=createRequire(import.meta.url)('../dist/plugin.cjs');
const version='1.130.0';
function fixture(options={}){
 const os=options.os??'linux',arch=options.arch??'x86_64';
 const asset=`glab_${version}_${os==='macos'?'darwin':'linux'}_${arch==='aarch64'?'arm64':'amd64'}.tar.gz`;
 const archive='https://gitlab.com/api/v4/projects/gitlab-org%2Fcli/packages/generic/glab/'+version+'/'+asset;
 return hostFixture('glab',{input:{version,installDir:'/tmp/glab-managed',...options.input},os,arch,...options,actualVersion:options.actualVersion??version,command:args=>{
  const supplied=options.command?.(args);if(supplied!==undefined)return supplied;
  if(args[0]==='curl'&&!args.includes('--output')){
   const url=args.at(-1);
   if(url.includes('/releases/'))return JSON.stringify({tag_name:'v'+(options.metadataVersion??version),assets:{links:[...(options.noAsset?[]:[{name:asset,url:options.archiveUrl??archive}]),...(options.noChecksum?[]:[{name:'checksums.txt',url:'https://gitlab.com/fixture/checksums.txt'}])]}});
   if(url.endsWith('/checksums.txt')){
    const row=(options.checksum??'a'.repeat(64))+'  '+(options.wrongEntry?'other.tar.gz':asset)+'\n';return options.duplicate?row+row:row;
   }
  }
  if(args[0]==='which')return (os==='netbsd'?'/usr/pkg/bin/':'/usr/local/bin/')+args[1];
  if(args[0]==='find')return options.noExecutable?'':args[1]+'/bin/glab';
  if(args[1]==='version')return 'glab version '+(options.actualVersion??version);
  return undefined;
 }});
}
for(const os of ['linux','macos'])for(const arch of ['x86_64','aarch64'])test(`${os}/${arch}: installs exact official GitLab archive, verifies checksum and publishes PATH`,()=>{
 const f=fixture({os,arch});plugin.setup();const result=JSON.parse(f.output[0]);
 assert.equal(result.tool,'glab');assert.equal(result.version,version);assert.equal(result.binDir,'/tmp/glab-managed/bin');
 assert.ok(f.calls.some(args=>args[0]==='curl'&&args.includes('--output')&&args.at(-1).includes(`_${os==='macos'?'darwin':'linux'}_${arch==='aarch64'?'arm64':'amd64'}.tar.gz`)));
 assert.equal(f.environment.PATH,result.environment.PATH);assert.ok(f.updates.length>0);
});
test('matching PATH installation skips network and mutations for exact or latest versions',()=>{
 for(const requested of ['latest',version]){
  const f=fixture({input:{version:requested}});plugin.setup();assert.equal(JSON.parse(f.output[0]).binDir,'/usr/local/bin');
  assert.ok(!f.calls.some(args=>['curl','mkdir','rm','mv','cp','tar','chmod','ln','pkg','pkg_add','pkgin'].includes(args[0])));
 }
});
test('PATH version mismatch installs the requested release and latest resolves a concrete prefix',()=>{
 let f=fixture({input:{version},command:args=>args[0]==='/usr/local/bin/glab'?'glab version 1.0.0':undefined});plugin.setup();
 assert.ok(f.calls.some(args=>args[0]==='curl'&&args.includes('--output')));
 f=fixture({input:{version:'latest'},command:args=>args[0]==='/usr/local/bin/glab'?(()=>{throw Error('missing');})():undefined});plugin.setup();
 assert.ok(JSON.parse(f.output[0]).binDir.endsWith('/glab/'+version+'/bin'));
});
test('missing assets, absent/invalid/ambiguous checksums and insecure URLs never publish success',()=>{
 for(const options of [{noAsset:true},{noChecksum:true},{checksum:'bad'},{wrongEntry:true},{duplicate:true},{archiveUrl:'http://example.invalid/glab.tar.gz'},{metadataVersion:'9.0.0'}]){
  const f=fixture(options);assert.throws(plugin.setup);assert.equal(f.output.length,0);assert.equal(f.updates.length,0);assert.ok(!f.calls.some(args=>args[0]==='curl'&&args.includes('--output')));
 }
});
test('bad archive, checksum mismatch and wrong installed version clean up and do not publish',()=>{
 for(const options of [{noExecutable:true},{actualDigest:'b'.repeat(64)},{actualVersion:'1.0.0'}]){
  const f=fixture(options);assert.throws(plugin.setup);assert.equal(f.output.length,0);assert.equal(f.updates.length,0);assert.ok(f.calls.some(args=>args[0]==='rm'));
 }
});
test('BSD uses native packages with optional privilege and verifies their installed version',()=>{
 for(const [os,manager]of [['freebsd','pkg'],['openbsd','pkg_add'],['netbsd','pkgin']]){
  const f=fixture({os,input:{version,sudo:true}});plugin.setup();assert.ok(f.calls.some(args=>args[0]==='sudo'&&args[1]==='-n'&&args[2]===manager));
  assert.ok(!f.calls.some(args=>args[0]==='curl'));assert.equal(JSON.parse(f.output[0]).version,version);
 }
});
test('malformed input and unsupported hosts fail before native commands',()=>{
 for(const input of [{version:'../bad'},{version:null},{installDir:'relative'},{unknown:true}]){
  const f=fixture({input});assert.throws(plugin.setup);assert.equal(f.calls.length,0);assert.equal(f.updates.length,0);
 }
 for(const os of ['windows','solaris']){
  const f=fixture({os});assert.throws(plugin.setup,/Unsupported/);assert.equal(f.calls.length,0);
 }
});
