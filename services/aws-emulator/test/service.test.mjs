import {serviceSuite} from "../../../test/services/suite.mjs";
await serviceSuite(new URL("../",import.meta.url));
