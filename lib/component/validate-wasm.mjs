// JavaScript test/SDK adapter to the repository's BEAM validator.
import {execFile} from 'node:child_process';
import {fileURLToPath} from 'node:url';
import {resolve} from 'node:path';
import {promisify} from 'node:util';
const execute=promisify(execFile);
const root=fileURLToPath(new URL('../../',import.meta.url));
export async function validateWasm(directory){
 const {stdout}=await execute('escript',[resolve(root,'scripts/fluentci_modules_ci'),'inspect-wasm',resolve(directory)],{cwd:root,maxBuffer:64*1024*1024});
 return JSON.parse(stdout);
}
