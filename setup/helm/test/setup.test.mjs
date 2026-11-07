import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("helm", new URL("../", import.meta.url));
