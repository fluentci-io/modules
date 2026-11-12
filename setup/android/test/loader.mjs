import {registerHooks} from 'node:module';
registerHooks({resolve(specifier,context,nextResolve){
 if(specifier==='fluentci:dependency/setup-java')return {url:new URL('./dependency.mjs',import.meta.url).href,shortCircuit:true};
 return nextResolve(specifier,context);
}});
