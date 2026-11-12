// Test-only replacement for the native component dependency import.
export const setup = args => {
  if (typeof globalThis.androidJavaDependency !== 'function') throw Error('Missing setup-java fixture');
  return globalThis.androidJavaDependency(args);
};
