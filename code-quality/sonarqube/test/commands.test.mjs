import '../../../test/dependencies/loader.mjs';
import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {readFileSync} from 'node:fs';
import {fixture} from '../../../test/cli/host.mjs';

const plugin = createRequire(import.meta.url)('../dist/plugin.cjs');
const upstream = JSON.parse(readFileSync(new URL('../upstream-commands.json', import.meta.url)));
const catalog = JSON.parse(readFileSync(new URL('../../../lib/cli/catalog.json', import.meta.url))).find(t => t.name === 'sonarqube');
const native = await import('../output/CI.Component/index.js');
const {Just, Nothing} = await import('../output/Data.Maybe/index.js');
function argv(name, input = {}) {
  const f = fixture({input:{runDir:'/tmp/sonar-command',...input}}); plugin[name]();
  assert.equal(f.plans[0].plan.tasks[0].program, 'sonar');
  return f.plans[0].plan.tasks[0].args;
}
test('every reviewed executable upstream command has a named function with all native options', () => {
  for (const source of upstream.commands) {
    if (source.isRoot || (source.isGroup && !['sonar analyze','sonar link','sonar update'].includes(source.fullName))) continue;
    const args = source.fullName.split(' ').slice(1);
    const command = catalog.commands.find(c => JSON.stringify(c.args) === JSON.stringify(args));
    assert.ok(command,source.fullName);
    for (const option of source.options) assert.ok(command.fields.some(f => f.flag === option.long),source.fullName + ' ' + option.long);
    const input = Object.fromEntries(command.fields.filter(f => f.required && f.default === null).map(f => [f.key,f.sample]));
    const actual = argv(command.name,input);
    assert.deepEqual(actual.slice(0,args.length),args);
  }
});
test('analysis repeats CSV file options literally; project directory and remote project key stay distinct', () => {
  assert.deepEqual(argv('analyze_agentic',{project:'/tmp/repository',projectKey:'org_app',files:'src/one.ts,"src/two,three.ts"',depth:'DEEP',force:true}),[
    'analyze','agentic','--file=src/one.ts','--file=src/two,three.ts','--project=org_app','--force','--depth=DEEP',
  ]);
  assert.deepEqual(argv('analyze_secrets',{paths:'src/one.ts, src/two.ts',exclude:'vendor, generated'}),[
    'analyze','secrets','--exclude=vendor','--exclude=generated','src/one.ts','src/two.ts',
  ]);
});
test('issue filters and remediation IDs use one normalized comma-separated native option', () => {
  assert.deepEqual(argv('list_issues',{projectKey:'app',statuses:'OPEN, CONFIRMED',severities:'HIGH,BLOCKER',pullRequest:'42'}),[
    'list','issues','--project=app','--statuses=OPEN,CONFIRMED','--severities=HIGH,BLOCKER','--pull-request=42',
  ]);
  assert.deepEqual(argv('remediate',{issues:'one, two'}),['remediate','--issues=one,two']);
});
test('API, architecture and import commands preserve native operand order without shell expansion', () => {
  assert.deepEqual(argv('api',{method:'post',endpoint:'/api/test',data:'{"literal":"$(touch injected)"}'}),['api','--data={"literal":"$(touch injected)"}','post','/api/test']);
  assert.deepEqual(argv('architecture_current_get',{projectKey:'app',from:'a',to:'b',page:2}),['architecture','current','get','--project=app','--from=a','--to=b','--page=2']);
  assert.deepEqual(argv('import_repositories',{repo:'org/one,org/two'}),['import','--repo=org/one','--repo=org/two','--non-interactive']);
  assert.deepEqual(argv('system_reset'),['system','reset']);
});
test('malformed lists fail before any setup or host calls', () => {
  for (const [name,key] of [['analyze','files'],['analyze_secrets','paths'],['list_issues','statuses'],['remediate','issues'],['import_repositories','repo'],['run','arguments']]) {
    for (const value of ['a,,b','a,','"unfinished',['one'],'bad\0value']) {
      const f = fixture({input:{runDir:'/tmp/sonar-invalid',[key]:value}});
      assert.throws(plugin[name]); assert.equal(f.calls.length,0); assert.equal(f.plans.length,0);
    }
  }
});
test('architecture input files are checked before setup dependencies', () => {
  let installed = false; globalThis.fluentciSetupDependencies = {'setup-sonarqube':() => {installed=true;}};
  const f = fixture({input:{runDir:'/tmp/sonar-missing',file:'missing.json'},fail:a => a[0] === 'test' && a[1] === '-f'});
  assert.throws(plugin.architecture_intended_set); assert.equal(installed,false); assert.equal(f.plans.length,0);
});
test('typed quality gate forwards remote selectors and returns the execution report with inherited credentials', () => {
  const contract = JSON.parse(readFileSync(new URL('../schema.json',import.meta.url))).exports.quality_gate_status;
  const input = Object.fromEntries(Object.keys(contract.input.properties).map(key => [key,key === 'runDir' ? '/tmp/typed-sonar' : Nothing.value]));
  input.projectKey = new Just('app'); input.branch = new Just('main'); input.format = new Just('json');
  const f = fixture({env:{SONARQUBE_CLI_TOKEN:'secret-fixture',SONARQUBE_CLI_ORG:'org'}});
  const result = native.quality_gate_status(input)();
  assert.equal(result.outcome,'succeeded');
  assert.deepEqual(f.plans[0].plan.tasks[0].args,['quality-gate','status','--project=app','--format=json','--branch=main']);
  assert.equal(f.plans[0].plan.inherit_env,true); assert.ok(!JSON.stringify(f.plans).includes('secret-fixture'));
});
