import '../dependencies/loader.mjs';
import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {fixture} from '../cli/host.mjs';

const credentials = {
 slack: {SLACK_WEBHOOK_URL:'https://hooks.slack.com/services/T123/B456/fixture-secret'},
 discord: {DISCORD_WEBHOOK_URL:'https://discord.com/api/webhooks/123456/fixture-secret'},
 telegram: {TELEGRAM_BOT_TOKEN:'123456:fixture-secret'},
};
const replies = {slack:'ok\n200\n',discord:'{"id":"987654321"}\n200\n',telegram:'{"ok":true,"result":{"message_id":42}}\n200\n'};
const isPost = args => args[0] === 'curl' && args.includes('POST');
export async function notificationSuite(provider, directory) {
 const component = await import(new URL('output/CI.Component/index.js',directory));
 const {Just,Nothing} = await import(new URL('output/Data.Maybe/index.js',directory));
 const schema = JSON.parse(readFileSync(new URL('schema.json',directory)));
 const contract = schema.exports.send;
 const args = (overrides={}) => Object.fromEntries(Object.keys(contract.input.properties).map(key=>{
  const value = Object.hasOwn(overrides,key) ? overrides[key] : key==='message'?'Build passed':key==='chatId'?'-100123456':undefined;
  return [key,contract.input.required.includes(key)?value:value===undefined?Nothing.value:new Just(value)];
 }));
 const host = (options={}) => {
  globalThis.fluentciSetupDependencies={'setup-curl':()=>{}};
  return fixture({...options,env:{...credentials[provider],...options.env},command:argv=>{
   const supplied=options.command?.(argv);if(supplied!==undefined)return supplied;
   if(argv[0]==='curl'&&argv.includes('--version'))return options.version??'curl 8.17.0 (fixture)\n';
   if(isPost(argv))return options.reply??replies[provider];
   return undefined;
  }});
 };
 const posts = f => f.calls.filter(isPost);
 const payload = f => {
  const post=posts(f)[0];return JSON.parse(post[post.indexOf('--data-raw')+1]);
 };
 test(provider+': CLI arguments are named scalars and the compiled entry exports send',()=>{
  assert.deepEqual(Object.keys(schema.exports),['send']);
  assert.ok(Object.values(contract.input.properties).every(prop=>['string','integer','boolean'].includes(prop.type)));
  assert.deepEqual(Object.keys(component),['send']);
 });
 test(provider+': literal text is JSON encoded and successful delivery returns a typed acknowledgement',()=>{
  const message='Build "green"\nUnicode 世界; $(touch injected) & @everyone';
  const f=host();const result=component.send(args({message}))();
  assert.deepEqual(result,{provider,sent:true,httpStatus:200,messageId:provider==='slack'?'':provider==='discord'?'987654321':'42'});
  assert.equal(payload(f)[provider==='discord'?'content':'text'],message);
  assert.equal(posts(f).length,1);assert.equal(f.output.length,0);
  const post=posts(f)[0];assert.equal(post[1],'--disable');
  assert.ok(post.includes('--globoff'));assert.ok(post.includes('=https'));
  assert.ok(!post.includes('--retry'));assert.ok(!post.includes('--location'));
  assert.ok(!f.calls.some(argv=>['sh','bash'].includes(argv[0])));
  for(const secret of Object.values(credentials[provider]))assert.ok(!JSON.stringify(f.calls).includes(secret));
  assert.ok(post.includes('--variable'));assert.ok(post.includes('--expand-url'));
 });
 test(provider+': supports Linux, macOS and BSD hosts with curl',()=>{
  for(const os of ['linux','macos','freebsd','openbsd','netbsd']){
   const f=host({os});assert.equal(component.send(args())().sent,true);assert.equal(posts(f).length,1);
  }
  const f=host({os:'windows'});assert.throws(()=>component.send(args())(),/Unsupported notification host OS/);assert.equal(f.calls.length,0);
 });
 test(provider+': malformed fields and credential selectors fail before commands or setup',()=>{
  const selector=provider==='telegram'?'tokenEnv':'webhookEnv';
  const inputs=[{message:''},{message:'   '},{message:'bad\0text'},{message:{text:'not a CLI JSON object'}},{message:['array']},{timeoutSeconds:0},{timeoutSeconds:601},{[selector]:'BAD-NAME'},{[selector]:'NAME\n'}];
  if(provider==='slack')inputs.push({threadTs:'bad'},{threadTs:'1.2\n'});
  if(provider==='discord')inputs.push({username:''},{username:'a'.repeat(81)},{avatarUrl:'http://example.com/avatar'},{avatarUrl:'https://example.com/white space'},{threadId:'0'},{threadId:'1&wait=false'});
  if(provider==='telegram')inputs.push({chatId:'0'},{chatId:'-0'},{chatId:'000'},{chatId:'-000'},{chatId:'../escape'},{parseMode:'XML'},{messageThreadId:0});
  for(const input of inputs){
   let installed=false;const f=host();globalThis.fluentciSetupDependencies={'setup-curl':()=>{installed=true;}};
   assert.throws(()=>component.send(args(input))());assert.equal(f.calls.length,0);assert.equal(installed,false);
  }
 });
 test(provider+': rejects overlong text before host commands and counts Unicode code points',()=>{
  const limit=provider==='slack'?4000:provider==='discord'?2000:4096;
  let f=host();assert.throws(()=>component.send(args({message:'x'.repeat(limit+1)}))());assert.equal(f.calls.length,0);
  f=host();assert.equal(component.send(args({message:'😀'.repeat(limit)}))().sent,true);
 });
 test(provider+': missing or malformed credentials never install curl or send a request',()=>{
  const key=Object.keys(credentials[provider])[0];
  for(const value of [undefined,'','   ','http://example.com/secret','https://evil.example/secret','bad\nsecret']){
   let installed=false;const f=host({env:{[key]:value}});globalThis.fluentciSetupDependencies={'setup-curl':()=>{installed=true;}};
   assert.throws(()=>component.send(args())());assert.equal(f.calls.length,0);assert.equal(installed,false);
  }
 });
 test(provider+': custom credential variable names keep credentials out of argv',()=>{
  const selector=provider==='telegram'?'tokenEnv':'webhookEnv';const secret=Object.values(credentials[provider])[0];
  const f=host({env:{CUSTOM_NOTIFICATION_CREDENTIAL:secret}});
  assert.equal(component.send(args({[selector]:'CUSTOM_NOTIFICATION_CREDENTIAL'}))().sent,true);
  const post=posts(f)[0];assert.ok(post.includes('%CUSTOM_NOTIFICATION_CREDENTIAL'));assert.ok(!JSON.stringify(f.calls).includes(secret));
 });
 test(provider+': absent curl invokes its setup component and rechecks availability',()=>{
  let available=false;let installed=false;
  const f=host({fail:argv=>argv[0]==='which'&&argv[1]==='curl'&&!available});
  globalThis.fluentciSetupDependencies={'setup-curl':()=>{installed=true;available=true;}};
  assert.equal(component.send(args())().sent,true);assert.equal(installed,true);
  assert.equal(f.calls.filter(a=>a[0]==='which'&&a[1]==='curl').length,2);
 });
 test(provider+': setup failures and missing tools cannot produce successful delivery',()=>{
  const f=host({fail:argv=>argv[0]==='which'&&argv[1]==='curl'});
  globalThis.fluentciSetupDependencies={'setup-curl':()=>{throw Error('setup failed');}};
  assert.throws(()=>component.send(args())(),/setup failed/);assert.equal(posts(f).length,0);
 });
 test(provider+': rejects curl releases without secret expansion before posting',()=>{
  for(const version of ['curl 7.88.1','curl 8.2.1','invalid']){
   const f=host({version});assert.throws(()=>component.send(args())(),/curl >= 8.3.0/);assert.equal(posts(f).length,0);
  }
  const f=host({version:'curl 8.3.0'});assert.equal(component.send(args())().sent,true);assert.equal(posts(f).length,1);
 });
 test(provider+': HTTP failures, redirects, transport errors and malformed acknowledgements never return success',()=>{
  const invalid = provider==='slack'?['not_ok\n200']:provider==='discord'?['{}\n200','{"id":"0"}\n200','not-json\n200','\n204']:['{"ok":false}\n200','{"ok":true,"result":{"message_id":0}}\n200','{}\n200','not-json\n200'];
  for(const reply of [...invalid,'error\n400','redirect\n302','busy\n429','server\n503','missing-status']){
   const f=host({reply});assert.throws(()=>component.send(args())());assert.equal(posts(f).length,1);assert.equal(f.output.length,0);
  }
  const f=host({fail:isPost});assert.throws(()=>component.send(args())(),/transport failed/);assert.equal(posts(f).length,1);
 });
 test(provider+': explicit timeouts are bounded and passed literally',()=>{
  const f=host();component.send(args({timeoutSeconds:5}))();const post=posts(f)[0];
  assert.equal(post[post.indexOf('--connect-timeout')+1],'5');assert.equal(post[post.indexOf('--max-time')+1],'5');
 });
 if(provider==='slack')test('Slack threaded replies and GovSlack use native incoming-webhook fields',()=>{
  const f=host({env:{SLACK_WEBHOOK_URL:'https://hooks.slack-gov.com/services/T123/B456/fixture-secret'}});
  component.send(args({threadTs:'1712345678.123456'}))();assert.equal(payload(f).thread_ts,'1712345678.123456');
 });
 if(provider==='discord')test('Discord waits for acknowledgement and disables mentions unless explicitly enabled',()=>{
  let f=host();component.send(args({username:'Build bot',avatarUrl:'https://example.com/assets/avatar.png',threadId:'123456789'}))();
  assert.deepEqual(payload(f).allowed_mentions,{parse:[]});assert.equal(payload(f).username,'Build bot');
  assert.ok(posts(f)[0].includes('wait=true'));assert.ok(posts(f)[0].includes('thread_id=123456789'));
  f=host();component.send(args({allowMentions:true}))();assert.deepEqual(payload(f).allowed_mentions,{parse:['users','roles','everyone']});
 });
 if(provider==='telegram')test('Telegram forwards formatting, topic, silent, protected and preview options with false values intact',()=>{
  const f=host();component.send(args({chatId:'@build_channel',parseMode:'HTML',messageThreadId:7,disableNotification:true,protectContent:false,disableWebPagePreview:true}))();
  assert.deepEqual(payload(f),{chat_id:'@build_channel',text:'Build passed',parse_mode:'HTML',message_thread_id:7,disable_notification:true,protect_content:false,link_preview_options:{is_disabled:true}});
  assert.ok(posts(f)[0].includes('https://api.telegram.org/bot{{TELEGRAM_BOT_TOKEN}}/sendMessage'));
 });
}
