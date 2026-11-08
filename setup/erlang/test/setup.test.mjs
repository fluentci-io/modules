import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture as host} from '../../../test/setup/host.mjs';
const {setup}=createRequire(import.meta.url)('../dist/plugin.cjs');
const digest='a'.repeat(64);
const versions=['27.3.4','28.3.2','28.3.3','29.0-rc1'];
function fixture(options={}){
 const input={version:'28.3.2',...options.input};
 return host('erlang',{...options,input,command:(argv,stderr)=>{
  const supplied=options.command?.(argv,stderr);if(supplied!==undefined)return supplied;
  if(argv[0]==='sh'&&argv[2]?.includes('/etc/os-release'))return options.distribution??'ubuntu-24.04';
  if(argv[0]==='which')return '/usr/local/bin/'+argv[1];
  if(argv[0]==='brew'&&argv[1]==='--prefix')return '/opt/homebrew/opt/'+argv[2];
  if(argv[0]==='curl'&&!argv.includes('--output'))return argv.at(-1).endsWith('.csv')?'ref_name,ref,datetime,sha256,openssl,wxwidgets\n'+versions.map(v=>'OTP-'+v+',revision,date,'+digest+',openssl,wxwidgets').join('\n'):versions.map(v=>'OTP-'+v+' revision date').join('\n');
  if(argv[0].endsWith('/erl')&&argv.includes('-eval'))return (options.actualVersion??'28.3.2')+'\n';
 }});
}
for(const os of ['linux','macos','darwin'])for(const arch of ['x86_64','aarch64'])test(`${os}/${arch}: installs the matching OTP archive and verifies runtime/compiler`,()=>{
 const f=fixture({os,arch,input:{installDir:'/tmp/otp-fixture'}});setup();const result=JSON.parse(f.output[0]);assert.equal(result.tool,'erlang');assert.equal(result.version,'28.3.2');assert.equal(result.binDir,'/tmp/otp-fixture/bin');
 const url=f.calls.find(a=>a[0]==='curl'&&a.includes('--output')).at(-1);assert.ok(url.includes(os==='linux'?`/${arch==='aarch64'?'arm64':'amd64'}/ubuntu-24.04/OTP-28.3.2.tar.gz`:`OTP-28.3.2-macos-${arch==='aarch64'?'arm64':'amd64'}.tar.gz`));
 assert.equal(f.calls.some(a=>a[0]==='/tmp/otp-fixture/Install'),os==='linux');assert.ok(f.calls.some(a=>a[0]==='test'&&a[2]==='/tmp/otp-fixture/bin/erlc'));assert.ok(f.calls.some(a=>a.includes('-eval')&&a.at(-1).includes('OTP_VERSION')));assert.ok(!f.calls.some(a=>a.includes('--version')));
});
for(const os of ['freebsd','netbsd','openbsd'])test(`${os}: installs native Erlang packages and verifies OTP patch version`,()=>{
 const f=fixture({os,input:{packageName:'erlang-28.3.2',sudo:true}});setup();assert.equal(JSON.parse(f.output[0]).version,'28.3.2');assert.ok(f.calls.some(a=>a[0]==='sudo'&&a.includes({freebsd:'pkg',netbsd:'pkgin',openbsd:'pkg_add'}[os])));assert.ok(!f.calls.some(a=>a[0]==='curl'));assert.ok(f.calls.some(a=>a.includes('-eval')));
});
test('latest and numeric branches resolve stable numeric versions without choosing release candidates',()=>{
 for(const version of ['latest','28','v28','OTP-28']){const f=fixture({input:{version},actualVersion:'28.3.3'});setup();assert.equal(JSON.parse(f.output[0]).version,'28.3.3');}
});
test('unsupported Linux archive families use native packages and macOS can explicitly select a keg-only formula',()=>{
 let f=fixture({distribution:'debian-13'});setup();assert.ok(f.calls.some(a=>a[0]==='apt-get'));assert.ok(!f.calls.some(a=>a[0]==='curl'));
 f=fixture({os:'macos',input:{version:'28',packageName:'erlang@28'},actualVersion:'28.3.3'});setup();assert.equal(JSON.parse(f.output[0]).binDir,'/opt/homebrew/opt/erlang@28/bin');assert.ok(!f.calls.some(a=>a[0]==='curl'));
});
test('invalid configuration and unsupported OS fail before running commands',()=>{
 for(const input of [{version:'../escape'},{unknown:true},{installDir:'relative'},{installDir:'/'},{sudo:'yes'}]){const f=fixture({input});assert.throws(setup);assert.equal(f.calls.length,0);}
 const f=fixture({os:'windows'});assert.throws(setup,/Unsupported/);assert.equal(f.calls.length,0);
});
test('missing versions, native repositories, compilers, and archive checksums never publish success',()=>{
 for(const options of [{input:{version:'999.0'}},{os:'freebsd',fail:a=>a[0]==='pkg'},{os:'macos',actualDigest:'b'.repeat(64)},{fail:a=>a[0]==='test'&&a[2].endsWith('/erlc')}]){const f=fixture(options);assert.throws(setup);assert.equal(f.output.length,0);assert.equal(f.updates.length,0);}
});
test('owned archive failures are cleaned up while pre-existing prefixes are preserved',()=>{
 let f=fixture({input:{installDir:'/tmp/otp-owned'},fail:a=>a[0]==='curl'&&a.includes('--output')});assert.throws(setup);assert.ok(f.calls.some(a=>a[0]==='rm'&&a.at(-1)==='/tmp/otp-owned'));
 f=fixture({input:{installDir:'/tmp/otp-existing'},existing:true,actualVersion:'27.3.4'});assert.throws(setup,/version mismatch/);assert.ok(!f.calls.some(a=>a[0]==='rm'&&a.at(-1)==='/tmp/otp-existing'));
});
