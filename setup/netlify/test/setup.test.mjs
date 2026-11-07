import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("netlify", new URL("../", import.meta.url));
