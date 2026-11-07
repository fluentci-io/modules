import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("pulumi", new URL("../", import.meta.url));
