import test from 'node:test';
import assert from 'node:assert/strict';
import {fixture} from '../../../test/setup/host.mjs';
import {captureWith} from '../output/CI.Setup.Host/index.js';

test('command environment overrides remain scoped on success and failure',()=>{
 for(const fail of [false,true]) {
  let seen;
  const f=fixture('wrangler',{env:{EXISTING:'parent'},command:(args,stderr,environment)=>{
   seen={...environment};
   assert.deepEqual(args,['fixture-command',"literal ' $(touch injected)"]);
   assert.equal(stderr,false);
   if(fail)throw Error('fixture command failed');
   return 'command output';
  }});
  const before={...f.environment};
  const invoke=()=>captureWith({PATH:'/selected/bin:/usr/bin',EXISTING:'child',NEW_VARIABLE:'value=with spaces'})(false)(['fixture-command',"literal ' $(touch injected)"])();
  if(fail)assert.throws(invoke,/fixture command failed/);
  else assert.equal(invoke(),'command output\n');
  assert.equal(seen.PATH,'/selected/bin:/usr/bin');
  assert.equal(seen.EXISTING,'child');assert.equal(seen.NEW_VARIABLE,'value=with spaces');
  assert.deepEqual(f.environment,before);assert.equal(f.updates.length,0);
 }
});

test('command environment rejects invalid identifiers before host effects',()=>{
 for(const key of ['-i','A=B','BAD-NAME','bad\nkey','']) {
  const f=fixture('wrangler');
  assert.throws(()=>captureWith({[key]:'value'})(false)(['fixture-command'])());
  assert.equal(f.calls.length,0);assert.equal(f.scopedCalls.length,0);assert.equal(f.updates.length,0);
 }
 const f=fixture('wrangler');
 assert.throws(()=>captureWith({PATH:'/selected/bin'})(false)([])(),/executable/);
 assert.equal(f.calls.length,0);assert.equal(f.updates.length,0);
});
