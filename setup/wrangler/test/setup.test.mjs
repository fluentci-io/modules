import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("wrangler", new URL("../", import.meta.url));
