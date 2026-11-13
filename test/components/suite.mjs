import "../dependencies/loader.mjs";
import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {fixture} from '../cli/host.mjs';

const catalog=JSON.parse(readFileSync(new URL('../../lib/cli/catalog.json',import.meta.url)));
export async function componentSuite(directory) {
 const schema=JSON.parse(readFileSync(new URL('schema.json',directory)));
 const native=await import(new URL('output/CI.Component/index.js',directory));
 const {Just,Nothing}=await import(new URL('output/Data.Maybe/index.js',directory));
 const cli=catalog.find(tool=>tool.name===schema.name);
 const sample=(key,prop,command)=>{
   const field=command?.fields.find(field=>field.key===key);
   return field?.choices?.[0]??field?.sample??prop.default??(prop.type==='array'?['literal-value']:prop.type==='boolean'?true:prop.type==='integer'?2:key==='runDir'?'/tmp/component-run':'literal-value');
 };
 const args=(contract,command)=>Object.fromEntries(Object.entries(contract.input.properties).map(([key,prop])=>[key,contract.input.required.includes(key)?sample(key,prop,command):Nothing.value]));
 for(const [name,contract]of Object.entries(schema.exports)) {
   test('typed component '+name+': native arguments and return value',()=>{
    const command=cli?.commands.find(command=>command.name===name);
    const input=args(contract,command);
    if(name==='setup'&&['depot','buildx','flipt','git','gh','glab'].includes(schema.name)){input.version=new Just('../invalid-version');const f=fixture();assert.throws(()=>native[name](input)());assert.equal(f.calls.length,0);return;}
    if(cli){const f=fixture();const result=native[name](input)();assert.equal(result.outcome,'succeeded');assert.equal(result.reportPath,input.runDir+'/result.json');assert.equal(f.plans.length,1);assert.equal(f.output.length,0);return;}
    if(schema.name.startsWith('setup-')){input.version=new Just('../invalid-version');const f=fixture();assert.throws(()=>native[name](input)());assert.equal(f.calls.length,0);return;}
    if(['gemfury','cachix'].includes(schema.name)){fixture();const result=native[name](input)();assert.equal(result.uploaded??result.enabled,false);return;}
    if(schema.name==='buildx'){input.runDir='';fixture();assert.throws(()=>native[name](input)());return;}
    // Package builders validate CPU architecture and tree layout through their
    // existing native suites. The typed boundary must also reject an invalid root.
    fixture({fail:()=>true});assert.throws(()=>native[name](input)());
   });
 }
}
