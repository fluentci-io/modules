import '../dependencies/loader.mjs';
import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {fixture} from '../cli/host.mjs';

export async function containerSetupSuite(directory) {
 const schema=JSON.parse(readFileSync(new URL('schema.json',directory)));
 const native=await import(new URL('output/CI.Component/index.js',directory));
 const {Just,Nothing}=await import(new URL('output/Data.Maybe/index.js',directory));
 const spec=JSON.parse(readFileSync(new URL('module-dependencies.json',directory)));
 const input=name=>Object.fromEntries(Object.entries(schema.exports[name].input.properties).map(([key,prop])=>[key,schema.exports[name].input.required.includes(key)?(key==='runDir'?'/tmp/container-test':prop.default??(key==='arguments'?'--help':'fixture')):Nothing.value]));
 const installers=fn=>{globalThis.fluentciSetupDependencies=Object.fromEntries(spec.requirements.map(d=>[d.alias,args=>fn(d.alias,args)]));};
 for(const name of Object.keys(schema.exports).filter(name=>name!=='setup')) {
  test(schema.name+': '+name+' skips installers for available tools, including executable overrides',()=>{
   for(const override of [false,true]){
    installers(()=>{throw Error('Installer must not run');});
    const f=fixture();const args=input(name);
    if(override)args[schema.name==='buildx'?'docker':'executable']=new Just('/fixture/custom-tool');
    const result=native[name](args)();
    assert.equal(result.outcome,'succeeded');assert.equal(f.plans.length,1);
    assert.ok(f.calls.some(args=>args[0]==='docker'&&args[1]==='buildx'||args[0]===schema.name&&args[1]===(schema.name==='flipt'?'--version':'version')));
   }
  });
  test(schema.name+': '+name+' installs missing prerequisites before running and rechecks them',()=>{
   const available=new Set(),invoked=[];
   installers(alias=>{invoked.push(alias);available.add(alias);});
   const f=fixture({fail:args=>spec.requirements.some(d=>!available.has(d.alias)&&JSON.stringify(args)===JSON.stringify(d.probe))});
   native[name](input(name))();assert.deepEqual(invoked,spec.requirements.map(d=>d.alias));assert.equal(f.plans.length,1);
  });
  test(schema.name+': '+name+' cannot run a plan after setup fails',()=>{
   installers(()=>{throw Error('Setup failed');});
   const first=spec.requirements[0];const f=fixture({fail:args=>JSON.stringify(args)===JSON.stringify(first.probe)});
   assert.throws(()=>native[name](input(name))(),/Setup failed/);assert.equal(f.plans.length,0);
  });
 }
 test(schema.name+': explicit setup forwards typed options and returns the real installer result',()=>{
  const result={tool:schema.name,version:'1.2.3',binDir:'/fixture/bin',environment:[{name:'PATH',value:'/fixture/bin:/usr/bin'}]};let seen;
  installers((alias,args)=>{assert.equal(alias,'setup-'+schema.name);seen=args;return result;});
  for(const os of ['linux','macos'])for(const arch of ['x86_64','aarch64']){
   seen=undefined;const f=fixture({os,arch});
   assert.deepEqual(native.setup({...input('setup'),version:new Just('1.2.3'),installDir:new Just('/fixture/managed')})(),result);
   assert.deepEqual(seen,{version:'1.2.3',installDir:'/fixture/managed'});
   assert.equal(f.calls.length,0);assert.equal(f.plans.length,0);
  }
 });
 test(schema.name+': malformed CSV lists cannot reach setup or a plan',()=>{
  const fields=Object.entries(schema.exports[schema.name==='flipt'?'validate':'build'].input.properties);
  const key=schema.name==='buildx'?'tag':schema.name==='flipt'?'files':'tags';
  assert.ok(fields.some(([field])=>field===key));
  for(const value of ['a,,b',',a','a,','"unclosed','a\u0000b']){
   installers(()=>{throw Error('Unexpected setup');});const f=fixture();
   assert.throws(()=>native[schema.name==='flipt'?'validate':'build']({...input(schema.name==='flipt'?'validate':'build'),[key]:new Just(value)})());
   assert.equal(f.calls.length,0);assert.equal(f.plans.length,0);
  }
 });
 test(schema.name+': CSV values trim whitespace, preserve quoted commas and remain literal argv',()=>{
  installers(()=>{throw Error('Unexpected setup');});const f=fixture();
  const key=schema.name==='buildx'?'tag':schema.name==='flipt'?'files':'tags';const build=input(schema.name==='flipt'?'validate':'build');
  const value='example/app:one, "example/app:two,part", $(touch injected)';
  native[schema.name==='flipt'?'validate':'build']({...build,[key]:new Just(value)})();const argv=f.plans[0].plan.tasks[0].args;
  for(const token of ['example/app:one','example/app:two,part','$(touch injected)'])assert.ok(argv.includes((schema.name==='flipt'?'':'--tag=')+token));
 });
 if(['depot','flipt'].includes(schema.name))test(schema.name+': rejects unsupported hosts before setup and native commands',()=>{
  for(const os of ['windows','freebsd','openbsd','netbsd'])for(const name of ['setup',schema.name==='flipt'?'validate':'build','version']){
   installers(()=>{throw Error('Unexpected setup');});const f=fixture({os});
   assert.throws(()=>native[name](input(name))(),/Unsupported|supports Linux and macOS/);assert.equal(f.calls.length,0);assert.equal(f.plans.length,0);
  }
 });
}
