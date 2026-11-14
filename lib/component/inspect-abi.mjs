import {readFile} from 'node:fs/promises';
import {resolve} from 'node:path';
import {transpile} from '@bytecodealliance/jco';
import ts from 'typescript';
const bytes=await readFile(resolve(process.argv[2],'dist/plugin.wasm'));
const {files}=await transpile(bytes,{name:'plugin',instantiation:'sync',wasiShim:false});
const entry=Object.entries(files).find(([name])=>name.endsWith('/fluentci-module-api.d.ts'))??Object.entries(files).find(([name])=>name==='plugin.d.ts');
if(!entry)throw Error('Component public API declarations unavailable');
const source=ts.createSourceFile('api.d.ts',new TextDecoder().decode(entry[1]),ts.ScriptTarget.Latest,true);
const types=new Map();
for(const node of source.statements)if(ts.isInterfaceDeclaration(node)||ts.isTypeAliasDeclaration(node))types.set(node.name.text,node);
function shape(node,seen=new Set()){
 if(ts.isTypeReferenceNode(node)){
  const name=node.typeName.getText();
  if(name==='Array')return {type:'array',items:shape(node.typeArguments[0],seen)};
  if(seen.has(name))throw Error('Recursive ABI type: '+name);
  return shape(types.get(name),new Set([...seen,name]));
 }
 if(ts.isTypeAliasDeclaration(node))return shape(node.type,seen);
 if(ts.isInterfaceDeclaration(node))return {type:'object',properties:Object.fromEntries(node.members.filter(ts.isPropertySignature).map(p=>[p.name.text??p.name.getText(),{...shape(p.type,seen),optional:Boolean(p.questionToken)}]))};
 if(ts.isArrayTypeNode(node))return {type:'array',items:shape(node.elementType,seen)};
 const kind=({[ts.SyntaxKind.StringKeyword]:'string',[ts.SyntaxKind.BooleanKeyword]:'boolean',[ts.SyntaxKind.NumberKeyword]:'number',[ts.SyntaxKind.VoidKeyword]:'void'})[node.kind];
 if(!kind)throw Error('Unsupported ABI syntax: '+node.getText());
 return {type:kind};
}
const functions=[];
function add(node){functions.push({name:node.name.text??node.name.getText(),parameters:node.parameters.map(p=>shape(p.type)),output:shape(node.type),returnName:node.type.getText()});}
for(const node of source.statements){
 if(ts.isFunctionDeclaration(node)&&node.name.text!=='instantiate')add(node);
 if(ts.isInterfaceDeclaration(node)&&node.name.text==='Root')for(const member of node.members)if(ts.isMethodSignature(member))add(member);
}
console.log(JSON.stringify(functions));
