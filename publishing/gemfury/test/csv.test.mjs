import '../../../test/dependencies/loader.mjs';
import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {fixture} from '../../../test/cli/host.mjs';
const component=await import('../output/CI.Component/index.js');
const env={FURY_ACCOUNT:'ci-packages',FURY_USER:'publisher',FURY_TOKEN:'synthetic-fury-token'};
const curl=f=>f.calls.filter(args=>args[0]==='curl');

test('public files input is CSV while the typed result retains decoded paths',()=>{
 const schema=JSON.parse(readFileSync(new URL('../schema.json',import.meta.url)));
 assert.equal(schema.exports.upload.input.properties.files.type,'string');
 assert.equal(schema.exports.upload.output.properties.files.type,'array');
 const f=fixture({env});const result=component.upload({files:' dist/app.deb, dist/app.rpm '})();
 assert.deepEqual(result,{uploaded:true,files:['dist/app.deb','dist/app.rpm']});
 assert.deepEqual(f.calls.filter(a=>a[0]==='test'&&a[1]==='-f'),[['test','-f','dist/app.deb'],['test','-f','dist/app.rpm']]);
 assert.equal(curl(f).length,2);
 assert.ok(f.calls.findIndex(a=>a[0]==='curl')>f.calls.findIndex(a=>a[0]==='test'&&a[1]==='-s'&&a[2]==='dist/app.rpm'));
 assert.ok(!JSON.stringify(f.calls).includes(env.FURY_TOKEN));
});
test('CSV quotes preserve commas, embedded quotes and literal shell characters',()=>{
 const f=fixture({env});const result=component.upload({files:'"dist/file,one.deb","dist/a""b.rpm",dist/$(touch injected).deb'})();
 assert.deepEqual(result.files,['dist/file,one.deb','dist/a"b.rpm','dist/$(touch injected).deb']);
 assert.equal(curl(f).length,3);
 assert.ok(curl(f)[0].includes('package=@"dist/file,one.deb"'));
 assert.ok(!f.calls.some(args=>['sh','bash'].includes(args[0])));
});
test('malformed lists, invalid paths and obsolete JSON arrays fail before setup or host commands',()=>{
 let installed=false;globalThis.fluentciSetupDependencies={'setup-gemfury':()=>{installed=true;}};
 for(const files of ['', '  ', 'one.deb,,two.rpm', 'one.deb,', '"bad', 'bad\0.deb', 'bad\n.deb', 'bad\r.rpm', ['one.deb'], '["one.deb","two.rpm"]']){
  const f=fixture({env});assert.throws(()=>component.upload({files})());
  assert.equal(f.calls.length,0);assert.equal(installed,false);
 }
});
test('blank or omitted tokens preserve skipped uploads for valid CSV paths',()=>{
 for(const token of [undefined,'','   ']){
  const f=fixture({env:{...env,FURY_TOKEN:token}});
  const result=component.upload({files:'one.deb, two.rpm'})();
  assert.deepEqual(result,{uploaded:false,files:['one.deb','two.rpm']});assert.equal(f.calls.length,0);
 }
});
test('a missing later package prevents every upload',()=>{
 const f=fixture({env,fail:a=>a[0]==='test'&&a[1]==='-f'&&a[2]==='missing.rpm'});
 assert.throws(()=>component.upload({files:'one.deb,missing.rpm'})());assert.equal(curl(f).length,0);
});
