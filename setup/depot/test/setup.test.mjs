import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture as hostFixture} from '../../../test/setup/host.mjs';
const plugin=createRequire(import.meta.url)('../dist/plugin.cjs');
const version='2.103.12';
function fixture(options={}){
 const os=options.os??'linux',arch=options.arch??'x86_64';
 const asset=`depot_${version}_${os==='macos'?'darwin':'linux'}_${arch==='aarch64'?'arm64':'amd64'}.tar.gz`;
 const url='https://github.com/depot/cli/releases/download/v'+version+'/'+asset;
 return hostFixture('depot',{input:{version,installDir:'/tmp/depot-managed',...options.input},os,arch,...options,command:args=>{
  const supplied=options.command?.(args,asset);if(supplied!==undefined)return supplied;
  if(args[0]==='curl'&&!args.includes('--output')){
   if(args.at(-1).includes('api.github.com'))return JSON.stringify({tag_name:'v'+version,assets:[{name:asset,browser_download_url:url,digest:options.noDigest?null:'sha256:'+(options.digest??'a'.repeat(64))},...(options.noChecksum?[]:[{name:`depot_${version}_checksums.txt`,browser_download_url:'https://github.com/depot/cli/checksums.txt',digest:null}])]});
   if(args.at(-1).endsWith('/checksums.txt'))return (options.checksum??'a'.repeat(64))+'  '+(options.wrongChecksumEntry?'other.tar.gz':asset)+'\n';
  }
  if(args[0]==='find')return options.noExecutable?'':args[1]+'/depot';
  if(args[1]==='version'||args.includes('--version'))return 'depot version '+(options.actualVersion??version);
  return undefined;
 }});
}
for(const os of ['linux','macos'])for(const arch of ['x86_64','aarch64'])test(`${os}/${arch}: verifies exact official release and publishes the installed CLI`,()=>{
 const f=fixture({os,arch});plugin.setup();const result=JSON.parse(f.output[0]);
 assert.equal(result.tool,'depot');assert.equal(result.version,version);assert.equal(result.binDir,'/tmp/depot-managed/bin');
 assert.ok(f.calls.some(args=>args[0]==='curl'&&args.includes('--output')&&args.at(-1).includes(`_${os==='macos'?'darwin':'linux'}_${arch==='aarch64'?'arm64':'amd64'}.tar.gz`)));
 assert.equal(f.environment.PATH,result.environment.PATH);assert.ok(f.updates.length>0);
});
test('reuses matching PATH installation without network or filesystem mutation',()=>{
 for(const requested of ['latest',version]){
  const f=fixture({input:{version:requested},actualVersion:version});plugin.setup();
  const result=JSON.parse(f.output[0]);assert.equal(result.version,version);assert.equal(result.binDir,'/usr/local/bin');
  assert.ok(!f.calls.some(args=>['curl','mkdir','rm','mv','cp','tar','chmod','ln'].includes(args[0])));
 }
});
test('an installed version mismatch resolves and installs the explicitly requested release',()=>{
 const f=fixture({input:{version},command:args=>args[0]==='/usr/local/bin/depot'?'depot version 1.0.0':undefined});plugin.setup();
 assert.ok(f.calls.some(args=>args[0]==='curl'&&args.includes('--output')));assert.equal(JSON.parse(f.output[0]).version,version);
});
test('exact release checksum entry is required when GitHub asset digests are unavailable',()=>{
 const f=fixture({noDigest:true});plugin.setup();assert.ok(f.calls.some(args=>args.at(-1).endsWith('/checksums.txt')));
 for(const options of [{noChecksum:true},{wrongChecksumEntry:true},{checksum:'invalid'}]){
  const bad=fixture({noDigest:true,...options});assert.throws(plugin.setup,/checksum|SHA-256/i);assert.equal(bad.output.length,0);assert.equal(bad.updates.length,0);
 }
});
test('checksum mismatch, broken archive and wrong version clean up and never publish success',()=>{
 for(const options of [{digest:'b'.repeat(64)},{noExecutable:true},{actualVersion:'1.0.0'}]){
  const f=fixture(options);assert.throws(plugin.setup);assert.equal(f.output.length,0);assert.equal(f.updates.length,0);assert.ok(f.calls.some(args=>args[0]==='rm'));
 }
});
test('unsupported hosts and malformed inputs fail before native commands',()=>{
 for(const os of ['windows','freebsd','openbsd','netbsd']){
  const f=fixture({os});assert.throws(plugin.setup,/Unsupported|supports Linux and macOS/);assert.equal(f.calls.length,0);assert.equal(f.updates.length,0);
 }
 for(const input of [{version:'../escape'},{version:null},{installDir:'relative'},{unexpected:true}]){
  const f=fixture({input});assert.throws(plugin.setup);assert.equal(f.calls.length,0);assert.equal(f.updates.length,0);
 }
});
