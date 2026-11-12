import './loader.mjs';
import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture} from '../../../test/setup/host.mjs';
const {setup}=createRequire(import.meta.url)('../dist/plugin.cjs');
const digest='4e4c464f145a7512b57d088ac6c278c03c9eea610886b35a5e0804e74eedf583';
const macDigests={x86_64:'c5a6378ab5cf7e0d5701921405115befff13e9ff7417fb588389338f8bd050f3',aarch64:'835b62a26162b229b441d1f6d4680383815a270809eb33522c0d480fa5002c4e'};
function host(options={}){
 const os=options.os??'linux',arch=options.arch??'x86_64',javaCalls=[];
 globalThis.androidJavaDependency=args=>{
  javaCalls.push(args);if(options.javaFail)throw Error('setup-java failed');
  return {tool:'java',version:options.javaVersion??'21.0.5',binDir:'/fixture/jdk/bin',environment:[{name:'JAVA_HOME',value:'/fixture/jdk'},{name:'PATH',value:'/fixture/jdk/bin:/usr/bin:/bin'}]};
 };
 const f=fixture('android',{os,arch,input:options.input??{},actualDigest:options.digest??(os==='macos'?macDigests[arch]:digest),command:args=>{
  if(options.fail?.(args))throw Error('Injected SDK failure');
  if(args[0]==='sh'&&args[3]==='fluentci-probe-exists')return options.existing?'yes':'';
  if(args[0]==='cat')return args[1]===options.input?.packageFile?(options.packageFileContents??'platform-tools'):(options.marker??(os==='macos'?macDigests[arch]:digest));
  if(args[0].endsWith('/sdkmanager')&&args[1]==='--version')return '23.0';
  if(args[0].endsWith('/sdkmanager')&&args[1]==='--list_installed'){
   const list=value=>typeof value==='string'?value.split(',').map(v=>v.trim()).filter(Boolean):[];
   const input=options.input??{};
   const packages=[...list(input.packages??'platform-tools'),...list(input.apiLevels).map(v=>'platforms;android-'+v),...list(input.buildToolsVersions).map(v=>'build-tools;'+v),...list(input.ndkVersions).map(v=>'ndk;'+v),...list(input.cmakeVersions).map(v=>'cmake;'+v),...list(input.systemImages),...(options.packageFileContents??'').split('\n').filter(Boolean)];
   return options.installedPackages??packages.map(p=>p+' | 1 | fixture').join('\n');
  }
  return undefined;
 }});
 return {...f,javaCalls};
}
for(const [os,arch,asset]of [['linux','x86_64','linux'],['macos','x86_64','mac_x86_64'],['macos','aarch64','mac_arm64']])test(`${os}/${arch}: invokes setup-java 21, verifies archive, and publishes SDK environment`,()=>{
 const f=host({os,arch});setup();assert.deepEqual(f.javaCalls,[{version:'21'}]);
 assert.ok(f.calls.some(a=>a[0]==='curl'&&a.at(-1).endsWith(`commandlinetools-${asset}-15859902_latest.zip`)));
 const result=JSON.parse(f.output[0]);assert.equal(result.javaVersion,'21.0.5');assert.equal(result.version,'23.0');assert.equal(result.sdkRoot,f.environment.ANDROID_HOME);
 assert.equal(f.environment.ANDROID_HOME,f.environment.ANDROID_SDK_ROOT);assert.equal(f.environment.JAVA_HOME,'/fixture/jdk');
 for(const directory of ['/cmdline-tools/latest/bin','/platform-tools','/emulator','/fixture/jdk/bin'])assert.ok(f.environment.PATH.includes(directory));
 assert.equal(f.updates.length,1);
});
test('Java version is forwarded to the real dependency contract',()=>{
 const f=host({input:{javaVersion:'17'},javaVersion:'17.0.12'});setup();assert.deepEqual(f.javaCalls,[{version:'17'}]);assert.equal(JSON.parse(f.output[0]).javaVersion,'17.0.12');
});
test('SDK packages, versions, system images, proxies, channels, and native options are literal tokens',()=>{
 const f=host({input:{sdkRoot:"/tmp/sdk ' literal",packages:' platform-tools,emulator ',apiLevels:'35,36',buildToolsVersions:'36.0.0',ndkVersions:'27.2.12479018',cmakeVersions:'3.22.1',systemImages:'system-images;android-36;google_apis;arm64-v8a',channel:3,proxyType:'http',proxyHost:'proxy.example',proxyPort:8080,sdkManagerArgs:'--verbose'}});setup();
 const args=f.calls.find(a=>a[3]==='fluentci-sdk-input'&&a.includes('--install'));
 for(const token of ["--sdk_root=/tmp/sdk ' literal",'--channel=3','--proxy=http','--proxy_host=proxy.example','--proxy_port=8080','--verbose','platform-tools','emulator','platforms;android-35','platforms;android-36','build-tools;36.0.0','ndk;27.2.12479018','cmake;3.22.1','system-images;android-36;google_apis;arm64-v8a'])assert.ok(args.includes(token),token);
 assert.equal(f.environment.ANDROID_NDK_HOME,"/tmp/sdk ' literal/ndk/27.2.12479018");
 assert.ok(f.environment.PATH.includes('/build-tools/36.0.0'));assert.ok(f.environment.PATH.includes('/cmake/3.22.1/bin'));
 const call=f.scopedCalls.find(c=>c.args===args||c.args.includes('--install'));assert.equal(call.environment.JAVA_HOME,'/fixture/jdk');
});
test('blank package lists can bootstrap SDK tools without package installation',()=>{
 const f=host({input:{packages:'  ',acceptLicenses:false}});setup();assert.ok(!f.calls.some(a=>a[3]==='fluentci-sdk-input'));
});
test('disabled license acceptance uses closed stdin and preserves sdkmanager failures',()=>{
 const f=host({input:{acceptLicenses:false}});setup();
 const command=f.calls.find(a=>a[3]==='fluentci-sdk-input');assert.equal(command[0],'sh');assert.ok(command[2].includes('< /dev/null'));assert.ok(!f.calls.some(a=>a.includes('--licenses')));
 const failed=host({fail:a=>a[3]==='fluentci-sdk-input'&&a.includes('--install')});assert.throws(setup);assert.equal(failed.updates.length,0);
});
test('managed cached command-line tools are reused without downloading',()=>{
 const f=host({existing:true});setup();assert.ok(!f.calls.some(a=>a[0]==='curl'&&a.includes('--output')));
});
test('all unsupported OS values fail explicitly before Java or SDK commands',()=>{
 for(const os of ['windows','freebsd','openbsd','netbsd','solaris']){
  const f=host({os});assert.throws(setup,new RegExp('Unsupported Android SDK OS: '+os));assert.equal(f.calls.length,0);assert.equal(f.javaCalls.length,0);
 }
 for(const [os,arch]of [['linux','aarch64'],['macos','riscv64']]){
  const f=host({os,arch});assert.throws(setup,/Unsupported Android SDK architecture/);assert.equal(f.calls.length,0);assert.equal(f.javaCalls.length,0);
 }
});
test('invalid typed inputs and malformed lists fail before any host commands',()=>{
 for(const input of [{version:'../bad'},{javaVersion:'21;id'},{sdkRoot:'/'},{sdkRoot:'relative'},{packages:['platform-tools']},{packages:'platform-tools,,emulator'},{apiLevels:'36,'},{channel:4},{channel:0.5},{acceptLicenses:null},{proxyHost:'proxy.example'},{proxyType:'http',proxyHost:'host',proxyPort:70000},{sdkManagerArgs:'--sdk_root=/tmp/other'},{archiveUrl:'http://example.com/sdk.zip',archiveSha256:'a'.repeat(64)},{archiveUrl:'https://example.com/sdk.zip'},{unknown:true}]){
  const f=host({input});assert.throws(setup,undefined,JSON.stringify(input));assert.equal(f.calls.length,0);assert.equal(f.javaCalls.length,0);
 }
});
test('Java, checksum, unzip, tool validation, and license failures never publish Android setup',()=>{
 for(const options of [{javaFail:true},{digest:'b'.repeat(64)},{fail:a=>a[0]==='unzip'},{fail:a=>a[0].endsWith('/sdkmanager')&&a[1]==='--version'},{fail:a=>a.includes('--licenses')},{existing:true,marker:'different'}]){
  const f=host(options);assert.throws(setup);assert.equal(f.updates.length,0);assert.equal(f.output.length,0);
 }
});
test('custom archive URL requires and uses its exact SHA-256',()=>{
 const f=host({input:{version:'custom-19',archiveUrl:'https://example.com/tools.zip',archiveSha256:'a'.repeat(64)},digest:'a'.repeat(64)});setup();
 assert.ok(f.calls.some(a=>a[0]==='curl'&&a.at(-1)==='https://example.com/tools.zip'));
});
test('package files are checked before setup-java is invoked',()=>{
 const f=host({input:{packageFile:'missing-packages.txt'},fail:a=>a[0]==='test'&&a[1]==='-f'&&a[2]==='missing-packages.txt'});
 assert.throws(setup);assert.equal(f.javaCalls.length,0);assert.equal(f.updates.length,0);
});
test('successful sdkmanager exits cannot hide missing packages or unaccepted licenses',()=>{
 const f=host({installedPackages:'',input:{acceptLicenses:false}});
 assert.throws(setup,/SDK package missing after installation/);assert.equal(f.updates.length,0);assert.equal(f.output.length,0);
 const file=host({input:{packages:'',packageFile:'packages.txt'},packageFileContents:'platforms;android-36\nbuild-tools;36.0.0'});setup();
 assert.ok(file.calls.some(a=>a.includes('--install')&&a.includes('platforms;android-36')&&a.includes('build-tools;36.0.0')));
});
test('typed component forwards named SDK options and returns SDK and Java information',async()=>{
 const native=await import('../output/CI.Component/index.js');
 const {Just,Nothing}=await import('../output/Data.Maybe/index.js');
 const {readFileSync}=await import('node:fs');
 const schema=JSON.parse(readFileSync(new URL('../schema.json',import.meta.url)));
 const input=Object.fromEntries(Object.keys(schema.exports.setup.input.properties).map(k=>[k,Nothing.value]));
 input.javaVersion=new Just('25');input.apiLevels=new Just('36');
 const f=host({javaVersion:'25.0.1'});const result=native.setup(input)();
 assert.deepEqual(f.javaCalls,[{version:'25'}]);assert.equal(result.javaVersion,'25.0.1');assert.ok(result.sdkRoot.startsWith('/'));
 assert.ok(result.environment.some(v=>v.name==='ANDROID_HOME'&&v.value===result.sdkRoot));assert.equal(f.output.length,0);
});
