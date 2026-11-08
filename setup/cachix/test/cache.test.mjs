import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture} from '../../../test/setup/host.mjs';

const {setup}=createRequire(import.meta.url)('../dist/plugin.cjs');
function host(options={}) {
 return fixture('cachix',{existing:true,versionOutput:'cachix 1.2.3',...options,input:{version:'1.2.3',cache:'fluentci',...options.input}});
}

for(const os of ['linux','macos'])test(`${os}: configures a public cache without authentication`,()=>{
 const f=host({os});setup();const result=JSON.parse(f.output[0]);
 assert.ok(f.calls.some(args=>args[0]===result.binDir+'/cachix'&&args[1]==='use'&&args[2]==='fluentci'));
 assert.equal(result.tool,'cachix');assert.ok(f.updates.length>0);
});

test('private cache credentials stay inherited and out of command arguments and returns',()=>{
 const token='fixture-private-cache-token';
 const f=host({env:{CACHIX_AUTH_TOKEN:token},input:{cache:'private-builds'}});setup();
 assert.ok(f.calls.some(args=>args[1]==='use'&&args[2]==='private-builds'));
 assert.ok(!JSON.stringify(f.calls).includes(token));assert.ok(!JSON.stringify(f.output).includes(token));
 assert.equal(JSON.parse(f.output[0]).environment.CACHIX_AUTH_TOKEN,undefined);
});

test('cache names are validated before any host command',()=>{
 for(const cache of ['', ' ', 'UPPER', '-cache', 'cache-', 'cache.name', '--help', 'cache;id', 'a'.repeat(64), 'cache\nname', null, 42, []]){
  const f=host({input:{cache}});assert.throws(setup);assert.equal(f.calls.length,0);assert.equal(f.updates.length,0);
 }
});

test('omitting cache retains CLI-only setup',()=>{
 const f=fixture('cachix',{existing:true,versionOutput:'cachix 1.2.3',input:{version:'1.2.3'}});setup();
 assert.ok(!f.calls.some(args=>args[1]==='use'));assert.equal(f.output.length,1);
});

test('missing Nix and failed cache configuration do not publish successful setup',()=>{
 for(const fail of [args=>args[0]==='which'&&args[1]==='nix',args=>args[1]==='use']){
  const f=host({fail});assert.throws(setup);assert.equal(f.output.length,0);assert.equal(f.updates.length,0);
 }
});

test('typed cache argument configures the cache and returns the setup result',async()=>{
 const native=await import('../output/CI.Component/index.js');
 const {Just,Nothing}=await import('../output/Data.Maybe/index.js');
 const f=host();const result=native.setup({version:new Just('1.2.3'),cache:new Just('typed-cache'),installDir:Nothing.value,packageName:Nothing.value,sudo:Nothing.value})();
 assert.ok(f.calls.some(args=>args[1]==='use'&&args[2]==='typed-cache'));
 assert.equal(result.tool,'cachix');assert.ok(result.environment.some(variable=>variable.name==='PATH'));
});
