import test from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {fixture} from '../../../test/cli/host.mjs';
const plugin = createRequire(import.meta.url)('../dist/plugin.cjs');
test('Scanner keeps -D properties, quality gate waiting, and SONAR_TOKEN separate from sonar CLI', () => {
  const f = fixture({input:{runDir:'/tmp/scanner-csv',projectKey:'app',sources:'src',qualityGateWait:true,properties:'sonar.sourceEncoding=UTF-8,"sonar.exclusions=vendor/**,generated/**"'},env:{SONAR_TOKEN:'scanner-secret'}});
  plugin.scan();
  const task = f.plans[0].plan.tasks[0];
  assert.equal(task.program,'sonar-scanner');
  assert.deepEqual(task.args,['-Dsonar.projectKey=app','-Dsonar.sources=src','-Dsonar.qualitygate.wait=true','-Dsonar.sourceEncoding=UTF-8','-Dsonar.exclusions=vendor/**,generated/**']);
  assert.ok(!JSON.stringify(f.plans).includes('scanner-secret'));
});
test('Scanner rejects malformed CSV property lists before host calls', () => {
  for (const properties of ['a,,b','"unfinished',['key=value']]) {
    const f = fixture({input:{runDir:'/tmp/scanner-invalid',properties}});
    assert.throws(plugin.scan); assert.equal(f.calls.length,0); assert.equal(f.plans.length,0);
  }
});
