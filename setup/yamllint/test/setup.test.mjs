import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("yamllint", new URL("../", import.meta.url));
