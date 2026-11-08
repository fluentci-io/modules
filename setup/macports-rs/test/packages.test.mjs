import {macPortsPackageSuite} from "../../../test/setup-tools/macports-packages.mjs";
await macPortsPackageSuite("macports-rs",new URL("../",import.meta.url));
