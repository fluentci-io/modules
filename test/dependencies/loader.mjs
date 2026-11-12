import {registerHooks} from 'node:module';
const bridge=new URL('./mock.mjs',import.meta.url).href;
registerHooks({resolve(specifier,context,nextResolve){
 if(specifier.startsWith('fluentci:dependency/')){
  const alias=specifier.slice('fluentci:dependency/'.length);
  const source=`import {invoke} from ${JSON.stringify(bridge)};export const setup=args=>invoke(${JSON.stringify(alias)},args);`;
  return {url:'data:text/javascript,'+encodeURIComponent(source),shortCircuit:true};
 }
 return nextResolve(specifier,context);
}});
