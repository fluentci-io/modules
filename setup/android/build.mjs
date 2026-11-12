import {spawnSync} from 'node:child_process';
import {fileURLToPath} from 'node:url';
import {buildModule} from '../../lib/component/build.mjs';

// Prepare actual WIT imports from the declared local setup-java component.
// This builds the dependency; it does not run Java or Android installers.
const prepared=spawnSync('fluentci',['install','--frozen-lockfile'],{stdio:'inherit'});
if(prepared.error)throw prepared.error;
if(prepared.status!==0)throw Error('Could not prepare setup-java component dependency');
await buildModule(process.cwd(),{regressionPlugins:[{
 name:'android-regression-dependency',
 setup(build){build.onResolve({filter:/^fluentci:dependency\/setup-java$/},()=>({path:fileURLToPath(new URL('./test/dependency.mjs',import.meta.url))}));},
}]});
