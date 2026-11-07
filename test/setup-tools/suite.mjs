import test from 'node:test';
import assert from 'node:assert/strict';
import { createRequire } from 'node:module';
import { readFileSync } from 'node:fs';
import { dirname } from 'node:path';
import { fixture as hostFixture } from '../setup/host.mjs';

const tools=JSON.parse(readFileSync(new URL('../../lib/setup/tools.json',import.meta.url)));
export async function suite(name,directory){
 const tool=tools.find(t=>t.name===name);assert.ok(tool);
 const plugin=createRequire(import.meta.url)(new URL('dist/plugin.cjs',directory).pathname);
 const {substitute}=await import(new URL('output/CI.Setup.Tools/index.js',directory));
 const version=name==='aws'?'2.2.3':name==='binaryen'?'125':tool.defaultVersion==='stable'?'stable':tool.defaultVersion==='latest'?'1.2.3':tool.defaultVersion;
 function fixture(options={}){
  const os=options.os??'linux',arch=options.arch??'x86_64';
  const normalized={os:os==='darwin'?'macos':os,arch:['arm64','aarch64'].includes(arch)?'aarch64':'x86_64'};
  const actual=options.actualVersion??(version==='stable'?'1.2.3':version);
  return hostFixture(name,{input:{version,...options.input},os,arch,...options,command:(args,stderr)=>{
   const injected=options.command?.(args,stderr);if(injected!==undefined)return injected;
   if(options.fail?.(args))throw Error('Injected failure');
   if(args[0]==='which')return '/usr/local/bin/'+args[1];
   if(args[0]==='dirname')return dirname(args[1]);
   if(args[0]==='find')return options.matches??args[1]+'/package/bin/'+tool.program;
   if(args[0]==='curl'&&!args.includes('--output')){
    const url=args.at(-1);
    if(url.includes('api.github.com')){
     const selected=tools.find(t=>t.repository&&url.includes('/repos/'+t.repository+'/'))??tool;
     const releaseVersion=selected.name==='binaryen'?'125':actual;
     return JSON.stringify({tag_name:selected.tagPrefix+releaseVersion,assets:[{name:substitute(normalized)(releaseVersion)(selected.asset),browser_download_url:'https://github.com/fixture/tool.tar.gz',digest:options.digest??null}]});
    }
    if(url.includes('clojure')||url.includes('stable.txt'))return actual;
   }
   if(args[0]==='go'&&args[1]==='version')return 'binary: go1.25\n\tmod\t'+tool.package+'\tv'+actual+'\thash\n';
   if(args[0].endsWith('/wasm-opt'))return 'wasm-opt version 125';
   if(args.includes('--version')||args.includes('-version')||args.includes('-Sdescribe')||args[1]==='version'||(args[0].endsWith('/'+tool.program)&&tool.checkVersion))return tool.program+' '+actual;
   return undefined;
  }});
 }
 test(name+': installs, verifies, and publishes PATH on Linux/macOS',()=>{
  for(const os of ['linux','macos','darwin']){
   if(['dpkg','rpmbuild'].includes(name)&&os!=='linux')continue;
   const f=fixture({os});plugin.setup();const result=JSON.parse(f.output[0]);
   assert.equal(result.tool,name==='nix-package'?'nix':name);
   assert.ok(result.binDir.startsWith('/'));
   assert.equal(f.environment.PATH,result.environment.PATH);
   assert.ok(f.updates.length>0);
  }
 });
 test(name+': uses native BSD repositories or rejects Linux-only/Nix tools',()=>{
  for(const os of ['freebsd','openbsd','netbsd']){
   const f=fixture({os});
   if(['dpkg','rpmbuild','nix-package'].includes(name)){assert.throws(plugin.setup,/Linux/);continue;}
   plugin.setup();assert.ok(f.calls.some(a=>['pkg','pkg_add','pkgin'].includes(a[0])));
   assert.ok(!f.calls.some(a=>a[0]==='curl'));
  }
 });
 test(name+': rejects invalid inputs and unsupported OS before mutations',()=>{
  for(const input of [{unknown:true},{version:null},{version:'../escape'},{installDir:'relative'},{installDir:'/'},{installDir:'/tmp/../bad'},{sudo:'true'},{packageName:'--force'}]){
   const f=fixture({input});assert.throws(plugin.setup);assert.equal(f.calls.length,0);assert.equal(f.updates.length,0);
  }
  for(const os of ['windows','solaris']){const f=fixture({os});assert.throws(plugin.setup,/Unsupported/);assert.equal(f.calls.length,0);}
 });
 test(name+': failures never publish a successful setup',()=>{
  const f=fixture({fail:args=>args[0]==='which'});assert.throws(plugin.setup);assert.equal(f.output.length,0);assert.equal(f.updates.length,0);
 });
 if(!['native','nix','rustfmt','aws'].includes(tool.backend))test(name+': reuses a verified existing per-user installation',()=>{
  const f=fixture({existing:true,input:{installDir:"/tmp/tool ' literal"}});plugin.setup();assert.ok(!f.calls.some(a=>a[0]==='curl'&&a.includes('--output')));
 });
 if(tool.backend==='github')test(name+': rejects wrong archives and cleans up failed installations',()=>{
  for(const options of [...(['raw','gz'].includes(tool.format)?[]:[{matches:''}]),{digest:'sha256:'+'b'.repeat(64)}]){
   const f=fixture(options);assert.throws(plugin.setup);assert.ok(f.calls.some(a=>a[0]==='rm'));assert.equal(f.updates.length,0);
  }
 });
}
