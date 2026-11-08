import {packageSuite} from "../../../test/setup-tools/packages.mjs";
await packageSuite("flox",new URL("../",import.meta.url));
