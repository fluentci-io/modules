import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("render", new URL("../", import.meta.url));
