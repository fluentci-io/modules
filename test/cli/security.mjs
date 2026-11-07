import assert from 'node:assert/strict';
import { test } from 'node:test';
import { spawnSync } from 'node:child_process';
import { mkdirSync, mkdtempSync, readFileSync, realpathSync, rmSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { tmpdir } from 'node:os';
import { fixture } from './host.mjs';

export function securitySuite(tool, plugin) {
  if (!['betterleaks','gitleaks','syft'].includes(tool.name)) return;
  const available=spawnSync('which',[tool.program],{encoding:'utf8'}).status===0;
  const required=process.env.FLUENTCI_REQUIRE_SECURITY_TESTS==='1';
  test('native '+tool.name+' scans only controlled offline fixtures',{skip:!available&&!required,timeout:120000},()=>{
    assert.ok(available,tool.program+' must be installed');
    const project=realpathSync(mkdtempSync(join(tmpdir(),'fluentci-security-')));
    mkdirSync(join(project,'data'));
    let counter=0;
    try {
      const invoke=(command,fields,failure=false)=>{
        const runDir=join(project,'run-'+counter++);
        const f=fixture({native:true,env:{SYFT_CHECK_FOR_APP_UPDATE:'false'},input:{project,runDir,...fields}});
        if(failure) {assert.throws(plugin[command],/failed/);assert.equal(f.output.length,0);}
        else {
          try{plugin[command]();}catch(error){throw Error(error.message+'\n'+readFileSync(join(runDir,tool.name+'.stderr'),'utf8'));}
          assert.equal(JSON.parse(f.output[0]).outcome,'succeeded');
        }
        return runDir;
      };
      if(['betterleaks','gitleaks'].includes(tool.name)) {
        const config=join(project,'rules.toml'),reportPath=join(project,'findings.json');
        writeFileSync(config,`title = "fixture"\n[[rules]]\nid = "fixture-marker"\ndescription = "synthetic marker"\nregex = '''MODULE_TEST_SECRET_[A-Z]{16}'''\n`);
        writeFileSync(join(project,'data/sample.txt'),'ordinary fixture text\n');
        const fields={directory:'data',config,reportPath};
        invoke('scan_dir',fields);
        const synthetic='MODULE_TEST_SECRET_'+'A'.repeat(16);
        writeFileSync(join(project,'data/sample.txt'),synthetic+'\n');
        invoke('scan_dir',fields,true);
        const findings=readFileSync(reportPath,'utf8');
        assert.equal(JSON.parse(findings).length,1);
        assert.ok(!findings.includes(synthetic),'Report must redact the synthetic credential');
      }else{
        writeFileSync(join(project,'data/package.json'),JSON.stringify({name:'fixture',version:'1.0.0',dependencies:{'example-dependency':'1.2.3'}}));
        writeFileSync(join(project,'data/package-lock.json'),JSON.stringify({name:'fixture',version:'1.0.0',lockfileVersion:3,packages:{'':{name:'fixture',version:'1.0.0',dependencies:{'example-dependency':'1.2.3'}},'node_modules/example-dependency':{version:'1.2.3'}}}));
        const file=join(project,'sbom.json');
        invoke('scan',{source:'dir:data',output:['syft-json='+file]});
        const sbom=JSON.parse(readFileSync(file,'utf8'));
        assert.ok(sbom.artifacts.some(a=>a.name==='example-dependency'&&a.version==='1.2.3'));
        const converted=join(project,'cyclonedx.json');
        invoke('convert',{file,output:['cyclonedx-json='+converted]});
        assert.equal(JSON.parse(readFileSync(converted,'utf8')).bomFormat,'CycloneDX');
      }
    } finally {rmSync(project,{recursive:true,force:true});}
  });
}
