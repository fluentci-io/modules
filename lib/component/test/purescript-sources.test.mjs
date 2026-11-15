import test from 'node:test';
import assert from 'node:assert/strict';
import {mkdtemp, mkdir, writeFile, rm} from 'node:fs/promises';
import {tmpdir} from 'node:os';
import {dirname, join} from 'node:path';
import {purescriptBuildArgs} from '../purescript-sources.mjs';

test('dependency builds include installed Flow without duplicating the full SDK', async t => {
  const root=await mkdtemp(join(tmpdir(),'fluentci source paths '));
  t.after(()=>rm(root,{recursive:true,force:true}));
  assert.deepEqual(await purescriptBuildArgs(root,false),['build']);
  const files=['.sdk/purescript/src/FluentCI/Flow.purs','.sdk/purescript/src/FluentCI/Flow.js','.sdk/inspection/composition-runtime.mjs'];
  for(const file of files) {
    await assert.rejects(purescriptBuildArgs(root,true),/Missing generated pipeline support/);
    await mkdir(dirname(join(root,file)),{recursive:true});
    await writeFile(join(root,file),'fixture');
  }
  assert.deepEqual(await purescriptBuildArgs(root,true),[
    'build','--purs-args=.sdk/purescript/src/FluentCI/Flow.purs',
  ]);
});
