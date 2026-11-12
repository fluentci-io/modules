import './loader.mjs';
import {componentSuite} from '../../../test/components/suite.mjs';
await componentSuite(new URL('../',import.meta.url));
