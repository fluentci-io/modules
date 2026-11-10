import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture} from '../../../test/setup/host.mjs';
const {setup}=createRequire(import.meta.url)('../dist/plugin.cjs');
function host(options={}){
 const os=options.os??'linux',arch=options.arch??'x86_64',version=options.phpVersion??'8.4.7';
 return fixture('php',{os,arch,input:{version:'8.4',...options.input},listing:options.listing,command:(args,stderr,env)=>{
  if(options.fail?.(args))throw Error('Injected PHP setup failure');
  if(args[0]==='curl'&&!args.includes('--output')){
   if(args.at(-1).includes('api.github.com/repos/jdx/mise/'))return JSON.stringify({tag_name:'v2026.10.4',assets:[{name:`mise-v2026.10.4-${os==='darwin'?'macos':os}-${['arm64','aarch64'].includes(arch)?'arm64':'x64'}.tar.gz`,browser_download_url:'https://github.com/jdx/mise/releases/download/v2026.10.4/mise.tar.gz',digest:null}]});
   if(args.at(-1)==='https://composer.github.io/installer.sig')return options.signature??'a'.repeat(96);
  }
  if(args[0]==='find')return args[1]+'/mise/bin/mise';
  if(args[0].endsWith('/mise')&&args[1]==='--version')return 'mise 2026.10.4';
  if(args[0]==='sh'&&args[3]==='fluentci-php'){
   const command=args.slice(6);
   if(command[0]==='latest')return options.resolved??version;
   if(command[0]==='where')return '/fixture/php';
   if(command[0]==='env')return JSON.stringify({PATH:'/fixture/php/bin:/usr/bin:/bin',LD_LIBRARY_PATH:'/fixture/php/lib'});
   return '';
  }
  if(args[1]==='-r'){
   if(args[2]==='echo PHP_VERSION;')return options.actualVersion??version;
   if(args[2].includes('hash_file'))return options.actualSignature??'a'.repeat(96);
   if(args[2].includes('version_compare'))return version.startsWith('5.')||version.startsWith('7.1.')?'yes':'no';
  }
  if(args[0]==='pkg_info'&&args.includes('-e'))return 'php-8.4.7';
  if(args[1]==='--version'&&/\/php\d*$/.test(args[0]))return 'PHP '+version;
  if(args[1]?.endsWith('/composer')&&args.includes('--version'))return 'Composer version '+(options.composerVersion??'2.8.5');
  if(args[1]?.includes('/vendor/bin/')&&args.includes('--version'))return 'Tool version 11.1.0';
  return undefined;
 }});
}
for(const os of ['linux','macos'])for(const arch of ['x86_64','aarch64'])test(`${os}/${arch}: resolves a PHP prefix, verifies it, and publishes Composer`,()=>{
 const f=host({os,arch});setup();const result=JSON.parse(f.output[0]);
 assert.equal(result.version,'8.4.7');assert.equal(result.tool,'php');assert.equal(result.binDir,'/fixture/php/bin');
 assert.ok(f.calls.some(a=>a[0]==='sh'&&a[3]==='fluentci-php'&&a.includes('vfox:jdx/vfox-php@8.4.7')));
 assert.equal(f.environment.LD_LIBRARY_PATH,'/fixture/php/lib');assert.ok(f.environment.PATH.includes('/composer/bin:'));
 assert.equal(f.updates.length,1);
});
test('exact old releases and prereleases are not limited by a hardcoded PHP version list',()=>{
 for(const version of ['5.6.40','7.4.33','8.3.15','8.6.0RC1']){
  const f=host({phpVersion:version,input:{version,tools:'none'}});setup();assert.equal(JSON.parse(f.output[0]).version,version);
  assert.ok(!f.calls.some(a=>a[0]==='curl'&&a.at(-1).includes('composer.github.io')));
 }
});
test('versioned tools have isolated manifests and literal arguments using the selected PHP',()=>{
 const f=host({input:{tools:' composer:2, phpunit:11,phpstan:^2.1,deployer:7 '}});setup();
 const requires=f.calls.filter(a=>a.includes('require'));
 assert.equal(requires.length,3);
 for(const [index,selector]of ['phpunit/phpunit:11','phpstan/phpstan:^2.1','deployer/deployer:7'].entries()){
  assert.equal(requires[index][0],'/fixture/php/bin/php');assert.equal(requires[index].at(-1),selector);
  assert.ok(requires[index].includes('--no-interaction'));assert.ok(requires[index].includes('--no-scripts'));assert.ok(requires[index].includes('--no-plugins'));
 }
 assert.equal(new Set(requires.map(a=>a.find(s=>s.startsWith('--working-dir=')))).size,3);
 for(const call of f.scopedCalls.filter(call=>call.args.includes('require'))){
  const directory=call.args.find(s=>s.startsWith('--working-dir=')).slice('--working-dir='.length);
  assert.equal(call.environment.COMPOSER,'composer.json');
  assert.equal(call.environment.COMPOSER_VENDOR_DIR,directory+'/vendor');
  assert.equal(call.environment.COMPOSER_BIN_DIR,directory+'/vendor/bin');
 }
 for(const name of ['composer/bin','tools/phpunit/vendor/bin','tools/phpstan/vendor/bin','tools/deployer/vendor/bin'])assert.ok(f.environment.PATH.includes(name));
});
test('custom Composer packages use their basename as executable',()=>{
 const f=host({input:{tools:'laravel/pint:1.20.0'}});setup();
 assert.ok(f.calls.some(a=>a.includes('laravel/pint:1.20.0')));
 assert.ok(f.calls.some(a=>a[1]?.endsWith('/vendor/bin/pint')&&a.includes('--version')));
});
test('Composer latest selects the compatible LTS channel for legacy PHP',()=>{
 const f=host({phpVersion:'5.6.40',composerVersion:'2.2.25',input:{version:'5.6'}});setup();
 assert.ok(f.calls.some(a=>a[1]?.endsWith('/composer-setup.php')&&a.includes('--2.2')));
});
test('Composer channels and exact releases are verified using the Composer script version',()=>{
 for(const [requested,reported,selector]of [['1','1.10.27','--1'],['2','2.8.5','--2'],['2.2','2.2.25','--2.2'],['2.8.5','2.8.5','--version=2.8.5']]){
  const f=host({composerVersion:reported,input:{tools:'composer:'+requested}});setup();
  assert.ok(f.calls.some(a=>a[1]?.endsWith('/composer-setup.php')&&a.includes(selector)));
  assert.ok(f.calls.some(a=>a[1]?.endsWith('/composer')&&a.includes('--version')));
  assert.equal(f.updates.length,1);
 }
 for(const [requested,reported]of [['2','1.10.27'],['2.2','2.8.5'],['2.8.5','2.8.6']]){
  const f=host({composerVersion:reported,input:{tools:'composer:'+requested}});
  assert.throws(setup,/Installed Composer version mismatch/);
  assert.equal(f.updates.length,0);assert.equal(f.output.length,0);
 }
});
test('blank tool lists skip module tool installation',()=>{
 for(const tools of ['', '   ', 'none']){
  const f=host({input:{tools}});setup();assert.ok(!f.calls.some(a=>a[0]==='curl'&&a.at(-1)==='https://composer.github.io/installer.sig'));
 }
});
test('malformed fields and tool selectors are rejected before any host command',()=>{
 for(const input of [{unknown:true},{version:null},{version:'../8.4'},{version:'8.4;touch bad'},{installDir:'relative'},{installDir:'/'},{tools:['phpunit']},{tools:'composer,,phpunit'},{tools:'phpunit,'},{tools:'unknown-tool'},{tools:'phpunit:11;id'},{tools:'composer:^2'},{tools:'composer:2.8'},{tools:'phpunit,phpunit:10'},{tools:'../phpunit:11'},{miseVersion:'../bad'},{sudo:'true'}]){
  const f=host({input});assert.throws(setup,undefined,JSON.stringify(input));assert.equal(f.calls.length,0);assert.equal(f.updates.length,0);
 }
});
test('unsupported hosts and native-only options fail before mutations',()=>{
 for(const options of [{os:'windows'},{os:'solaris'},{arch:'riscv64'},{input:{sudo:true}},{input:{packageName:'php84'}},{os:'freebsd',input:{installDir:'/tmp/php'}}]){
  const f=host(options);assert.throws(setup);assert.equal(f.calls.length,0);assert.equal(f.updates.length,0);
 }
});
test('FreeBSD, OpenBSD and NetBSD use native versioned packages and optional elevation',()=>{
 for(const os of ['freebsd','openbsd','netbsd']){
  const f=host({os,input:{version:'8.4',packageName:os==='freebsd'?'php84':os==='openbsd'?'php%8.4':'php84',sudo:true,tools:'none'},listing:'/usr/local/bin/php84\n'});setup();
  assert.ok(f.calls.some(a=>a[0]==='sudo'&&a[1]==='-n'&&['pkg','pkg_add','pkgin'].includes(a[2])));
  assert.ok(f.calls.some(a=>a[0]==='ln'&&a[2]==='/usr/local/bin/php84'));
  assert.ok(!f.calls.some(a=>a[0]==='sh'&&a[3]==='fluentci-php'));assert.equal(f.updates.length,1);
 }
});
test('wrong PHP, invalid signatures, missing prerequisites, and failed tools never publish success',()=>{
 const cases=[{actualVersion:'8.3.9'},{resolved:'not-a-release'},{signature:'bad'},{actualSignature:'b'.repeat(96)},{fail:a=>a[0]==='which'&&a[1]==='make'},{input:{tools:'phpunit'},fail:a=>a.includes('require')},{input:{tools:'phpunit'},fail:a=>a[1]?.includes('/vendor/bin/')&&a.includes('--version')}];
 for(const options of cases){const f=host(options);assert.throws(setup);assert.equal(f.updates.length,0);assert.equal(f.output.length,0);}
});
