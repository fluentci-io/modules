#!/usr/bin/env python3
"""Generate typed PureScript component entrypoints for every registered module."""
import argparse
import copy
import json
from pathlib import Path
import re
import tomllib

ROOT=Path(__file__).resolve().parents[1]
COMMON={
 'project':'Working directory containing the source checkout; defaults to the current directory.',
 'runDir':'Fresh directory for this invocation’s execution report and task logs; must not already exist.',
 'executable':'Native CLI executable name or absolute path; defaults to this operation’s tool.',
 'timeoutMs':'Maximum task duration in milliseconds; defaults to 900000.',
 'artifacts':'Output artifacts to collect as NAME=PATH entries; names must be unique.',
 'directory':'Input directory containing the package tree to validate and build.',
 'arch':'Target package CPU architecture; the payload must already be compiled for this architecture.',
 'spec':'RPM spec file inside the package tree.',
 'output':'Destination path for generated packages.',
 'packages':'Comma-separated package selectors, optionally with per-package versions using the selected manager’s syntax; omitted or blank values install only the manager.',
 'version':'Tool release or supported channel to install; omitted values use the documented default.',
 'toolchain':'Rustup toolchain channel or exact release; alias for version. Both must agree when provided.',
 'components':'Comma-separated Rustup components to install, such as rustfmt,clippy; omitted or blank values add no components.',
 'targets':'Comma-separated Rust target triples to install, such as wasm32-wasip2,wasm32-unknown-unknown; omitted or blank values add no targets.',
 'trustedUsers':'Additional trusted Nix users or @groups; root is retained. Only set on trusted machines.',
 'extraConf':'Additional single-line Nix key=value settings passed literally to the installer.',
 'profile':'Rustup installation profile: minimal (default), default, or complete.',
 'installDir':'Absolute per-user installation prefix; omit for native package installations.',
 'packageName':'Native package or port selector overriding the default repository package name.',
 'sudo':'Use noninteractive sudo for native package or system installation; defaults to false.',
 'otpVersion':'Erlang/OTP major release matching the Elixir archive.',
 'daemon':'Install Nix in multi-user daemon mode; defaults to true.',
 'init':'Determinate Nix service integration: systemd or none.',
 'baseline':'Use Bun’s baseline CPU build; defaults to false.',
 'libc':'Linux C library variant: auto, gnu, or musl.',
 'nodeVersion':'Node.js release or channel to install for the PureScript toolchain.',
 'bunVersion':'Bun release to install for the PureScript toolchain.',
 'npmVersion':'npm release to install for the PureScript toolchain.',
 'spagoVersion':'Spago release to install for the PureScript toolchain.',
 'nodePackageName':'Native Node.js package selector for BSD toolchain installation.',
 'bunPackageName':'Native Bun package selector for BSD toolchain installation.',
 'cliVersion':'Extism CLI release; takes precedence over version.',
 'jsVersion':'Extism JavaScript PDK compiler release.',
 'pythonVersion':'Extism Python PDK compiler release.',
 'xtpVersion':'Expected XTP version; upstream exposes a latest-only download.',
 'binaryenVersion':'Binaryen release providing wasm-opt and wasm-merge.',
 'docker':'Docker executable name or absolute path.',
 'experimental':'Enable experimental Docker Buildx features.',
 'cache':'Cachix cache name; credentials come from CACHIX_AUTH_TOKEN.',
 'parallel':'Maximum number of concurrent build or test jobs.',
 'buildDir':'Directory containing the configured build tree.',
 'sourceDir':'Directory containing the source project.',
 'config':'Named configuration selected by the native tool.',
 'outputOnFailure':'Print failing test output when tests fail.',
 'target':'Target selected for this native operation.',
 'arguments':'Literal native CLI argument tokens, passed without shell expansion.',
 'files':'Files selected for the native operation; paths are passed literally without shell expansion.',
}

def scalar(kind):return {'string':'String','boolean':'Boolean','integer':'Int','number':'Number','array':'Array String'}[kind]
def quoted(key):return json.dumps(key) if key in {'type','data','class','instance','module','import','foreign','in','where','case','of','do','let'} else key
def doc(text):return str(text).replace('\n',' ').replace('\r',' ')
def describe(key,prop,context):
 text=prop.get('description','')
 if not text or text==key:
  setup_only={'packages','toolchain','components','targets','trustedUsers','extraConf','profile'}
  text=COMMON.get(key) if key not in setup_only or context.startswith('setup-') else None
  if not text:
   label=re.sub(r'([a-z])([A-Z])',r'\1 \2',key).replace('_',' ')
   text=f'{label[:1].upper()+label[1:]} supplied to the {context} operation.'
 if 'default' in prop:text+=' Default: '+json.dumps(prop['default'])+'.'
 if prop.get('enum'):text+=' Allowed values: '+', '.join(map(str,prop['enum']))+'.'
 return doc(text)

EXEC={'type':'object','required':['outcome','runDir','reportPath','stdoutPath','stderrPath'],'properties':{k:{'type':'string'} for k in ['outcome','runDir','reportPath','stdoutPath','stderrPath']},'additionalProperties':False}
SETUP={'type':'object','required':['tool','version','binDir','environment'],'properties':{'tool':{'type':'string'},'version':{'type':'string'},'binDir':{'type':'string'},'environment':{'type':'array','items':{'type':'object','required':['name','value'],'properties':{'name':{'type':'string'},'value':{'type':'string'}},'additionalProperties':False}}},'additionalProperties':False}

def setup_props(name):
 props={k:{'type':t} for k,t in [('version','string'),('installDir','string'),('packageName','string'),('sudo','boolean')]}
 extras={'rust':{'toolchain':'string','components':'string','targets':'string','profile':'string'},'bun':{'baseline':'boolean','libc':'string'},'pkl':{'libc':'string'},'elixir':{'otpVersion':'string'},'nix':{'daemon':'boolean'},'determinate-nix':{'init':'string','trustedUsers':'array','extraConf':'array'},'extism':{k:'string' for k in ['cliVersion','jsVersion','pythonVersion','xtpVersion','binaryenVersion']},'purescript':{k:'string' for k in ['nodeVersion','bunVersion','npmVersion','spagoVersion','nodePackageName','bunPackageName']}}
 if name=='cachix':extras[name]={'cache':'string'}
 if name in ['pkgx','mise','devbox','flox','macports','macports-rs']:extras[name]={'packages':'string'}
 if name in ['devbox','flox']:extras[name]['project']='string'
 props.update({k:({'type':v,'items':{'type':'string'}} if v=='array' else {'type':v}) for k,v in extras.get(name,{}).items()});return props

def generated():
 registry=tomllib.loads((ROOT/'fluentci.toml').read_text())['modules']
 catalog={t['path']:t for t in json.loads((ROOT/'lib/cli/catalog.json').read_text())}
 for module in registry:
  directory=ROOT/module['path'];name=module['name'];category,tool=module['path'].split('/')
  legacy=(directory/'legacy-entry.mjs').read_text()
  exports=[n.strip() for n in re.search(r'export\s*\{([^}]+)\}',legacy).group(1).split(',') if n.strip()]
  source=['-- Generated by scripts/generate_components.py.',f'module CI.Component ({", ".join(exports)}) where','', 'import Prelude','import CI.Contract as Contract','import Data.Either (either)','import Data.Maybe (Maybe(..))','import Effect (Effect)','import Effect.Exception (throw)']
  if module['path'] in catalog:source+=['import '+('CI.NixPublish' if name=='nix-publish' else 'CI.CLI')+' as Native']
  elif category=='setup':
   source+=['import CI.Setup as Setup','import CI.Setup.Types as Types']
   if tool=='purescript':source+=['import CI.Setup.PureScript as Native']
  elif name=='buildx':source+=['import Buildx as B','import Buildx.Commands as C']
  elif name in {'dpkg','rpmbuild'}:source+=['import CI.'+('Dpkg' if name=='dpkg' else 'Rpmbuild')+' as Native']
  elif name=='cachix':source+=['import CI.Cachix as Native','import CI.Cachix.Support (unwrap)','import FluentCI.Plugin as P','import Data.String.Common (trim)']
  elif name=='gemfury':source+=['import CI.Gemfury as Native','import FluentCI.Plugin as P','import Data.String.Common (trim)']
  else:raise ValueError('No typed component migration for '+name)
  source+=[''];schemas={};docs=[f'# {name} component functions','','Requires FluentCI v0.17.2 or newer. The compiler derives native WIT signatures', 'and embedded help from these typed PureScript functions. Optional arguments may be omitted.','']
  for function in exports:
   properties={};required=[];output=copy.deepcopy(EXEC);returned='Contract.ExecutionResult';body=[]
   description=''
   if module['path'] in catalog:
    command=next(c for c in catalog[module['path']]['commands'] if c['name']==function)
    definition=json.loads((directory/'legacy-schema.json').read_text())['exports'][function]['input']
    properties=copy.deepcopy(definition['properties']);required=definition['required'];properties['artifacts']={'type':'array','items':{'type':'string'}}
    if catalog[module['path']].get('csvLists'):
     properties['artifacts']={'type':'string','description':'Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas.'}
    description=command['description']
    body=['  json <- '+('Native.csvInput (Contract.input (Contract.encodeInput args)) >>= Contract.cliInput' if catalog[module['path']].get('csvLists') else 'Contract.cliInput (Contract.encodeInput args)'),f'  Native.execute "{name}" "{function}" json']
   elif category=='setup':
    properties=setup_props(tool);output=copy.deepcopy(SETUP);returned='Contract.SetupResult';description=f'Install and verify {tool}, select its version, and publish its environment for subsequent tasks.'
    if tool=='purescript':
     returned='{ tool :: String, version :: String, binDir :: String, environment :: Array Contract.Variable, nodeVersion :: String, bunVersion :: String, npmVersion :: String, spagoVersion :: String }'
     for key in ['nodeVersion','bunVersion','npmVersion','spagoVersion']:output['properties'][key]={'type':'string'};output['required'].append(key)
     body=['  config <- either throw pure (Native.decodeConfig (Contract.input (Contract.encodeInput args)))','  result <- Native.setupWith config','  pure (result { environment = Contract.variables result.environment })']
    else:body=[f'  config <- either throw pure (Types.decodeConfig "{tool}" (Contract.input (Contract.encodeInput args)))',f'  Contract.setupResult <$> Setup.install "{tool}" config']
   elif name in {'dpkg','rpmbuild'}:
    properties={k:{'type':'string'} for k in ['directory','arch','output']+(['spec'] if name=='rpmbuild' else [])};required=['directory','arch']+(['spec'] if name=='rpmbuild' else [])
    returned='Array String' if function=='build' else 'Boolean';output={'type':'array','items':{'type':'string'}} if function=='build' else {'type':'boolean'}
    description=f'{"Build packages from" if function=="build" else "Validate"} a Linux {name} package tree and target architecture.'
    body=['  config <- either throw pure (Native.decodeConfig (Contract.input (Contract.encodeInput args)))']+(['  Native.buildWith config'] if function=='build' else ['  Native.validateWith config','  pure true'])
   elif name=='buildx':
    definition=json.loads((directory/'legacy-schema.json').read_text())['exports'][function]['input'];properties=copy.deepcopy(definition['properties']);properties.pop('help',None);required=definition['required']
    if 'type_' in properties:properties['type']=properties.pop('type_')
    title=''.join(p.capitalize() for p in function.split('_'));pure=title[:1].lower()+title[1:];description=f'Run Docker Buildx {function.replace("_"," ")} and return execution report paths.'
    body=[f'  config <- either throw pure (C.decode{title}Args (Contract.buildxInput (Contract.encodeInput args)))',f'  plan <- either throw pure (C.{pure} config)',f'  let runtime = C.runtime{title} config','  void (B.execute runtime plan)','  pure { outcome: "succeeded", runDir: runtime.runDir, reportPath: runtime.runDir <> "/result.json", stdoutPath: runtime.runDir <> "/buildx.stdout", stderrPath: runtime.runDir <> "/buildx.stderr" }']
   elif name=='gemfury':
    properties={'files':{'type':'array','items':{'type':'string'}}};required=['files'];returned='{ uploaded :: Boolean, files :: Array String }';output={'type':'object','properties':{'uploaded':{'type':'boolean'},'files':{'type':'array','items':{'type':'string'}}},'required':['uploaded','files'],'additionalProperties':False};description='Upload Linux packages to Gemfury using credentials from the host environment.'
    body=['  present <- P.hasEnv "FURY_TOKEN" >>= unwrap','  token <- if present then P.getEnv "FURY_TOKEN" >>= unwrap else pure ""','  Native.uploadFiles args.files','  pure { uploaded: trim token /= "", files: args.files }']
   elif name=='cachix':
    properties={'cache':{'type':'string'}};required=['cache'];returned='{ enabled :: Boolean, cache :: String }';output={'type':'object','properties':{'enabled':{'type':'boolean'},'cache':{'type':'string'}},'required':['enabled','cache'],'additionalProperties':False};description=('Configure' if function=='setup' else 'Push the result closure to')+' a Cachix cache using host credentials.'
    body=['  present <- P.hasEnv "CACHIX_AUTH_TOKEN" >>= unwrap','  token <- if present then P.getEnv "CACHIX_AUTH_TOKEN" >>= unwrap else pure ""',f'  Native.{"setupWith" if function=="setup" else "pushResultWith"} args.cache','  pure { enabled: trim token /= "", cache: args.cache }']
   if category=='setup' and tool in ['macports','macports-rs']:
    properties['packages']['description']='Comma-separated MacPorts port names to install, such as git,cmake,python312; omit or leave blank for CLI-only setup. Package versions come from the configured ports tree.'
    properties['sudo']['description']='Use noninteractive sudo for requested port installs; setup-macports also uses it for its system installer. The macports-rs CLI itself is always installed without sudo.'
   if category=='setup' and tool=='cachix':properties['version']['description']='Expected Cachix version from the configured nixpkgs registry entry; latest accepts the packaged version. An explicit version mismatch fails setup.'
   if category=='setup' and tool=='cachix':properties['cache']['description']='Cachix cache name to enable with cachix use after installation; omit for CLI-only setup. Public caches need no token; private caches use inherited CACHIX_AUTH_TOKEN.'
   if category=='setup' and tool in ['devbox','flox']:properties['project']['description']='Project environment directory to initialize or update; defaults to the current directory. Creates or updates the manager manifest and lockfile when packages are supplied.'
   for key,prop in properties.items():prop['description']=describe(key,prop,name+' '+function)
   args_type='{ '+', '.join(quoted(key)+' :: '+('' if key in required else 'Maybe ')+('('+scalar(prop['type'])+')' if prop['type']=='array' and key not in required else scalar(prop['type'])) for key,prop in properties.items())+' }'
   source+=['-- | '+doc(description)]+['-- | @param '+key+' '+prop['description'] for key,prop in properties.items()]
   source+=[function+' :: '+args_type+' -> Effect '+('('+returned+')' if returned.startswith(('Array ','{')) else returned),function+' args = do']+body+['']
   schemas[function]={'description':description,'input':{'type':'object','properties':properties,'required':required,'additionalProperties':False},'output':output}
   wit_function=re.sub(r'([a-z0-9])([A-Z])',r'\1-\2',function).replace('_','-').lower()
   docs+=['## `'+wit_function+'`','',description,'','| Argument | Type | Required | Description |','| --- | --- | --- | --- |']
   docs += ['| `'+re.sub(r'([a-z0-9])([A-Z])',r'\1-\2',key).replace('_','-').lower()+'` | `'+prop['type']+'` | '+('yes' if key in required else 'no')+' | '+prop['description'].replace('|','\\|')+' |' for key,prop in properties.items()]
   docs+=['','Returns `'+returned+'`.','']
  if name=='gemfury':source+=['unwrap :: forall a. P.Result a -> Effect a','unwrap = either (throw <<< P.errorMessage) pure','']
  if module['path'] in catalog:source=[line for line in source if line not in ['import Data.Either (either)','import Effect.Exception (throw)']]
  source=[line.replace('import Data.Maybe (Maybe(..))','import Data.Maybe (Maybe)') for line in source]
  if all(not any(key not in value['input']['required'] for key in value['input']['properties']) for value in schemas.values()):source=[line for line in source if line!='import Data.Maybe (Maybe)']
  yield directory/'src/CI/Component.purs','\n'.join(source)
  yield directory/'entry.mjs','export { '+', '.join(exports)+' } from "./output/CI.Component/index.js";\n'
  yield directory/'schema.json',json.dumps({'name':name,'runtime':'component','exports':schemas},indent=2)+'\n'
  yield directory/'COMPONENT.md','\n'.join(docs)

if __name__=='__main__':
 parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--check',action='store_true');args=parser.parse_args()
 for path,text in generated():
  if args.check:
   if not path.exists() or path.read_text()!=text:raise SystemExit('Stale component contract: '+str(path.relative_to(ROOT)))
  else:path.parent.mkdir(parents=True,exist_ok=True);path.write_text(text)
 print('All component entrypoints, argument descriptions, and return schemas agree.')
