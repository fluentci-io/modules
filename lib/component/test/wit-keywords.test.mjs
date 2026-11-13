import test from 'node:test';
import assert from 'node:assert/strict';
import {identifier} from '../records.mjs';
import {componentContract,jsName,witName} from '../inspection/components.mjs';

// Include primitive type tokens as well as declaration/control keywords. They
// are also reserved by the WIT lexer when used as an identifier.
const reserved='use type func u8 u16 u32 u64 s8 s16 s32 s64 f32 f64 char resource own borrow record flags variant enum bool string option result future stream error-context list map as from static interface tuple world import export package constructor include with async'.split(' ');
for(const keyword of reserved)test(`WIT identifier ${keyword} is explicitly escaped`,()=>{
 assert.equal(identifier(keyword),'%'+keyword);
});
test('optional from inputs and keyword exports produce escaped WIT with unchanged public names',()=>{
 const {wit,functions}=componentContract([{
  name:'from',description:'Return a fixture value.',
  args:[{name:'from',type:'string',required:false,description:'Native source selector.'},{name:'sourcePath',type:'string',required:true}],
  invoke:{style:'object'},component:{returnType:'string'}
 }],'typescript');
 assert.match(wit,/%from: option<string>/);
 assert.match(wit,/source-path: string/);
 assert.match(wit,/%from: func\(args: from-args\) -> string/);
 assert.equal(functions[0].witName,'from');
 assert.equal(functions[0].args[0].name,'from');
 assert.equal(witName('from'),'from');assert.equal(jsName('from'),'from');
});
test('ordinary identifiers and names containing keyword fragments stay unchanged',()=>{
 for(const name of ['build','from-path','platform','string-value'])assert.equal(identifier(name),name);
});
