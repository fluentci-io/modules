import test from 'node:test';
import assert from 'node:assert/strict';
import {spawnSync} from 'node:child_process';
import {mkdtempSync,writeFileSync,readFileSync,rmSync} from 'node:fs';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
const catalog=JSON.parse(readFileSync(new URL('../../../lib/cli/catalog.json',import.meta.url)));
const command=catalog.find(t=>t.name==='nix-publish').commands.find(c=>c.name==='flakestry');
const available=spawnSync('bun',['--version'],{timeout:10000}).status===0;
test('Flakestry publishes the native registry payload using synthetic OIDC and rejects failures',{skip:!available&&!process.env.FLUENTCI_REQUIRE_ARTIFACT_TESTS},()=>{
 assert.ok(available,'Bun is required');const directory=mkdtempSync(join(tmpdir(),'fluentci-nix-publish-'));
 try {
  const trace=join(directory,'nix-argv');
  writeFileSync(join(directory,'nix'),'#!/bin/sh\nif [ -n "$TEST_NIX_FAIL" ]; then exit 23; fi\nprintf "%s\\n" "$@" >> "$TRACE_FILE"\ncase "$*" in *metadata*) printf \'{"locked":{"rev":"fixture"}}\\n\';; *) printf \'{"packages":{"x86_64-linux":{}}}\\n\';; esac\n',{mode:0o755});
  const mock=`globalThis.fetch=async(url,options)=>{const u=new URL(url);if(u.hostname==='actions.example.invalid'){if(u.searchParams.get('audience')!=='https://registry.example.invalid'||u.searchParams.get('request')!=='original'||options.headers.Authorization!=='bearer request-sentinel'||options.redirect!=='error')throw Error('bad OIDC request');return {ok:!process.env.TEST_OIDC_FAIL,status:403,json:async()=>({value:process.env.TEST_EMPTY_IDENTITY?'':'oidc-sentinel'})};}if(u.href!=='https://registry.example.invalid/api/publish'||options.method!=='POST'||options.headers['Github-Token']!=='github-sentinel'||options.headers.Authorization!=='Bearer oidc-sentinel')throw Error('bad registry request');const p=JSON.parse(options.body);if(p.version!=='v1.2.3'||p.ref!=='commit-sha'||p.readme!=='docs/README.md'||p.metadata.locked.rev!=='fixture'||!p.outputs.packages||typeof p.metadata_errors!=='string'||typeof p.outputs_errors!=='string')throw Error('bad registry payload');return {ok:!process.env.TEST_STATUS,status:Number(process.env.TEST_STATUS||200)};};\n`;
  const env={...process.env,PATH:directory+':'+process.env.PATH,TRACE_FILE:trace,GH_TOKEN:'github-sentinel',ACTIONS_ID_TOKEN_REQUEST_TOKEN:'request-sentinel',ACTIONS_ID_TOKEN_REQUEST_URL:'https://actions.example.invalid/token?request=original'};
  const run=(changes={},ignore='false',url='https://registry.example.invalid')=>spawnSync('bun',['-e',mock+command.args[1],'--','v1.2.3','commit-sha','docs/README.md',url,ignore],{env:{...env,...changes},encoding:'utf8',timeout:20000});
  let result=run();assert.equal(result.status,0,result.stderr);assert.equal(JSON.parse(result.stdout).published,true);const argv=readFileSync(trace,'utf8');assert.equal(argv.match(/--no-write-lock-file/g).length,2);assert.ok(argv.includes('--all-systems'));
  result=run({TEST_STATUS:'409'},'true');assert.equal(result.status,0,result.stderr);assert.equal(JSON.parse(result.stdout).alreadyExists,true);
  for(const changes of [{GH_TOKEN:''},{ACTIONS_ID_TOKEN_REQUEST_TOKEN:''},{ACTIONS_ID_TOKEN_REQUEST_URL:''},{TEST_OIDC_FAIL:'1'},{TEST_EMPTY_IDENTITY:'1'},{TEST_STATUS:'409'},{TEST_STATUS:'500'},{TEST_NIX_FAIL:'1'}]){result=run(changes);assert.notEqual(result.status,0);assert.equal(result.stdout,'');for(const secret of ['github-sentinel','request-sentinel','oidc-sentinel'])assert.ok(!result.stderr.includes(secret));}
  result=run({},'false','http://registry.example.invalid');assert.notEqual(result.status,0);
 } finally {rmSync(directory,{recursive:true,force:true});}
});
