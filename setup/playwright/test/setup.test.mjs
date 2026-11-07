import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("playwright", new URL("../", import.meta.url));
