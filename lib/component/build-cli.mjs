// Command-line adapter to the existing JavaScript component compiler API.
import {buildModule} from './build.mjs';
await buildModule(process.cwd(),{prepareDependencies:false});
