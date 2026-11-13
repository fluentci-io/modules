import './loader.mjs';
import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {fixture} from '../cli/host.mjs';
import {dependencyOperation} from './operation.mjs';

export async function dependencySuite(directory){
 const spec=JSON.parse(readFileSync(new URL('module-dependencies.json',directory)));
 const native=await import(new URL('output/CI.ModuleDependencies/index.js',directory));
 for(const requirement of spec.requirements){
  test(spec.module+': missing '+requirement.program+' invokes '+requirement.alias+' and rechecks availability',()=>{
   let installed=false;const invoked=[];
   globalThis.fluentciSetupDependencies=Object.fromEntries(spec.requirements.map(d=>[d.alias,args=>{invoked.push({alias:d.alias,args});installed=true;}]));
   const f=fixture({fail:args=>!installed&&JSON.stringify(args)===JSON.stringify(requirement.probe)});
   native.ensureFor(requirement.program)();
   assert.ok(invoked.some(d=>d.alias===requirement.alias));assert.ok(invoked.every(d=>Object.keys(d.args).length===0));
   assert.ok(f.calls.filter(args=>JSON.stringify(args)===JSON.stringify(requirement.probe)).length>=2);
   assert.equal(f.plans.length,0);
  });
 }
 test(spec.module+': available tools never invoke a setup installer',()=>{
  const invoked=[];globalThis.fluentciSetupDependencies=Object.fromEntries(spec.requirements.map(d=>[d.alias,()=>invoked.push(d.alias)]));
  fixture();native.ensureFor(spec.requirements[0].program)();assert.deepEqual(invoked,[]);
 });
 test(spec.module+': setup failures stop execution',()=>{
  globalThis.fluentciSetupDependencies=Object.fromEntries(spec.requirements.map(d=>[d.alias,()=>{throw Error('Injected setup failure');}]));
  const first=spec.requirements[0];
  fixture({fail:args=>JSON.stringify(args)===JSON.stringify(first.probe)});
  assert.throws(()=>native.ensureFor(first.program)(),/Injected setup failure/);
 });
 test(spec.module+': an installer that does not provide its tool cannot report success',()=>{
  globalThis.fluentciSetupDependencies=Object.fromEntries(spec.requirements.map(d=>[d.alias,()=>{}]));
  const first=spec.requirements[0];
  fixture({fail:args=>JSON.stringify(args)===JSON.stringify(first.probe)});
  assert.throws(()=>native.ensureFor(first.program)());
 });
 if(['cmake','rustfmt'].includes(spec.module))test(spec.module+': command-specific tools use the same setup companion',()=>{
  const program=spec.module==='cmake'?'ctest':'cargo';let available=false;let invoked=false;
  const alias=spec.requirements[0].alias;
  globalThis.fluentciSetupDependencies={[alias]:()=>{invoked=true;available=true;}};
  fixture({fail:args=>args[0]==='which'&&args[1]===program&&!available});
  native.ensureFor(program)();assert.equal(invoked,true);
 });
 if(spec.module==='gh-artifacts')test('GitHub uploads configure a missing client SDK and reject incomplete setup',()=>{
  let f;
  globalThis.fluentciSetupDependencies={'setup-gh-artifacts':()=>{f.environment.FLUENTCI_GH_ARTIFACT_CLIENT='/fixture/installed-client.mjs';}};
  f=fixture({env:{FLUENTCI_GH_ARTIFACT_CLIENT:''}});native.ensureFor('bun')();
  assert.equal(f.environment.FLUENTCI_GH_ARTIFACT_CLIENT,'/fixture/installed-client.mjs');
  globalThis.fluentciSetupDependencies={'setup-gh-artifacts':()=>{}};
  fixture({env:{FLUENTCI_GH_ARTIFACT_CLIENT:''}});assert.throws(()=>native.ensureFor('bun')(),/did not configure/);
 });
 test(spec.module+': unsupported hosts cannot trigger setup',()=>{
  let invoked=false;globalThis.fluentciSetupDependencies=Object.fromEntries(spec.requirements.map(d=>[d.alias,()=>{invoked=true;}]));
  const f=fixture({os:'windows'});assert.throws(()=>native.ensureFor(spec.requirements[0].program)(),/Unsupported setup dependency OS/);
  assert.equal(invoked,false);assert.equal(f.calls.length,0);
 });

 const catalog=JSON.parse(readFileSync(new URL('../../lib/cli/catalog.json',import.meta.url)));
 const cli=catalog.find(t=>t.name===spec.module);
 if(cli){
  const component=await import(new URL('output/CI.Component/index.js',directory));
  const {Just,Nothing}=await import(new URL('output/Data.Maybe/index.js',directory));
  const schema=JSON.parse(readFileSync(new URL('schema.json',directory)));
  const operation=dependencyOperation(cli,schema,Nothing.value);
  const operationArgs=()=>({...operation.input});
  test(spec.module+': the typed operation installs its missing prerequisite before executing the plan',()=>{
   let available=false;const invoked=[];const first=spec.requirements[0];
   globalThis.fluentciSetupDependencies=Object.fromEntries(spec.requirements.map(d=>[d.alias,()=>{invoked.push(d.alias);available=true;}]));
   const f=fixture({fail:args=>!available&&JSON.stringify(args)===JSON.stringify(first.probe)});
   const result=component[operation.name](operationArgs())();
   assert.ok(invoked.includes(first.alias));assert.equal(result.outcome,'succeeded');assert.equal(f.plans.length,1);
  });
  if(!['depot','flipt'].includes(spec.module))test(spec.module+': explicit executable overrides bypass setup dependencies',()=>{
   globalThis.fluentciSetupDependencies=Object.fromEntries(spec.requirements.map(d=>[d.alias,()=>{throw Error('Unexpected setup');}]));
   const f=fixture();const input={...operationArgs(),executable:new Just('/fixture/custom-tool')};
   component[operation.name](input)();assert.equal(f.plans[0].plan.tasks[0].program,'/fixture/custom-tool');
   assert.ok(!f.calls.some(args=>args[0]==='which'));
  });
  test(spec.module+': malformed typed operations cannot trigger setup',()=>{
   let invoked=false;globalThis.fluentciSetupDependencies=Object.fromEntries(spec.requirements.map(d=>[d.alias,()=>{invoked=true;}]));
   const f=fixture();assert.throws(()=>component[operation.name]({...operationArgs(),runDir:''})());
   assert.equal(invoked,false);assert.equal(f.calls.length,0);assert.equal(f.plans.length,0);
  });
 }

}
