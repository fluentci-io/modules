import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("aws", new URL("../", import.meta.url));
