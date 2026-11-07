import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("checkov", new URL("../", import.meta.url));
