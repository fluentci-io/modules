import test from 'node:test';
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { mkdtempSync, writeFileSync, readFileSync, existsSync, rmSync, realpathSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fixture } from './host.mjs';

export function buildSuite(tool, plugin) {
  if (!['cmake','meson','ninja','sccache'].includes(tool.name)) return;
  const available=spawnSync('which',[tool.program]).status===0 && spawnSync('which',['cc']).status===0;
  test('native '+tool.name+' produces a build artifact and propagates build failures', {skip:!available&&process.env.FLUENTCI_REQUIRE_BUILD_TESTS!=='1'},()=>{
    assert.ok(available,'build tool and C compiler are required');
    const project=realpathSync(mkdtempSync(join(tmpdir(),'fluentci-build-')));
    let counter=0;
    const env={CC:spawnSync('which',['cc'],{encoding:'utf8'}).stdout.trim(),SCCACHE_DIR:join(project,'cache'),SCCACHE_SERVER_PORT:String(43000+process.pid%15000)};
    const invoke=(command,fields={})=>{
      const runDir=join(project,'run-'+counter++);
      const f=fixture({native:true,env,input:{project,runDir,...fields}});
      try { plugin[command](); } catch(error) {
        for(const suffix of ['stdout','stderr']) {
          const path=join(runDir,tool.name+'.'+suffix);
          if(existsSync(path)) error.message+='\n'+readFileSync(path,'utf8');
        }
        throw error;
      }
      return f;
    };
    try {
      writeFileSync(join(project,'hello.c'),'int main(void) { return 0; }\n');
      if(tool.name==='cmake') {
        writeFileSync(join(project,'CMakeLists.txt'),'cmake_minimum_required(VERSION 3.16)\nproject(fixture C)\nadd_executable(hello hello.c)\nenable_testing()\nadd_test(NAME hello COMMAND hello)\ninstall(TARGETS hello DESTINATION bin)\n');
        invoke('configure');invoke('build',{parallel:2});invoke('test',{parallel:2});invoke('install',{prefix:join(project,'installed')});
        assert.ok(existsSync(join(project,'installed/bin/hello')));
        writeFileSync(join(project,'hello.c'),'invalid C code\n');assert.throws(()=>invoke('build'),/failed/);
      } else if(tool.name==='meson') {
        writeFileSync(join(project,'meson.build'),"project('fixture','c')\nexe=executable('hello','hello.c',install:true)\ntest('hello',exe)\n");
        invoke('configure',{prefix:'/usr'});invoke('compile');invoke('test');invoke('install',{destdir:join(project,'installed')});
        assert.ok(existsSync(join(project,'installed/usr/bin/hello')));
        writeFileSync(join(project,'hello.c'),'invalid C code\n');assert.throws(()=>invoke('compile'),/failed/);
      } else if(tool.name==='ninja') {
        writeFileSync(join(project,'build.ninja'),'rule cc\n  command = cc $in -o $out\nbuild hello: cc hello.c\n');
        invoke('build');assert.ok(existsSync(join(project,'hello')));invoke('targets');invoke('clean');
        assert.ok(!existsSync(join(project,'hello')));
        writeFileSync(join(project,'hello.c'),'invalid C code\n');assert.throws(()=>invoke('build'),/failed/);
      } else {
        invoke('zero_stats');invoke('compile',{compiler:'cc',arguments:['-c','hello.c','-o','hello.o']});
        assert.ok(existsSync(join(project,'hello.o')));invoke('stats');
        assert.match(readFileSync(join(project,'run-2/sccache.stdout'),'utf8'),/Compile|compile/i);
        writeFileSync(join(project,'hello.c'),'invalid C code\n');assert.throws(()=>invoke('compile',{compiler:'cc',arguments:['-c','hello.c','-o','bad.o']}),/failed/);
      }
    } finally {
      if(tool.name==='sccache') {try{invoke('stop_server');}catch{}}
      rmSync(project,{recursive:true,force:true});
    }
  });
}
