import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture} from '../../../test/setup/host.mjs';
const {setup}=createRequire(import.meta.url)('../dist/plugin.cjs');
test('major-only release tags pin the upstream flake without probing authenticated commands',()=>{
 const f=fixture('flakehub-push',{input:{version:'v7'},command:args=>args[0]==='curl'&&!args.includes('--output')?JSON.stringify({tag_name:'v7'}):undefined});
 setup();const result=JSON.parse(f.output[0]);assert.equal(result.version,'v7');assert.ok(f.calls.some(args=>args[0]==='nix'&&args.includes('github:DeterminateSystems/flakehub-push/v7')));assert.ok(!f.calls.some(args=>args[0].endsWith('/flakehub-push')));
});
