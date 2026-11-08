import {packageSuite} from "../../../test/setup-tools/packages.mjs";
await packageSuite("mise",new URL("../",import.meta.url));
