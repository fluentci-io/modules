#!/usr/bin/env node
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { resolve } from 'node:path';
import { pathToFileURL } from 'node:url';
import { createHash } from 'node:crypto';
import { transpile } from '../lib/component/node_modules/@bytecodealliance/jco/dist/api.js';
import ts from '../lib/component/node_modules/typescript/lib/typescript.js';

const witName=value=>value.replace(/([a-z0-9])([A-Z])/g,'$1-$2').replaceAll('_','-').toLowerCase();
export function componentMetadata(bytes) {
  assert.deepEqual([...bytes.subarray(0,8)],[0,97,115,109,13,0,1,0],'Expected a native WebAssembly component, not an Extism core module');
  let offset=8,metadata;
  const uint=()=>{let value=0;for(let shift=0;shift<35;shift+=7){assert.ok(offset<bytes.length,'Truncated component');const byte=bytes[offset++];value+=(byte&127)*2**shift;if(!(byte&128))return value;}throw Error('Invalid component length');};
  while(offset<bytes.length){const id=bytes[offset++],length=uint(),end=offset+length;assert.ok(end<=bytes.length,'Truncated component');if(id===0){const size=uint();const name=bytes.subarray(offset,offset+size).toString('utf8');offset+=size;if(name==='fluentci:metadata'){assert.equal(metadata,undefined,'Duplicate module metadata');metadata=JSON.parse(bytes.subarray(offset,end).toString('utf8'));}}offset=end;}
  assert.ok(metadata?.functions?.length,'Missing typed component metadata');return metadata;
}

function declarations(files) {
  const text=Object.entries(files).find(([name])=>name.endsWith('/fluentci-module-api.d.ts'))?.[1]??Object.entries(files).find(([name])=>name==='plugin.d.ts')?.[1];
  assert.ok(text,'Component is missing the public API');
  const source=ts.createSourceFile('api.d.ts',new TextDecoder().decode(text),ts.ScriptTarget.Latest,true);
  const types=new Map(),functions=new Map();
  for(const node of source.statements){if(ts.isInterfaceDeclaration(node)||ts.isTypeAliasDeclaration(node))types.set(node.name.text,node);if(ts.isFunctionDeclaration(node)&&node.name.text!=='instantiate')functions.set(witName(node.name.text.replace(/^_/,'')),node);if(ts.isInterfaceDeclaration(node)&&node.name.text==='Root')for(const member of node.members)if(ts.isMethodSignature(member))functions.set(witName((member.name.text??member.name.getText()).replace(/^_/,'')),member);}
  return {types,functions};
}
function checkType(node,schema,types) {
  assert.ok(node,'Missing native return/argument type');
  if(ts.isTypeReferenceNode(node)) {
    if(node.typeName.getText()==='Array'){assert.equal(schema.type,'array');checkType(node.typeArguments[0],schema.items,types);return;}
    const declaration=types.get(node.typeName.getText());assert.ok(declaration,'Unresolved native component type: '+node.typeName.getText());
    if(ts.isTypeAliasDeclaration(declaration)){checkType(declaration.type,schema,types);return;}
    assert.equal(schema.type,'object');const properties=declaration.members.filter(ts.isPropertySignature);assert.deepEqual(properties.map(p=>(p.name.text??p.name.getText())).sort(),Object.keys(schema.properties).sort(),'Native record fields differ from schema');for(const p of properties)checkType(p.type,schema.properties[(p.name.text??p.name.getText())],types);return;
  }
  if(ts.isArrayTypeNode(node)){assert.equal(schema.type,'array');checkType(node.elementType,schema.items,types);return;}
  const expected={string:ts.SyntaxKind.StringKeyword,boolean:ts.SyntaxKind.BooleanKeyword,integer:ts.SyntaxKind.NumberKeyword,number:ts.SyntaxKind.NumberKeyword}[schema.type];
  assert.equal(node.kind,expected,'Native component type differs from schema');
}
export async function validateWasm(directory) {
  const source=await readFile(resolve(directory,'entry.mjs'),'utf8');const match=source.match(/export\s*\{([^}]+)\}/);assert.ok(match,'Missing entry point declarations');
  const expected=match[1].split(',').map(n=>witName(n.trim())).filter(Boolean).sort();
  const bytes=await readFile(resolve(directory,'dist/plugin.wasm'));const metadata=componentMetadata(bytes);
  const sidecar=JSON.parse(await readFile(resolve(directory,'dist/fluentci.metadata.json'),'utf8'));
  assert.equal(sidecar.sha256,createHash('sha256').update(bytes).digest('hex'),'Component checksum differs from metadata sidecar');assert.deepEqual(sidecar.functions,metadata.functions);
  const {files}=await transpile(bytes,{name:'plugin',instantiation:'sync',wasiShim:false});const {types,functions}=declarations(files);
  assert.deepEqual([...functions.keys()].sort(),expected,'Component public exports differ from entry.mjs');
  assert.deepEqual(metadata.functions.map(f=>f.name).sort(),expected,'Typed metadata exports differ');
  const schema=JSON.parse(await readFile(resolve(directory,'schema.json'),'utf8'));
  for(const [sourceName,contract]of Object.entries(schema.exports)) {
    const name=witName(sourceName),native=functions.get(name),meta=metadata.functions.find(f=>f.name===name);
    assert.ok(native&&meta,'Missing native function '+name);assert.equal(meta.inputFormat,'wit');assert.ok(meta.description?.trim(),name+': missing function description');assert.ok(meta.returnType?.trim(),name+': missing return type');
    const props=contract.input.properties,required=contract.input.required??[];
    assert.deepEqual(meta.args.map(a=>a.name).sort(),Object.keys(props).map(witName).sort(),name+': argument metadata differs');
    if(Object.keys(props).length){assert.equal(native.parameters.length,1);const input=types.get(native.parameters[0].type.getText());assert.ok(input&&ts.isInterfaceDeclaration(input),'Use one named argument record');
      const nativeFields=new Map(input.members.filter(ts.isPropertySignature).map(p=>[witName((p.name.text??p.name.getText())),p]));
      assert.deepEqual([...nativeFields.keys()].sort(),Object.keys(props).map(witName).sort());
      for(const [key,prop]of Object.entries(props)){const arg=meta.args.find(a=>a.name===witName(key)),field=nativeFields.get(witName(key));assert.ok(arg.description?.trim(),name+'/'+key+': missing argument description');assert.equal(arg.required!==false,required.includes(key));assert.equal(Boolean(field.questionToken),!required.includes(key));checkType(field.type,prop,types);}
    }else assert.equal(native.parameters.length,0);
    checkType(native.type,contract.output,types);
    let nativeReturn;
    if(contract.output.type==='object')nativeReturn=witName(native.type.getText());
    else if(contract.output.type==='array')nativeReturn='list<'+({string:'string',boolean:'bool',integer:'s32',number:'f64'}[contract.output.items.type])+'>';
    else nativeReturn={string:'string',boolean:'bool',integer:'s32',number:'f64'}[contract.output.type];
    assert.equal(meta.returnType,nativeReturn,name+': return metadata differs from native ABI');
  }
  return expected;
}
if(process.argv[1]&&import.meta.url===pathToFileURL(resolve(process.argv[1])).href){try{assert.equal(process.argv.length,3,'Usage: node scripts/validate_wasm.mjs MODULE_DIRECTORY');const functions=await validateWasm(process.argv[2]);console.log(`Validated ${process.argv[2]}: native component, ${functions.length} typed function(s), named arguments, descriptions, and returns.`);}catch(error){console.error(error);process.exitCode=1;}}
