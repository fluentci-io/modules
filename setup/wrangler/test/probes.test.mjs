import test from 'node:test';
import assert from 'node:assert/strict';
import {mkdtempSync,writeFileSync,rmSync} from 'node:fs';
import {join} from 'node:path';
import {tmpdir} from 'node:os';
import {fixture} from '../../../test/setup/host.mjs';
import {exists,findExecutable} from '../output/CI.Setup.Host/index.js';

test('optional installer probes never create failed host tasks for missing paths or tools',()=>{
 const directory=mkdtempSync(join(tmpdir(),'fluentci-probe-'));
 try {
  const host=fixture('wrangler',{native:true});
  assert.equal(exists(join(directory,'missing'))(),false);
  assert.equal(findExecutable('fluentci-no-such-tool-948267')(),'');
  const literal=join(directory,"a ' $(touch injected) file");writeFileSync(literal,'fixture');
  assert.equal(exists(literal)(),true);
  assert.ok(host.calls.every(args=>args[0]==='sh'));
  assert.equal(exists(join(directory,'injected'))(),false);
 } finally {rmSync(directory,{recursive:true,force:true});}
});
