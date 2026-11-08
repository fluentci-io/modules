import {packageSuite} from "../../../test/setup-tools/packages.mjs";
await packageSuite("devbox",new URL("../",import.meta.url));
