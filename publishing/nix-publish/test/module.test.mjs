import '../../../test/dependencies/loader.mjs';
import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {fixture} from '../../../test/cli/host.mjs';
import {Just,Nothing} from '../output/Data.Maybe/index.js';
// Load the component after the test loader has registered fluentci: imports.
const component=await import('../output/CI.Component/index.js');
const schema=JSON.parse(readFileSync(new URL('../schema.json',import.meta.url)));
const environment={GH_TOKEN:'github-sentinel',FLAKEHUB_PUSH_GITHUB_TOKEN:'flakehub-sentinel',ACTIONS_ID_TOKEN_REQUEST_TOKEN:'request-sentinel',ACTIONS_ID_TOKEN_REQUEST_URL:'https://example.invalid/token?request=1'};
function args(name,overrides={}) {
 const contract=schema.exports[name].input;
 const values={runDir:'/tmp/publish-run',name:'example/project',version:'v1.2.3',ref:'a'.repeat(40)};
 return Object.fromEntries(Object.keys(contract.properties).map(key=>[key,key in overrides?overrides[key]:contract.required.includes(key)?values[key]:Nothing.value]));
}
test('all public exports have typed component contracts',()=>assert.deepEqual(Object.keys(component).sort(),Object.keys(schema.exports).sort()));
for(const name of Object.keys(schema.exports))test(name+': typed result, literal argv and private credentials',()=>{
 const f=fixture({env:environment});const result=component[name](args(name))();
 assert.equal(result.outcome,'succeeded');assert.equal(result.reportPath,'/tmp/publish-run/result.json');assert.equal(f.output.length,0);assert.equal(f.plans.length,1);
 const task=f.plans[0].plan.tasks[0];
 assert.equal(task.program,name==='flakehub'?'flakehub-push':name==='flakestry'?'bun':'nix');
 if(name==='flakehub')assert.deepEqual(task.args,['--name=example/project','--tag=v1.2.3','--visibility=public']);
 if(name==='flakestry')assert.deepEqual(task.args.slice(-5),['v1.2.3','a'.repeat(40),'README.md','https://flakestry.dev','false']);
 if(['check','metadata','outputs'].includes(name))assert.ok(task.args.includes('--no-write-lock-file'));
 for(const secret of ['github-sentinel','flakehub-sentinel','request-sentinel'])assert.ok(!JSON.stringify([f.calls,f.plans,result]).includes(secret));
});
for(const name of ['flakehub','flakestry'])test(name+': missing or blank credentials fail before host commands',()=>{
 for(const key of [name==='flakehub'?'FLAKEHUB_PUSH_GITHUB_TOKEN':'GH_TOKEN','ACTIONS_ID_TOKEN_REQUEST_TOKEN','ACTIONS_ID_TOKEN_REQUEST_URL'])for(const value of [undefined,'','   ']){
  const env={...environment,[key]:value};if(value===undefined)delete env[key];
  const f=fixture({env});assert.throws(()=>component[name](args(name))(),new RegExp(key));assert.equal(f.calls.length,0);assert.equal(f.plans.length,0);
 }
});
test('publishing uses literal named values and validates required fields and visibility',()=>{
 const version="v1.2.3; $(touch injected)";let f=fixture({env:environment});component.flakehub(args('flakehub',{version}))();assert.ok(f.plans[0].plan.tasks[0].args.includes('--tag='+version));
 for(const changes of [{version:''},{name:''},{visibility:new Just('unknown')},{runDir:''}]){f=fixture({env:environment});assert.throws(()=>component.flakehub(args('flakehub',changes))());assert.equal(f.calls.length,0);assert.equal(f.plans.length,0);}
});
test('Linux/macOS only and native failures cannot report successful publication',()=>{
 for(const os of ['freebsd','openbsd','netbsd','windows']){const f=fixture({os,env:environment});assert.throws(()=>component.flakehub(args('flakehub'))(),/Linux and macOS/);assert.equal(f.calls.length,0);}
 for(const options of [{fail:argv=>argv[0]==='which'},{outcome:'failed'},{outcome:'cancelled'},{transportError:true}]){fixture({...options,env:environment});assert.throws(()=>component.flakehub(args('flakehub'))());}
});
