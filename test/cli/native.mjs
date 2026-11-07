import assert from 'node:assert/strict';
import { test } from 'node:test';
import { spawnSync } from 'node:child_process';
import { mkdtempSync, readFileSync, realpathSync, rmSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { tmpdir } from 'node:os';
import { fixture } from './host.mjs';

export function nativeSuite(tool, plugin) {
  if (tool.name === 'uv') {
    const available=spawnSync('which',['uv'],{encoding:'utf8'}).status===0;
    test('native uv locks, syncs, and runs an offline Python project', {skip:!available&&process.env.FLUENTCI_REQUIRE_CLI_NATIVE_TESTS!=='1'},()=>{
      assert.ok(available,'uv must be installed for native tests');
      const project=realpathSync(mkdtempSync(join(tmpdir(),'fluentci-uv-')));
      try {
        const python=spawnSync('python3',['-c','import sys; print(sys.executable)'],{encoding:'utf8'}).stdout.trim();
        writeFileSync(join(project,'pyproject.toml'),'[project]\nname = "module-fixture"\nversion = "0.1.0"\nrequires-python = ">=3.9"\ndependencies = []\n[tool.uv]\npackage = false\n');
        const env={UV_CACHE_DIR:join(project,'cache'),UV_PYTHON_DOWNLOADS:'never',UV_OFFLINE:'1'};
        const invoke=(command,fields)=>{
          const f=fixture({native:true,env,input:{project,runDir:join(project,command+'-run'),python,...fields}});
          plugin[command](); return f;
        };
        invoke('lock',{});
        assert.match(readFileSync(join(project,'uv.lock'),'utf8'),/module-fixture/);
        invoke('sync',{locked:true});
        invoke('run_command',{locked:true,command:['python','-c','print("uv module passed")']});
        assert.match(readFileSync(join(project,'run_command-run','uv.stdout'),'utf8'),/uv module passed/);
      } finally {rmSync(project,{recursive:true,force:true});}
    });
    return;
  }
  const sources = {
    black: ['source.py','value=  1\n','format','check'],
    prettier: ['source.js','const value={hello:"world"};\n','format','check'],
    ruff: ['source.py','value=  1\n','format','format_check'],
    biome: ['source.js','const value={hello:"world"};\n','format','ci'],
    rustfmt: ['source.rs','fn main(){println!("hello");}\n','format','check'],
  };
  const linters = {
    shellcheck: ['source.sh',"#!/bin/sh\nprintf '%s\\n' hello\n",'#!/bin/sh\necho $value\n'],
    yamllint: ['source.yaml','---\nname: example\n','name:\n   nested: 1\n  broken: 2\n'],
  };
  if (!sources[tool.name] && !linters[tool.name]) return;
  const available=spawnSync('which',[tool.program],{encoding:'utf8'}).status===0;
  const required=process.env.FLUENTCI_REQUIRE_CLI_NATIVE_TESTS === '1';
  test('native '+tool.program+' accepts module argv and rejects invalid or unformatted input', {skip:!available&&!required},()=>{
    assert.ok(available,tool.program+' must be installed for native tests');
    const project=realpathSync(mkdtempSync(join(tmpdir(),'fluentci-native-')));
    let counter=0;
    const invoke=(command,fields={})=>{
      const f=fixture({native:true,input:{project,runDir:join(project,'run-'+counter++),...fields}});
      plugin[command](); return f;
    };
    try {
      const source=sources[tool.name]??linters[tool.name];
      const path=join(project,source[0]);
      writeFileSync(path,source[1]);
      if(sources[tool.name]) {
        // Biome CI also runs unused-variable checks, so limit this fixture to formatting.
        const check=tool.name==='biome' ? 'run' : source[3];
        const fields=tool.name==='biome'?{arguments:['format','source.js']}:{files:[source[0]]};
        assert.throws(()=>invoke(check,fields),/failed/);
        invoke(source[2],{files:[source[0]]});
        assert.notEqual(readFileSync(path,'utf8'),source[1]);
        invoke(check,fields);
      } else {
        invoke('lint',{files:[source[0]]});
        writeFileSync(path,source[2]);
        assert.throws(()=>invoke('lint',{files:[source[0]]}),/failed/);
      }
    } finally {rmSync(project,{recursive:true,force:true});}
  });
}
