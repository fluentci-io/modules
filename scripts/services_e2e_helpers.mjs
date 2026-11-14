// Pure orchestration helpers: importing this file never builds or starts services.
export function serviceInvocation(name,operation,project,fields={}){
 const argv=['fluentci','run',name,operation,'--project',project];
 for(const [key,value]of Object.entries(fields))argv.push('--'+key.replace(/[A-Z]/g,c=>'-'+c.toLowerCase())+'='+String(value));
 return argv;
}

export function serviceOutput(operation,output){
 // The native CLI emits string results verbatim, while records are JSON.
 // Build returns one image reference after any compiler/host progress lines.
 if(operation==='build'){
  const image=output.trimEnd().split('\n').at(-1)?.trim();
  if(!image)throw Error('Native build did not return an image reference');
  return image;
 }
 if(operation==='logs')return output;
 const starts=[0];
 for(let index=0;index<output.length;index++)if(output[index]==='\n')starts.push(index+1);
 for(const index of starts.reverse()){
  try{
   const value=JSON.parse(output.slice(index));
   if(value&&typeof value==='object'&&!Array.isArray(value)&&typeof value.name==='string'&&typeof value.state==='string')return value;
  }catch{}
 }
 throw Error('Native '+operation+' did not return a JSON service record');
}

export async function runBuildPool(items,concurrency,build){
 if(!Number.isInteger(concurrency)||concurrency<1||concurrency>4)throw Error('SERVICE_BUILD_CONCURRENCY must be an integer from 1 to 4');
 let index=0,preparation=Promise.resolve();const failures=[];
 const serial=action=>{
  const task=preparation.then(action);preparation=task.catch(()=>{});return task;
 };
 const worker=async()=>{
  while(index<items.length){
   const item=items[index++];
   try{await build(item,serial);}catch(error){failures.push({item,error});}
  }
 };
 await Promise.all(Array.from({length:Math.min(concurrency,items.length)},worker));
 return failures;
}
