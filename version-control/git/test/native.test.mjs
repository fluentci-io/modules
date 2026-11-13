import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {mkdtempSync,writeFileSync,readFileSync,mkdirSync,rmSync} from 'node:fs';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {spawnSync} from 'node:child_process';
import {fixture} from '../../../test/cli/host.mjs';
const plugin=createRequire(import.meta.url)('../dist/plugin.cjs');

test('native Git stages, commits, tags, archives and clones an offline fixture and propagates invalid refs',()=>{
 const root=mkdtempSync(join(tmpdir(),'fluentci-vcs-'));
 const source=join(root,'source');mkdirSync(source);
 const env={GIT_CONFIG_NOSYSTEM:'1',GIT_CONFIG_GLOBAL:join(root,'unused-config'),GIT_AUTHOR_NAME:'CI Fixture',GIT_AUTHOR_EMAIL:'fixture@example.invalid',GIT_COMMITTER_NAME:'CI Fixture',GIT_COMMITTER_EMAIL:'fixture@example.invalid'};
 let counter=0;
 const invoke=(command,fields={})=>{
  const runDir=join(root,'run-'+counter++);
  const f=fixture({native:true,env,input:{project:source,runDir,...fields}});plugin[command]();
  assert.equal(JSON.parse(f.output[0]).outcome,'succeeded');return readFileSync(join(runDir,'git.stdout'),'utf8').trim();
 };
 try{
  const init=spawnSync('git',['init',source],{encoding:'utf8',env:{...process.env,...env}});
  assert.equal(init.status,0,init.stderr);
  writeFileSync(join(source,'source.txt'),'offline fixture\n');
  invoke('add',{paths:'source.txt'});invoke('commit',{message:'Fixture commit'});
  const sha=invoke('rev_parse',{revision:'HEAD'});assert.match(sha,/^[a-f0-9]{40,64}$/);
  invoke('tag',{name:'v1.0.0',message:'Fixture release'});assert.equal(invoke('describe',{revision:'HEAD'}),'v1.0.0');
  const archive=join(root,'source.tar');invoke('archive',{tree:'HEAD',output:archive});assert.ok(readFileSync(archive).length>0);
  const checkout=join(root,'checkout');invoke('clone',{url:source,directory:checkout});assert.equal(readFileSync(join(checkout,'source.txt'),'utf8'),'offline fixture\n');
  writeFileSync(join(source,'source.txt'),'changed fixture\n');assert.throws(()=>invoke('diff'),/failed/);
  assert.throws(()=>invoke('rev_parse',{revision:'refs/heads/nonexistent-fixture'}),/failed/);
 }finally{rmSync(root,{recursive:true,force:true});}
});
