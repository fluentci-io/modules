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
 if name=='android':
  fields={
   'version':('string','15859902','Pinned Google command-line tools archive build ID; nondefault builds require archiveUrl and archiveSha256.'),
   'javaVersion':('string','21','Java release or supported selector forwarded to the typed setup-java dependency; defaults to Java 21.'),
   'sdkRoot':('string',None,'Absolute SDK root; defaults to a per-user directory keyed by the command-line tools build.'),
   'packages':('string','platform-tools','Comma-separated native Android SDK package IDs, such as platform-tools,platforms;android-36,build-tools;36.0.0. Blank installs no packages through this field.'),
   'apiLevels':('string',None,'Comma-separated API levels or preview names; installs platforms;android-VALUE for each entry.'),
   'buildToolsVersions':('string',None,'Comma-separated Android build-tools revisions to install and add to PATH.'),
   'ndkVersions':('string',None,'Comma-separated side-by-side NDK revisions to install; ANDROID_NDK_HOME selects the first.'),
   'cmakeVersions':('string',None,'Comma-separated SDK CMake revisions to install and add to PATH.'),
   'systemImages':('string',None,'Comma-separated complete system-image package IDs; no emulator or virtual device is started.'),
   'packageFile':('string',None,'Existing file of newline-separated SDK package IDs, passed to sdkmanager.'),
   'channel':('integer',0,'Highest SDK repository channel to include: 0 stable, 1 beta, 2 dev, or 3 canary.'),
   'acceptLicenses':('boolean',True,'Accept SDK licenses noninteractively. False uses existing licenses and closed stdin; missing licenses fail installation.'),
   'proxyType':('string',None,'SDK proxy protocol: http or socks; requires proxyHost and proxyPort.'),
   'proxyHost':('string',None,'SDK repository proxy hostname or IP address.'),
   'proxyPort':('integer',None,'SDK proxy port from 1 to 65535 when a proxy is enabled.'),
   'sdkManagerArgs':('string',None,'Additional literal sdkmanager option/value tokens as comma-separated text; cannot change the managed operation or SDK root.'),
   'archiveUrl':('string',None,'Optional HTTPS command-line tools ZIP URL for mirrors or alternate builds; requires archiveSha256.'),
   'archiveSha256':('string',None,'Lowercase SHA-256 of the alternate ZIP. Default Google downloads use pinned platform checksums.')}
  return {key:dict(type=kind,description=description,**({'default':default} if default is not None else {})) for key,(kind,default,description) in fields.items()}
 props={k:{'type':t} for k,t in [('version','string'),('installDir','string'),('packageName','string'),('sudo','boolean')]}
 extras={'rust':{'toolchain':'string','components':'string','targets':'string','profile':'string'},'bun':{'baseline':'boolean','libc':'string'},'pkl':{'libc':'string'},'elixir':{'otpVersion':'string'},'nix':{'daemon':'boolean'},'determinate-nix':{'init':'string','trustedUsers':'array','extraConf':'array'},'extism':{k:'string' for k in ['cliVersion','jsVersion','pythonVersion','xtpVersion','binaryenVersion']},'purescript':{k:'string' for k in ['nodeVersion','bunVersion','npmVersion','spagoVersion','nodePackageName','bunPackageName']}}
 if name=='cachix':extras[name]={'cache':'string'}
 if name=='uv':extras[name]={'pythonVersion':'string','tools':'string'}
 if name=='php':extras[name]={'tools':'string','miseVersion':'string'}
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
  if name in ['depot','buildx','flipt'] or category=='version-control':exports=['setup']+exports
  source=['-- Generated by scripts/generate_components.py.',f'module CI.Component ({", ".join(exports)}) where','', 'import Prelude','import CI.Contract as Contract','import Data.Either (either)','import Data.Maybe (Maybe(..))','import Effect (Effect)','import Effect.Exception (throw)']
  if category!='setup' or name=='setup-buildx':source+=['import CI.ModuleDependencies as Dependencies']
  if module['path'] in catalog:source+=['import '+('CI.NixPublish' if name=='nix-publish' else 'CI.CLI')+' as Native']
  elif category=='setup':
   if tool not in ['php','uv','android']:source+=['import CI.Setup as Setup','import CI.Setup.Types as Types']
   if tool=='purescript':source+=['import CI.Setup.PureScript as Native']
   if tool=='android':source+=['import CI.Setup.Android as Native']
   if tool=='uv':source+=['import CI.Setup.UvEnvironment as Native']
   if tool=='php':source+=['import CI.Setup.PHP as Native']
  elif category=='notifications':source+=['import CI.Notifications as Native']
  elif category=='services':
   source+=['import CI.Services as Native']
   if name=='aws-emulator':source+=['import CI.Services.Aws as Aws']
  elif name=='buildx':source+=['import Buildx as B','import Buildx.Commands as C']
  elif name in {'dpkg','rpmbuild'}:source+=['import CI.'+('Dpkg' if name=='dpkg' else 'Rpmbuild')+' as Native']
  elif name=='cachix':source+=['import CI.Cachix as Native','import CI.Cachix.Support (unwrap)','import FluentCI.Plugin as P','import Data.String.Common (trim)']
  elif name=='gemfury':source+=['import CI.Gemfury as Native','import FluentCI.Plugin as P','import Data.String.Common (trim)']
  else:raise ValueError('No typed component migration for '+name)
  if name in ['depot','buildx','flipt']:source+=['import CI.ContainerSetup as ContainerSetup']
  if category=='version-control':source+=['import CI.ToolSetup as ContainerSetup']
  source+=[''];schemas={};docs=[f'# {name} component functions','',('Requires FluentCI v0.17.3 or newer.' if tool=='android' or category!='setup' else 'Requires FluentCI v0.17.2 or newer.')+' The compiler derives native WIT signatures', 'and embedded help from these typed PureScript functions. Optional arguments may be omitted.','']
  for function in exports:
   properties={};required=[];output=copy.deepcopy(EXEC);returned='Contract.ExecutionResult';body=[]
   description=''
   if (name in ['depot','buildx','flipt'] or category=='version-control') and function=='setup':
    properties=setup_props(name);output=copy.deepcopy(SETUP);returned='Contract.SetupResult'
    description=f'Ensure {name} is installed and verified, reusing an available matching version, and publish its environment.'
    body=['  ContainerSetup.setupWith (Contract.input (Contract.encodeInput args))']
   elif module['path'] in catalog:
    command=next(c for c in catalog[module['path']]['commands'] if c['name']==function)
    definition=json.loads((directory/'legacy-schema.json').read_text())['exports'][function]['input']
    properties=copy.deepcopy(definition['properties']);required=definition['required'];properties['artifacts']={'type':'array','items':{'type':'string'}}
    if catalog[module['path']].get('csvLists'):
     properties['artifacts']={'type':'string','description':'Comma-separated NAME=PATH output artifacts; use CSV double quotes around entries containing commas.'}
    description=command['description']
    body=['  json <- '+('Native.csvInput (Contract.input (Contract.encodeInput args)) >>= Contract.cliInput' if catalog[module['path']].get('csvLists') else 'Contract.cliInput (Contract.encodeInput args)'),f'  Native.executeWithSetup Dependencies.ensureFor "{name}" "{function}" json']
   elif category=='setup':
    properties=setup_props(tool);output=copy.deepcopy(SETUP);returned='Contract.SetupResult';description=f'Install and verify {tool}, select its version, and publish its environment for subsequent tasks.'
    if tool=='purescript':
     returned='{ tool :: String, version :: String, binDir :: String, environment :: Array Contract.Variable, nodeVersion :: String, bunVersion :: String, npmVersion :: String, spagoVersion :: String }'
     for key in ['nodeVersion','bunVersion','npmVersion','spagoVersion']:output['properties'][key]={'type':'string'};output['required'].append(key)
     body=['  config <- either throw pure (Native.decodeConfig (Contract.input (Contract.encodeInput args)))','  result <- Native.setupWith config','  pure (result { environment = Contract.variables result.environment })']
    elif tool=='android':
     description='Install Java (21 by default) through setup-java, verify Android command-line tools, install selected SDK packages, and publish their environment.'
     returned='{ tool :: String, version :: String, binDir :: String, environment :: Array Contract.Variable, sdkRoot :: String, javaVersion :: String, commandLineToolsBuild :: String }'
     for key in ['sdkRoot','javaVersion','commandLineToolsBuild']:output['properties'][key]={'type':'string'};output['required'].append(key)
     body=['  config <- either throw pure (Native.decodeConfig (Contract.input (Contract.encodeInput args)))','  result <- Native.setupWith config','  pure { tool: result.tool, version: result.version, binDir: result.binDir, environment: Contract.variables result.environment, sdkRoot: result.sdkRoot, javaVersion: result.javaVersion, commandLineToolsBuild: result.commandLineToolsBuild }']
    elif tool=='uv':
     description='Install and verify uv, optionally configure a Python version and isolated tools, and publish their environment.'
     properties['pythonVersion']['description']='Optional Python release or interpreter selector such as 3.13 or cpython-3.13.1; omit to retain uv-only setup. BSD selects an existing matching interpreter without downloads.'
     properties['tools']['description']='Comma-separated Python CLI packages with optional single native version constraints, such as ruff==0.12.0,httpie. Blank or omitted values install no tools.'
     body=['  config <- either throw pure (Native.decodeConfig (Contract.input (Contract.encodeInput args)))','  Contract.setupResult <$> Native.setupWith config']
    elif tool=='php':
     description='Install and verify PHP and optional versioned CI tools, then publish their environment.'
     properties['tools'].update(default='composer',description='Comma-separated PHP tools, optionally name:version, such as composer:2,phpunit:11,phpstan. Blank or none skips module tool installation. Supports documented aliases and vendor/package:version with a matching executable name.')
     properties['miseVersion'].update(default='latest',description='mise release used to install PHP on Linux/macOS; ignored for native BSD packages.')
     properties['version'].update(default='latest',description='PHP major/minor prefix or exact upstream release, including prereleases; latest/stable resolves the latest available release. Versions are discovered dynamically by the PHP backend. BSD is limited to native repository packages.')
     properties['installDir']['description']='Absolute per-user prefix for the PHP manager and isolated tool environments; native BSD packages require this to be omitted.'
     body=['  config <- either throw pure (Native.decodeConfig (Contract.input (Contract.encodeInput args)))','  Contract.setupResult <$> Native.setupWith config']
    else:body=[f'  config <- either throw pure (Types.decodeConfig "{tool}" (Contract.input (Contract.encodeInput args)))',f'  Contract.setupResult <$> Setup.install "{tool}" config']
   elif category=='services':
    properties={'project':{'type':'string','default':'.','description':'Workspace directory used by every native service manager call.'},'name':{'type':'string','description':f'Full service name, default module-{name}-default; must start with module-{name}- to scope lifecycle operations.'}}
    binding={'type':'object','required':['containerPort','port','address'],'properties':{'containerPort':{'type':'integer'},'port':{'type':'integer'},'address':{'type':'string'}},'additionalProperties':False}
    output={'type':'object','required':['name','state','backend','host','port','endpoint','ports'],'properties':{**{key:{'type':'string'} for key in ['name','state','backend','host','endpoint']},'port':{'type':'integer'},'ports':{'type':'array','items':binding}},'additionalProperties':False}
    returned='Native.ServiceResult'
    description={'start':'Start an idempotent background service through FluentCI’s native workspace service manager and wait for readiness.','stop':'Stop only this named service through the native manager; preserve explicitly mounted data. Native dependents are stopped too.','restart':'Restart the existing native service definition and wait for readiness.','status':'Return the service’s native lifecycle state and actual loopback port bindings.','logs':'Read a bounded snapshot of native service logs without starting a service.'}.get(function,'Build the official AWS Emulator package into a local Docker image without starting it.')
    if function=='start':
     fields={
      'version':('string',None,'Docker image version tag. Uses the profile default when omitted; cannot be combined with image.'),
      'image':('string',None,'Full Docker image reference, including an optional digest; replaces the default repository and version.'),
      'port':('integer',9297 if name=='aws-emulator' else 0,'Host port for the primary endpoint; zero allocates an available loopback port. AWS Emulator uses the same nonzero port inside and outside its container.'),
      'ports':('string',None,'Comma-separated container ports or HOST:CONTAINER bindings. Omit for every profile port with random host bindings. Include the primary port once.'),
      'volumes':('string',None,'Comma-separated /CONTAINER_PATH anonymous volumes or SOURCE:/CONTAINER_PATH[:ro|rw] mounts. Explicit named/bind data survives stop.'),
      'env':('string',None,'Comma-separated KEY=VALUE test configuration overrides; no JSON object. Use disposable test values because definitions are sent to the manager.'),
      'command':('string',None,'Comma-separated foreground command tokens replacing the image command; literal argv, with no shell expansion.'),
      'dependsOn':('string',None,'Comma-separated existing native service names whose readiness must be satisfied before startup.'),
      'startupTimeoutMs':('integer',None,'Readiness deadline, from 100 to 600000 milliseconds; defaults to the service profile.'),
      'stopTimeoutMs':('integer',5000,'Graceful shutdown deadline from 100 to 120000 milliseconds.'),
      'restartPolicy':('string','never','Native restart policy: never, on_failure or always.'),
      'maxRestarts':('integer',0,'Maximum automatic restarts, from zero to 100.'),
      'healthCheck':('boolean',True,'Keep running the readiness probe as the native recurring health check.'),
      'readinessCommand':('string',None,'Comma-separated literal probe command run inside the owned container; overrides the profile probe.'),
      'readinessPath':('string',None,'HTTP readiness URL path for profiles using an HTTP probe.')}
     if name=='aws-emulator':fields['stateDir']=('string',None,'Required absolute host directory holding generated credentials and TLS files. Mounted into the emulator and never deleted by stop.');required=['stateDir']
     for key,(kind,default,description_) in fields.items():properties[key]={'type':kind,'description':description_,**({'default':default} if default is not None else {})}
     properties['restartPolicy']['enum']=['never','on_failure','always']
    if function=='logs':properties['tail']={'type':'integer','default':100,'minimum':1,'maximum':10000,'description':'Maximum recent log lines, from 1 to 10000.'};output={'type':'string'};returned='String'
    if function=='build':
     properties={'project':properties['project'],'image':{'type':'string','default':'fluentci/aws-emulator:local','description':'Local image name/tag to build.'},'architecture':{'type':'string','default':'auto','enum':['auto','x86_64','aarch64'],'description':'RPM architecture; auto uses the Docker daemon architecture.'},'packageUrl':{'type':'string','description':'Optional HTTPS URL of a pinned official AWS Emulator RPM; requires packageSha256. Default uses the official latest LTS package.'},'packageSha256':{'type':'string','description':'Lowercase SHA-256 for a pinned RPM; custom URLs require it.'},'timeoutMs':{'type':'integer','default':1800000,'description':'Image build deadline from 1000 to 3600000 milliseconds.'}};output={'type':'string'};returned='String'
    args='(Contract.input (Contract.encodeInput args))'
    body=[f'  '+(f'Aws.build (Dependencies.ensureFor "docker") {args}' if function=='build' else f'Native.{function} '+('(Dependencies.ensureFor "docker") ' if function in ['start','restart'] else '')+f'"{name}" {args}')]
   elif category=='notifications':
    properties={'message':{'type':'string','minLength':1,'description':f'Notification text, passed literally and JSON-encoded internally. Maximum {2000 if name=="discord" else 4096 if name=="telegram" else 4000} Unicode characters; no JSON object is accepted.'}}
    required=['message']
    credential='tokenEnv' if name=='telegram' else 'webhookEnv'
    properties[credential]={'type':'string','default':{'slack':'SLACK_WEBHOOK_URL','discord':'DISCORD_WEBHOOK_URL','telegram':'TELEGRAM_BOT_TOKEN'}[name],'description':'Name of the host environment variable holding the credential; pass the variable name, never the secret URL or token.'}
    properties['timeoutSeconds']={'type':'integer','minimum':1,'maximum':600,'default':30,'description':'HTTP request timeout in seconds, from 1 to 600. Notifications are sent once without automatic retries.'}
    if name=='slack':properties['threadTs']={'type':'string','description':'Existing Slack message timestamp for a threaded reply, such as 1712345678.123456.'}
    if name=='discord':
     properties.update({'username':{'type':'string','description':'Optional webhook display name, from 1 to 80 Unicode characters.'},'avatarUrl':{'type':'string','description':'Optional HTTPS image URL overriding the webhook avatar.'},'threadId':{'type':'string','description':'Positive numeric Discord thread ID; required for existing forum/media channel threads.'},'allowMentions':{'type':'boolean','default':False,'description':'Allow user, role and everyone mentions explicitly. The default disables all parsed mentions.'}})
    if name=='telegram':
     properties.update({'chatId':{'type':'string','minLength':1,'description':'Nonzero numeric Telegram chat ID (including negative group IDs), or an @channel username.'},'parseMode':{'type':'string','enum':['HTML','MarkdownV2','Markdown'],'description':'Optional Telegram formatting mode; omitted text is plain. Escape markup according to the selected mode.'},'messageThreadId':{'type':'integer','minimum':1,'description':'Optional positive forum topic message-thread ID.'},'disableNotification':{'type':'boolean','description':'Send silently when true.'},'protectContent':{'type':'boolean','description':'Protect the message from forwarding and saving when true.'},'disableWebPagePreview':{'type':'boolean','description':'Disable link previews when true.'}});required.append('chatId')
    returned='{ provider :: String, sent :: Boolean, httpStatus :: Int, messageId :: String }'
    output={'type':'object','properties':{'provider':{'type':'string'},'sent':{'type':'boolean'},'httpStatus':{'type':'integer'},'messageId':{'type':'string'}},'required':['provider','sent','httpStatus','messageId'],'additionalProperties':False}
    description=f'Send one {name.capitalize()} notification through curl and verify its delivery acknowledgement. Credentials come from the host environment.'
    body=[f'  Native.{name} (Dependencies.ensureFor "curl") args']
   elif name in {'dpkg','rpmbuild'}:
    properties={k:{'type':'string'} for k in ['directory','arch','output']+(['spec'] if name=='rpmbuild' else [])};required=['directory','arch']+(['spec'] if name=='rpmbuild' else [])
    returned='Array String' if function=='build' else 'Boolean';output={'type':'array','items':{'type':'string'}} if function=='build' else {'type':'boolean'}
    description=f'{"Build packages from" if function=="build" else "Validate"} a Linux {name} package tree and target architecture.'
    body=['  config <- either throw pure (Native.decodeConfig (Contract.input (Contract.encodeInput args)))']+(['  Native.buildWithSetup (Dependencies.ensureFor "'+name+'") config'] if function=='build' else ['  Native.validateWithSetup (Dependencies.ensureFor "'+name+'") config','  pure true'])
   elif name=='buildx':
    definition=json.loads((directory/'legacy-schema.json').read_text())['exports'][function]['input'];properties=copy.deepcopy(definition['properties']);properties.pop('help',None);required=definition['required']
    if 'type_' in properties:properties['type']=properties.pop('type_')
    title=''.join(p.capitalize() for p in function.split('_'));pure=title[:1].lower()+title[1:];description=f'Run Docker Buildx {function.replace("_"," ")} and return execution report paths.'
    lists=[key for key,prop in properties.items() if prop['type']=='array']
    for key in lists:properties[key]={'type':'string','description':properties[key].get('description',key).replace('(default [])', '(default: none)')+' Comma-separated values; CSV quotes preserve literal commas. Blank optional lists add no arguments.'}
    body=['  json <- Contract.csvFields [ '+', '.join(json.dumps(key) for key in lists)+' ] (Contract.encodeInput args)', f'  config <- either throw pure (C.decode{title}Args (Contract.buildxInput json))',f'  plan <- either throw pure (C.{pure} config)',f'  let runtime = C.runtime{title} config','  Dependencies.ensureFor "docker"','  void (B.execute runtime plan)','  pure { outcome: "succeeded", runDir: runtime.runDir, reportPath: runtime.runDir <> "/result.json", stdoutPath: runtime.runDir <> "/buildx.stdout", stderrPath: runtime.runDir <> "/buildx.stderr" }']
   elif name=='gemfury':
    properties={'files':{'type':'string','minLength':1,'description':'Required comma-separated package paths. Whitespace is trimmed; CSV quotes preserve commas inside a filename. Empty lists and malformed entries are rejected.'}};required=['files'];returned='{ uploaded :: Boolean, files :: Array String }';output={'type':'object','properties':{'uploaded':{'type':'boolean'},'files':{'type':'array','items':{'type':'string'}}},'required':['uploaded','files'],'additionalProperties':False};description='Upload Linux packages to Gemfury using credentials from the host environment.'
    body=['  files <- Native.decodeFiles args.files','  present <- P.hasEnv "FURY_TOKEN" >>= unwrap','  token <- if present then P.getEnv "FURY_TOKEN" >>= unwrap else pure ""','  Native.uploadFilesWithSetup (Dependencies.ensureFor "curl") files','  pure { uploaded: trim token /= "", files }']
   elif name=='cachix':
    properties={'cache':{'type':'string'}};required=['cache'];returned='{ enabled :: Boolean, cache :: String }';output={'type':'object','properties':{'enabled':{'type':'boolean'},'cache':{'type':'string'}},'required':['enabled','cache'],'additionalProperties':False};description=('Configure' if function=='setup' else 'Push the result closure to')+' a Cachix cache using host credentials.'
    body=['  present <- P.hasEnv "CACHIX_AUTH_TOKEN" >>= unwrap','  token <- if present then P.getEnv "CACHIX_AUTH_TOKEN" >>= unwrap else pure ""',f'  Native.{"setupWithSetup" if function=="setup" else "pushResultWithSetup"} (Dependencies.ensureFor "nix") args.cache','  pure { enabled: trim token /= "", cache: args.cache }']
   if name=='setup-buildx':body.insert(1,'  Dependencies.ensureFor "docker"')
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
  if module['path'] in catalog or category in ['notifications','services']:source=[line for line in source if line not in ['import Data.Either (either)','import Effect.Exception (throw)']]
  if category=='notifications':source=[line for line in source if line not in ['import Prelude','import CI.Contract as Contract']]
  if category=='services':source=[line for line in source if line!='import Prelude']
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
