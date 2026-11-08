import {packageSuite} from "../../../test/setup-tools/packages.mjs";
await packageSuite("pkgx",new URL("../",import.meta.url));
