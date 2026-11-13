import assert from "node:assert/strict";
import { readFileSync, realpathSync, mkdtempSync, writeFileSync, chmodSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { createRequire } from "node:module";
import { test } from "node:test";
import { fixture } from "./host.mjs";
import { nativeSuite } from "./native.mjs";
import { artifactSuite } from "./artifacts.mjs";

const catalog = JSON.parse(readFileSync(new URL('../../lib/cli/catalog.json', import.meta.url)));
const right = result => { assert.equal(result.constructor.name, "Right", result.value0); return result.value0; };
const sample = field => field.choices.length ? field.choices[0] : field.sample ?? (field.kind === 'boolean' ? true : field.kind === 'integer' ? 3 : field.kind === 'strings' ? ['literal value'] : 'literal value');
const scalarToken = (field, value) => {
  const token = (field.style.startsWith('prefix:') ? field.style.slice(7) : '') + String(value);
  return !field.flag || ['space-list','separate','file-separate','directory-separate'].includes(field.style) ? token : field.flag + '=' + token;
};
export async function suite(directory) {
  const schema = JSON.parse(readFileSync(new URL('schema.json', directory)));
  const tool = catalog.find(tool => tool.name === schema.name);
  const plugin = createRequire(import.meta.url)(new URL('dist/plugin.cjs', directory).pathname);
  const { makePlan } = await import(new URL('output/CI.CLI/index.js', directory));
  const { compile } = await import(new URL('output/FluentCI.Host.Plan/index.js', directory));
  const plan = (command, input) => JSON.parse(right(compile(right(makePlan(tool.name)(command)(input)))));
  const rawArguments = args => tool.csvLists ? args.map(value=>'"'+value.replaceAll('"','""')+'"').join(',') : args;
  const inputFor = command => Object.fromEntries([['runDir', '/tmp/fresh-run'], ...command.fields.filter(f => f.required && f.default === null).map(f => [f.key, sample(f)])]);
  nativeSuite(tool, plugin);
  artifactSuite(tool, plugin);
  test('private regression exports agree with the command catalog', () => {
    assert.deepEqual(Object.keys(plugin).sort(), tool.commands.map(c => c.name).sort());
    assert.deepEqual(Object.keys(schema.exports).filter(name=>name!=='setup'||tool.commands.some(command=>command.name==='setup')).sort(), Object.keys(plugin).sort());
  });
  for (const command of tool.commands) {
    test(command.name + ': defaults and native command prefix', () => {
      for(const field of command.fields.filter(field=>field.kind==='integer'&&field.style==='signed'))for(const value of [0,-1])assert.ok(plan(command.name,{...inputFor(command),[field.key]:value}).tasks[0].args.includes(scalarToken(field,value)));
      const document = plan(command.name, inputFor(command));
      assert.equal(document.inherit_env, true);
      assert.equal(document.jobs, 1);
      const task = document.tasks[0];
      assert.equal(task.program, command.program || tool.program);
      const initial=inputFor(command);
      const prefix=command.args.flatMap(arg=>[
        ...command.fields.filter(field=>field.scope==='before:'+arg&&Object.hasOwn(initial,field.key)).map(field=>String(initial[field.key])),arg
      ]);
      assert.deepEqual(task.args.slice(0,prefix.length),prefix);
      assert.equal(task.cwd, '.');
      assert.equal(task.timeout_ms, 900000);
      for (const [key,value] of Object.entries({...tool.environment,...command.environment})) assert.equal(task.env[key],value);
      const f = fixture({ input: inputFor(command) });
      plugin[command.name]();
      assert.deepEqual(f.plans[0].plan, document);
      assert.equal(JSON.parse(f.output[0]).outcome, 'succeeded');
      assert.equal(f.calls[0][0], 'test');
    });
    test(command.name + ': typed values and literal argv survive host execution', () => {
      const input = { ...inputFor(command), project: "/tmp/a ' 世界; $(touch injected)", executable: '/tmp/tool path', timeoutMs: 1234 };
      for (const f of command.fields) input[f.key] = sample(f);
      const task = plan(command.name, input).tasks[0];
      assert.equal(task.program,input.executable);
      assert.equal(task.cwd,input.project);
      assert.equal(task.timeout_ms,1234);
      for (const field of command.fields) {
        const value = input[field.key];
        if (field.kind === 'boolean' && field.style === 'switch') {
          assert.equal(task.args.includes(field.flag),value); continue;
        }
        const values = Array.isArray(value) ? value : [String(value)];
        for (const token of values) {
          const expected = scalarToken(field,token);
          assert.ok(task.args.includes(expected), command.name + ': missing ' + expected);
          if (field.scope === 'global' && command.args.length) assert.ok(task.args.indexOf(expected) < task.args.indexOf(command.args[0]));
        }
        if (field.kind === 'boolean') assert.ok(plan(command.name,{...input,[field.key]:false}).tasks[0].args.includes(!field.flag && field.style.startsWith('prefix:') ? field.style.slice(7)+'false' : field.flag+'=false'));
      }
      const f = fixture({ input }); plugin[command.name]();
      assert.deepEqual(f.calls.slice(0,2),[['test','-d',input.project],['test','-x',input.executable]]);
      assert.deepEqual(f.plans[0].plan.tasks[0],task);
    });
    test(command.name + ': rejects malformed inputs before host calls', () => {
      const base = inputFor(command);
      const invalid = [[],null,{}, {...base,unknown:true},{...base,artifacts:{report:''}},{...base,artifacts:[]},{...base,runDir:''},{...base,runDir:null},{...base,project:4},{...base,project:'bad\0path'},{...base,timeoutMs:0},{...base,timeoutMs:1.5},{...base,timeoutMs:'100'},{...base,executable:''}];
      for (const field of command.fields) {
        invalid.push({...base,[field.key]:null},{...base,[field.key]:{} });
        if (field.required && field.default === null) { const missing={...base}; delete missing[field.key]; invalid.push(missing); }
        if (field.kind === 'strings') invalid.push({...base,[field.key]:[42]}, {...base,[field.key]:['']});
        if (field.kind === 'integer' && field.style !== 'signed') {
          invalid.push({...base,[field.key]:field.style === 'nonnegative' ? -1 : 0});
          if (field.style === 'nonnegative') assert.ok(plan(command.name,{...base,[field.key]:0}).tasks[0].args.includes(scalarToken(field,0)));
        }
        if (field.kind === 'string') invalid.push({...base,[field.key]:''},{...base,[field.key]:'bad\0value'});
        if (field.choices.length) invalid.push({...base,[field.key]:'invalid-choice'});
        if (field.scope === 'positional' || (field.scope.startsWith('before:') && !field.flag)) invalid.push({...base,[field.key]:field.kind === 'strings'?['--flag']:'--flag'});
      }
      for (const input of invalid) {
        const f=fixture({input}); assert.throws(plugin[command.name], undefined, JSON.stringify(input));
        assert.equal(f.plans.length,0); assert.equal(f.calls.length,0);
      }
    });
  }
  for (const command of tool.commands) {
    const files=command.fields.filter(field=>['file','file-separate'].includes(field.style));
    if (!files.length) continue;
    test(command.name+': supplied input files are checked before executing', () => {
      // Optional config files are absent from inputFor. Supply every file field
      // explicitly so the missing-file assertion exercises a real preflight.
      const input={...inputFor(command),...Object.fromEntries(files.map(field=>[field.key,sample(field)]))};
      const existing=fixture({input});
      plugin[command.name]();
      assert.ok(existing.calls.some(args=>args[0]==='test'&&args[1]==='-f'));
      assert.equal(existing.plans.length,1);
      const missing=fixture({input,fail:args=>args[0]==='test'&&args[1]==='-f'});
      assert.throws(plugin[command.name]);
      assert.ok(missing.calls.some(args=>args[0]==='test'&&args[1]==='-f'));
      assert.equal(missing.plans.length,0);
      assert.equal(missing.output.length,0);
    });
  }
  test('declares output artifacts', () => {
    const base=inputFor(tool.commands[0]);
    const task=plan(tool.commands[0].name,{...base,artifacts:{report:'output.json'}}).tasks[0];
    assert.ok(JSON.stringify(task).includes('output.json'));
  });
  if (tool.path.startsWith('secrets/')) test('authentication stays in inherited environment and out of plan/input', () => {
    const f=fixture({input:inputFor(tool.commands[0]),env:{DOPPLER_TOKEN:'secret-sentinel',INFISICAL_TOKEN:'secret-sentinel',VAULT_TOKEN:'secret-sentinel',BAO_TOKEN:'secret-sentinel'}});
    plugin.run(); assert.ok(!JSON.stringify(f.plans).includes('secret-sentinel'));
    const input={...inputFor(tool.commands[0]),token:'secret-sentinel'};
    assert.equal(makePlan(tool.name)('run')(input).constructor.name,'Left');
  });
  test('checks supported OS and missing executable before starting a plan', () => {
    const command=tool.commands[0], input=inputFor(command);
    for (const os of ['linux','macos','freebsd','openbsd','netbsd']) {
      const f=fixture({os,input}); plugin.run(); assert.equal(f.plans.length,1);
    }
    let f=fixture({os:'windows',input}); assert.throws(plugin.run,/Unsupported/); assert.equal(f.calls.length,0);
    for (const program of ['which','test']) {
      f=fixture({input,fail:args=>args[0]===program}); assert.throws(plugin.run); assert.equal(f.plans.length,0);
    }
  });
  test('propagates transport errors, failed outcomes, invalid host responses, and report errors', () => {
    const input=inputFor(tool.commands[0]);
    for (const options of [{outcome:'failed'},{outcome:'cancelled'},{response:'{'},{response:'{}'},{transportError:true},{fail:args=>args[0]==='cat'}]) {
      const f=fixture({input,...options}); assert.throws(plugin.run); assert.equal(f.output.length,0);
    }
  });
  test('raw command arguments preserve shell syntax and option ordering', () => {
    const args=['--flag','a b',"quote ' 世界; $(touch injected)",'--','-literal'];
    assert.deepEqual(plan('run',{runDir:'run',arguments:rawArguments(args)}).tasks[0].args,args);
  });
  if (tool.name === 'ubicloud') test('requires token without recording its value in plan', () => {
    const f=fixture({input:{runDir:'run'},env:{UBI_TOKEN:''}}); assert.throws(plugin.help,/UBI_TOKEN/); assert.equal(f.plans.length,0);
    const good=fixture({input:{runDir:'run'},env:{UBI_TOKEN:'secret-sentinel'}}); plugin.help();
    assert.ok(!JSON.stringify(good.plans).includes('secret-sentinel'));
  });
  test('native plan execution preserves cwd/argv, reports failures, and refuses reused run directories', () => {
    const project=realpathSync(mkdtempSync(join(tmpdir(),'fluentci-cli-')));
    try {
      const executable=join(project,'test cli');
      writeFileSync(executable,'#!/bin/sh\nprintf "%s\\n" "$PWD" "$@"\n'); chmodSync(executable,0o755);
      const args=['space value',"$(touch injected); ' 世界",'--option'];
      const runDir=join(project,'run');
      let f=fixture({native:true,input:{project,runDir,executable,arguments:rawArguments(args)}}); plugin.run();
      assert.equal(JSON.parse(f.output[0]).outcome,'succeeded');
      assert.equal(readFileSync(join(runDir,tool.name+'.stdout'),'utf8'),[project,...args,''].join('\n'));
      assert.throws(plugin.run,/already exists/);
      writeFileSync(executable,'#!/bin/sh\nexit 7\n');
      f=fixture({native:true,input:{project,runDir:join(project,'failed'),executable,arguments:rawArguments(['x'])}});
      assert.throws(plugin.run,/failed/); assert.equal(f.output.length,0);
    } finally { rmSync(project,{recursive:true,force:true}); }
  });
}
