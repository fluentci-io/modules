import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("gh-artifact", new URL("../", import.meta.url));
