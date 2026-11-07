import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("cachix", new URL("../", import.meta.url));
