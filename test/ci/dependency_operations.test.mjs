import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {dependencyOperation} from '../dependencies/operation.mjs';

const catalog=JSON.parse(readFileSync(new URL('../../lib/cli/catalog.json',import.meta.url)));
const omitted=Symbol('Nothing');
function operation(name) {
 const cli=catalog.find(tool=>tool.name===name);
 const schema=JSON.parse(readFileSync(new URL('../../'+cli.path+'/schema.json',import.meta.url)));
 return dependencyOperation(cli,schema,omitted);
}

test('dependency fixtures prefer version when the public module provides it',()=>{
 const selected=operation('cmake');
 assert.equal(selected.name,'version');
 assert.equal(selected.input.runDir,'/tmp/setup-dependency-run');
 assert.equal(selected.input.executable,omitted);
});
test('Tangled fixtures select run and supply required native arguments',()=>{
 const selected=operation('tangled-artifacts');
 assert.equal(selected.name,'run');
 assert.equal(selected.input.arguments,'"--help"');
 assert.equal(selected.input.executable,omitted);
 assert.equal(selected.input.runDir,'/tmp/setup-dependency-run');
});
test('dependency fixtures encode list samples as CSV strings with literal commas and quotes',()=>{
 const cli={name:'fixture',commands:[{name:'run',fields:[{key:'arguments',sample:['--label','hello, world','say "hi"']}]}]};
 const schema={exports:{run:{input:{required:['arguments'],properties:{arguments:{type:'string'}}}}}};
 const selected=dependencyOperation(cli,schema,omitted);
 assert.equal(selected.input.arguments,'"--label","hello, world","say ""hi"""');
});
test('tools without version use help or a real named operation',()=>{
 assert.equal(operation('codacy').name,'help');
 assert.equal(operation('ubicloud').name,'version');
 assert.equal(operation('nix-publish').name,'check');
});
test('each CLI fixture supplies all required public arguments before failure assertions',()=>{
 for(const cli of catalog){
  const schema=JSON.parse(readFileSync(new URL('../../'+cli.path+'/schema.json',import.meta.url)));
  const selected=dependencyOperation(cli,schema,omitted);
  for(const key of schema.exports[selected.name].input.required){
   assert.notEqual(selected.input[key],omitted,`${cli.name}.${key}`);
   assert.notEqual(selected.input[key],undefined,`${cli.name}.${key}`);
   if(schema.exports[selected.name].input.properties[key].type==='string'){
    assert.equal(typeof selected.input[key],'string',`${cli.name}.${key} must match its public string contract`);
   }
  }
 }
});
