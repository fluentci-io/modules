import test from 'node:test';
import assert from 'node:assert/strict';
import {runBuildPool,serviceInvocation} from '../../scripts/services_e2e_helpers.mjs';

test('service calls select the registered module and keep the workspace as a literal argument',()=>{
 assert.deepEqual(serviceInvocation('redis','logs',"/tmp/workspace with ' quotes",{follow:true,tail:20}),[
  'fluentci','run','redis','logs','--project',"/tmp/workspace with ' quotes",'--follow=true','--tail=20',
 ]);
 assert.deepEqual(serviceInvocation('aws-emulator','start','/tmp/project',{stateDir:'/tmp/aws material'}).slice(-1),['--state-dir=/tmp/aws material']);
});

test('build workers overlap while shared dependency operations remain exclusive',async()=>{
 let active=0,peak=0,preparing=0,peakPreparing=0;const completed=[];
 const turn=()=>new Promise(resolve=>setImmediate(resolve));
 const failures=await runBuildPool([1,2,3,4],2,async(item,serial)=>{
  active++;peak=Math.max(peak,active);
  await serial(async()=>{preparing++;peakPreparing=Math.max(peakPreparing,preparing);await turn();preparing--;});
  await turn();completed.push(item);active--;
 });
 assert.deepEqual(failures,[]);assert.equal(peak,2);assert.equal(peakPreparing,1);
 assert.deepEqual(completed.sort(),[1,2,3,4]);assert.equal(active,0);
});

test('failed preparation does not poison the queue and every worker settles',async()=>{
 const completed=[];
 const failures=await runBuildPool([1,2,3],2,async(item,serial)=>{
  await serial(async()=>{if(item===1)throw Error('fixture failure');});
  await new Promise(resolve=>setImmediate(resolve));completed.push(item);
 });
 assert.equal(failures.length,1);assert.equal(failures[0].item,1);
 assert.match(failures[0].error.message,/fixture failure/);assert.deepEqual(completed.sort(),[2,3]);
 for(const count of [0,-1,1.5,5,NaN])await assert.rejects(runBuildPool([],count,()=>{}),/SERVICE_BUILD_CONCURRENCY/);
});
