import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture} from '../../../test/setup/host.mjs';
const {setup}=createRequire(import.meta.url)('../dist/plugin.cjs');
function host(options={}) {
 const os=options.os??'linux',arch=options.arch??'x86_64';
 const target=(os==='macos'?'darwin':'linux')+'-'+(arch==='aarch64'?'arm64':'x64');
 return fixture('xata',{os,arch,input:{version:'1.18.2'},...options,command:args=>{
  if(args[0]==='curl'&&!args.includes('--output'))return JSON.stringify({version:options.manifestVersion??'1.18.2',targets:{[target]:{url:options.url??'https://xata-cli-versions.s3.amazonaws.com/versions/1.18.2-latest/xata-'+target,sha256sum:options.digest??'a'.repeat(64)}}});
  if(args[0].endsWith('/xata')&&args[1]==='--version')return 'xata 1.18.2';
 }});
}
for(const os of ['linux','macos'])for(const arch of ['x86_64','aarch64'])test(`${os}/${arch}: verifies the versioned official binary manifest`,()=>{
 const f=host({os,arch});setup();
 assert.equal(JSON.parse(f.output[0]).version,'1.18.2');
 assert.ok(f.calls.some(a=>a[0]==='curl'&&a.at(-1).includes('/versions/1.18.2-latest/manifest.json')));
 assert.ok(f.calls.some(a=>a[0]==='curl'&&a.includes('--output')&&a.at(-1).endsWith((os==='macos'?'darwin':'linux')+'-'+(arch==='aarch64'?'arm64':'x64'))));
 assert.ok(!f.calls.some(a=>a[0]==='tar'||a[0]==='bun'||a[0]==='npm'));
});
test('manifest mismatches, unsafe URLs, missing checksums, and corrupted binaries fail setup',()=>{
 for(const options of [{manifestVersion:'1.18.3'},{url:'http://example.com/xata'},{url:'https://example.com/xata'},{digest:''},{digest:'b'.repeat(64)}]){
  const f=host(options);assert.throws(setup);assert.equal(f.output.length,0);assert.equal(f.updates.length,0);
 }
});
test('Alpine is rejected before downloading a glibc binary',()=>{
 const f=fixture('xata',{input:{version:'1.18.2'},command:args=>args[0]==='sh'&&args[3]==='fluentci-probe-exists'&&args[4]==='/etc/alpine-release'?'yes':undefined});
 assert.throws(setup,/glibc/);assert.ok(!f.calls.some(a=>a[0]==='curl'));assert.equal(f.updates.length,0);
});
