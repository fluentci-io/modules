import {versionControlSuite} from "../../../test/version-control/suite.mjs";
await versionControlSuite(new URL("../",import.meta.url));
