import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("azure", new URL("../", import.meta.url));
