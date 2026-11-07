import assert from 'node:assert/strict';
import { test } from 'node:test';
import { existsSync, mkdtempSync, readFileSync, realpathSync, rmSync, writeFileSync } from 'node:fs';
import { join, resolve } from 'node:path';
import { tmpdir } from 'node:os';
import { fixture } from './host.mjs';

export function browserSuite(tool, plugin) {
  if (!['playwright','cypress'].includes(tool.name)) return;
  const tools=process.env.FLUENTCI_BROWSER_TOOLS;
  const required=process.env.FLUENTCI_REQUIRE_BROWSER_TESTS==='1';
  test('native '+tool.name+' runs browser assertions and propagates test failures', {skip:!tools&&!required,timeout:300000},()=>{
    assert.ok(tools,'Set FLUENTCI_BROWSER_TOOLS to the npm installation prefix');
    const packageName=tool.name==='playwright'?'@playwright/test':'cypress';
    const version=JSON.parse(readFileSync(resolve(tools,'node_modules',packageName,'package.json'),'utf8')).version;
    const project=realpathSync(mkdtempSync(join(tmpdir(),'fluentci-browser-')));
    let counter=0;
    try {
      writeFileSync(join(project,'package.json'),JSON.stringify({name:'browser-fixture',private:true}));
      const setup=fixture({native:true,input:{project,runDir:join(project,'setup-run'),version,timeoutMs:120000}});
      try {plugin.setup();} catch(error) {
        const log=join(project,'setup-run',tool.name+'.stderr');
        const logs=existsSync(log)?readFileSync(log,'utf8'):'';
        throw Error(error.message+'\n'+logs);
      }
      assert.equal(JSON.parse(setup.output[0]).outcome,'succeeded');
      assert.equal(JSON.parse(readFileSync(join(project,'package.json'),'utf8')).devDependencies[packageName],version);
      const executable=join(project,'node_modules','.bin',tool.program);
      assert.ok(existsSync(executable));
      function invoke(command,fields={},failure=false) {
        const runDir=join(project,'run-'+counter++);
        const f=fixture({native:true,input:{project,executable,runDir,timeoutMs:120000,...fields}});
        if(failure) {
          assert.throws(plugin[command],/failed/);
          assert.equal(f.output.length,0);
        } else {
          try {plugin[command]();} catch(error) {
            const logs=['stdout','stderr'].map(suffix=>{
              const path=join(runDir,tool.name+'.'+suffix);
              return existsSync(path)?readFileSync(path,'utf8'):'';
            }).join('\n');
            throw Error(error.message+'\n'+logs);
          }
          assert.equal(JSON.parse(f.output[0]).outcome,'succeeded');
        }
        return runDir;
      }
      invoke('version');
      if(tool.name==='playwright') {
        writeFileSync(join(project,'playwright.config.cjs'),'module.exports = {testDir: ".", testMatch: "*.spec.cjs", use: {browserName: "chromium", headless: true}};\n');
        const spec=join(project,'smoke.spec.cjs');
        writeFileSync(spec,'const {test,expect}=require("@playwright/test"); test("local browser",async({page})=>{await page.setContent("<h1>module passed</h1>"); await expect(page.locator("h1")).toHaveText("module passed");});\n');
        const listing=invoke('list',{tests:['smoke.spec.cjs']});
        assert.match(readFileSync(join(listing,'playwright.stdout'),'utf8'),/local browser/);
        const run=invoke('test',{tests:['smoke.spec.cjs'],workers:1,retries:0,reporter:'line',forbidOnly:true});
        assert.match(readFileSync(join(run,'playwright.stdout'),'utf8'),/1 passed/);
        writeFileSync(spec,'const {test,expect}=require("@playwright/test"); test("expected failure",()=>{expect(1).toBe(2);});\n');
        const failed=invoke('test',{tests:['smoke.spec.cjs'],workers:1,retries:0,reporter:'line'},true);
        assert.match(readFileSync(join(failed,'playwright.stdout'),'utf8'),/1 failed/);
      } else {
        writeFileSync(join(project,'cypress.config.cjs'),'module.exports = {video: false, screenshotOnRunFailure: false, e2e: {supportFile: false, specPattern: "*.cy.js"}};\n');
        const spec=join(project,'smoke.cy.js');
        writeFileSync(spec,'describe("local browser",()=>{it("renders local content",()=>{cy.document().then(doc=>{doc.body.innerHTML="<h1>module passed</h1>";});cy.get("h1").should("have.text","module passed");});});\n');
        invoke('verify');
        const run=invoke('test',{browser:'electron',spec:'smoke.cy.js',reporter:'spec'});
        assert.match(readFileSync(join(run,'cypress.stdout'),'utf8'),/1 passing/);
        writeFileSync(spec,'describe("expected failure",()=>{it("fails",()=>{expect(1).to.equal(2);});});\n');
        const failed=invoke('test',{browser:'electron',spec:'smoke.cy.js',reporter:'spec'},true);
        assert.match(readFileSync(join(failed,'cypress.stdout'),'utf8'),/1 failing/);
      }
    } finally {rmSync(project,{recursive:true,force:true});}
  });
}
