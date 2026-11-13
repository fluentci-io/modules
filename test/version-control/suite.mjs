import '../dependencies/loader.mjs';
import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {fixture} from '../cli/host.mjs';
const catalog=JSON.parse(readFileSync(new URL('../../lib/cli/catalog.json',import.meta.url)));

export async function versionControlSuite(directory){
 const schema=JSON.parse(readFileSync(new URL('schema.json',directory))),name=schema.name;
 const spec=JSON.parse(readFileSync(new URL('module-dependencies.json',directory)));
 const tool=catalog.find(tool=>tool.name===name);
 const native=await import(new URL('output/CI.Component/index.js',directory));
 const {Just,Nothing}=await import(new URL('output/Data.Maybe/index.js',directory));
 const input=operation=>Object.fromEntries(Object.entries(schema.exports[operation].input.properties).map(([key,prop])=>{
  const field=tool.commands.find(c=>c.name===operation)?.fields.find(f=>f.key===key);
  return [key,schema.exports[operation].input.required.includes(key)?(key==='runDir'?'/tmp/vcs-run':field?.sample??prop.enum?.[0]??prop.default??(prop.type==='integer'?123:key==='arguments'?'--help':'fixture')):Nothing.value];
 }));
 const installers=fn=>{globalThis.fluentciSetupDependencies=Object.fromEntries(spec.requirements.map(d=>[d.alias,args=>fn(d.alias,args)]));};
 test(name+': every public input is scalar or CSV with a source description',()=>{
  assert.ok(schema.exports.setup);
  for(const contract of Object.values(schema.exports)){
   assert.ok(contract.description);
   for(const prop of Object.values(contract.input.properties)){assert.ok(['string','integer','number','boolean'].includes(prop.type));assert.ok(prop.description);}
  }
 });
 for(const operation of tool.commands.map(c=>c.name)){
  test(name+': '+operation+' checks setup and skips installed tools, including overrides',()=>{
   for(const override of [false,true]){
    installers(()=>{throw Error('Installer should not run');});const f=fixture();const args=input(operation);
    if(override)args.executable=new Just('/fixture/custom-vcs');
    assert.equal(native[operation](args)().outcome,'succeeded');assert.equal(f.plans.length,1);
    for(const requirement of spec.requirements)assert.ok(f.calls.some(args=>JSON.stringify(args)===JSON.stringify(requirement.probe)));
   }
  });
  test(name+': '+operation+' installs and rechecks all missing tools before executing',()=>{
   const ready=new Set(),installed=[];installers(alias=>{installed.push(alias);ready.add(alias);});
   const f=fixture({fail:args=>spec.requirements.some(r=>!ready.has(r.alias)&&JSON.stringify(args)===JSON.stringify(r.probe))});
   native[operation](input(operation))();assert.deepEqual(installed,spec.requirements.map(r=>r.alias));assert.equal(f.plans.length,1);
  });
  test(name+': '+operation+' stops on prerequisite failure',()=>{
   installers(()=>{throw Error('Setup sentinel');});const first=spec.requirements[0];
   const f=fixture({fail:args=>JSON.stringify(args)===JSON.stringify(first.probe)});
   assert.throws(()=>native[operation](input(operation))(),/Setup sentinel/);assert.equal(f.plans.length,0);
  });
 }
 test(name+': explicit setup returns and forwards the real dependency contract on every supported host',()=>{
  for(const os of ['linux','macos','freebsd','openbsd','netbsd'])for(const arch of ['x86_64','aarch64']){
   const result={tool:name,version:'1.2.3',binDir:'/fixture/bin',environment:[{name:'PATH',value:'/fixture/bin:/usr/bin'}]};let seen;
   installers((alias,args)=>{assert.equal(alias,'setup-'+name);seen=args;return result;});fixture({os,arch});
   assert.deepEqual(native.setup({...input('setup'),version:new Just('1.2.3')})(),result);assert.deepEqual(seen,{version:'1.2.3'});
  }
 });
 if(name!=='git')test(name+': explicit setup installs Git only when missing and rechecks it',()=>{
  let gitReady=false;const installed=[];const result={tool:name,version:'1.2.3',binDir:'/fixture/bin',environment:[]};
  installers(alias=>{installed.push(alias);if(alias==='setup-git')gitReady=true;return result;});
  fixture({fail:args=>!gitReady&&args[0]==='git'});assert.deepEqual(native.setup(input('setup'))(),result);
  assert.deepEqual(installed,['setup-git','setup-'+name]);
 });
 test(name+': malformed lists and input files fail before installers and plans',()=>{
  for(const value of ['a,,b','a,',',a','"unterminated','x\u0000y']){
   installers(()=>{throw Error('Unexpected installer');});const f=fixture();
   assert.throws(()=>native.run({...input('run'),arguments:value})());assert.equal(f.calls.length,0);assert.equal(f.plans.length,0);
  }
  if(name!=='git'){
   installers(()=>{throw Error('Unexpected installer');});const f=fixture({fail:args=>args[0]==='test'&&args[1]==='-f'});
   assert.throws(()=>native.release_upload({...input('release_upload'),files:'missing.zip'})());assert.equal(f.plans.length,0);
   assert.ok(!f.calls.some(args=>args[0]===name));
  }
 });
 test(name+': native failures cannot return a successful execution result',()=>{
  installers(()=>{throw Error('Unexpected installer');});const f=fixture({outcome:'failed'});
  assert.throws(()=>native.version(input('version'))(),/failed/);assert.equal(f.plans.length,1);
 });
 test(name+': unsupported OS fails before setup',()=>{
  installers(()=>{throw Error('Unexpected installer');});
  for(const operation of ['setup','version']){
   const f=fixture({os:'windows'});assert.throws(()=>native[operation](input(operation))(),/Unsupported/);assert.equal(f.calls.length,0);assert.equal(f.plans.length,0);
  }
 });
 test(name+': credentials remain inherited and never become plan fields',()=>{
  installers(()=>{throw Error('Unexpected installer');});const sentinel='credential-sentinel';
  const f=fixture({env:{GH_TOKEN:sentinel,GITLAB_TOKEN:sentinel}});native.version(input('version'))();assert.ok(!JSON.stringify(f.plans).includes(sentinel));
 });
 test(name+': raw CSV preserves literal shell syntax and quoted commas in native order',()=>{
  installers(()=>{throw Error('Unexpected installer');});const f=fixture();
  native.run({...input('run'),arguments:'api, "path,with,commas", $(touch injected),literal value'})();
  assert.deepEqual(f.plans[0].plan.tasks[0].args,['api','path,with,commas','$(touch injected)','literal value']);
 });
 if(name==='git')test('Git uses fast-forward-only pulls and explicit force policy',()=>{
  installers(()=>{throw Error('Unexpected installer');});let f=fixture();native.pull(input('pull'))();assert.ok(f.plans[0].plan.tasks[0].args.includes('--ff-only'));
  f=fixture();native.push(input('push'))();assert.ok(!f.plans[0].plan.tasks[0].args.includes('--force-with-lease'));
 });
 if(name==='gh')test('GitHub explicit setup reuses an exact PATH version without an installer',()=>{
  installers(()=>{throw Error('Installer must not run');});
  const f=fixture({command:args=>{
   if(args[0]==='sh'&&args[3]==='fluentci-probe-tool')return '/fixture/gh';
   if(args[0]==='/fixture/gh')return 'gh version 1.2.3';
   if(args[0]==='dirname')return '/fixture';
  }});
  const result=native.setup({...input('setup'),version:new Just('1.2.3')})();
  assert.equal(result.version,'1.2.3');assert.equal(result.binDir,'/fixture');assert.ok(f.updates.length>0);
  assert.ok(!f.calls.some(args=>['curl','mkdir','tar','unzip'].includes(args[0])));
 });
 if(name==='glab')test('GitLab rejects malformed variable and input entries before setup',()=>{
  for(const key of ['variables','inputs'])for(const value of ['no-separator',':missing-key','bad key:value']){
   installers(()=>{throw Error('Unexpected installer');});const f=fixture();
   assert.throws(()=>native.ci_run({...input('ci_run'),[key]:new Just(value)})(),/KEY:VALUE/);assert.equal(f.calls.length,0);assert.equal(f.plans.length,0);
  }
 });
 if(name==='gh')test('GitHub check gates and merge strategy remain explicit native flags',()=>{
  installers(()=>{throw Error('Unexpected installer');});let f=fixture();native.run_watch(input('run_watch'))();assert.ok(f.plans[0].plan.tasks[0].args.includes('--exit-status'));
  f=fixture();native.pr_merge({...input('pr_merge'),method:'squash'})();assert.ok(f.plans[0].plan.tasks[0].args.includes('--squash'));
 });
 if(name==='glab')test('GitLab retry selects a job and cancellation selects the pipeline subcommand',()=>{
  installers(()=>{throw Error('Unexpected installer');});let f=fixture();native.ci_retry({...input('ci_retry'),job:'lint'})();assert.ok(f.plans[0].plan.tasks[0].args.includes('lint'));
  f=fixture();native.ci_cancel({...input('ci_cancel'),pipelineId:42})();assert.deepEqual(f.plans[0].plan.tasks[0].args.slice(0,3),['ci','cancel','pipeline']);assert.ok(f.plans[0].plan.tasks[0].args.includes('42'));
 });
}
