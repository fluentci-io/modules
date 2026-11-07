import test from 'node:test';
import assert from 'node:assert/strict';
import {mkdtempSync,mkdirSync,writeFileSync,rmSync} from 'node:fs';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {recordContract,identifier} from '../records.mjs';
const con=(module,name)=>({tag:'TypeConstructor',contents:[module.split('.'),name]});
const app=(fn,arg)=>({tag:'TypeApp',contents:[fn,arg]});
const record=fields=>app(con('Prim','Record'),Object.entries(fields).reduceRight((tail,[key,value])=>({tag:'RCons',contents:[key,value,tail]}),{tag:'REmpty'}));
function contract(t,type){
 const root=mkdtempSync(join(tmpdir(),'fluentci-record-contract-'));t.after(()=>rmSync(root,{recursive:true,force:true}));
 const dir=join(root,'output','Fixture');mkdirSync(dir,{recursive:true});
 const wrapped=app(app(con('Prim','Function'),record({})),app(con('Effect','Effect'),type));
 writeFileSync(join(dir,'docs.json'),JSON.stringify({declarations:[{title:'build',info:{declType:'value',type:wrapped}}]}));
 return recordContract({name:'build',invoke:{module:join(dir,'index.js'),export:'build'}});
}
test('compiler records preserve nested lists, scalar types and WIT keywords',t=>{
 const result=contract(t,record({runDir:con('Prim','String'),count:con('Prim','Int'),ok:con('Prim','Boolean'),environment:app(con('Prim','Array'),record({type:con('Prim','String')}))}));
 assert.equal(result.result,'build-result');assert.match(result.definitions,/run-dir: string/);assert.match(result.definitions,/count: s32/);assert.match(result.definitions,/ok: bool/);assert.match(result.definitions,/environment: list<build-result-environment-item>/);assert.match(result.definitions,/%type: string/);
});
test('parenthesized list results resolve to native lists',t=>assert.equal(contract(t,{tag:'ParensInType',contents:app(con('Prim','Array'),con('Prim','String'))}).result,'list<string>'));
test('optional result records fail explicitly',t=>assert.throws(()=>contract(t,app(con('Data.Maybe','Maybe'),record({value:con('Prim','String')}))),/explicit result codec/));
test('WIT reserved identifiers are escaped',()=>{assert.equal(identifier('use'),'%use');assert.equal(identifier('build'),'build');});
