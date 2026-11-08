import {macPortsPackageSuite} from "../../../test/setup-tools/macports-packages.mjs";
await macPortsPackageSuite("macports",new URL("../",import.meta.url));
