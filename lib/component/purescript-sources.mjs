import {access} from 'node:fs/promises';
import {resolve} from 'node:path';

// FluentCI installs generated bindings in src/, but their Flow support is
// outside Spago's default source glob. Include only that installed module:
// the remaining SDK modules already come from the pinned fluentci package.
export async function purescriptBuildArgs(root, hasDependencies) {
  if (!hasDependencies) return ['build'];
  const source = '.sdk/purescript/src/FluentCI/Flow.purs';
  for (const path of [source, source.replace(/\.purs$/, '.js'), '.sdk/inspection/composition-runtime.mjs']) {
    try { await access(resolve(root, path)); }
    catch (error) {
      if (error.code !== 'ENOENT') throw error;
      throw Error(`Missing generated pipeline support: ${path}; run fluentci install --frozen-lockfile`, {cause:error});
    }
  }
  return ['build', `--purs-args=${source}`];
}
