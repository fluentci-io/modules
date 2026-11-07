import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("flyctl", new URL("../", import.meta.url));
