#!/usr/bin/env python3
"""Build/test multiple modules on one runner, preserving separate logs and failures."""
import argparse
import json
from pathlib import Path
import subprocess
import sys
import tomllib

ROOT=Path(__file__).resolve().parents[1]

def run(modules, log_dir):
    log_dir.mkdir(parents=True, exist_ok=True)
    failed=[]
    for module in modules:
        directory=(ROOT/module['path']).resolve()
        if not directory.is_relative_to(ROOT) or directory==ROOT:
            raise ValueError('Module path escapes repository')
        name=module['name']
        if not name or any(c not in 'abcdefghijklmnopqrstuvwxyz0123456789-' for c in name):
            raise ValueError('Invalid module name')
        commands=([['bun','install','--frozen-lockfile']] if module['path'].startswith('testing/') else [['npm','ci']])+[
            ['npm','run','build'],['npm','test'],['node',str(ROOT/'scripts/validate_wasm.mjs'),str(directory)]]
        manifest=directory/'fluentci-module.toml'
        if manifest.exists() and tomllib.loads(manifest.read_text()).get('dependencies'):
            # Resolve/type-check/compose the real components without running installers.
            commands.append(['fluentci','run','.','--help'])
        logfile=log_dir/(name+'.log')
        print('Testing '+name,flush=True)
        with logfile.open('w') as output:
            for command in commands:
                result=subprocess.run(command,cwd=directory,stdout=output,stderr=subprocess.STDOUT)
                if result.returncode:
                    failed.append(name)
                    print(name+' FAILED: '+str(logfile),flush=True)
                    print(logfile.read_text()[-12000:],flush=True)
                    break
            else:print(name+' passed',flush=True)
    print(f'{len(modules)-len(failed)}/{len(modules)} modules passed',flush=True)
    return 1 if failed else 0

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--modules',required=True,help='JSON array from registry batch')
    parser.add_argument('--log-dir',type=Path,required=True)
    args=parser.parse_args()
    sys.exit(run(json.loads(args.modules),args.log_dir))
