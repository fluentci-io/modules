import test from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, writeFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { spawn, spawnSync } from 'node:child_process';
import { fixture } from './host.mjs';

export function artifactSuite(tool, plugin) {
  if(tool.name==='nexus') {
    test('Nexus RAW transfers real files and rejects HTTP failures', async()=>{
      const server=spawn(process.execPath,['--input-type=module','-e',`
        import http from 'node:http';let stored;
        const server=http.createServer(async(req,res)=>{
          if(req.headers.authorization!=='Bearer synthetic'){res.writeHead(401).end();return;}
          if(req.url!=='/repository/raw/release.zip'){res.writeHead(404).end();return;}
          if(req.method==='PUT'){const data=[];for await(const chunk of req)data.push(chunk);stored=Buffer.concat(data);res.writeHead(201).end();}
          else if(stored){res.end(stored);}else{res.writeHead(404).end();}
        });server.listen(0,'127.0.0.1',()=>console.log(server.address().port));
      `],{stdio:['ignore','pipe','pipe']});
      const directory=mkdtempSync(join(tmpdir(),'fluentci-nexus-'));
      try {
        const port=await new Promise((resolve,reject)=>{
          server.stdout.once('data',data=>resolve(Number(data.toString().trim())));
          server.once('error',reject);server.once('exit',code=>reject(Error('HTTP fixture exited: '+code)));
        });
        const file=join(directory,"asset ' literal.zip"), config=join(directory,'curl.conf'), output=join(directory,'downloaded.zip');
        writeFileSync(file,'synthetic release bytes');writeFileSync(config,'header = "Authorization: Bearer synthetic"\n');
        let counter=0;
        const invoke=(command,fields)=>{
          fixture({native:true,input:{project:directory,runDir:join(directory,'run-'+counter++),curlConfig:config,...fields}});
          plugin[command]();
        };
        const url='http://127.0.0.1:'+port+'/repository/raw/release.zip';
        invoke('upload',{file,url});invoke('head',{url});invoke('download',{url,output});
        const {readFileSync}=await import('node:fs');assert.equal(readFileSync(output,'utf8'),'synthetic release bytes');
        assert.throws(()=>invoke('download',{url:'http://127.0.0.1:'+port+'/missing',output}),/failed/);
      } finally {server.kill();rmSync(directory,{recursive:true,force:true});}
    });
    return;
  }
  if(tool.name==='scorecard') {
    test('scorecard gate enforces scores and rejects incomplete reports', t=>{
      if(spawnSync('bun',['--version']).status!==0){if(process.env.FLUENTCI_REQUIRE_ARTIFACT_TESTS)assert.fail('Bun is required');t.skip('Bun is unavailable');return;}
      const directory=mkdtempSync(join(tmpdir(),'fluentci-score-gate-'));
      try {
        const report=join(directory,'score.json');
        const command=tool.commands.find(c=>c.name==='gate');
        const run=(value,minimum=7)=>{writeFileSync(report,JSON.stringify(value));return spawnSync('bun',[...command.args,report,String(minimum)],{encoding:'utf8'});};
        let result=run({checks:[{name:'Pinned-Dependencies',score:9}]},8);
        assert.equal(result.status,0,result.stderr);assert.equal(JSON.parse(result.stdout).passed,true);
        for(const value of [{checks:[{name:'check',score:6}]},{checks:[{name:'unscored',score:-1}]},{checks:[]},{},{checks:[{score:'9'}]}])assert.notEqual(run(value).status,0);
        assert.notEqual(run({checks:[{score:10}]},11).status,0);
      } finally {rmSync(directory,{recursive:true,force:true});}
    });
    return;
  }
  if (!['gh-artifacts', 'gitlab-artifacts'].includes(tool.name)) return;
  test(tool.name + ': upload adapter validates credentials, request, and remote failures', t => {
    if (spawnSync('bun', ['--version']).status !== 0) {
      if (process.env.FLUENTCI_REQUIRE_ARTIFACT_TESTS) assert.fail('Bun is required');
      t.skip('Bun is unavailable'); return;
    }
    const directory = mkdtempSync(join(tmpdir(), 'fluentci-artifact-'));
    try {
      const command = tool.commands.find(c => c.name === 'upload');
      const archive = join(directory, "release ' asset.zip");
      writeFileSync(archive, 'synthetic archive');
      const sdk = join(directory, 'sdk.mjs');
      writeFileSync(sdk, 'export class DefaultArtifactClient { async uploadArtifact(name,files,root,options) { if(process.env.TEST_FAIL)throw Error("upload failed"); return {id:123,name,files,root,options}; } }');
      const env = { ...process.env, ACTIONS_RUNTIME_TOKEN:'synthetic-token', ACTIONS_RESULTS_URL:'https://example.invalid', CI_JOB_TOKEN:'synthetic-token', FLUENTCI_GH_ARTIFACT_CLIENT:sdk };
      const args = tool.name === 'gh-artifacts' ? ['release', directory, '7', archive] : [archive, '42', 'https://gitlab.example/api/v4/'];
      const mock = tool.name === 'gitlab-artifacts' ? `globalThis.fetch=async(url,options)=>{if(url!=="https://gitlab.example/api/v4/jobs/42/artifacts?artifact_format=zip&artifact_type=archive")throw Error("wrong upload URL: "+url);if(options.method!=="POST"||options.headers["JOB-TOKEN"]!=="synthetic-token"||await options.body.get("file").text()!=="synthetic archive")throw Error("invalid request");return {ok:!process.env.TEST_FAIL,status:process.env.TEST_FAIL?403:201,text:async()=>"created"};};` : '';
      const run = changes => spawnSync('bun', ['-e', mock + command.args[1], '--', ...args], {encoding:'utf8',env:{...env,...changes}});
      const success = run({});
      assert.equal(success.status, 0, success.stderr);
      const output = JSON.parse(success.stdout);
      if (tool.name === 'gh-artifacts') {
        assert.equal(output.id,123); assert.deepEqual(output.files,[archive]);
        assert.equal(output.root,directory); assert.equal(output.options.retentionDays,7);
      } else assert.equal(output.status,201);
      assert.notEqual(run({TEST_FAIL:'1'}).status,0);
      assert.notEqual(run({ACTIONS_RUNTIME_TOKEN:'',CI_JOB_TOKEN:''}).status,0);
      assert.ok(!success.stdout.includes('synthetic-token'));
    } finally { rmSync(directory,{recursive:true,force:true}); }
  });
}
