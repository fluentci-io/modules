// Test-only component imports. Production Wasm always uses real WIT dependencies.
export function invoke(alias,args) {
  if(alias==='setup-java'&&typeof globalThis.androidJavaDependency==='function')return globalThis.androidJavaDependency(args);
  const install=globalThis.fluentciSetupDependencies?.[alias];
  if(typeof install!=='function')throw Error('No setup fixture registered for '+alias);
  return install(args);
}
