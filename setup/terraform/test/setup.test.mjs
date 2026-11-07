import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("terraform", new URL("../", import.meta.url));
