import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture} from '../../../test/setup/host.mjs';
const {setup}=createRequire(import.meta.url)('../dist/plugin.cjs');
function host(options={}){
 return fixture('uv',{os:options.os??'linux',input:{version:'0.11.0',...options.input},command:(args)=>{
  if(options.fail?.(args))throw Error('Injected uv environment failure');
  if(args[0].endsWith('/uv')&&args[1]==='--version')return 'uv 0.11.0';
  if(args[0].endsWith('/uv')&&args[1]==='python'&&args[2]==='find')return options.pythonPath??'/fixture/python/bin/python3.13';
  if(args[0]==='/fixture/python/bin/python3.13'&&args[1]==='--version')return 'Python 3.13.5';
  return undefined;
 }});
}
for(const os of ['linux','macos'])test(os+': optional Python is installed before tools and all executable paths are published',()=>{
 const f=host({os,input:{pythonVersion:'3.13',tools:' ruff==0.12.0, httpie '}});setup();
 const installed=f.calls.findIndex(a=>a[1]==='python'&&a[2]==='install');
 const found=f.calls.findIndex(a=>a[1]==='python'&&a[2]==='find');
 const tools=f.calls.filter(a=>a[1]==='tool'&&a[2]==='install');
 assert.ok(installed>=0&&found>installed);assert.equal(tools.length,2);
 assert.deepEqual(tools.map(a=>a.at(-1)),['ruff==0.12.0','httpie']);
 for(const a of tools){assert.ok(a.includes('--force'));assert.equal(a[a.indexOf('--python')+1],'/fixture/python/bin/python3.13');}
 assert.equal(f.environment.UV_PYTHON,'/fixture/python/bin/python3.13');
 assert.ok(f.environment.PATH.includes('/tool-bin:'));assert.ok(f.environment.PATH.includes('/python-bin:'));
 assert.equal(f.updates.length,1);
 assert.ok(f.scopedCalls.filter(c=>c.args[1]==='tool').every(c=>c.environment.UV_TOOL_DIR.includes('uv-environments')));
});
test('omitted and blank optional fields preserve uv-only setup',()=>{
 for(const input of [{},{pythonVersion:'',tools:''},{tools:'   '}]){
  const f=host({input});setup();assert.ok(!f.calls.some(a=>['python','tool'].includes(a[1])));assert.equal(f.environment.UV_PYTHON,undefined);
 }
});
test('tools can be installed without an explicitly requested Python',()=>{
 const f=host({input:{tools:'ruff,httpie>=3'}});setup();
 assert.ok(!f.calls.some(a=>a[1]==='python'));
 const tools=f.calls.filter(a=>a[1]==='tool');assert.equal(tools.length,2);assert.ok(tools.every(a=>!a.includes('--python')));
});
test('invalid Python and tool fields fail before host commands',()=>{
 for(const input of [{pythonVersion:null},{pythonVersion:'../3.13'},{pythonVersion:'3.13;id'},{tools:['ruff']},{tools:'ruff,,httpie'},{tools:'ruff,'},{tools:'--help'},{tools:'ruff;id'},{tools:'ruff,ruff'},{tools:null}]){
  const f=host({input});assert.throws(setup,undefined,JSON.stringify(input));assert.equal(f.calls.length,0);assert.equal(f.updates.length,0);
 }
});
test('BSD selects an existing matching Python and disables downloads for tools',()=>{
 for(const os of ['freebsd','openbsd','netbsd']){
  const f=host({os,input:{pythonVersion:'3.13',tools:'ruff'}});setup();
  assert.ok(!f.calls.some(a=>a[1]==='python'&&a[2]==='install'));
  for(const a of f.calls.filter(a=>a[1]==='tool'||(a[1]==='python'&&a[2]==='find')))assert.ok(a.includes('--no-python-downloads'));
  assert.equal(f.updates.length,1);
 }
});
test('Python and tool failures never publish a successful setup',()=>{
 for(const options of [{pythonPath:'relative/python'},{fail:a=>a[1]==='python'&&a[2]==='install'},{fail:a=>a[1]==='python'&&a[2]==='find'},{fail:a=>a[1]==='tool'&&a[2]==='install'}]){
  const f=host({...options,input:{pythonVersion:'3.13',tools:'ruff'}});assert.throws(setup);assert.equal(f.updates.length,0);assert.equal(f.output.length,0);
 }
});
test('typed component forwards Python and CSV tools and returns the prepared environment',async()=>{
 const native=await import('../output/CI.Component/index.js');
 const {Just,Nothing}=await import('../output/Data.Maybe/index.js');
 const f=host();
 const result=native.setup({version:new Just('0.11.0'),installDir:Nothing.value,packageName:Nothing.value,sudo:Nothing.value,pythonVersion:new Just('3.13'),tools:new Just('ruff==0.12.0')})();
 assert.equal(result.tool,'uv');assert.equal(result.version,'0.11.0');
 assert.ok(result.environment.some(v=>v.name==='UV_PYTHON'&&v.value==='/fixture/python/bin/python3.13'));
 assert.equal(f.output.length,0);assert.equal(f.updates.length,1);
});
