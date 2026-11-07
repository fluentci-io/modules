import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("ninja", new URL("../", import.meta.url));
