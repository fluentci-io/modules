// Pure orchestration helpers: importing this file never builds or starts services.
export function serviceInvocation(name,operation,project,fields={}){
 const argv=['fluentci','run',name,operation,'--project',project];
 for(const [key,value]of Object.entries(fields))argv.push('--'+key.replace(/[A-Z]/g,c=>'-'+c.toLowerCase())+'='+String(value));
 return argv;
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
