import test from 'node:test';
import assert from 'node:assert/strict';
import { createRequire } from 'node:module';
import { fixture as hostFixture } from '../../../test/setup/host.mjs';

const plugin = createRequire(import.meta.url)('../dist/plugin.cjs');
const release = '1.12.0.17622';
function fixture(options = {}) {
  return hostFixture('sonarqube', { ...options, command(args) {
    if (options.fail?.(args)) throw Error('Injected failure');
    if (args[0] === 'which') return '/usr/bin/' + args[1];
    if (args[0] === 'curl' && !args.includes('--output')) {
      if (args.at(-1).endsWith('/stable.version')) return options.release ?? release;
      if (args.at(-1).includes('/releases?')) return JSON.stringify([{tag_name: release}]);
      throw Error('Unexpected metadata URL: ' + args.at(-1));
    }
    if (args[0].endsWith('/bin/sonar') && args[1] === '--version') return 'sonar v' + (options.actualVersion ?? '1.12.0');
    return undefined;
  }});
}
for (const [os, arch, platform] of [['linux','x86_64','linux-x86-64'],['linux','aarch64','linux-arm64'],['macos','aarch64','macos-arm64']]) {
  test(`${os}/${arch}: resolves a concrete release and installs the standalone sonar binary`, () => {
    const f = fixture({os, arch}); plugin.setup();
    const result = JSON.parse(f.output[0]);
    assert.equal(result.version, '1.12.0');
    assert.equal(result.binDir, `/home/test/.local/share/fluentci/sonarqube/${release}/bin`);
    assert.ok(f.calls.some(a => a[0] === 'curl' && a.at(-1) === `https://binaries.sonarsource.com/Distribution/sonarqube-cli/${release}/${os}/sonarqube-cli-${release}-${platform}.bin`));
    assert.ok(f.calls.some(a => a[0] === 'chmod' && a.at(-1).endsWith('/bin/sonar')));
    assert.ok(!f.calls.some(a => ['java','unzip','pkg','pkg_add','pkgin'].includes(a[0])));
    assert.equal(f.environment.PATH, result.environment.PATH);
  });
}
test('semantic versions resolve to a full release ID; exact versions do not fetch metadata', () => {
  for (const version of ['1.12.0', release]) {
    const f = fixture({input:{version}}); plugin.setup();
    const metadata = f.calls.filter(a => a[0] === 'curl' && !a.includes('--output'));
    assert.equal(metadata.length, version === release ? 0 : 1);
    assert.ok(JSON.parse(f.output[0]).binDir.includes('/' + release + '/bin'));
  }
});
test('legacy CDN binaries fall back from .bin to .exe without invoking the vendor installer', () => {
  const f = fixture({fail:a => a[0] === 'curl' && a.includes('--output') && a.at(-1).endsWith('.bin')}); plugin.setup();
  assert.equal(f.calls.filter(a => a[0] === 'curl' && a.includes('--output')).length, 2);
  assert.ok(f.calls.some(a => a[0] === 'curl' && a.at(-1).endsWith('.exe')));
});
test('cached installations are verified and reused without downloading', () => {
  const f = fixture({existing:true,input:{version:release}}); plugin.setup();
  assert.ok(f.calls.some(a => a[0].endsWith('/bin/sonar') && a[1] === '--version'));
  assert.ok(!f.calls.some(a => a[0] === 'curl'));
});
test('unsupported hosts, malformed selectors and system-install options fail before commands', () => {
  for (const options of [
    ...['freebsd','openbsd','netbsd','windows'].map(os => ({os})),
    {os:'macos',arch:'x86_64'}, {input:{version:'1.12'}}, {input:{version:'bad'}},
    {input:{version:'../escape'}}, {input:{sudo:true}}, {input:{packageName:'sonar-scanner'}},
  ]) {
    const f = fixture(options); assert.throws(plugin.setup);
    assert.equal(f.calls.length, 0); assert.equal(f.updates.length, 0);
  }
});
test('bad metadata, download failures and wrong banners never publish a successful setup', () => {
  for (const options of [
    {release:'../invalid'}, {actualVersion:'9.0.0'},
    {fail:a => a[0] === 'curl' && a.includes('--output')},
    {fail:a => a[0] === 'cp'},
  ]) {
    const f = fixture(options); assert.throws(plugin.setup);
    assert.equal(f.output.length,0); assert.equal(f.updates.length,0);
    if (!options.release) assert.ok(f.calls.some(a => a[0] === 'rm' && a.includes('--')));
  }
});
