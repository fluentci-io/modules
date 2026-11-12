import test from 'node:test';
import assert from 'node:assert/strict';
import {spawnSync} from 'node:child_process';
import {fileURLToPath} from 'node:url';

test('real Android component composes setup-java, installs SDK packages, reuses them, and propagates native failures',{
 skip:process.env.FLUENTCI_ANDROID_E2E!=='1',timeout:25*60*1000,
},()=>{
 const result=spawnSync('python3',[fileURLToPath(new URL('./live.py',import.meta.url))],{encoding:'utf8',timeout:24*60*1000,maxBuffer:32*1024*1024});
 if(result.stdout)process.stdout.write(result.stdout);
 if(result.stderr)process.stderr.write(result.stderr);
 assert.ifError(result.error);assert.equal(result.status,0,'Android end-to-end verification failed');
});
