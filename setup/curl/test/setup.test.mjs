import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("curl", new URL("../", import.meta.url));
