import {dependencySuite} from "../../../test/dependencies/suite.mjs";
await dependencySuite(new URL("../",import.meta.url));
