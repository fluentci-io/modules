import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture} from '../../../test/setup/host.mjs';
const {setup}=createRequire(import.meta.url)('../dist/plugin.cjs');

for(const os of ['linux','macos'])test(`${os}: installs nixpkgs Cachix before configuring the cache`,()=>{
 const f=fixture('cachix',{os,input:{cache:'fluentci',installDir:'/tmp/cachix-fixture'},versionOutput:'cachix 1.2.3'});
 setup();
 const install=f.calls.findIndex(args=>args[0]==='nix'&&args.includes('profile')&&args.includes('install'));
 assert.ok(install>=0);assert.ok(f.calls[install].includes('nixpkgs#cachix'));
 assert.ok(f.calls[install].includes('/tmp/cachix-fixture/profile'));
 const use=f.calls.findIndex(args=>args[0]==='/tmp/cachix-fixture/bin/cachix'&&args[1]==='use'&&args[2]==='fluentci');
 assert.ok(use>install);assert.ok(!f.calls.some(args=>args[0]==='curl'));
 assert.ok(!JSON.stringify(f.calls).includes('github:cachix/cachix'));
 assert.equal(JSON.parse(f.output[0]).version,'1.2.3');
});

test('a pinned version must match the Cachix package supplied by nixpkgs',()=>{
 const f=fixture('cachix',{input:{version:'1.2.3'},versionOutput:'cachix 1.2.4'});
 assert.throws(setup,/mismatch/);assert.ok(f.calls.some(args=>args.includes('nixpkgs#cachix')));
 assert.equal(f.output.length,0);assert.equal(f.updates.length,0);
});

test('Nix profile install failures propagate before cachix use or environment publication',()=>{
 const f=fixture('cachix',{input:{cache:'fluentci'},fail:args=>args[0]==='nix'&&args.includes('install')});
 assert.throws(setup);assert.ok(!f.calls.some(args=>args[1]==='use'));
 assert.equal(f.output.length,0);assert.equal(f.updates.length,0);
});
